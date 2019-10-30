//
//  YXMineViewController.swift
//  YXEDU
//
//  Created by Jake To on 10/28/19.
//  Copyright © 2019 shiji. All rights reserved.
//

import UIKit

class YXMineViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UICollectionViewDelegate, UICollectionViewDataSource {

    private var badges: [YXBadgeModel] = []
    private var bindInfo: [String] = []
    
    @IBOutlet weak var avatarImageView: YXDesignableImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var myIntegralLabel: UILabel!
    @IBOutlet weak var calendarLabel: UILabel!
    @IBOutlet weak var totalMedalLabel: UILabel!
    @IBOutlet weak var ownedMedalLabel: UILabel!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.interactivePopGestureRecognizer?.delegate = nil
        
        loadData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        navigationController?.setNavigationBarHidden(true, animated: true)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
        navigationController?.setNavigationBarHidden(false, animated: false)
    }
    
    private func loadData() {
        YXComHttpService.shared().requestUserInfo({ (response, isSuccess) in
            if isSuccess, let response = response {
                let loginModel = response as! YXLoginModel
                YXConfigure.shared().loginModel = loginModel
                
                self.loadBadgeData()
                
                self.avatarImageView.sd_setImage(with: URL(string: loginModel.user.avatar), completed: nil)
                self.nameLabel.text = loginModel.user.nick
                self.myIntegralLabel.text = "\(loginModel.user.punchDays ?? 0)"
                self.calendarLabel.text = "\(loginModel.user.punchDays ?? 0)"
                
                let bindLabel = self.tableView.cellForRow(at: IndexPath(row: 0, section: 0))?.viewWithTag(2) as! UILabel
                self.bindInfo = loginModel.user.userBind.components(separatedBy: ",")
                self.bindInfo.insert(loginModel.user.mobile, at: 0)
                if self.bindInfo[1] == "1", self.bindInfo[2] == "2" {
                    
                } else {
                    bindLabel.text = "去绑定"
                }

                let speechLabel = self.tableView.cellForRow(at: IndexPath(row: 1, section: 0))?.viewWithTag(2) as! UILabel
                if loginModel.user.speech == "0" {
                    speechLabel.text = "英式"
                    
                } else {
                    speechLabel.text = "美式"
                }
                
                let materailLabel = self.tableView.cellForRow(at: IndexPath(row: 2, section: 0))?.viewWithTag(2) as! UILabel
                materailLabel.text = "0.00M"
                
                let remindLabel = self.tableView.cellForRow(at: IndexPath(row: 3, section: 0))?.viewWithTag(2) as! UILabel
                if let date = YYCache.object(forKey: "Reminder") as? Date {
                    let dateFormatter = DateFormatter()
                    dateFormatter.dateStyle = .short
                    remindLabel.text = dateFormatter.string(from: date)
                    
                } else {
                    remindLabel.text = "已关闭"
                }
                
                self.tableView.reloadData()
            }
        })
    }
    
    private func loadBadgeData() {
        YXComHttpService.shared().requestBadgesInfo({ (response, isSuccess) in
            if isSuccess, let response = response {
                guard let badgesList = YXConfigure.shared().confModel.badgeList else { return }
                
                for badges in badgesList {
                    for badge in (badges as! YXBadgeListModel).options {
                        self.badges.append(badge as! YXBadgeModel)
                    }
                }
                
//                guard let badgeStatus = (response as! [String: Any])["badgesInfo"] as? [[String:Any]] else { return }
//                for badge in badgeStatus {
//                    let badgeId = badge["badgeId"] as? Int ?? 0
//                    let done = badge["done"] as? Int ?? 0
//                    let status = badge["status"] as? Int ?? 0
//                    let total = badge["total"] as? Int ?? 0
//                    print(badgeId)
//                }

                self.ownedMedalLabel.text = "--"
                self.totalMedalLabel.text = "/\(self.badges.count)"
                self.collectionView.reloadData()
            }
        })
    }
    
    
    
    // MARK: - TableView
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 7
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.row {
        case 0:
            return tableView.dequeueReusableCell(withIdentifier: "CellOne")!
        case 1:
            return tableView.dequeueReusableCell(withIdentifier: "CellTwo")!
        case 2:
            return tableView.dequeueReusableCell(withIdentifier: "CellThree")!
        case 3:
            return tableView.dequeueReusableCell(withIdentifier: "CellFour")!
        case 4:
            return tableView.dequeueReusableCell(withIdentifier: "CellFive")!
        case 5:
            return tableView.dequeueReusableCell(withIdentifier: "CellSix")!
        default:
            return tableView.dequeueReusableCell(withIdentifier: "CellSeven")!
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath.row {
        case 0:
            break

        case 1:
            break

        case 2:
            self.performSegue(withIdentifier: "ManageMaterial", sender: self)
            break

        case 3:
            self.performSegue(withIdentifier: "SetReminder", sender: self)
            break

        case 4:
            self.performSegue(withIdentifier: "AboutUs", sender: self)
            break

        case 5:
            self.performSegue(withIdentifier: "FeedBack", sender: self)
            break
            
        default:
            break
        }
    }
    
    
    
    // MARK: - CollectionView
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return badges.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "BadgeCell", for: indexPath)
        let badge = badges[indexPath.row]
        
        let imageView = cell.viewWithTag(1) as! UIImageView
        imageView.sd_setImage(with: URL(string: badge.realize), completed: nil)
        
        return cell
    }
}
