//
//  YXNewLearningResultViewController.swift
//  YXEDU
//
//  Created by 沙庭宇 on 2020/8/26.
//  Copyright © 2020 shiji. All rights reserved.
//

import Foundation

class YXNewLearningResultViewController: YXViewController, YXNewLearningResultViewProtocol {

    var requestCount: Int      = 0 // 请求次数
    var newLearnAmount: Int    = 0 // 新学单词数
    var reviewLearnAmount: Int = 0 // 复习单词数量
    var model: YXExerciseResultDisplayModel?
    var learnConfig: YXLearnConfig?

    var contentView = YXNewLearningResultView()
    var loadingView = YXExerciseResultLoadingView()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.createSubviews()
        self.bindProperty()
        self.requestData()
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        NotificationCenter.default.post(name: YXNotification.kRefreshReviewTabPage, object: nil)
    }

    private func createSubviews() {
        self.view.addSubview(loadingView)
        self.view.addSubview(contentView)
        loadingView.snp.makeConstraints { (make) in
            make.top.equalTo(AdaptIconSize(123))
            make.centerX.width.equalToSuperview()
            make.height.equalTo(AdaptIconSize(120))
        }
        contentView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
    }

    private func bindProperty() {
        self.customNavigationBar?.isHidden = true
        self.contentView.delegate          = self
        self.contentView.isHidden          = true
    }

    private func setData() {
        guard let _model = self.model else { return }
        self.contentView.setData(model: _model)
    }

    // MARK: ==== Request ====
    private func requestData() {
        guard let config = self.learnConfig else {
            return
        }
        let request = YXExerciseRequest.learnResult(bookId: config.bookId, unitId: config.unitId, wordId: config.homeworkId)
        YYNetworkService.default.request(YYStructResponse<YXLearnResultModel>.self, request: request, success: { [weak self] (response) in
            guard let self = self else {
                return
            }
            // 如果后台还在计算,则重新请求
            if response.data?.countStatus == .some(.ing) {
                // 如果请求次数超过五次,则退出
                if self.requestCount >= 5 {
                    YXUtils.showHUD(nil, title: "后台繁忙,请稍后重试")
                } else {
                    self.requestCount += 1
                    self.requestData()
                }
            } else {
                self.loadingView.removeFromSuperview()
                self.contentView.isHidden = false
                self.model = self.transformModel(response.data)
//                if let _unitModelList = self.model?.unitList {
//                    for (index, unitModel) in _unitModelList.enumerated() {
//                        if unitModel.unitID == config.unitId {
//                            self.currentUnitIndex = index + 1
//                        }
//                    }
//                }

//                self.loadSubViews()
                self.setData()
            }
        }) { (error) in
            YXUtils.showHUD(nil, title: error.message)
        }
    }

    // MARK: ==== YXNewLearningResultViewProtocol ====
    func closedAction() {
        self.navigationController?.popViewController(animated: true)
    }

    func punchAction() {
        let vc = YXShareViewController()
        self.navigationController?.pushViewController(vc, animated: true)
    }

    // MARK: ==== Tools ====
    private func transformModel(_ model: YXLearnResultModel?) -> YXExerciseResultDisplayModel? {
        guard let _model = model else {
            return nil
        }
        return YXExerciseResultDisplayModel.displayModel(newStudyWordCount: self.newLearnAmount, reviewWordCount: self.reviewLearnAmount, model: _model)
    }
}
