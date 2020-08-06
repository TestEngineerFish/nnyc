//
//  YXReviewViewController.swift
//  YXEDU
//
//  Created by sunwu on 2019/12/9.
//  Copyright © 2019 shiji. All rights reserved.
//

import UIKit

class YXReviewViewController: YXTableViewController, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
        
    private var headerView: YXReviewHeaderView?
    private var footerView = YXReviewPlanEmptyView()
    private var reviewPageModel: YXReviewPageModel?
    private var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.itemSize                = CGSize(width: AdaptSize(365), height: AdaptSize(269))
        layout.minimumInteritemSpacing = AdaptSize(30)
        layout.minimumLineSpacing      = AdaptSize(30)
        layout.scrollDirection         = .horizontal
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor     = .white
        collectionView.layer.masksToBounds = false
        collectionView.showsHorizontalScrollIndicator = false
        return collectionView
    }()
    
    deinit {
        NotificationCenter.default.removeObserver(self, name: YXNotification.kRefreshReviewTabPage, object: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.customNavigationBar?.isHidden = true
        self.isMonitorNetwork              = true
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
//        self.collectionView.setContentOffset(CGPoint(x: AdaptSize(-37), y: 0), animated: false)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        YXAlertCheckManager.default.checkLatestBadge()
        self.fetchData()
//        YXTest.default.test()
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        
        self.tableView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
    }
    
    override func addNotification() {
        NotificationCenter.default.addObserver(self, selector: #selector(fetchDataWhenResultPageClosed), name: YXNotification.kRefreshReviewTabPage, object: nil)
    }
    
    override func monitorNetwork(isReachable: Bool) {
        if dataSource.count == 0 && isReachable {
            self.fetchData()
        }
    }
        
    override func refreshData() {
        self.fetchData()
    }
    
    func configTableView() {
        self.configHeaderView()
        self.configFooterView()
        self.tableView.tableHeaderView = self.headerView
        self.tableView.register(YXReviewPlanTableViewCell.classForCoder(), forCellReuseIdentifier: "YXReviewPlanTableViewCell")
        if isPad() {
            self.tableView.separatorColor = .clear
        }
    }

    func configCollectionView() {
        self.collectionView.delegate   = self
        self.collectionView.dataSource = self
        self.collectionView.register(YXReviewPlanCollectionViewItem.classForCoder(), forCellWithReuseIdentifier: "kYXReviewPlanCollectionViewItem")
    }
    
    func configHeaderView() {
        self.headerView?.startReviewEvent = { [weak self] in
            guard let self = self else { return }
            self.startReviewEvent()
        }
        self.headerView?.createReviewPlanEvent = { [weak self] in
            guard let self = self else { return }
            self.createReviewEvent()
        }
    }
    
    func configFooterView() {
        self.footerView.size = CGSize(width: screenWidth, height: AdaptIconSize(72))
        self.footerView.createReviewPlanEvent = { [weak self] in
            guard let self = self else { return }
            self.createReviewEvent()
        }
    }
    
    func fetchData() {
        YXReviewDataManager().fetchReviewPlanData { [weak self] (pageModel, errorMsg) in
            guard let self = self else { return }
            if let reviewModel = pageModel {
                self.reviewPageModel = reviewModel
                self.setData()
            } else if let msg = errorMsg {
                UIView.toast(msg)
            }
            
            self.finishLoading()
        }
    }
    
    @objc private func fetchDataWhenResultPageClosed() {
        self.fetchData()
    }

    private func setData() {
        guard let reviewPageModel = self.reviewPageModel else {
            return
        }
        self.dataSource  = {
            let planList = reviewPageModel.reviewPlans ?? []
            if isPad() && !planList.isEmpty {
                return [0]
            }
            return planList
        }()
        let otherHeight  = kStatusBarHeight + AdaptSize(isPad() ? 101 : 68)
        let headerHeight = (isPad() ? AdaptSize(550) : AdaptFontSize(360)) + otherHeight
        self.headerView  = YXReviewHeaderView(frame: CGRect(x: 0, y: 0, width: screenWidth, height: headerHeight), reviewModel: reviewPageModel)
        self.headerView?.reviewModel = reviewPageModel
        if self.dataSource.count == 0 {
            self.tableView.tableFooterView = self.footerView
        } else {
            self.tableView.tableFooterView = nil
        }
        self.configTableView()
        self.configCollectionView()
        self.tableView.reloadData()
        self.collectionView.reloadData()
    }

    // MARK: ==== UICollectionViewDataSource, UICollectionViewDelegate ====
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        guard let modelList = self.reviewPageModel?.reviewPlans else {
            return 0
        }
        return modelList.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "kYXReviewPlanCollectionViewItem", for: indexPath) as? YXReviewPlanCollectionViewItem, let modelList = self.reviewPageModel?.reviewPlans else {
            return UICollectionViewCell()
        }
        let model = modelList[indexPath.row]
        cell.setData(model)
        cell.startListenPlanEvent = { [weak self] in
            guard let self = self else { return }
            self.startListenPlanEvent(planId: model.planId)
        }
        cell.startReviewPlanEvent = { [weak self] in
            guard let self = self else { return }
            self.startReviewPlanEvent(planId: model.planId)
        }
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let modelList = self.reviewPageModel?.reviewPlans else {
            return
        }

        let model = modelList[indexPath.row]
        let vc = YXReviewPlanDetailViewController()
        vc.planId = model.planId
        self.navigationController?.pushViewController(vc, animated: true)
    }

    // MARK: ==== UICollectionViewDelegateFlowLayout ====
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: AdaptSize(37), bottom: 0, right: AdaptSize(37))
    }
    
}

