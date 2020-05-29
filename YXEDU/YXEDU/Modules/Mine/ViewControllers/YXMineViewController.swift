//
//  YXMineViewController.swift
//  YXEDU
//
//  Created by Jake To on 10/28/19.
//  Copyright © 2019 shiji. All rights reserved.
//

import UIKit

class YXMineViewController: YXViewController, UITableViewDelegate, UITableViewDataSource, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {

    private var temporaryUserModel: YXNewLoginUserInfoModel?
    private var earnedBadgeCount = 0
    private var badgeModelList   = [YXBadgeModel]()
    private var bindInfo         = ["", "", ""]
    
    @IBOutlet weak var avatarImageView: YXDesignableImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var myIntegralLabel: UILabel!
    @IBOutlet weak var calendarLabel: UILabel!
    @IBOutlet weak var totalMedalLabel: UILabel!
    @IBOutlet weak var ownedMedalLabel: UILabel!
    @IBOutlet weak var badgeNumberView: UIView!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var tableView: UITableView!
    let badgeView = YXRedDotView()
    
    @IBOutlet weak var myIntegralViewHeight: NSLayoutConstraint!
    @IBOutlet weak var myIntegralViewTopOffset: NSLayoutConstraint!
    @IBOutlet weak var collectionLeftConsraint: NSLayoutConstraint!
    @IBOutlet weak var collectionRightConsraint: NSLayoutConstraint!

    @IBAction func tapCoin(_ sender: UITapGestureRecognizer) {
        self.performSegue(withIdentifier: "Coin", sender: self)
    }
    
    @IBAction func tapCalendar(_ sender: UITapGestureRecognizer) {
        self.performSegue(withIdentifier: "Calendar", sender: self)
    }
    
    @IBAction func edit(_ sender: UITapGestureRecognizer) {
        self.performSegue(withIdentifier: "Edit", sender: self)
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.bindProperty()
        
        if isPad() {
            myIntegralViewHeight.constant = 112
            myIntegralViewTopOffset.constant = 44
        }
        
//        self.refreshUserInfoData()
    }
    
    private func bindProperty() {
        self.collectionLeftConsraint.constant  = AdaptSize(22)
        self.customNavigationBar?.isHidden     = true
        let tapAction = UITapGestureRecognizer(target: self, action: #selector(pushBadgeListVC))
          self.badgeNumberView.addGestureRecognizer(tapAction)
        navigationController?.interactivePopGestureRecognizer?.delegate = nil
    }

    override func addNotification() {
        NotificationCenter.default.addObserver(self, selector: #selector(thirdPartLogin), name: NSNotification.Name(rawValue: "CompletedBind"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(refreshData), name: YXNotification.kUpdateFeedbackReplyBadge, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(refreshUserInfoData), name: YXNotification.kMineTabUserInfo, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(refreshBadgeData), name: YXNotification.kMineTabBadge, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(refreshIntegralData), name: YXNotification.kMineTabIntegral, object: nil)
    }

    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
        navigationController?.navigationBar.barTintColor = UIColor.white
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.black]
        navigationController?.navigationBar.tintColor = UIColor.black
        
        // 个人信息
        self.loadData()
        // 徽章
        self.refreshBadgeData()
        self.loadBadgeData()
        // 积分
        self.refreshIntegralData()
        self.loadIntegralData()
        YXAlertCheckManager.default.checkLatestBadgeWhenBackTabPage()
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "Edit" {
            let destinationViewController = segue.destination as! YXPersonalInformationVC
            let userModel = YXUserModel_Old()
            userModel.avatar = temporaryUserModel?.avatar
            userModel.nick = temporaryUserModel?.nick
            userModel.sex = "\(temporaryUserModel?.sex ?? 0)"
            userModel.area = temporaryUserModel?.area
            userModel.mobile = temporaryUserModel?.mobile
            userModel.birthday = temporaryUserModel?.birthday
            userModel.speech = temporaryUserModel?.speech
            userModel.grade = temporaryUserModel?.grade

            destinationViewController.userModel = userModel
            
        } else if segue.identifier == "Coin" {
            let squirrelCoinViewController = segue.destination as! YXSquirrelCoinViewController
            squirrelCoinViewController.coinAmount = self.myIntegralLabel.text
        }
    }

    // MARK: ---- Request ----

    /// 请求个人信息
    private func loadData() {
        let request = YXMineRequest.getUserInfo
        YYNetworkService.default.request(YYStructResponse<YXNewLoginModel>.self, request: request, success: { (response) in
            guard let loginModel = response.data else { return }
            self.updateUserInfo(loginModel: loginModel)
//            YXFileManager.share.saveJsonToFile(with: loginModel.toJSONString() ?? "", type: .mine_userInfo)
        }, fail: nil)
    }

    /// 请求徽章列表
    private func loadBadgeData() {
        let request = YXMineRequest.badgeList
        YYNetworkService.default.request(YYStructDataArrayResponse<YXBadgeModel>.self, request: request, success: { [weak self] (response) in
            guard let self = self, let modelList = response.dataArray else { return }
            self.updateBadgeData(modelList: modelList)
            if let jsonStr = modelList.toJSONString() {
                YXFileManager.share.saveJsonToFile(with: jsonStr, type: .mine_badge)
            }
        }) { error in
            YXUtils.showHUD(kWindow, title: error.message)
        }
    }

