//
//  YXChinseAnswerView.swift
//  YXEDU
//
//  Created by sunwu on 2019/10/25.
//  Copyright © 2019 shiji. All rights reserved.
//

import UIKit

/// 中文答案
class YXChinseAnswerView: YXBaseAnswerView, UICollectionViewDelegate, UICollectionViewDataSource {
    
    enum Config {
        static var itemHeight: CGFloat = 42
        static var itemWidth: CGFloat = screenWidth - 35 * 2
        static var itemInterval: CGFloat = 13
    }
    

    private var flowLayout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
    private var collectionView: UICollectionView!
    private var collectionViewCell: UICollectionViewCell!
    
    func itemSize() -> CGSize {
        return CGSize(width: Config.itemWidth, height: Config.itemHeight)
    }
  
    func createSubviews() {
        flowLayout = UICollectionViewFlowLayout()
        flowLayout.scrollDirection = .vertical
        flowLayout.itemSize = CGSize(width: Config.itemWidth, height: Config.itemHeight)
        flowLayout.minimumLineSpacing = Config.itemInterval
        flowLayout.minimumInteritemSpacing = 0
        flowLayout.sectionInset = UIEdgeInsets(top: 0, left: 35, bottom: 0, right: 35)
                
        collectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: flowLayout)
        collectionView.backgroundColor = UIColor.white
        collectionView.decelerationRate = UIScrollView.DecelerationRate.fast
        collectionView.showsVerticalScrollIndicator = false
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.alwaysBounceVertical = true
        collectionView.isScrollEnabled = false
        collectionView.delegate = self
        collectionView.dataSource = self
        self.addSubview(collectionView)
        
        collectionView.register(UICollectionViewCell.classForCoder(), forCellWithReuseIdentifier: "UICollectionViewCell")
        
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        collectionView.frame = self.bounds
//        collectionView.frame = CGRect(x: 0, y: 0, width: screenWidth, height: 42 * 4 + 13 * 3)
    }
    
    override func bindData() {
        self.collectionView.reloadData()
    }
    
        
    //MARK:- delegate
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 4
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let idf = "UICollectionViewCell"
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: idf, for: indexPath)
        cell.backgroundColor = UIColor.clear
        cell.layer.borderWidth = 1
        cell.layer.borderColor = UIColor.black6.cgColor
        cell
        return cell
    }

    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let cell = collectionViewCell {
            cell.layer.borderColor = UIColor.clear.cgColor
        }
        let cell = collectionView.cellForItem(at: indexPath)
        cell?.layer.borderColor = UIColor.orange1.cgColor
        collectionViewCell = cell
        
        self.answerCompletion(right: true)
    }

    

}
