//
//  YXItemAnswerView.swift
//  YXEDU
//
//  Created by sunwu on 2019/10/25.
//  Copyright © 2019 shiji. All rights reserved.
//

import UIKit

/// 中文或单词答案
class YXItemAnswerView: YXBaseAnswerView, UICollectionViewDelegate, UICollectionViewDataSource {
    
    enum Config {
        static var itemHeight: CGFloat = AdaptSize(42)
        static var itemWidth: CGFloat = screenWidth - AdaptSize(35) * 2
        static var itemInterval: CGFloat = AdaptSize(13)
    }
    
    private var flowLayout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
    private var collectionView: UICollectionView!
    private var collectionViewCell: UICollectionViewCell!
    
    
    var titleLabel: UILabel {
        let label = UILabel()
        label.textColor = UIColor.black2
        label.font = UIFont.pfSCRegularFont(withSize: AdaptSize(14))
        return label
    }
    
    override func createSubviews() {
        super.createSubviews()
        flowLayout = UICollectionViewFlowLayout()
        flowLayout.scrollDirection = .vertical
        flowLayout.itemSize = CGSize(width: Config.itemWidth, height: Config.itemHeight)
        flowLayout.minimumLineSpacing = Config.itemInterval
        flowLayout.minimumInteritemSpacing = 0
        flowLayout.sectionInset = UIEdgeInsets(top: 0, left: AdaptSize(35), bottom: 0, right: AdaptSize(35))

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
        
        self.collectionView.reloadData()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        let itemNum = CGFloat(self.exerciseModel.option?.firstItems?.count ?? 0)
        let h = (Config.itemHeight + Config.itemInterval) * itemNum - Config.itemInterval
        collectionView.snp.makeConstraints { (make) in
            make.center.equalToSuperview()
            make.width.equalToSuperview()
            make.height.equalTo(h)
        }
    }
    
    override func bindData() {
//        self.collectionView.reloadData()
    }
    
        
    //MARK:- delegate
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.exerciseModel.option?.firstItems?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let idf = "UICollectionViewCell"
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: idf, for: indexPath)
        cell.backgroundColor = UIColor.white
        cell.layer.borderWidth = 1
        cell.layer.borderColor = UIColor.black6.cgColor
        
        cell.layer.masksToBounds = true
        cell.layer.cornerRadius = itemSize().height / 2
        
        let label = self.titleLabel
        label.text = exerciseModel.option?.firstItems?[indexPath.row].content
        
        cell.contentView.addSubview(label)
        label.snp.makeConstraints { (make) in
            make.left.equalTo(21)
            make.right.equalTo(-21)
            make.top.bottom.equalToSuperview()
        }
        
        return cell
    }

    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let cell = collectionViewCell {
            cell.backgroundColor = UIColor.white
            cell.layer.borderColor = UIColor.black6.cgColor
            if let label = cell.contentView.subviews.first as? UILabel {
                label.textColor = UIColor.black2
            }
        }
        let cell = collectionView.cellForItem(at: indexPath)
        cell?.layer.borderColor = UIColor.orange1.cgColor
        cell?.backgroundColor = UIColor.orange1
        if let label = cell?.contentView.subviews.first as? UILabel {
            label.textColor = UIColor.white
        }
        collectionViewCell = cell
        
        if exerciseModel.answers?.first == exerciseModel.option?.firstItems?[indexPath.row].optionId {
            self.answerCompletion(right: true)
        } else {
            self.answerCompletion(right: false)
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                cell?.backgroundColor = UIColor.white
                cell?.layer.borderColor = UIColor.black6.cgColor
                if let label = cell?.contentView.subviews.first as? UILabel {
                    label.textColor = UIColor.black2
                }
            }
            
        }
    }

    
    private func itemSize() -> CGSize {
        return CGSize(width: Config.itemWidth, height: Config.itemHeight)
    }
    
}
