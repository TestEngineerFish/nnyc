//
//  YXReviePlanStudentsListViewController.swift
//  YXEDU
//
//  Created by 沙庭宇 on 2020/3/28.
//  Copyright © 2020 shiji. All rights reserved.
//

import UIKit

class YXReviePlanStudentsListViewController: YXViewController, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {

    var planId: Int?
    private var page = 1
    private var hasMore = true

    var collectionView: UICollectionView = {
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.itemSize                = CGSize(width: AdaptIconSize(168), height: AdaptIconSize(200))
        flowLayout.minimumLineSpacing      = AdaptIconSize(5)
        flowLayout.minimumInteritemSpacing = AdaptIconSize(5)
        flowLayout.scrollDirection         = .vertical
        return UICollectionView(frame: .zero, collectionViewLayout: flowLayout)
    }()
    var studentModelList = [YXStudentModel]()
    var reviewPlanName = ""

    override func viewDidLoad() {
        super.viewDidLoad()
        self.bindProperty()
        self.createSubviews()
        self.requestStudentList()
    }

    private func bindProperty() {
        self.customNavigationBar?.title = "词单学习情况"
        self.customNavigationBar?.backgroundColor = UIColor.white
        self.collectionView.delegate              = self
        self.collectionView.dataSource            = self

        self.collectionView.backgroundColor       = UIColor.clear
        self.collectionView.showsVerticalScrollIndicator   = false
        self.collectionView.showsHorizontalScrollIndicator = false
        self.collectionView.register(YXStudentLearnCell.classForCoder(), forCellWithReuseIdentifier: "kYXStudentLearnCell")
    }

    private func createSubviews() {
        self.view.addSubview(self.collectionView)
        if let navBar = self.customNavigationBar {
            self.view.bringSubviewToFront(navBar)
        }
        self.collectionView.snp.makeConstraints { (make) in
            make.width.equalToSuperview()
            make.centerX.equalToSuperview()
            make.top.equalToSuperview().offset(kNavHeight + AdaptSize(10))
            make.bottom.equalToSuperview()
        }
    }

    // MARK: ---- Request ----
    private func requestStudentList() {
        guard hasMore, let _planId = self.planId else { return }

        let request = YXReviewRequest.studentStudyList(planId: _planId, page: self.page)
        YYNetworkService.default.request(YYStructResponse<YXStudentListModel>.self, request: request, success: { [weak self] (response) in
            guard let self = self, let data = response.data, let modelList = data.list else { return }
            self.hasMore = data.hasMore
            self.page = self.page + 1
            
            if self.page == 2 {
                self.studentModelList = modelList

            } else {
                self.studentModelList = self.studentModelList + modelList
            }
            
            self.collectionView.reloadData()
            
        }) { (error) in
            YXUtils.showHUD(nil, title: error.message)
        }
    }

    // MARK: ---- UICollectionViewDataSource && UICollectionViewDelegate ----
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.studentModelList.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "kYXStudentLearnCell", for: indexPath) as? YXStudentLearnCell else {
            return UICollectionViewCell()
        }
        let model = self.studentModelList[indexPath.row]
        cell.setData(model)
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: AdaptIconSize(10), left: AdaptIconSize(16), bottom: AdaptSize(0), right: AdaptIconSize(16))
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let model = self.studentModelList[indexPath.row]
        guard let info = model.learnInfo else {
            return
        }
        if info.reviewState == .finish || info.listenState == .finish {
            let vc = YXReviewPlanReportViewController()
            vc.hideShareView  = true
            vc.planId         = info.reviewPlanId
            vc.reviewPlanName = self.reviewPlanName
            YRRouter.sharedInstance().currentNavigationController()?.pushViewController(vc, animated: true)
        }
    }

    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        let index = page == 1 ? 1 : page - 1
        if indexPath.row == index * 10 {
            requestStudentList()
        }
    }
}