extension YXReviewViewController {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if isPad() { return AdaptSize(270) }
        guard let model = dataSource[indexPath.row] as? YXReviewPlanModel else {
            return .zero
        }
        return YXReviewPlanTableViewCell.viewHeight(model: model)
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if isPad() {
            let cell = UITableViewCell()
            cell.addSubview(self.collectionView)
            cell.layer.masksToBounds = false
            self.collectionView.snp.makeConstraints { (make) in
                make.edges.equalToSuperview()
            }
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "YXReviewPlanTableViewCell", for: indexPath)
            cell.selectionStyle = .none
            tableView.separatorColor = UIColor.clear
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        guard let _cell = cell as? YXReviewPlanTableViewCell,
              let model = dataSource[indexPath.row] as? YXReviewPlanModel else {
            return
        }
        
        _cell.reviewPlanModel = model
        _cell.startListenPlanEvent = { [weak self] in
            guard let self = self else { return }
            self.startListenPlanEvent(planId: model.planId)
        }
        _cell.startReviewPlanEvent = { [weak self] in
            guard let self = self else { return }
            self.startReviewPlanEvent(planId: model.planId)
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if isPad() { return }
        if let model = dataSource[indexPath.row] as? YXReviewPlanModel {
            let vc = YXReviewPlanDetailViewController()
            vc.planId = model.planId
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
}


extension YXReviewViewController {
    /// 智能复习
    func startReviewEvent() {
//        YRRouter.openURL("exercise/study", query: ["type" : YXExerciseDataType.aiReview.rawValue], animated: true)
        if (headerView?.reviewModel.canMakeReviewPlans ?? 0) > 0 {
            let taskModel = YXWordBookResourceModel(type: .all) {
                YXWordBookResourceManager.shared.contrastBookData()
            }
            YXWordBookResourceManager.shared.addTask(model: taskModel)
            let vc = YXExerciseViewController()
            vc.learnConfig = YXAIReviewLearnConfig()
            self.navigationController?.pushViewController(vc, animated: true)
            YXLog("==== 开始智能复习 ====")
        } else {
            let nrView = YXNotReviewWordView()
            nrView.show()
        }
    }
    
    /// 开始复习 —— 复习计划
    func startReviewPlanEvent(planId: Int) {
//        YRRouter.openURL("exercise/study", query: ["type" : YXExerciseDataType.normalReview.rawValue], animated: true)
        let taskModel = YXWordBookResourceModel(type: .all) {
            YXWordBookResourceManager.shared.contrastBookData()
        }
        YXWordBookResourceManager.shared.addTask(model: taskModel)
        let vc = YXExerciseViewController()
        vc.learnConfig = YXReviewPlanLearnConfig(planId: planId)
        self.navigationController?.pushViewController(vc, animated: true)
        YXLog("==== 开始复习计划复习 ====")
    }
    
    /// 开始听力 —— 复习计划
    func startListenPlanEvent(planId: Int) {
        let taskModel = YXWordBookResourceModel(type: .all) {
            YXWordBookResourceManager.shared.contrastBookData()
        }
        YXWordBookResourceManager.shared.addTask(model: taskModel)
        let vc = YXExerciseViewController()
        vc.learnConfig = YXListenReviewLearnConfig(planId: planId)
        self.navigationController?.pushViewController(vc, animated: true)
        YXLog("==== 开始听力复习 ====")
    }
    
    func createReviewEvent() {
        let vc = YXMakeReviewPlanViewController()
        vc.delegate = self
        self.navigationController?.pushViewController(vc, animated: true)
    }
}


extension YXReviewViewController: YXMakeReviewPlanProtocol {
    func makeReivewPlanFinised() {
        self.fetchData()
    }
}
