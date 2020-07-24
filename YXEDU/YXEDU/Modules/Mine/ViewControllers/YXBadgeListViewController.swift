//
//  YXBadgeListViewController.swift
//  YXEDU
//
//  Created by Jake To on 12/25/19.
//  Copyright © 2019 shiji. All rights reserved.
//

import UIKit

class YXBadgeListViewController: YXViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    // TODO: ---- Subviews ----
    var backgroundImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "badgeListBackground")
        return imageView
    }()
    
    var backButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "comNaviBack_white_normal"), for: .normal)
        return button
    }()
    
    var badgeImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "badgeImage")
        return imageView
    }()
    
    var titleLabel: UILabel = {
        let label = UILabel()
        label.text          = "我的徽章"
        label.textColor     = UIColor.orange1
        label.font          = UIFont.regularFont(ofSize: AdaptFontSize(12))
        label.textAlignment = .center
        return label
    }()
    
    var badgeNumberLabel: UILabel = {
        let label = UILabel()
        label.text          = "-/-"
        label.textColor     = UIColor.orange1
        label.font          = UIFont.DINAlternateBold(ofSize: 17)
        label.textAlignment = .center
        return label
    }()
    
    var collectionViewBackgroundView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        return view
    }()
    
    var collectionView: UICollectionView = {
        let width = (screenWidth - 120) / 3
        let layout = UICollectionViewFlowLayout()
        layout.itemSize                = CGSize(width: width, height: width)
        layout.minimumLineSpacing      = 20
        layout.minimumInteritemSpacing = 20
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.showsVerticalScrollIndicator   = false
        collectionView.showsHorizontalScrollIndicator = false
        return collectionView
    }()
    
    // TODO: ---- Data ----
    var badgeModelList: [YXBadgeModel] = []
    var earnedBadgeCount = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.createSubviews()
        self.bindProperty()
        self.collectionView.reloadData()
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        self.badgeNumberLabel.sizeToFit()
        self.badgeNumberLabel.snp.updateConstraints { (make) in
            make.size.equalTo(self.badgeNumberLabel.size)
        }
    }
    
    private func createSubviews() {
        self.view.addSubview(backgroundImageView)
        self.view.addSubview(backButton)
        self.view.addSubview(badgeImageView)
        self.view.addSubview(collectionViewBackgroundView)
        collectionViewBackgroundView.addSubview(collectionView)
        badgeImageView.addSubview(titleLabel)
        badgeImageView.addSubview(badgeNumberLabel)
        
        backgroundImageView.snp.makeConstraints { (make) in
            make.left.top.right.equalToSuperview()
            make.height.equalTo(AdaptSize(327))
        }
        backButton.snp.makeConstraints { (make) in
            make.left.equalToSuperview().offset(AdaptSize(16))
            make.top.equalToSuperview().offset(kStatusBarHeight + AdaptSize(16))
            make.size.equalTo(CGSize(width: AdaptSize(22), height: AdaptSize(22)))
        }
        badgeImageView.snp.makeConstraints { (make) in
            make.top.equalTo(backButton).offset(AdaptSize(3))
            make.centerX.equalToSuperview()
            make.size.equalTo(CGSize(width: AdaptSize(164), height: AdaptSize(73)))
        }
        titleLabel.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.top.equalToSuperview().offset(AdaptSize(20))
            make.size.equalTo(CGSize(width: AdaptSize(100), height: AdaptSize(17)))
        }
        badgeNumberLabel.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.top.equalTo(titleLabel.snp.bottom)
            make.size.equalTo(CGSize.zero)
        }
        collectionViewBackgroundView.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.bottom.equalToSuperview().inset(20)
            make.top.equalTo(badgeImageView.snp.bottom).offset(AdaptSize(23))
            make.left.right.equalToSuperview().inset(20)
        }
        collectionView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview().inset(20)
        }
    }
    
    private func bindProperty() {
        self.collectionView.delegate        = self
        self.collectionView.dataSource      = self
        self.collectionView.backgroundColor = UIColor.clear
        self.badgeNumberLabel.text          = String(format: "%ld/%ld", self.earnedBadgeCount, self.badgeModelList.count)
        self.collectionViewBackgroundView.layer.setDefaultShadow()
        self.collectionViewBackgroundView.layer.cornerRadius = AdaptSize(8)
        self.collectionView.register(YXBadgeCell.classForCoder(), forCellWithReuseIdentifier: "kYXBadgeCell")
        self.backButton.addTarget(self, action: #selector(backAction), for: .touchUpInside)
    }
    
    // MARK: ---- Event ----
    @objc private func backAction() {
        YRRouter.sharedInstance().currentNavigationController()?.popViewController(animated: true)
    }
    
    // MARK: - UICollectionView
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.badgeModelList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "kYXBadgeCell", for: indexPath) as? YXBadgeCell else {
            return UICollectionViewCell()
        }
        let badgeModel = self.badgeModelList[indexPath.row]
        cell.setData(badgeModel)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let badge = self.badgeModelList[indexPath.row]
        
        var badgeDetailView: YXBadgeDetailView?
        if let finishDateTimeInterval = badge.finishDateTimeInterval, finishDateTimeInterval != 0 {
            badgeDetailView = YXBadgeDetailView(badge: badge, didCompleted: true)

        } else {
            badgeDetailView = YXBadgeDetailView(badge: badge, didCompleted: false)
        }
        
        badgeDetailView?.show()
    }
}
