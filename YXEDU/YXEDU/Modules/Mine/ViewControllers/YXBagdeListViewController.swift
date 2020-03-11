//
//  YXBagdeListViewController.swift
//  YXEDU
//
//  Created by Jake To on 12/25/19.
//  Copyright © 2019 shiji. All rights reserved.
//

import UIKit

class YXBagdeListViewController: YXViewController, UITableViewDelegate, UITableViewDataSource, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {

    var badgeLists: [YXBadgeListModel] = []
    
    
    @IBAction func back(_ sender: UIBarButtonItem) {
        navigationController?.popViewController(animated: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    
    
    // MARK: - UITableView
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return badgeLists.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "YXBadgeListCell", for: indexPath) as! YXBadgeListCell
        let badgeList = badgeLists[indexPath.row]
         
        cell.titleLabel.text = badgeList.title
        
        cell.collectionView.tag = indexPath.row
        cell.collectionView.delegate = self
        cell.collectionView.dataSource = self
        cell.collectionView.register(UINib(nibName: "YXBadgeCell", bundle: nil), forCellWithReuseIdentifier: "YXBadgeCell")
        cell.collectionView.reloadData()
        
        return cell
    }
    
    
    
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
