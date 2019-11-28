//
//  YXImageAnswerViw.swift
//  YXEDU
//
//  Created by sunwu on 2019/10/25.
//  Copyright © 2019 shiji. All rights reserved.
//

import UIKit

/// 图片答案
class YXImageAnswerView: YXBaseAnswerView, UICollectionViewDelegate, UICollectionViewDataSource {
    
    enum Config {
        static var itemHeight: CGFloat = AdaptSize(105)
        static var itemWidth: CGFloat = AdaptSize(146)
        static var itemInterval: CGFloat = AdaptSize(14)
    }
    

    private var flowLayout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
    private var collectionView: UICollectionView!
    private var collectionViewCell: UICollectionViewCell!
    
    func itemSize() -> CGSize {
        return CGSize(width: Config.itemWidth, height: Config.itemHeight)
    }
    
    private var imageView: YXKVOImageView {
        let imageView = YXKVOImageView()
        return imageView
    }
    
    override func createSubviews() {
        super.createSubviews()
        flowLayout = UICollectionViewFlowLayout()
        flowLayout.scrollDirection = .vertical
        flowLayout.itemSize = CGSize(width: Config.itemWidth, height: Config.itemHeight)
        flowLayout.minimumLineSpacing = Config.itemInterval
        flowLayout.minimumInteritemSpacing = 0

        collectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: flowLayout)
        collectionView.backgroundColor = UIColor.white
        collectionView.decelerationRate = UIScrollView.DecelerationRate.fast
        collectionView.showsVerticalScrollIndicator = false
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.alwaysBounceVertical = true
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.isScrollEnabled = false
        self.addSubview(collectionView)

        collectionView.register(UICollectionViewCell.classForCoder(), forCellWithReuseIdentifier: "UICollectionViewCell")
        self.collectionView.reloadData()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        let itemHNum = ((self.exerciseModel.option?.firstItems?.count ?? 0) + 1)/2
        let h = (Config.itemHeight + Config.itemInterval) * CGFloat(itemHNum) - Config.itemInterval
        collectionView.snp.makeConstraints { (make) in
            make.center.equalToSuperview()
            make.width.equalToSuperview()
            make.height.equalTo(h)
        }
    }
        
    //MARK:- delegate
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.exerciseModel.option?.firstItems?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let idf = "UICollectionViewCell"
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: idf, for: indexPath)
        
        cell.layer.borderWidth = 1.5
        cell.layer.borderColor = UIColor.clear.cgColor
        
        cell.layer.masksToBounds = true
        cell.layer.cornerRadius = 5.5
        
        let iv = self.imageView
        if let url = exerciseModel.option?.firstItems?[indexPath.row].content {
            iv.showImage(with: url, placeholder: UIImage.imageWithColor(UIColor.orange7))
        }
        
        cell.contentView.addSubview(iv)
        iv.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
    
        return cell
    }

    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let cell = collectionViewCell {
            cell.layer.borderColor = UIColor.clear.cgColor
        }
        let cell = collectionView.cellForItem(at: indexPath)
        cell?.layer.borderColor = UIColor.orange1.cgColor        
        collectionViewCell = cell
        
        
        if exerciseModel.answers?.first == exerciseModel.option?.firstItems?[indexPath.row].optionId {
            self.answerCompletion(right: true)
        } else {
            self.answerCompletion(right: false)
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                cell?.layer.borderColor = UIColor.clear.cgColor
            }
        }
    }
}




