//
//  YXReviePlanStudentsListViewController.swift
//  YXEDU
//
//  Created by 沙庭宇 on 2020/3/28.
//  Copyright © 2020 shiji. All rights reserved.
//

import UIKit

class YXReviePlanStudentsListViewController: YXViewController, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {

    var collectionView: UICollectionView = {
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.itemSize                = CGSize(width: AdaptSize(168), height: AdaptSize(200))
        flowLayout.minimumLineSpacing      = AdaptSize(5)
        flowLayout.minimumInteritemSpacing = AdaptSize(5)
        flowLayout.scrollDirection         = .vertical
        return UICollectionView(frame: .zero, collectionViewLayout: flowLayout)
    }()
    var studentModelList = [YXStudentModel]()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.bindProperty()
        self.createSubviews()
        self.requestStudentList()
    }

    private func bindProperty() {
        self.customNavigationBar?.title = "单词学习情况"
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
        let request = YXReviewRequest.studentStudyList
        YYNetworkService.default.request(YYStructDataArrayResponse<YXStudentModel>.self, request: request, success: { (response) in
            guard let modelList = response.dataArray else {
                return
            }
            self.studentModelList = modelList
            self.collectionView.reloadData()
        }) { (error) in
            YXUtils.showHUD(kWindow, title: error.message)
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
        return UIEdgeInsets(top: AdaptSize(10), left: AdaptSize(16), bottom: AdaptSize(0), right: AdaptSize(16))
    }

}
