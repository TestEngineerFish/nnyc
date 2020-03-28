//
//  YXReviewPlanStudyStatusViewController.swift
//  YXEDU
//
//  Created by Jake To on 3/27/20.
//  Copyright © 2020 shiji. All rights reserved.
//

import UIKit

class YXReviewPlanStudyStatusViewController: YXViewController { //, UICollectionViewDelegate, UICollectionViewDataSource {

    private var status: [YXReviewPlanStatusListModel] = []
    private var page = 1
    private var hasMore = false
    
    private let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.itemSize = CGSize(width: (screenWidth - 68) / 2, height: 190)
        layout.minimumInteritemSpacing = 16
        layout.minimumLineSpacing = 16
        
        let collectionView = UICollectionView(frame: CGRect(x: 0, y: kNavHeight, width: screenWidth, height: screenHeight - kNavHeight))
        collectionView.collectionViewLayout = layout
        return collectionView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.addSubview(collectionView)
        
        collectionView.register(UINib(nibName: "YXReviewPlanStudyStatusCell", bundle: nil), forCellWithReuseIdentifier: "YXReviewPlanStudyStatusCell")
        fetchReviewPlanStatusList(page: page)
    }
    
    private func fetchReviewPlanStatusList(page: Int) {
        let request = YXReviewRequest.reviewPlanStatusList(page: page)
        YYNetworkService.default.request(YYStructDataArrayResponse<YXReviewPlanStatusListModel>.self, request: request, success: { (response) in
            guard let status = response.dataArray else { return }
            self.page = self.page + 1
            
            if self.page == 2 {
                self.status = status

            } else {
                self.status = self.status + status
            }
            
            self.collectionView.reloadData()
            
        }) { error in
            YXUtils.showHUD(kWindow, title: error.message)
        }
    }
        
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return status.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "YXReviewPlanStudyStatusCell", for: indexPath) as! YXReviewPlanStudyStatusCell
        let state = status[indexPath.row]
        
        cell.avatarImageView.sd_setImage(with: URL(string: state.user?.avatarPath ?? ""))
        cell.nameLabel.text = state.user?.name
        
        return cell
    }
}
