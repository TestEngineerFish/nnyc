//
//  YXHomeViewController.swift
//  YXEDU
//
//  Created by Jake To on 10/24/19.
//  Copyright © 2019 shiji. All rights reserved.
//

import UIKit
import Lottie
import GrowingCoreKit
import GrowingAutoTrackKit
import StoreKit

@objc
class YXHomeViewController: YXViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    private var wordListType: YXWordListType = .learned
    
    private var learnedWordsCount    = "--"
    private var collectedWordsCount  = "--"
    private var wrongWordsCount      = "--"
    private var animationPlayFinished = false
    private var homeModel: YXHomeModel?
    private var activityModel: YXActivityModel?
    private var service: YXExerciseService = YXExerciseServiceImpl()
    
    @IBOutlet weak var homeEntryView: YXDesignableView!
    @IBOutlet weak var bookNameButton: UIButton!
    @IBOutlet weak var startStudyView: YXDesignableView!
    @IBOutlet weak var startStudyButton: YXDesignableButton!
    @IBOutlet weak var changeBookButton: UIButton!
    @IBOutlet weak var unitNameButton: UIButton!
    @IBOutlet weak var unlearnedTitleLabel: UILabel!
    @IBOutlet weak var countOfWaitForStudyWords: YXDesignableLabel!
    @IBOutlet weak var progressBar: UIProgressView!
    @IBOutlet weak var studyDataCollectionView: UICollectionView!
    @IBOutlet weak var subItemCollectionView: UICollectionView!
    
    @IBOutlet weak var homeViewAspect: NSLayoutConstraint!
    @IBOutlet weak var homeViewiPadAspect: NSLayoutConstraint!
    @IBOutlet weak var startStudyButtonHeight: NSLayoutConstraint!
    @IBOutlet weak var startStudyButtonTopOffset: NSLayoutConstraint!
    @IBOutlet weak var startStudyButtonBottomOffset: NSLayoutConstraint!
    @IBOutlet weak var studyDataCollectionViewBottomOffset: NSLayoutConstraint!
    @IBOutlet weak var subItemCollectionViewHeight: NSLayoutConstraint!
    @IBOutlet weak var activityView: UIView!
    @IBOutlet weak var activityViewHeight: NSLayoutConstraint!
    @IBOutlet weak var collectionViewTop: NSLayoutConstraint!
    @IBOutlet weak var activityViewTop: NSLayoutConstraint!
    var bubbleImageView: UIImageView?

    var squirrelAnimationView: AnimationView?
    
    @IBAction func startExercise(_ sender: UIButton) {
        YXLog("====开始主流程的学习====")
        guard let homeData = self.homeModel else {
            YXLog("首页数据未加载，无法学习")
            return
        }
        YXLog(String(format: "当前学习词书名：%@, 词书ID：%ld,当前学习单元：%@，单元ID：%ld", homeData.bookName ?? "--", homeData.bookId ?? -1, homeData.unitName ?? "--", homeData.unitId ?? -1))
        
        if self.countOfWaitForStudyWords.text == "0" && self.service.progress != .unreport {
            let alertView = YXAlertView(type: .normal)
            if homeData.isLastUnit == 1 {
                YXLog("当前词书\(homeData.bookName ?? "")已背完啦")
                alertView.descriptionLabel.text = "你太厉害了，已经背完这本书拉，你可以……"
                alertView.closeButton.isHidden  = false
                alertView.leftButton.setTitle("换单元", for: .normal)
                alertView.rightOrCenterButton.setTitle("换本书学", for: .normal)
                
                alertView.cancleClosure = { [weak self] in
                    guard let self = self else { return }
                    self.showLearnMap(alertView.rightOrCenterButton)
                }
                
                alertView.doneClosure = { [weak self] (text: String?) in
                    guard let self = self else { return }
                    YXLog("更换词书")
                    self.performSegue(withIdentifier: "AddBookFromHome", sender: self)
                }
            } else {
                YXLog("当前单元\(homeData.unitName ?? "")暂时没有需要新学或复习的单词")
                alertView.descriptionLabel.text = "你太厉害了，暂时没有需要新学或复习的单词，你可以……"
                alertView.rightOrCenterButton.setTitle("换单元", for: .normal)
                alertView.doneClosure = { [weak self] (text: String?) in
                    guard let self = self else { return }
                    self.showLearnMap(alertView.rightOrCenterButton)
                }
            }
            
            alertView.adjustAlertHeight()
            YXAlertQueueManager.default.addAlert(alertView: alertView)
            
        } else {
            self.study(focus: false)
        }
    }

    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.createSubviews()
        self.registerNotification()
        self.bindProperty()
        self.bindData()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.requestBaseInfo()
        self.requestActivity()
        self.checkComment()
        YXStepConfigManager.share.contrastStepConfig()
        YXAlertCheckManager.default.checkLatestBadge()
        YXRedDotManager.share.updateTaskCenterBadge()

        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) { [weak self] in
            if YRRouter.sharedInstance().currentViewController() == self {
                // 如果学完一次主流程，并且没有设置过提醒，则弹出弹窗
                if YYCache.object(forKey: "DidFinishMainStudyProgress") as? Bool == true, YYCache.object(forKey: .didShowSetupReminderAlert) == nil {
                    let setReminderView = YXSetReminderView()
                    YXAlertQueueManager.default.addAlert(alertView: setReminderView)
                }
            }
        }

        if !self.animationPlayFinished {
            self.setSquirrelAnimation()
        }
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let identifier = segue.identifier else { return }
        let identifierList = ["LearnedWords", "FavoritesWords", "WrongWords", "WordList"]
        if identifierList.contains(identifier) {
            if let destinationViewController = segue.destination as? YXWordListViewController {
                destinationViewController.wordListType = wordListType
            }
        }
    }
    
    // MARK: ---- Notification ----
    /// 注册通知
    private func registerNotification() {
        NotificationCenter.default.addObserver(self, selector: #selector(updateTaskCenterStatus), name: YXNotification.kUpdateTaskCenterBadge, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(playSquirrelAnimation), name: YXNotification.kSquirrelAnimation, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(updateMyClassStatus), name: YXNotification.kReloadClassList, object: nil)
    }
    
    // MARK: ---- Request ----
    /// 更新用户基本信息
    /// - Parameter block: 闭包事件
    private func requestBaseInfo(finished block: (()->Void)? = nil) {
        let request = YXHomeRequest.getBaseInfo(userId: YXUserModel.default.uuid ?? "")
        YYNetworkService.default.request(YYStructResponse<YXHomeModel>.self, request: request, success: { [weak self] (response) in
            guard let self = self, let userInfomation = response.data else { return }
            self.homeModel = userInfomation
            YXLog("==== 当前用户User ID", self.homeModel?.userId ?? 0)
            
            self.initService()
            YXUserModel.default.userId        = self.homeModel?.userId
            YXUserModel.default.currentUnitId = self.homeModel?.unitId
            YXUserModel.default.currentBookId = self.homeModel?.bookId
            YXUserModel.default.currentGrade  = self.homeModel?.bookGrade
            YXUserModel.default.isJoinClass   = self.homeModel?.isJoinClass ?? false
            YXUserModel.default.hasNewWork    = self.homeModel?.hasHomework ?? false

            DispatchQueue.main.async { [weak self] in
                guard let self = self else { return }
                self.updateWordCountRemind()
                self.adjustStartStudyButtonState()
                self.bookNameButton.setTitle(self.homeModel?.bookName, for: .normal)
                self.unitNameButton.setTitle(self.homeModel?.unitName, for: .normal)
                self.progressBar.setProgress(Float(self.homeModel?.unitProgress ?? 0), animated: true)
                self.learnedWordsCount   = "\(self.homeModel?.learnedWords ?? 0)"
                self.collectedWordsCount = "\(self.homeModel?.collectedWords ?? 0)"
                self.wrongWordsCount     = "\(self.homeModel?.wrongWords ?? 0)"
                self.studyDataCollectionView.reloadData()
                self.subItemCollectionView.reloadData()
            }
            self.uploadGrowing()
            block?()
        }) { error in
            YXLog("获取主页基础数据失败：", error.localizedDescription)
        }
    }

    /// 更新用户配置信息
    private func requestUserConfig() {
        YXUserDataManager.share.updateUserInfomation { [weak self] (userInfomation) in
            guard let self = self, let _userInfomation = userInfomation else {
                return
            }

            YYCache.set(!_userInfomation.isJoinSchool, forKey: .isShowSelectSchool)
            YXUserModel.default.isFinishedNewUserStudy = !_userInfomation.isNewUser
            if _userInfomation.didSelectBook {
                YYCache.set(false, forKey: .isShowSelectBool)
            } else {
                YYCache.set(true, forKey: .isShowSelectBool)
                self.uploadAppInfo()
            }

            if _userInfomation.reminder?.didOpen == 1, let time = _userInfomation.reminder?.timeStamp {
                YYCache.set(Date(timeIntervalSince1970: time), forKey: .didShowSetupReminderAlert)
                YYCache.set(Date(timeIntervalSince1970: time), forKey: .reminder)
            } else {
                YYCache.set(nil, forKey: "DidFinishMainStudyProgress")
                YYCache.set(nil, forKey: .didShowSetupReminderAlert)
                YYCache.set(nil, forKey: .reminder)
            }
            Growing.setPeopleVariableWithKey("cidan", andStringValue: "0")
            DispatchQueue.main.async { [weak self] in
                self?.processRegisterEvent()
            }
        }
    }

    /// 活动
    private func requestActivity() {
        let request = YXHomeRequest.activityInfo
        YYNetworkService.default.request(YYStructResponse<YXActivityModel>.self, request: request, success: { [weak self] (response) in
            guard let self = self, let model = response.data else {
                return
            }
            self.activityModel = model
            DispatchQueue.main.async { [weak self] in
                self?.setActivityView(image: model.imageUrlStr)
            }
        }) { (error) in
            YXUtils.showHUD(nil, title: error.message)
        }
    }

    /// 上传剪切板和设备信息
    private func uploadAppInfo() {
        guard var clipboard = UIPasteboard.general.string else {
            return
        }
        let platform  = "0"
        let systemVer = UIDevice().sysVersion() ?? ""
        let screen    = UIDevice().screenResolution() ?? ""
        if clipboard.count != 26 {
            clipboard = ""
        }
        let request = YXRegisterAndLoginRequest.uploadAppInfo(clipboard: clipboard, platform: platform, systomVersion: systemVer, screen: screen)
        YYNetworkService.default.request(YYStructResponse<YXResultModel>.self, request: request, success: { (response) in
            YXLog("上报设备信息成功")
        }) { (error) in
            YXLog("上报设备信息失败")
        }
    }

    // MARK: ---- Event ----

    private func createSubviews() {
        self.customNavigationBar?.isHidden         = true
        self.progressBar.layer.cornerRadius        = 5
        self.progressBar.clipsToBounds             = true
        self.progressBar.subviews[1].clipsToBounds = true
        if (progressBar.layer.sublayers?.count ?? 0) > 1 {
            progressBar.layer.sublayers![1].cornerRadius = 5
        }
        if isPad() {
            self.homeViewAspect.isActive                      = false
            self.homeViewiPadAspect.isActive                  = true
            self.countOfWaitForStudyWords.font                = UIFont.DINAlternateBold(ofSize: 70)
            self.startStudyView.cornerRadius                  = 36
            self.startStudyButton.cornerRadius                = 36
            self.startStudyButton.titleLabel?.font            = UIFont.systemFont(ofSize: 26, weight: .medium)
            self.startStudyButtonHeight.constant              = 72
            self.startStudyButtonTopOffset.constant           = 24
            self.startStudyButtonBottomOffset.constant        = 44
            self.studyDataCollectionViewBottomOffset.constant = 36
        }
    }

    private func bindProperty() {
        self.studyDataCollectionView.register(UINib(nibName: "YXHomeStudyDataCell", bundle: nil), forCellWithReuseIdentifier: "YXHomeStudyDataCell")
        self.subItemCollectionView.register(UINib(nibName: "YXHomeSubItemCell", bundle: nil), forCellWithReuseIdentifier: "YXHomeSubItemCell")
        self.subItemCollectionView.register(UINib(nibName: "YXHomeSubItemiPadCell", bundle: nil), forCellWithReuseIdentifier: "YXHomeSubItemiPadCell")
    }

    private func bindData() {
        self.requestUserConfig()
        self.setSquirrelAnimation()
    }

    @objc private func updateTaskCenterStatus() {
        self.subItemCollectionView.reloadData()
    }

    @objc private func playSquirrelAnimation() {
        YYCache.set(true, forKey: YXLocalKey.firstShowHome)
        self.setSquirrelAnimation()
    }

    @objc private func updateMyClassStatus() {
        self.requestBaseInfo()
    }

    @objc private func newUserStudy() {
        self.study(focus: true)
    }

    @IBAction func showLearnMap(_ sender: UIButton) {
        let vc = YXLearnMapViewController()
        vc.bookId = self.homeModel?.bookId
        vc.unitId = self.homeModel?.unitId
        self.navigationController?.pushViewController(vc, animated: true)
        YXLog("进入单元地图")
    }

    private func getUnlearnWordCount(home model: YXHomeModel) -> (Int, Int) {
        let service = YXExerciseServiceImpl()
        let config  = YXBaseLearnConfig(bookId: model.bookId ?? 0, unitId: model.unitId ?? 0, learnType: .base, homeworkId: 0)

        if let studyModel = service.studyDao.selectStudyRecordModel(learn: config) {
            let newCount = service.studyDao.getUnlearnedNewWordCount(study: studyModel.studyId)
            let reviewCount = service.studyDao.getUnlearnedReviewWordCount(study: studyModel.studyId)
            return (newCount, reviewCount)
        } else {
            return (model.newWords ?? 0, model.reviewWords ?? 0)
        }
    }

    private func initService() {
        // 只有基础学习的bookId才是真实bookId，复习的bookId是后端虚构的ID
        let bookId = self.homeModel?.bookId ?? 0
        let unitId = self.homeModel?.unitId ?? 0
        let config = YXBaseLearnConfig(bookId: bookId, unitId: unitId)
        self.service.learnConfig = config
        self.service.initService()
    }


    private func toMyClass() {
//        let vc = YXNewLearningResultViewController()
//        self.navigationController?.pushViewController(vc, animated: true)
//        return
        if YXUserModel.default.isJoinClass {
            let vc = YXMyClassViewController()
            self.navigationController?.pushViewController(vc, animated: true)
        } else {
            YXAlertManager().showAddClassOrHomeworkAlert { (classNumber: String?) in
                YXUserDataManager.share.joinClass(code: classNumber) { (result) in
                    if result {
                        let vc = YXMyClassViewController()
                        YRRouter.sharedInstance().currentNavigationController()?.pushViewController(vc, animated: true)
                    }
                }
            }
        }
    }

    /// 检测当前词书是否需要更新
    private func checkDownloadBook() {
        let taskModel = YXWordBookResourceModel(type: .single, book: self.homeModel?.bookId) {
            YXWordBookResourceManager.shared.contrastBookData(by: self.homeModel?.bookId)
        }
        YXWordBookResourceManager.shared.addTask(model: taskModel)
    }

    /// Growing上传用户选择词书
    private func uploadGrowing() {
        guard let model = self.homeModel, let grade = model.bookGrade else {
            return
        }
        YXGrowingManager.share.uploadChangeBook(grade: "\(grade)", versionName: model.bookVersionName)
    }

    @objc private func toActivity() {
        guard let model = self.activityModel else {
            return
        }
        if !model.hadReward && model.hadNewFriend {
            self.bubbleImageView?.isHidden = true
        }
        let vc = YXWebViewController()
        vc.requestUrlStr = model.urlStr
        self.navigationController?.pushViewController(vc, animated: true)
    }

    /// 根据用户状态，继续注册流程（哎……）
    private func processRegisterEvent() {
        if (YYCache.object(forKey: .isShowSelectSchool) as? Bool) == .some(true) {
            let vc = YXSelectSchoolViewController()
            self.navigationController?.pushViewController(vc, animated: true)
        } else if (YYCache.object(forKey: .isShowSelectBool) as? Bool) == .some(true) {
            self.performSegue(withIdentifier: "AddBookGuide", sender: self)
        } else if !YXUserModel.default.isFinishedNewUserStudy {
            // 如果还未加载词书数据，则先加载
            if YXUserModel.default.currentBookId != nil && YXUserModel.default.currentUnitId != nil {
                self.newUserStudy()
            } else {
                self.requestBaseInfo { [weak self] in
                    guard let self = self else { return }
                    self.newUserStudy()
                }
            }
        }
    }

    // MARK: ---- Tools ----
    private func setActivityView(image urlStr: String) {
        guard let model = self.activityModel else {
            return
        }
        if model.isShow {
            // CreateSubviews
            let bannerH = (screenWidth - 40)/335*80
            self.activityViewHeight.constant = bannerH
            self.collectionViewTop.constant = 25
            let bannerImageView: YXKVOImageView = YXKVOImageView()
            self.activityView.removeAllSubviews()
            self.activityView.addSubview(bannerImageView)
            bannerImageView.sd_setImage(with: URL(string: urlStr), placeholderImage: UIImage(named: "activityBanner"))
            bannerImageView.snp.makeConstraints { (make) in
                make.edges.equalToSuperview()
            }
            // BindProperty
            let tapAction = UITapGestureRecognizer(target: self, action: #selector(toActivity))
            self.activityView.addGestureRecognizer(tapAction)
            self.bubbleImageView?.removeFromSuperview()
            // 活动未开始或者未参加，不展示小气泡
            if !model.isAction || !model.isJoin {
                return
            }
            self.bubbleImageView = {
                let imageView = UIImageView()
                imageView.image = UIImage(named: "activityBubble")
                imageView.isUserInteractionEnabled = true
                return imageView
            }()
            let bubbleButton: UIButton = {
                let button = UIButton()
                button.setImage(UIImage(named: "activityArrow"), for: .normal)
                button.setTitleColor(UIColor.hex(0x361211), for: .normal)
                button.titleLabel?.font = UIFont.mediumFont(ofSize: AdaptFontSize(12))
                button.imageEdgeInsets = UIEdgeInsets(top: 0, left: AdaptIconSize(78), bottom: 0, right: 0)
                button.titleEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: AdaptIconSize(13))
                return button
            }()
            if model.hadReward {
                bubbleButton.setTitle("奖励待领取", for: .normal)
            } else if model.hadNewFriend {
                bubbleButton.setTitle("新好友加入", for: .normal)
            } else if !model.taskFinished {
                if model.punchToday == 0 {
                    bubbleButton.setTitle("今日未打卡", for: .normal)
                } else {
                    bubbleButton.setTitle("今日打卡\(model.punchToday)/\(model.punchAmount)", for: .normal)
                }
            } else {
                bubbleButton.isHidden          = true
                self.bubbleImageView?.isHidden = true
            }
            self.view.addSubview(bubbleImageView!)
            self.bubbleImageView?.addSubview(bubbleButton)
            self.bubbleImageView?.snp.makeConstraints { (make) in
                make.right.equalTo(self.activityView)
                make.top.equalTo(self.activityView).offset(AdaptSize(-20))
                make.size.equalTo(CGSize(width: AdaptIconSize(98), height: AdaptIconSize(30)))
            }
            bubbleButton.snp.makeConstraints { (make) in
                make.left.top.right.equalToSuperview()
                make.bottom.equalToSuperview().offset(AdaptSize(-2))
            }
            // BindProperty
            self.activityViewTop.constant = isPad() ? AdaptSize(45) : AdaptSize(30)
            bubbleButton.addTarget(self, action: #selector(toActivity), for: .touchUpInside)
        } else {
            self.activityViewHeight.constant = 0
            self.collectionViewTop.constant  = 0
        }
    }
    
    private func setSquirrelAnimation() {
        if self.squirrelAnimationView?.superview != nil {
            self.squirrelAnimationView?.removeFromSuperview()
        }
        let isFirstShowHome = YYCache.object(forKey: YXLocalKey.firstShowHome) as? Bool ?? true
        if isFirstShowHome {
            if isPad() {
                squirrelAnimationView = AnimationView(name: "homeFirstiPad")
            } else {
                squirrelAnimationView = AnimationView(name: "homeFirst")
            }
            
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 1.5) { [weak self] in
                let animation = CAKeyframeAnimation(keyPath: "transform.scale")
                animation.values         = [1.0, 0.8, 1.0, 0.8, 1.0]
                animation.duration       = 3.5
                animation.timingFunction = CAMediaTimingFunction(name: .easeIn)
                self?.startStudyButton.layer.add(animation, forKey: nil)
                self?.startStudyView.layer.add(animation, forKey: nil)
            }
        } else {
            if isPad() {
                squirrelAnimationView = AnimationView(name: "homeNormaliPad")
            } else {
                squirrelAnimationView = AnimationView(name: "homeNormal")
            }
        }
        YYCache.set(false, forKey: YXLocalKey.firstShowHome)
        if let animationView = self.squirrelAnimationView {
            self.homeEntryView.insertSubview(animationView, at: 1)
        }
        squirrelAnimationView?.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            self.squirrelAnimationView?.play(completion: { [weak self] (isFinished) in
                if isFinished {
                    self?.animationPlayFinished = true
                    YXLog("动画播放完成")
                } else {
                    self?.animationPlayFinished = false
                    YXLog("动画未播放完")
                }
            })
        }
    }
    
    private func adjustStartStudyButtonState() {
        if let lastStoredDate = YXUserModel.default.lastStoredDate {
            if Calendar.current.isDateInToday(lastStoredDate) {
                if service.progress == .none {
                    startStudyButton.setTitle("再学一组", for: .normal)
                } else {
                    startStudyButton.setTitle("继续学习", for: .normal)
                }
            } else {
                startStudyButton.setTitle("开始背单词", for: .normal)
            }
        } else {
            startStudyButton.setTitle("开始背单词", for: .normal)
        }
    }

    private func study(focus: Bool) {
        guard let bookId = YXUserModel.default.currentBookId, let unitId = YXUserModel.default.currentUnitId else {
            return
        }
        self.checkDownloadBook()
        YXUserModel.default.lastStoredDate = Date()
        YXLog(String(format: "开始学习书(%ld),第(%ld)单元", bookId, unitId))
        let vc = YXExerciseViewController()
        vc.isFocusStudy = focus
        vc.learnConfig = YXBaseLearnConfig(bookId: bookId, unitId: unitId)
        self.navigationController?.pushViewController(vc, animated: true)
    }

    /// 检查是否需要弹出评分弹框
    private func checkComment() {
        let didShownAlert  = YYCache.object(forKey: YXLocalKey.didShowRate) as? Bool ?? false
        let punchCount = YYCache.object(forKey: YXLocalKey.punchCount) as? Int ?? 0
        YXLog("用户 \(YXUserModel.default.uuid ?? "") 打卡次数： \(punchCount)，是否弹过评分弹窗： \(didShownAlert)")
        if !didShownAlert, punchCount >= 4 {
            YYCache.set(true, forKey: YXLocalKey.didShowRate)
            YXLog("用户 \(YXUserModel.default.uuid ?? "") 弹出评分弹窗")

            if #available(iOS 10.3, *) {
                SKStoreReviewController.requestReview()
            } else {
                guard let writeReviewURL = URL(string: "https://apps.apple.com/app/id1379948642?action=write-review") else { return }
                UIApplication.shared.open(writeReviewURL, options: [:], completionHandler: nil)
            }
        }
    }

    private func updateWordCountRemind() {
        guard let model = self.homeModel else {
            return
        }
        let countData = self.getUnlearnWordCount(home: model)
        self.countOfWaitForStudyWords.text = "\(countData.0 + countData.1)"
        if countData.0 == 0 {
            self.unlearnedTitleLabel.text = "待复习"
        } else {
            self.unlearnedTitleLabel.text = "待学习"
        }
    }

    
    // MARK: ---- UICollection Delegate & DataSource
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView.tag == 1 {
            return 3
        } else {
            return 4
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView.tag == 1 {
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "YXHomeStudyDataCell", for: indexPath) as? YXHomeStudyDataCell else {
                return UICollectionViewCell()
            }
            
            switch indexPath.row {
            case 0:
                cell.titleLabel.text = "本书已学"
                cell.dataLabel.text = learnedWordsCount
                break
                
            case 1:
                cell.titleLabel.text = "收藏夹"
                cell.dataLabel.text = collectedWordsCount
                break
                
            case 2:
                cell.titleLabel.text = "错词本"
                cell.dataLabel.text = wrongWordsCount
                break
                
            default:
                break
            }
            
            return cell
            
        } else {
            if isPad() {
                guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "YXHomeSubItemiPadCell", for: indexPath) as? YXHomeSubItemiPadCell else {
                    return UICollectionViewCell()
                }
                cell.setData(indexPath)
                return cell
            } else {
                guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "YXHomeSubItemCell", for: indexPath) as? YXHomeSubItemCell else {
                    return UICollectionViewCell()
                }
                cell.setData(indexPath)
                return cell
            }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView.tag == 1 {
            switch indexPath.row {
            case 0:
                wordListType = .learned
                break
                
            case 1:
                wordListType = .collected
                break
                
            case 2:
                wordListType = .wrongWords
                break
                
            default:
                break
            }
            
            self.performSegue(withIdentifier: "WordList", sender: self)
            
        } else {
            switch indexPath.row {
            case 0:
                self.performSegue(withIdentifier: "TaskCenter", sender: self)
                break
            case 1:
                if isPad() {
                    self.performSegue(withIdentifier: "YXStudyReportViewController", sender: self)
                } else {
                    self.performSegue(withIdentifier: "Calendar", sender: self)
                }
                break
            case 2:
                if isPad() {
                    self.performSegue(withIdentifier: "Calendar", sender: self)
                } else {
                    self.toMyClass()
                }
                break
            case 3:
                if isPad() {
                    self.toMyClass()
                } else {
                    self.performSegue(withIdentifier: "YXStudyReportViewController", sender: self)
                }
                break
            default:
                break
            }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if collectionView.tag == 1 {
            return CGSize(width: collectionView.bounds.width / 3, height: 88)
            
        } else {
            if isPad() {
                let width = (screenWidth - 40 - 36) / 4
                subItemCollectionViewHeight.constant = width
                return CGSize(width: width, height: width)

            } else {
                return CGSize(width: (screenWidth - 40 - 12) / 2, height: 60)
            }
        }
    }
}