    /// 请求积分信息
    private func loadIntegralData() {
        let request = YXMineRequest.getCreditsInfo
        YYNetworkService.default.request(YYStructResponse<YXResultModel>.self, request: request, success: { (response) in
            guard let credits = response.data?.credits else { return }
            let dict = ["userCredits": credits]
            self.updateIntegralData(dict: dict)
            YXFileManager.share.saveJsonToFile(with: dict.toJson(), type: .mine_integral)
        }, fail: nil)
    }

    // MARK: ---- Update UI ----

    /// 更新个人信息
    private func updateUserInfo(loginModel: YXNewLoginModel) {
        self.temporaryUserModel            = loginModel.user
        YXUserModel.default.userAvatarPath = loginModel.user?.avatar
        YXUserModel.default.username       = loginModel.user?.nick
        self.avatarImageView.sd_setImage(with: URL(string: YXUserModel.default.userAvatarPath ?? ""), placeholderImage: #imageLiteral(resourceName: "challengeAvatar"), completed: nil)
        self.nameLabel.text     = YXUserModel.default.username
        if let garde = loginModel.user?.grade, !garde.isEmpty {
            self.nameLabel.text = (YXUserModel.default.username ?? "") + "   " + garde + "年级"
        }
        self.calendarLabel.text = "\(loginModel.user?.punchDays ?? 0)"

        // 账户信息
        let bindLabel = self.tableView.cellForRow(at: IndexPath(row: 0, section: 0))?.viewWithTag(2) as? UILabel
        self.bindInfo = [loginModel.user?.mobile ?? "", "", ""]

        if loginModel.user?.userBind?.contains(",1") ?? false || loginModel.user?.userBind?.contains("1")  ?? false {
            self.bindInfo[1] = "1"
        }

        if loginModel.user?.userBind?.contains(",2") ?? false || loginModel.user?.userBind?.contains("2")  ?? false {
            self.bindInfo[2] = "2"
        }

        if self.bindInfo[1] == "1", self.bindInfo[2] == "2" {
            bindLabel?.text = ""

        } else {
            bindLabel?.text = "去绑定"
        }

        // 发音
        let speechLabel = self.tableView.cellForRow(at: IndexPath(row: 1, section: 0))?.viewWithTag(2) as? UILabel
        if YXUserModel.default.didUseAmericanPronunciation {
            speechLabel?.text = "美式"
        } else {
            speechLabel?.text = "英式"
        }

        // 每日提醒
        let remindLabel = self.tableView.cellForRow(at: IndexPath(row: 2, section: 0))?.viewWithTag(2) as? UILabel
        if let date = UserDefaults.standard.object(forKey: "Reminder") as? Date {
            let dateFormatter = DateFormatter()
            dateFormatter.timeStyle = .short
            remindLabel?.text = dateFormatter.string(from: date)

        } else {
            remindLabel?.text = "已关闭"
        }

        YYCache.set(loginModel.notify, forKey: YXLocalKey.newFeedbackReply)
        self.tableView.reloadData()
    }

    /// 更新徽章列表
    private func updateBadgeData(modelList: [YXBadgeModel]) {
        if modelList.isEmpty { return }
        self.earnedBadgeCount = 0
        self.badgeModelList   = modelList
        modelList.forEach { (model) in
            if let finishDateTimeInterval = model.finishDateTimeInterval, finishDateTimeInterval != 0 {
                self.earnedBadgeCount += 1
            }
        }
        self.ownedMedalLabel.text = "\(self.earnedBadgeCount)"
        self.totalMedalLabel.text = "/\(self.badgeModelList.count)"

        self.badgeModelList.sort { (one, two) -> Bool in
            return (one.finishDateTimeInterval ?? 0) > (two.finishDateTimeInterval ?? 0)
        }

        self.collectionView.reloadData()
    }

       /// 更新积分信息
     private func updateIntegralData(dict: [String:Any]) {
         guard let number = dict["userCredits"] as? Int else {
             return
         }
         self.myIntegralLabel.text = "\(number)"
     }

    
    // MARK: ---- Event ----
    @objc private func pushBadgeListVC() {
        let vc = YXBadgeListViewController()
        vc.hidesBottomBarWhenPushed = true
        var acquireBadgeList    = [YXBadgeModel]()
        var notAcquireBadgeList = [YXBadgeModel]()
        badgeModelList.forEach { (model) in
            if model.finishDateTimeInterval != .some(0) {
                acquireBadgeList.append(model)
            } else {
                notAcquireBadgeList.append(model)
            }
        }
        vc.badgeModelList   = self.badgeModelList
        vc.earnedBadgeCount = self.earnedBadgeCount
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    // MARK: - TableView
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 6
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
            let cell = tableView.dequeueReusableCell(withIdentifier: "CellFive")!
            let badgeNum = YXRedDotManager.share.getFeedbackReplyBadgeNum()
            cell.addSubview(badgeView)
            badgeView.snp.makeConstraints { (make) in
                make.centerY.equalToSuperview()
                make.right.equalToSuperview().offset(-AdaptSize(30))
                make.size.equalTo(badgeView.size)
            }
            badgeView.isHidden = badgeNum <= 0
            return cell
        default:
            return tableView.dequeueReusableCell(withIdentifier: "CellSix")!
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
                        let request = YXRegisterAndLoginRequest.unbind(platfrom: "qq")
                        YYNetworkService.default.request(YYStructResponse<YXResultModel>.self, request: request, success: { [weak self] (response) in
                            guard let self = self, let data = response.data else { return }
                            self.loadData()

                        }) { error in
                            YXUtils.showHUD(kWindow, title: error.message)
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
                        let request = YXRegisterAndLoginRequest.unbind(platfrom: "wechat")
                        YYNetworkService.default.request(YYStructResponse<YXResultModel>.self, request: request, success: { [weak self] (response) in
                            guard let self = self, let data = response.data else { return }
                            self.loadData()

                        }) { error in
                            YXUtils.showHUD(kWindow, title: error.message)
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
                YXUserModel.default.didUseAmericanPronunciation = false
                YXConfigure.shared().isUSVoice = false
                self.loadData()
            }
            
            let usAction = UIAlertAction(title: "美式音标和发音", style: .default) { (action) in
                YXUserModel.default.didUseAmericanPronunciation = true
                YXConfigure.shared().isUSVoice = true
                self.loadData()
            }
            
            let cancleAction = UIAlertAction(title: "取消", style: .cancel, handler: nil)
            
            alertController.addAction(englishAction)
            alertController.addAction(usAction)
            alertController.addAction(cancleAction)

            if let cell = tableView.cellForRow(at: indexPath), UIDevice.current.userInterfaceIdiom == .pad, let popoverPresentationController = alertController.popoverPresentationController {
                let frame = tableView.convert(cell.frame, from: tableView)
                popoverPresentationController.sourceView = self.view
                popoverPresentationController.sourceRect = CGRect(x: screenWidth - 44, y: self.tableView.frame.minY + frame.midY, width: 44, height: 44)
            }
            
            self.present(alertController, animated: true, completion: nil)
            break

        case 2:
            self.performSegue(withIdentifier: "SetReminder", sender: self)
            break

        case 3:
            break

        case 4:
            self.performSegue(withIdentifier: "FeedBack", sender: self)
            break

        case 5:
            self.performSegue(withIdentifier: "Settings", sender: self)
            break
            
        default:
            break
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == 3 {
            return 6
        } else {
            return 44
        }
    }
    
    // MARK: - CollectionView
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return badgeModelList.count > 3 ? 3 : badgeModelList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "BadgeCell", for: indexPath)
        let badge = badgeModelList[indexPath.row]
        
        let imageView = cell.viewWithTag(1) as! UIImageView
        
        if let finishDateTimeInterval = badge.finishDateTimeInterval, finishDateTimeInterval != 0, let imageOfCompletedStatus = badge.imageOfCompletedStatus {
            imageView.sd_setImage(with: URL(string: imageOfCompletedStatus), completed: nil)
            
        } else if let imageOfIncompletedStatus = badge.imageOfIncompletedStatus {
            imageView.sd_setImage(with: URL(string: imageOfIncompletedStatus), completed: nil)
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.pushBadgeListVC()
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return AdaptSize(17)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: AdaptSize(94.3), height: AdaptSize(73))
    }

