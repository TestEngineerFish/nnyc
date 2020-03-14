//
//  YXBagdeListViewController.swift
//  YXEDU
//
//  Created by Jake To on 12/25/19.
//  Copyright © 2019 shiji. All rights reserved.
//

import UIKit

class YXBagdeListViewController: YXViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
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
        label.font          = UIFont.regularFont(ofSize: AdaptSize(12))
        label.textAlignment = .center
        return label
    }()
    
    var badgeNumberLabel: UILabel = {
        let label = UILabel()
        label.text          = "-/-"
        label.textColor     = UIColor.orange1
        label.font          = UIFont.DINAlternateBold(ofSize: AdaptSize(17))
        label.textAlignment = .center
        return label
    }()
    
    var collectionViewBackgroundView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        return view
    }()
    
    var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.itemSize                = CGSize(width: AdaptSize(94.3), height: AdaptSize(93.1))
        layout.minimumLineSpacing      = AdaptSize(20)
        layout.minimumInteritemSpacing = AdaptSize(20)
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        return collectionView
    }()
    
    // TODO: ---- Data ----
    var badgeLists: [YXBadgeListModel] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.createSubviews()
        self.bindProperty()
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
            make.size.equalTo(CGSize(width: AdaptSize(50), height: AdaptSize(17)))
        }
        badgeNumberLabel.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.top.equalTo(titleLabel.snp.bottom)
            make.size.equalTo(CGSize.zero)
        }
        collectionViewBackgroundView.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.bottom.equalToSuperview()
            make.top.equalTo(AdaptSize(23))
            make.width.equalTo(AdaptSize(357))
        }
        collectionView.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.top.equalToSuperview().offset(AdaptSize(18))
            make.width.equalTo(AdaptSize(323))
        }
    }
    
    private func bindProperty() {
        self.collectionView.delegate   = self
        self.collectionView.dataSource = self
    }
    
    // MARK: ---- Event ----
    @objc private func backAction() {
        YRRouter.sharedInstance()?.currentNavigationController()?.popViewController(animated: true)
    }
    
    
//    // MARK: - UITableView
//    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        return badgeLists.count
//    }
//    
//    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        let cell = tableView.dequeueReusableCell(withIdentifier: "YXBadgeListCell", for: indexPath) as! YXBadgeListCell
//        let badgeList = badgeLists[indexPath.row]
//         
//        cell.titleLabel.text = badgeList.title
//        
//        cell.collectionView.tag = indexPath.row
//        cell.collectionView.delegate = self
//        cell.collectionView.dataSource = self
//        cell.collectionView.register(UINib(nibName: "YXBadgeCell", bundle: nil), forCellWithReuseIdentifier: "YXBadgeCell")
//        cell.collectionView.reloadData()
//        
//        return cell
//    }
    
    
    
    // MARK: - UICollectionView
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return badgeLists[collectionView.tag].badges?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "YXBadgeCell", for: indexPath) as! YXBadgeCell
        let badge = badgeLists[collectionView.tag].badges?[indexPath.row]
        
        cell.titleLabel.text = badge?.name
        
        if let finishDateTimeInterval = badge?.finishDateTimeInterval, finishDateTimeInterval != 0, let imageOfCompletedStatus = badge?.imageOfCompletedStatus {
            cell.imageView.sd_setImage(with: URL(string: imageOfCompletedStatus), completed: nil)
            let dateFormatter = DateFormatter()
            dateFormatter.dateStyle = .long
            let dateString = dateFormatter.string(from: Date(timeIntervalSince1970: finishDateTimeInterval))
            cell.descriptionLabel.text = "\(dateString)"

        } else if let imageOfIncompletedStatus = badge?.imageOfIncompletedStatus {
            cell.imageView.sd_setImage(with: URL(string: imageOfIncompletedStatus), completed: nil)
            cell.descriptionLabel.text = "未获得"
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let badge = badgeLists[collectionView.tag].badges?[indexPath.row] else { return }
        
        var badgeDetailView: YXBadgeDetailView!
        if let finishDateTimeInterval = badge.finishDateTimeInterval, finishDateTimeInterval != 0 {
            badgeDetailView = YXBadgeDetailView(badge: badge, didCompleted: true)

        } else {
            badgeDetailView = YXBadgeDetailView(badge: badge, didCompleted: false)
        }
        
        badgeDetailView.show()
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 92, height: 154)
    }
}
