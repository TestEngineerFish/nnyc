//
//  YXReviewPlanDetailViewController.swift
//  YXEDU
//
//  Created by sunwu on 2019/12/17.
//  Copyright © 2019 shiji. All rights reserved.
//

import UIKit

/// 复习计划，详情页
class YXReviewPlanDetailViewController: YXViewController {
    
    var planId: Int = -1
    
    var headerView = YXReviewPlanDetailHeaderView()
    var wordListView = YXWordListView()
    var bottomView = YXReviewPlanDetailBottomView()
    
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
        self.customNavigationBar?.rightButtonTitle = ""
        
        
        wordListView.isWrongWordList = false
        wordListView.shouldShowEditButton = false
        wordListView.shouldShowBottomView = false
        wordListView.orderType = .default
        
        bottomView.listenEvent = { [weak self] in
            self?.listenEvent()
        }
        bottomView.reviewEvent = {[weak self] in
            self?.reviewEvent()
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
            make.height.equalTo(AS(60))
            make.bottom.equalTo(-kSafeBottomMargin)
        }
        
    }
    
    func fetchDetailData() {
        YXReviewDataManager().fetchReviewPlanDetailData(planId: planId) { [weak self] (detailModel, error) in
            guard let self = self else { return }
            if let msg = error {
                UIView.toast(msg)
            } else {
                self.headerView.reviewPlanModel = detailModel
                self.wordListView.words = detailModel?.words ?? []
            }
        }
    }
    
    
    func listenEvent() {
        
    }
    
    
    func reviewEvent() {
        
    }
    
}
