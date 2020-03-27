//
//  YXReviewPlanStudyStatusViewController.swift
//  YXEDU
//
//  Created by Jake To on 3/27/20.
//  Copyright © 2020 shiji. All rights reserved.
//

import UIKit

class YXReviewPlanStudyStatusViewController: YXViewController { //, UICollectionViewDelegate, UICollectionViewDataSource {

    let collectionView: UICollectionView = {
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
    }
        
//    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
//        <#code#>
//    }
//
//    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
//        <#code#>
//    }
}
