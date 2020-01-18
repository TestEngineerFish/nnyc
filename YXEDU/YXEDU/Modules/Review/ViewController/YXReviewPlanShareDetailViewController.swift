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
    var headerView   = YXReviewPlanShareDetailHeaderView()
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
        self.view.addSubview(self.headerView)
        self.view.addSubview(self.wordListView)
        self.view.addSubview(self.bottomView)
    }
    
    
    func bindProperty() {
        self.customNavigationBar?.title = "复习计划"
        
        wordListView.isWrongWordList = false
        wordListView.shouldShowEditButton = false
        wordListView.shouldShowBottomView = false
        wordListView.orderType = .default
        wordListView.showWordDetialClosure = { (wordId, isComplexWord) in
            let home = UIStoryboard(name: "Home", bundle: nil)
            let wordDetialViewController = home.instantiateViewController(withIdentifier: "YXWordDetailViewControllerNew") as! YXWordDetailViewControllerNew
            wordDetialViewController.wordId = wordId
            wordDetialViewController.isComplexWord = isComplexWord
            self.navigationController?.pushViewController(wordDetialViewController, animated: true)
        }
        
        bottomView.saveReviewPlanEvent = { [weak self] in
            self?.saveReviewPlanEvent()
        }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        headerView.snp.makeConstraints { (make) in
            make.top.equalTo(AS(4 + kNavHeight))
            make.left.right.equalTo(0)
            make.height.equalTo(AS(108))
        }
        
        wordListView.snp.makeConstraints { (make) in
            make.top.equalTo(headerView.snp.bottom).offset(AS(13))
            make.left.right.equalTo(0)
        }
        
        bottomView.snp.makeConstraints { (make) in
            make.top.equalTo(wordListView.snp.bottom)
            make.left.right.equalToSuperview()
            make.height.equalTo(AS(67))
            make.bottom.equalTo(-kSafeBottomMargin)
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
                self.headerView.reviewPlanModel = detailModel
                self.wordListView.words = detailModel?.words ?? []
            }
        }
    }
    
    func saveReviewPlanEvent() {
        let pid = self.reviewPlanModel?.planId ?? 0
        
        // 显示弹框
        let placeholder = self.reviewPlanModel?.planName ?? ""
        let alertView = YXAlertView(type: .inputable, placeholder: placeholder)
        alertView.titleLabel.text = "请设置复习计划名称"
        alertView.shouldOnlyShowOneButton = false
        alertView.doneClosure = {(text: String?) in
            guard let name = text else {
                return
            }
            YXToastView.share.showLoadView("数据保存中，请稍等片刻...")
            self.downLoadBookData({ [weak self] in
                guard let self = self else { return }
                let request = YXReviewRequest.makeReviewPlan(name: name, code: pid, idsList: nil)
                YYNetworkService.default.request(YYStructDataArrayResponse<YXReviewUnitModel>.self, request: request, success: { (response) in
                    YXToastView.share.hideView()
                    NotificationCenter.default.post(name: YXNotification.kRefreshReviewTabPage, object: nil)
                    UIView.toast("保存成功")
                    YRRouter.popViewController(true)
                }) { (error) in
                    YXToastView.share.hideView()
                    if error.code == 101 {
                        let alertView = YXAlertView(type: .normal)
                        alertView.descriptionLabel.text   = error.message
                        alertView.shouldOnlyShowOneButton = true
                        alertView.show()
                    } else {
                        YXUtils.showHUD(self.view, title: "\(error)")
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
        YXWordBookResourceManager.shared.downloadBookCount = _wordModelList.count
        YXWordBookResourceManager.shared.finishBlock       = finishBlock
        if _wordModelList.isEmpty {
            finishBlock?()
        } else {
            for wordModel in _wordModelList {
                guard let bookId = wordModel.bookId else { return }
                YXWordBookResourceManager.shared.checkLocalBooKStatus(with: bookId, newHash: wordModel.bookHash)
            }
        }
    }

}


