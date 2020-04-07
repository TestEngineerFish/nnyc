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
    
    var headerView = YXReviewPlanHeaderView()
    var wordListView = YXWordListView()
    var bottomView = YXReviewPlanDetailBottomView()
    
    
    var model: YXReviewPlanDetailModel?
    var moreButton = UIButton()
    
    deinit {
        NotificationCenter.default.removeObserver(self, name: YXNotification.kRefreshReviewDetailPage, object: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.createSubView()
        self.bindProperty()
        self.fetchDetailData()
    }
    
//    override func viewWillAppear(_ animated: Bool) {
//        super.viewWillAppear(animated)
//        navigationController?.setNavigationBarHidden(true, animated: animated)
//    }
//
//    override func viewWillDisappear(_ animated: Bool) {
//        super.viewWillDisappear(animated)
//        navigationController?.setNavigationBarHidden(false, animated: animated)
//    }
    
    override func addNotification() {
        NotificationCenter.default.addObserver(self, selector: #selector(fetchDetailData), name: YXNotification.kRefreshReviewDetailPage, object: nil)
    }
    
    func createSubView() {
        let view = UIView(frame: CGRect(x: 0, y: 0, width: screenWidth, height: 146))
        view.backgroundColor = UIColor.orange1
        self.view.addSubview(view)
        self.view.sendSubviewToBack(view)
        
        self.addMoreButton()

        self.view.addSubview(self.headerView)
        self.view.addSubview(self.wordListView)
        self.view.addSubview(self.bottomView)
    }
    
    func bindProperty() {
        self.customNavigationBar?.title = YXReviewDataManager.reviewPlanTitle
        self.customNavigationBar?.titleColor = .white
        self.customNavigationBar?.leftButtonTitleColor = .white
        
        wordListView.type                 = .reviewPlanDetail
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

        guard let model = model else { return }
        headerView.snp.remakeConstraints { (make) in
            make.top.equalTo(kNavHeight)
            make.left.right.equalTo(0)
            
            if (model.status?.totalCount ?? 0) > 0 {
                make.height.equalTo(164)

            } else {
                make.height.equalTo(126)
            }
            
        }
        
        wordListView.snp.remakeConstraints { (make) in
            make.top.equalTo(headerView.snp.bottom).offset(10)
            make.left.right.equalTo(0)
        }
        
        bottomView.snp.remakeConstraints { (make) in
            make.top.equalTo(wordListView.snp.bottom)
            make.left.right.equalToSuperview()
            make.height.equalTo(AS(60))
            make.bottom.equalTo(-kSafeBottomMargin)
        }
        
    }
    
    @objc func fetchDetailData() {
        YXReviewDataManager().fetchReviewPlanDetailData(planId: planId) { [weak self] (detailModel, error) in
            guard let self = self else { return }
            if let msg = error {
                UIView.toast(msg)
                
            } else {
                self.model = detailModel
                self.bottomView.reviewPlanModel = detailModel
                self.wordListView.words = detailModel?.words ?? []
                
                self.headerView.detailModel = detailModel
                self.headerView.statusClosure = {
                    let reviePlanStudentsListViewController = YXReviePlanStudentsListViewController()
                    reviePlanStudentsListViewController.planId = self.planId
                    self.navigationController?.pushViewController(reviePlanStudentsListViewController, animated: true)
                }
                
                self.headerView.reportClosure = {
                    let vc = YXReviewPlanReportViewController()
                    vc.planId = detailModel?.planId ?? 0
                    vc.reviewPlanName = detailModel?.planName ?? ""
                    YRRouter.sharedInstance().currentNavigationController()?.pushViewController(vc, animated: true)
                }
                
                self.headerView.shareClosure = {
                    self.share()
                }
                
                self.viewDidLayoutSubviews()
            }
        }
    }
    
    
    func listenEvent() {
        let vc = YXExerciseViewController()
        vc.dataType = .planListenReview
        vc.planId = planId
        vc.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    
    func reviewEvent() {
        let vc = YXExerciseViewController()
        vc.dataType = .planReview
        vc.planId = planId
        vc.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    
    private func addMoreButton() {
        moreButton.setImage(UIImage(named: "more"), for: .normal)
        
        self.customNavigationBar?.addSubview(moreButton)
        moreButton.snp.makeConstraints { (make) in
            make.centerY.equalToSuperview()
            make.right.equalTo(-15)
            make.size.equalTo(CGSize(width: 20, height: 22))
        }
        
        moreButton.addTarget(self, action: #selector(showMoreOption), for: .touchUpInside)
    }
    
    @objc
    private func showMoreOption() {
        let editView = YXReviewPlanEditView(point: CGPoint(x: 0, y: 0))
        editView.reviewPlanModel = self.model
        editView.show()
    }
    
    func share() {
        YXSettingDataManager().fetchShareCommand(planId: planId) { (model, msg) in
            if let commandModel = model, let content = commandModel.content {
                YXShareCodeView.share.showView(content)
                
            } else {
                UIView.toast(msg)
            }
        }
    }
}
