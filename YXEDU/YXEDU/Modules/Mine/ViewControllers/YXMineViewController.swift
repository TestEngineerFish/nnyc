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

    let badgeView = YXRedDotView()
    @IBOutlet weak var avatarImageView: YXDesignableImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var myIntegralLabel: UILabel!
    @IBOutlet weak var calendarLabel: UILabel!
    @IBOutlet weak var totalMedalLabel: UILabel!
    @IBOutlet weak var ownedMedalLabel: UILabel!
    @IBOutlet weak var badgeNumberView: UIView!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var myIntegralViewHeight: NSLayoutConstraint!
    @IBOutlet weak var myIntegralViewTopOffset: NSLayoutConstraint!
    @IBOutlet weak var collectionLeftConsraint: NSLayoutConstraint!
    @IBOutlet weak var collectionRightConsraint: NSLayoutConstraint!
    @IBOutlet weak var collectionHeightConstraint: NSLayoutConstraint!

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
    }
    
    private func bindProperty() {
        self.collectionLeftConsraint.constant    = AdaptSize(22)
        self.collectionHeightConstraint.constant = AdaptSize(73)
        self.customNavigationBar?.isHidden       = true
        let tapBadge  = UITapGestureRecognizer(target: self, action: #selector(pushBadgeListVC))
        let tapAvatar = UITapGestureRecognizer(target: self, action: #selector(pushUserInfoVC))
        self.badgeNumberView.addGestureRecognizer(tapBadge)
        self.avatarImageView.addGestureRecognizer(tapAvatar)
        self.avatarImageView.layer.masksToBounds = false
    }

    override func addNotification() {
        NotificationCenter.default.addObserver(self, selector: #selector(thirdPartLogin), name: NSNotification.Name(rawValue: "CompletedBind"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(refreshData), name: YXNotification.kUpdateFeedbackReplyBadge, object: nil)
    }

    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        // 个人信息
        self.loadData()
        // 徽章
        self.loadBadgeData()
        // 积分
        self.loadIntegralData()
        YXAlertCheckManager.default.checkLatestBadge()
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "Coin" {
            guard let squirrelCoinViewController = segue.destination as? YXSquirrelCoinViewController else {
                return
            }
            squirrelCoinViewController.coinAmount = self.myIntegralLabel.text
        }
    }

    // MARK: ---- Request ----

    /// 请求个人信息
    private func loadData() {
        let request = YXMineRequest.getUserInfo
        YYNetworkService.default.request(YYStructResponse<YXNewLoginModel>.self, request: request, success: { [weak self] (response) in
            guard let self = self, let loginModel = response.data else { return }
            self.updateUserInfo(loginModel: loginModel)
        }, fail: nil)
    }

    /// 请求徽章列表
    private func loadBadgeData() {
        let request = YXMineRequest.badgeList
        YYNetworkService.default.request(YYStructDataArrayResponse<YXBadgeModel>.self, request: request, success: { [weak self] (response) in
            guard let self = self, let modelList = response.dataArray else { return }
            self.updateBadgeData(modelList: modelList)
        }) { error in
            YXUtils.showHUD(nil, title: error.message)
        }
    }

    /// 请求积分信息
    private func loadIntegralData() {
        let request = YXMineRequest.getCreditsInfo
        YYNetworkService.default.request(YYStructResponse<YXResultModel>.self, request: request, success: { [weak self] (response) in
            guard let self = self, let credits = response.data?.credits else { return }
            let dict = ["userCredits": credits]
            self.updateIntegralData(dict: dict)
        }, fail: nil)
    }

    // MARK: ---- Update UI ----

    /// 更新个人信息
    private func updateUserInfo(loginModel: YXNewLoginModel) {
        self.temporaryUserModel            = loginModel.user
        YXUserModel.default.userAvatarPath = loginModel.user?.avatar
        YXUserModel.default.userName       = loginModel.user?.nick


        if let avatarStr = YXUserModel.default.userAvatarPath, avatarStr.isNotEmpty {
            YXKVOImageView().showImage(with: avatarStr, placeholder: #imageLiteral(resourceName: "challengeAvatar"), progress: nil) { [weak self] (image: UIImage?, error: NSError?, url: NSURL?) in
                guard let self = self else { return }
                self.avatarImageView.image = image?.corner(radius: AdaptIconSize(25), with: self.avatarImageView.size)
            }
        } else {
            self.avatarImageView.image = #imageLiteral(resourceName: "challengeAvatar")
        }
        self.nameLabel.text = YXUserModel.default.userName
        if let garde = loginModel.user?.grade, !garde.isEmpty {
            let gradeStr: String = {
                guard let gardeInt = Int(garde), gardeInt > 9 else {
                    return garde + "年级"
                }
                if gardeInt <= 12 {
                    return "高中"
                } else if gardeInt < 16 {
                    return "大学"
                } else {
                    return "其他"
                }
            }()
            self.nameLabel.text = (YXUserModel.default.userName ?? "") + "   " + gradeStr
        }
        self.calendarLabel.text = "\(loginModel.user?.punchDays ?? 0)"

        // 学校信息
        if let schoolDescriptionLabel = self.tableView.cellForRow(at: IndexPath(row: 0, section: 0))?.viewWithTag(2) as? UILabel {
            schoolDescriptionLabel.text = (loginModel.user?.schoolInfo?.cityId != .some(0)) ? "去修改" : "去填写"
        }

        // 账户信息
        let bindLabel = self.tableView.cellForRow(at: IndexPath(row: 2, section: 0))?.viewWithTag(2) as? UILabel
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
        let speechLabel = self.tableView.cellForRow(at: IndexPath(row: 3, section: 0))?.viewWithTag(2) as? UILabel
        if YXUserModel.default.didUseAmericanPronunciation {
            speechLabel?.text = "美式"
        } else {
            speechLabel?.text = "英式"
        }

        // 每日提醒
        let remindLabel = self.tableView.cellForRow(at: IndexPath(row: 4, section: 0))?.viewWithTag(2) as? UILabel
        if let date = YYCache.object(forKey: .reminder) as? Date {
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

    @objc private func pushUserInfoVC() {
        let vc = YXUserInfoViewController()
        vc.nick = {
            guard let _nick = temporaryUserModel?.nick, _nick.isNotEmpty else {
                return "未设置"
            }
            return _nick
        }()
        vc.birthday = {
            guard let _birthday = temporaryUserModel?.birthday, _birthday.isNotEmpty else {
                return "未设置"
            }
            return _birthday
        }()
        vc.area = {
            guard let _area = temporaryUserModel?.area, _area.isNotEmpty else {
                return "未设置"
            }
            return _area
        }()
        vc.grade = {
            var gradeStr = "未设置"
            switch temporaryUserModel?.grade {
            case .some("1"):
                gradeStr = "一年级"
            case .some("2"):
                gradeStr = "二年级"
            case .some("3"):
                gradeStr = "三年级"
            case .some("4"):
                gradeStr = "四年级"
            case .some("5"):
                gradeStr = "五年级"
            case .some("6"):
                gradeStr = "六年级"
            case .some("7"):
                gradeStr = "七年级"
            case .some("8"):
                gradeStr = "八年级"
            case .some("9"):
                gradeStr = "九年级"
            case .some("10"), .some("11"), .some("12"):
                gradeStr = "高中"
            default:
                break
            }
            return gradeStr
        }()
        vc.sex = {
            if temporaryUserModel?.sex == .some(1) {
                return "男"
            } else if temporaryUserModel?.sex == .some(2) {
                return "女"
            } else {
                return "未设置"
            }
        }()
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    // MARK: - TableView
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 8
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.row {
        case 0:
            return tableView.dequeueReusableCell(withIdentifier: "schoolCell") ?? UITableViewCell()
        case 1:
            return tableView.dequeueReusableCell(withIdentifier: "lineCell") ?? UITableViewCell()
        case 2:
            return tableView.dequeueReusableCell(withIdentifier: "CellOne") ?? UITableViewCell()
        case 3:
            return tableView.dequeueReusableCell(withIdentifier: "CellTwo") ?? UITableViewCell()
        case 4:
            return tableView.dequeueReusableCell(withIdentifier: "CellThree") ?? UITableViewCell()
        case 5:
            return tableView.dequeueReusableCell(withIdentifier: "CellFour") ?? UITableViewCell()
        case 6:
            let cell = tableView.dequeueReusableCell(withIdentifier: "CellFive") ?? UITableViewCell()
            let badgeNum = YXRedDotManager.share.getFeedbackReplyBadgeNum()
            cell.addSubview(badgeView)
            badgeView.snp.remakeConstraints { (make) in
                make.centerY.equalToSuperview()
                make.right.equalToSuperview().offset(-AdaptSize(30))
                make.size.equalTo(badgeView.size)
            }
            badgeView.isHidden = badgeNum <= 0
            return cell
        default:
            return tableView.dequeueReusableCell(withIdentifier: "CellSix") ?? UITableViewCell()
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
        
        switch indexPath.row {
        case 0:
            let vc = YXEditSchoolViewController()
            vc.schoolInfoModel = self.temporaryUserModel?.schoolInfo
            self.navigationController?.pushViewController(vc, animated: true)
        case 1:
            break
        case 2:
            let accountInfoView = YXAccountInfoView()
            accountInfoView.bindInfo = bindInfo
            accountInfoView.bindQQClosure = { [weak self] in
                guard let self = self else { return }
                if self.bindInfo[1] == "1" {
                    let alertView = YXAlertView()
                    alertView.titleLabel.text = "提示"
                    alertView.descriptionLabel.text = "解绑后将无法使用QQ进行登录"
                    alertView.doneClosure = { [weak self] (text: String?) in
                        guard let self = self else { return }
                        let request = YXRegisterAndLoginRequest.unbind(platfrom: "qq")
                        YYNetworkService.default.request(YYStructResponse<YXResultModel>.self, request: request, success: { [weak self] (response) in
                            self?.loadData()
                        }) { error in
                            YXUtils.showHUD(nil, title: error.message)
                        }
                    }
                    YXAlertQueueManager.default.addAlert(alertView: alertView)
                } else {
                    QQApiManager.shared().qqLogin()
                }
            }
            
            accountInfoView.bindWechatClosure = { [weak self] in
                guard let self = self else { return }
                if self.bindInfo[2] == "2" {
                    let alertView = YXAlertView()
                    alertView.titleLabel.text = "提示"
                    alertView.descriptionLabel.text = "解绑后将无法使用微信进行登录"
                    alertView.doneClosure = { [weak self] (text: String?) in
                        guard let self = self else { return }
                        let request = YXRegisterAndLoginRequest.unbind(platfrom: "wechat")
                        YYNetworkService.default.request(YYStructResponse<YXResultModel>.self, request: request, success: { [weak self] (response) in
                            self?.loadData()
                        }) { error in
                            YXUtils.showHUD(nil, title: error.message)
                        }
                    }
                    YXAlertQueueManager.default.addAlert(alertView: alertView)
                } else {
                    WXApiManager.shared().wxLogin()
                }
            }
            
            accountInfoView.show()
            break

        case 3:
            let alertController = UIAlertController(title: "选择音标和发音", message: nil, preferredStyle: .actionSheet)
            let englishAction = UIAlertAction(title: "英式音标和发音", style: .default) { (action) in
                YXUserModel.default.didUseAmericanPronunciation = false
                self.loadData()
            }
            
            let usAction = UIAlertAction(title: "美式音标和发音", style: .default) { (action) in
                YXUserModel.default.didUseAmericanPronunciation = true
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

        case 4:
            self.performSegue(withIdentifier: "SetReminder", sender: self)
            break

        case 5:
            break

        case 6:
            self.performSegue(withIdentifier: "FeedBack", sender: self)
            break

        case 7:
            self.performSegue(withIdentifier: "Settings", sender: self)
            break
            
        default:
            break
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == 1 || indexPath.row == 5 {
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
        
        if let imageView = cell.viewWithTag(1) as? UIImageView {
            if let finishDateTimeInterval = badge.finishDateTimeInterval, finishDateTimeInterval != 0, let imageOfCompletedStatus = badge.imageOfCompletedStatus {
                imageView.sd_setImage(with: URL(string: imageOfCompletedStatus), completed: nil)

            } else if let imageOfIncompletedStatus = badge.imageOfIncompletedStatus {
                imageView.sd_setImage(with: URL(string: imageOfIncompletedStatus), completed: nil)
            }
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
            guard let self = self else { return }
            self.loadData()
        }) { error in
            YXUtils.showHUD(nil, title: error.message)
        }
    }
}
