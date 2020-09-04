//
//  YXNewLearningResultViewController.swift
//  YXEDU
//
//  Created by 沙庭宇 on 2020/8/26.
//  Copyright © 2020 shiji. All rights reserved.
//

import Foundation

class YXNewLearningResultViewController: YXViewController, YXNewLearningResultViewProtocol, YXNewLearningResultShareViewProtocol {

    var requestCount: Int      = 0 // 请求次数
    var newLearnAmount: Int    = 0 // 新学单词数
    var reviewLearnAmount: Int = 0 // 复习单词数量
    var shareType: YXShareImageType = .learnResult
    var model: YXExerciseResultDisplayModel?
    var learnConfig: YXLearnConfig?

    var contentView = YXNewLearningResultView()
    var loadingView = YXExerciseResultLoadingView()
    private var shareView    = YXNewLearningResultShareView()
    private var shareManager = YXShareManager()

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
        self.contentView.isHidden          = true
        self.contentView.delegate          = self
        self.shareView.delegate            = self
        self.shareManager.setShareImage { [weak self] (image: UIImage?) in
            guard let self = self else { return }
            self.shareView.shareImageView.image        = image
            self.shareView.shareChannelView.shareImage = image
        }
    }

    private func setData() {
        guard let _model = self.model else { return }
        self.contentView.setData(currentLearnedWordsCount: newLearnAmount + reviewLearnAmount, model: _model)
        self.shareManager.setData(wordsAmount: _model.allWordNum, daysAmount: _model.studyDay, type: self.shareType)
        self.shareView.shareChannelView.coinImageView.isHidden = !_model.isShowCoin
        NotificationCenter.default.post(name: YXNotification.kReloadClassList, object: nil)
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
                self.setData()
                self.updatePunchCount()
            }
        }) { (error) in
            YXUtils.showHUD(nil, title: error.message)
        }
    }

    private func requestShare(shareType: YXShareChannel, learnType: YXLearnType) {
        let request = YXExerciseRequest.learnShare(shareType: shareType.rawValue, learnType: learnType.rawValue)
        YYNetworkService.default.request(YYStructResponse<YXResultModel>.self, request: request, success: { (response) in
            if shareType == .timeLine {
                self.shareView.shareChannelView.coinImageView.isHidden = true
            }
        }) { (error) in
            YXUtils.showHUD(nil, title: error.message)
        }
    }

    // MARK: ==== Event ====
    private func updatePunchCount() {
        if let count = YYCache.object(forKey: YXLocalKey.punchCount) as? Int {
            YXLog("用户 \(YXUserModel.default.uuid ?? "") 打卡次数： \(count + 1)")
            YYCache.set(count + 1, forKey: YXLocalKey.punchCount)

        } else {
            YXLog("用户 \(YXUserModel.default.uuid ?? "") 打卡次数： 1")
            YYCache.set(1, forKey: YXLocalKey.punchCount)
        }
    }

    // MARK: ==== YXNewLearningResultViewProtocol ====
    func closedAction() {
        self.navigationController?.popToRootViewController(animated: true)
    }

    func punchAction() {
        self.shareView.show()
    }

    // MARK: ==== YXNewLearningResultShareViewProtocol ====
    func refreshAction(complete block: ((UIImage?)->Void)?) {
        self.shareManager.refreshImage(complete: { (image) in
            block?(image)
        })
    }

    func shareFinished(type: YXShareChannel) {
        let learnType = learnConfig?.learnType ?? .base
        self.requestShare(shareType: type, learnType: learnType)
    }

    // MARK: ==== Tools ====
    private func transformModel(_ model: YXLearnResultModel?) -> YXExerciseResultDisplayModel? {
        guard let _model = model else {
            return nil
        }
        return YXExerciseResultDisplayModel.displayModel(newStudyWordCount: self.newLearnAmount, reviewWordCount: self.reviewLearnAmount, model: _model)
    }
}
