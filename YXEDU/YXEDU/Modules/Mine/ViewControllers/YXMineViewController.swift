//
//  YXMineViewController.swift
//  YXEDU
//
//  Created by Jake To on 10/28/19.
//  Copyright © 2019 shiji. All rights reserved.
//

import UIKit

class YXMineViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UICollectionViewDelegate, UICollectionViewDataSource {

    private var temporaryUserModel: YXUserModel_Old?
    
    private var badges: [YXPersonalBadgeModel] = []
    private var innerBadges: [YXPersonalBadgeModel] = []
    private var bindInfo: [String] = ["", "", ""]
    
    @IBOutlet weak var avatarImageView: YXDesignableImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var myIntegralLabel: UILabel!
    @IBOutlet weak var calendarLabel: UILabel!
    @IBOutlet weak var totalMedalLabel: UILabel!
    @IBOutlet weak var ownedMedalLabel: UILabel!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var tableView: UITableView!
    
    @IBAction func tapCalendar(_ sender: UITapGestureRecognizer) {
        navigationController?.pushViewController(YXCalendarViewController(), animated: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.interactivePopGestureRecognizer?.delegate = nil
        
        NotificationCenter.default.addObserver(self, selector: #selector(thirdPartLogin), name: NSNotification.Name(rawValue: "CompletedBind"), object: nil)
        
        loadData()
        tabBarController?.selectedIndex = 0
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        navigationController?.setNavigationBarHidden(true, animated: false)
        
        loadData()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
        navigationController?.setNavigationBarHidden(false, animated: false)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "Setting" {
            let destinationViewController = segue.destination as! YXPersonalInformationVC
            destinationViewController.userModel = temporaryUserModel!
            
        } else if segue.identifier == "Badge" {
            let destinationViewController = segue.destination as! YXPersonalMyBadgesVC
            
            guard let badgesList = YXConfigure.shared().confModel.badgeList else { return }
            
            var currentIndex = 0
            var sectionBadges: [[YXPersonalBadgeModel]] = []
            
            for badges in (badgesList as! [YXBadgeListModel]) {
                var newBadges: [YXPersonalBadgeModel] = []
                
                for _ in (badges.options as! [YXBadgeModel]) {
                    newBadges.append(self.innerBadges[currentIndex])
                    currentIndex = currentIndex + 1
                }
                
                sectionBadges.append(newBadges)
            }
            
            destinationViewController.badges = sectionBadges
        }
    }
    
    private func loadData() {
        YXComHttpService.shared().requestUserInfo({ (response, isSuccess) in
            if isSuccess, let response = response {
                let loginModel = response as! YXLoginModel
                YXConfigure.shared().loginModel = loginModel
                self.temporaryUserModel = loginModel.user
                
                // 积分
                self.loadIntegralData()
                
                // 徽章
                self.loadBadgeData()
                
                // 个人信息
                YXUserModel.default.userAvatarPath = loginModel.user.avatar
                YXUserModel.default.username = loginModel.user.nick
                self.avatarImageView.sd_setImage(with: URL(string: YXUserModel.default.userAvatarPath ?? ""), placeholderImage: #imageLiteral(resourceName: "userPlaceHolder"), completed: nil)
                self.nameLabel.text = YXUserModel.default.username
                self.calendarLabel.text = "\(loginModel.user.punchDays ?? 0)"
                
                // 账户信息
                let bindLabel = self.tableView.cellForRow(at: IndexPath(row: 0, section: 0))?.viewWithTag(2) as? UILabel
                self.bindInfo = [loginModel.user.mobile, "", ""]

                if loginModel.user.userBind.contains(",1") {
                    self.bindInfo[1] = "1"
                }
                
                if loginModel.user.userBind.contains(",2") {
                    self.bindInfo[2] = "2"
                }
                
                if self.bindInfo[1] == "1", self.bindInfo[2] == "2" {
                    bindLabel?.text = ""
                    
                } else {
                    bindLabel?.text = "去绑定"
                }

                // 发音
                let speechLabel = self.tableView.cellForRow(at: IndexPath(row: 1, section: 0))?.viewWithTag(2) as? UILabel
                if loginModel.user.speech == "0" {
                    speechLabel?.text = "英式"
                    YXUserModel.default.didUseAmericanPronunciation = false
                    
                } else {
                    speechLabel?.text = "美式"
                    YXUserModel.default.didUseAmericanPronunciation = true
                }
                
                // 素材包管理
                let materailLabel = self.tableView.cellForRow(at: IndexPath(row: 2, section: 0))?.viewWithTag(2) as? UILabel
                materailLabel?.text = "0.00M"
                
                // 每日提醒
                let remindLabel = self.tableView.cellForRow(at: IndexPath(row: 3, section: 0))?.viewWithTag(2) as? UILabel
                if let date = UserDefaults.standard.object(forKey: "Reminder") as? Date {
                    let dateFormatter = DateFormatter()
                    dateFormatter.timeStyle = .short
                    remindLabel?.text = dateFormatter.string(from: date)
                    
                } else {
                    remindLabel?.text = "已关闭"
                }
                
                self.tableView.reloadData()
            }
        })
    }
    
    private func loadIntegralData() {
        YXDataProcessCenter.get("\(YXEvnOC.baseUrl())/v1/user/credits", parameters: [:]) { (response, isSuccess) in
            guard isSuccess, let response = response?.responseObject else { return }
            self.myIntegralLabel.text = "\((response as! [String: Any])["userCredits"] as? Int ?? 0)"
        }
    }
    
    private func loadBadgeData() {
        self.badges = []
        
        YXComHttpService.shared().requestBadgesInfo({ (response, isSuccess) in
            if isSuccess, let response = response {
                guard let configure = YXConfigure.shared().confModel, let badgesList = configure.badgeList, let badgeStatus = (response as! [String: Any])["badgesInfo"] as? [[String:Any]] else { return }
                
                var earnedBadgeCount = 0
                var currentIndex = 0
                for a in 0..<badgesList.count {
                    let badges = (badgesList[a] as! YXBadgeListModel).options as! [YXBadgeModel]
                    for b in 0..<badges.count {
                        let badge = badges[b]
                        
                        let personalBadgeModel = YXPersonalBadgeModel()
                        personalBadgeModel.badgeID = badge.badgeId
                        personalBadgeModel.badgeName = badge.badgeName
                        personalBadgeModel.completedBadgeImageUrl = badge.realize
                        personalBadgeModel.incompleteBadgeImageUrl = badge.unRealized
                        personalBadgeModel.desc = badge.desc
                        
                        let badgeState = badgeStatus[currentIndex]
                        if let finishDate = badgeState["finishTime"] as? Double {
                            personalBadgeModel.finishDate = "\(finishDate)"
                            
                        } else {
                            personalBadgeModel.finishDate = "0"
                        }
                        personalBadgeModel.done = "\(badgeState["done"] as? Int ?? 0)"
                        personalBadgeModel.total = "\(badgeState["total"] as? Int ?? 0)"
                            
                        currentIndex = currentIndex + 1
                        if personalBadgeModel.finishDate != "0" {
                            earnedBadgeCount = earnedBadgeCount + 1
                        }
                        
                        self.badges.append(personalBadgeModel)
                    }
                }
                
                self.innerBadges = self.badges
                
                var newBadge = self.badges
                for index in 0..<self.badges.count {
                    let badge = self.badges[index]
                    
                    guard badge.finishDate != "0" else { continue }
                    newBadge.insert(badge, at: 0)
                    newBadge.remove(at: index + 1)
                }
                self.badges = newBadge

                self.ownedMedalLabel.text = "\(earnedBadgeCount)"
                self.totalMedalLabel.text = "/\(badgeStatus.count)"
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
        tableView.deselectRow(at: indexPath, animated: false)
        
        switch indexPath.row {
        case 0:
            let accountInfoView = YXAccountInfoView()
            accountInfoView.bindInfo = bindInfo
            accountInfoView.bindQQClosure = {
                if self.bindInfo[1] == "1" {
                    let alert = UIAlertController(title: "解绑后将无法使用QQ进行登录", message: "", preferredStyle: .alert)
                    let action1 = UIAlertAction(title: "确定", style: .default) { action in
                        YXPersonalViewModel().unbindSO("qq") { (response, isSuccess) in
                            guard isSuccess, let _ = response else { return }
                            self.loadData()
                        }
                    }
                    alert.addAction(action1)

                    let action2 = UIAlertAction(title: "取消", style: .cancel, handler: nil)
                    alert.addAction(action2)
                    
                    self.present(alert, animated: true)
                    
                } else {
                    QQApiManager.shared().qqLogin()
                }
            }
            
            accountInfoView.bindWechatClosure = {
                if self.bindInfo[2] == "2" {
                    let alert = UIAlertController(title: "解绑后将无法使用微信进行登录", message: "", preferredStyle: .alert)
                    let action1 = UIAlertAction(title: "确定", style: .default) { action in
                        YXPersonalViewModel().unbindSO("wechat") { (response, isSuccess) in
                            guard isSuccess, let _ = response else { return }
                            self.loadData()
                        }
                    }
                    alert.addAction(action1)

                    let action2 = UIAlertAction(title: "取消", style: .cancel, handler: nil)
                    alert.addAction(action2)
                    
                    self.present(alert, animated: true)
                    
                } else {
                    WXApiManager.shared().wxLogin()
                }
            }
            
            accountInfoView.show()
            break

        case 1:
            let alertController = UIAlertController(title: "选择音标和发音", message: nil, preferredStyle: .actionSheet)
            
            let englishAction = UIAlertAction(title: "英式音标和发音", style: .default) { (action) in
                YXDataProcessCenter.post("\(YXEvnOC.baseUrl())/v1/user/setup", parameters: ["speech": "0"]) { (response, isSuccess) in
                    guard isSuccess, let _ = response else { return }
                    YXConfigure.shared().isUSVoice = false
                    self.loadData()
                }
            }
            
            let usAction = UIAlertAction(title: "美式音标和发音", style: .default) { (action) in
                YXDataProcessCenter.post("\(YXEvnOC.baseUrl())/v1/user/setup", parameters: ["speech": "1"]) { (response, isSuccess) in
                    guard isSuccess, let _ = response else { return }
                    YXConfigure.shared().isUSVoice = true
                    self.loadData()
                }
            }
            
            let cancleAction = UIAlertAction(title: "取消", style: .cancel, handler: nil)
            
            alertController.addAction(englishAction)
            alertController.addAction(usAction)
            alertController.addAction(cancleAction)

            self.present(alertController, animated: true, completion: nil)
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
            
        case 6:
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
        
        if badge.finishDate == "0" {
            imageView.sd_setImage(with: URL(string: badge.incompleteBadgeImageUrl), completed: nil)
            
        } else {
            imageView.sd_setImage(with: URL(string: badge.completedBadgeImageUrl), completed: nil)
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.performSegue(withIdentifier: "Badge", sender: self)
    }
    
    
    
    // MARK: - 第三方登录
    @objc
    private func thirdPartLogin(_ notification: Notification) {
        guard let userInfo = notification.userInfo else { return }
        
        let personalBindModel = YXPersonalBindModel()
        personalBindModel.bind_pf = userInfo["platfrom"] as? String
        personalBindModel.code = userInfo["token"] as? String
        personalBindModel.openid = (userInfo["openID"] as? String == nil) ? "" : userInfo["openID"] as? String
        
        YXPersonalViewModel().bindSO(personalBindModel) { (response, isSuccess) in
            guard isSuccess, let _ = response else { return }
            self.loadData()
        }
    }
}
