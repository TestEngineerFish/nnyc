//
//  YXReviewPlanShareDetailViewController.swift
//  YXEDU
//
//  Created by sunwu on 2019/12/23.
//  Copyright © 2019 shiji. All rights reserved.
//

import UIKit


/// 复习计划，分享详情页
class YXReviewPlanShareDetailViewController: YXViewController {
        
    var planId: Int = -1
    var fromUser: String?
    
    var reviewPlanModel: YXReviewPlanModel?
    var wordListView = YXWordListView()
    var bottomView   = YXReviewPlanShareDetailBottomView()
    var activityView = UIActivityIndicatorView()

    var detailModel: YXReviewPlanDetailModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.createSubView()
        self.bindProperty()
        self.fetchDetailData()
    }
    
    func createSubView() {
        self.view.addSubview(self.wordListView)
        self.view.addSubview(self.bottomView)
        
        bottomView.backgroundColor = .white
        bottomView.layer.setDefaultShadow()
    }
    
    
    func bindProperty() {
        wordListView.type                 = .reviewPlanShareDetail
        wordListView.shouldShowEditButton = false
        wordListView.shouldShowBottomView = false
        wordListView.orderType            = .default
        bottomView.saveReviewPlanEvent = { [weak self] in
            self?.saveReviewPlanEvent()
        }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        wordListView.snp.makeConstraints { (make) in
            make.top.equalTo(kNavHeight)
            make.left.right.equalTo(0)
        }
        
        bottomView.snp.makeConstraints { (make) in
            make.top.equalTo(wordListView.snp.bottom)
            make.left.right.equalToSuperview()
            make.height.equalTo(AS(60) + kSafeBottomMargin)
            make.bottom.equalToSuperview()
        }
        
    }
    
    func fetchDetailData() {
        YXReviewDataManager().fetchReviewPlanDetailData(planId: planId) { [weak self] (detailModel, error) in
            guard let self = self else { return }
            if let msg = error {
                UIView.toast(msg)
            } else {
                detailModel?.fromUser = self.fromUser
                self.detailModel = detailModel
                self.reviewPlanModel = detailModel
                self.wordListView.words = detailModel?.words ?? []
                
                self.customNavigationBar?.title = detailModel?.planName
            }
        }
    }
    
    func saveReviewPlanEvent() {
        let pid = self.reviewPlanModel?.planId ?? 0
        
        // 显示弹框
        let placeholder = self.reviewPlanModel?.planName ?? ""
        let alertView = YXAlertView(type: .inputable, placeholder: placeholder)
        alertView.titleLabel.text = "请设置词单名称"
        alertView.shouldOnlyShowOneButton = false
        alertView.doneClosure = {(text: String?) in
            guard let name = text else {
                return
            }
            let toastView = YXToastView()
            toastView.showLoadView("数据保存中，请稍等片刻...")
            self.downLoadBookData({ [weak self] in
                guard let self = self else { return }
                let request = YXReviewRequest.makeReviewPlan(name: name, code: pid, idsList: nil)
                YYNetworkService.default.request(YYStructDataArrayResponse<YXReviewUnitModel>.self, request: request, success: { (response) in
                    toastView.hideView()
                    NotificationCenter.default.post(name: YXNotification.kRefreshReviewTabPage, object: nil)
                    UIView.toast("保存成功")
                    YRRouter.popViewController(true)
                }) { (error) in
                    toastView.hideView()
                    if error.code == 101 {
                        let alertView = YXAlertView(type: .normal)
                        alertView.descriptionLabel.text   = error.message
                        alertView.shouldOnlyShowOneButton = true
                        alertView.show()
                    } else {
                        YXUtils.showHUD(self.view, title: error.message)
                    }
                }
            })
        }
        alertView.show()
    }

    /// 下载词书
    private func downLoadBookData(_ finishBlock: (()->Void)?) {
        guard let wordModelList = detailModel?.words else {
            return
        }
        var _wordModelList = [YXWordModel]()
        var bookIdList     = [Int]()
        for wordModel in wordModelList {
            guard let bookId = wordModel.bookId else { continue }
            if !bookIdList.contains(bookId) {
                _wordModelList.append(wordModel)
                bookIdList.append(bookId)
            }
        }
        if _wordModelList.isEmpty {
            finishBlock?()
        } else {
            var dataList = [(Int, String)]()
            for wordModel in _wordModelList {
                guard let bookId = wordModel.bookId else { return }
                dataList.append((bookId, wordModel.bookHash))
            }
            YXWordBookResourceManager.shared.saveReviewPlan(dataList: dataList, finished: finishBlock)
        }
    }

}