    // MARK: ---- Notification ----

    /// 刷新个人信息
    @objc private func refreshUserInfoData() {
//        if let jsonStr = YXFileManager.share.getJsonFromFile(type: .mine_userInfo), let loginModel = YXNewLoginModel.init(JSONString: jsonStr) {
//            self.updateUserInfo(loginModel: loginModel)
//        }
    }

    /// 刷新徽章
    @objc private func refreshBadgeData() {
        if let jsonListStr = YXFileManager.share.getJsonFromFile(type: .mine_badge), let modelList = Array<YXBadgeModel>(JSONString: jsonListStr) {
            self.updateBadgeData(modelList: modelList)
        }
    }

    /// 刷新积分
    @objc private func refreshIntegralData() {
        if let jsonStr = YXFileManager.share.getJsonFromFile(type: .mine_integral) {
            self.updateIntegralData(dict: jsonStr.convertToDictionary())
        }
    }

    @objc private func refreshData() {
        self.tableView.reloadData()
    }

    // ---- 第三方登录
    @objc
    private func thirdPartLogin(_ notification: Notification) {
        guard let userInfo = notification.userInfo else { return }
  
        let request = YXRegisterAndLoginRequest.bind2(platfrom: userInfo["platfrom"] as? String ?? "", openId: userInfo["openID"] as? String ?? "", code: userInfo["token"] as? String ?? "")
        YYNetworkService.default.request(YYStructResponse<YXResultModel>.self, request: request, success: { [weak self] (response) in
            guard let self = self, let data = response.data else { return }
            self.loadData()

        }) { error in
            YXUtils.showHUD(kWindow, title: error.message)
        }
    }
}
