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
class YXHomeViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    private var wordListType: YXWordListType = .learned
    
    private var learnedWordsCount    = "--"
    private var collectedWordsCount  = "--"
    private var wrongWordsCount      = "--"
    private var animationPlayFinished = false
    private var homeModel: YXHomeModel!
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

    var squirrelAnimationView: AnimationView?
    
    @IBAction func startExercise(_ sender: UIButton) {
        YXLog("====开始主流程的学习====")
        guard let homeData = self.homeModel else {
            YXLog("首页数据未加载，无法学习")
            return
        }
        YXLog(String(format: "当前学习词书名：%@, 词书ID：%ld,当前学习单元：%@，单元ID：%ld", homeData.bookName ?? "--", homeData.bookId ?? -1, homeData.unitName ?? "--", homeData.unitId ?? -1))
        
        if self.countOfWaitForStudyWords.text == "0" {
            let alertView = YXAlertView(type: .normal)
            if homeData.isLastUnit == 1 {
                YXLog("当前词书\(homeData.bookName ?? "")已背完啦")
                alertView.descriptionLabel.text = "你太厉害了，已经背完这本书拉，你可以……"
                alertView.closeButton.isHidden  = false
                alertView.leftButton.setTitle("换单元", for: .normal)
                alertView.rightOrCenterButton.setTitle("换本书学", for: .normal)
                
                alertView.cancleClosure = {
                    self.showLearnMap(alertView.rightOrCenterButton)
                }
                
                alertView.doneClosure = { _ in
                    YXLog("更换词书")
                    self.performSegue(withIdentifier: "AddBookFromHome", sender: self)
                }
            } else {
                YXLog("当前单元\(homeData.unitName ?? "")暂时没有需要新学或复习的单词")
                alertView.descriptionLabel.text = "你太厉害了，暂时没有需要新学或复习的单词，你可以……"
                alertView.rightOrCenterButton.setTitle("换单元", for: .normal)
                alertView.doneClosure = { _ in
                    self.showLearnMap(alertView.rightOrCenterButton)
                }
            }
            
            alertView.adjustAlertHeight()
            alertView.show()
            
        } else {
            YXUserModel.default.lastStoredDate = Date()
            YXLog(String(format: "开始学习书(%ld),第(%ld)单元", homeData.bookId ?? 0, homeData.unitId ?? 0))
            let vc = YXExerciseViewController()
            vc.learnConfig = YXBaseLearnConfig(bookId: homeData.bookId ?? 0, unitId: homeData.unitId ?? 0)
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let lineView = UIView(frame: CGRect(x: 0, y: -0.5, width: screenWidth, height: 0.5))
        lineView.backgroundColor = UIColor.hex(0xDCDCDC)
        self.tabBarController?.tabBar.addSubview(lineView)
                
        progressBar.layer.cornerRadius = 5
        progressBar.clipsToBounds = true
        progressBar.layer.sublayers![1].cornerRadius = 5
        progressBar.subviews[1].clipsToBounds = true
                
        studyDataCollectionView.register(UINib(nibName: "YXHomeStudyDataCell", bundle: nil), forCellWithReuseIdentifier: "YXHomeStudyDataCell")
        subItemCollectionView.register(UINib(nibName: "YXHomeSubItemCell", bundle: nil), forCellWithReuseIdentifier: "YXHomeSubItemCell")
        subItemCollectionView.register(UINib(nibName: "YXHomeSubItemiPadCell", bundle: nil), forCellWithReuseIdentifier: "YXHomeSubItemiPadCell")

        if isPad() {
            homeViewAspect.isActive = false
            homeViewiPadAspect.isActive = true
            
            countOfWaitForStudyWords.font = UIFont.DINAlternateBold(ofSize: 70)
            startStudyView.cornerRadius = 36
            startStudyButton.cornerRadius = 36
            startStudyButton.titleLabel?.font = UIFont.systemFont(ofSize: 26, weight: .medium)
            startStudyButtonHeight.constant = 72
            startStudyButtonTopOffset.constant = 24
            startStudyButtonBottomOffset.constant = 44
            studyDataCollectionViewBottomOffset.constant = 36
        }

        self.checkUserState()
        self.setSquirrelAnimation()
        self.registerNotification()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.checkGuide()
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.startStudyButton.isEnabled   = true
        tabBarController?.tabBar.isHidden = false
        navigationController?.setNavigationBarHidden(true, animated: animated)
        loadData()
        YXStepConfigManager.share.contrastStepConfig()
        YXAlertCheckManager.default.checkLatestBadgeWhenBackTabPage()
        YXRedDotManager.share.updateTaskCenterBadge()
        
        // 如果学完一次主流程，并且没有设置过提醒，则弹出弹窗
        if YYCache.object(forKey: "DidFinishMainStudyProgress") as? Bool == true, UserDefaults.standard.object(forKey: "DidShowSetupReminderAlert") == nil {
            let setReminderView = YXSetReminderView()
            setReminderView.show()
        }
        
        if !self.animationPlayFinished {
            self.setSquirrelAnimation()
        }

        YXLog("用户 \(YXUserModel.default.uuid ?? "") 打卡次数： \((YYCache.object(forKey: YXLocalKey.punchCount) as? Int) ?? 0)，是否弹过评分弹窗： \((YYCache.object(forKey: YXLocalKey.didShowRate) as? Bool) ?? false)")
        if YYCache.object(forKey: YXLocalKey.didShowRate) as? Bool == nil, let count = YYCache.object(forKey: YXLocalKey.punchCount) as? Int, count >= 4 {
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

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let identifier = segue.identifier else { return }
        let identifierList = ["LearnedWords", "FavoritesWords", "WrongWords", "WordList"]
        if identifierList.contains(identifier) {
            let destinationViewController = segue.destination as! YXWordListViewController
            destinationViewController.wordListType = wordListType
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
    private func loadData() {
        let request = YXHomeRequest.getBaseInfo(userId: YXUserModel.default.uuid ?? "")
        YYNetworkService.default.request(YYStructResponse<YXHomeModel>.self, request: request, success: { (response) in
            guard let userInfomation = response.data else { return }
            self.homeModel = userInfomation
            YXLog("==== 当前用户User ID", self.homeModel?.userId ?? 0)
            
            self.initService()
            self.adjustStartStudyButtonState()
            self.bookNameButton.setTitle(self.homeModel?.bookName, for: .normal)
            self.unitNameButton.setTitle(self.homeModel?.unitName, for: .normal)
            self.progressBar.setProgress(Float(self.homeModel?.unitProgress ?? 0), animated: true)
            let countData = self.getUnlearnWordCount(home: self.homeModel)
            self.countOfWaitForStudyWords.text = "\(countData.0 + countData.1)"
            if countData.0 == 0 {
                self.unlearnedTitleLabel.text = "待复习"
            } else {
                self.unlearnedTitleLabel.text = "待学习"
            }
            
            self.learnedWordsCount   = "\(self.homeModel?.learnedWords ?? 0)"
            self.collectedWordsCount = "\(self.homeModel?.collectedWords ?? 0)"
            self.wrongWordsCount     = "\(self.homeModel?.wrongWords ?? 0)"
            self.studyDataCollectionView.reloadData()

            YXUserModel.default.currentBookId   = self.homeModel.bookId
            YXUserModel.default.currentGrade    = self.homeModel.bookGrade
            YXUserModel.default.isJoinClass     = self.homeModel.isJoinClass
            YXUserModel.default.hasNewWork      = self.homeModel.hasHomework

            self.handleTabData()
            self.initDataManager()
            self.uploadGrowing()
            self.subItemCollectionView.reloadData()
        }) { error in
            YXLog("获取主页基础数据失败：", error.localizedDescription)
        }
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
        service.learnConfig = config
        service.initService()
    }

    /// 处理基础信息请求
    private func handleTabData() {
        let taskModel = YXWordBookResourceModel(type: .single, book: self.homeModel.bookId) {
            YXWordBookResourceManager.shared.contrastBookData(by: self.homeModel.bookId)
        }
        YXWordBookResourceManager.shared.addTask(model: taskModel)
    }

    private func uploadGrowing() {
        guard let model = self.homeModel, let grade = model.bookGrade else {
            return
        }
        YXGrowingManager.share.uploadChangeBook(grade: "\(grade)", versionName: model.bookVersionName)
    }

    private func checkGuide() {
        if (YYCache.object(forKey: .isShowSelectSchool) as? Bool) == .some(true) {
            let vc = YXSelectSchoolViewController()
            self.navigationController?.pushViewController(vc, animated: true)
        } else if (YYCache.object(forKey: .isShowSelectBool) as? Bool) == .some(true) {
            self.performSegue(withIdentifier: "AddBookGuide", sender: self)
        } else {
            self.navigationController?.interactivePopGestureRecognizer?.delegate = nil
        }
    }
    
    private func checkUserState() {
        YXUserDataManager.share.updateUserInfomation { (userInfomation) in
            if userInfomation?.reminder?.didOpen == 1, let time = userInfomation?.reminder?.timeStamp {
                UserDefaults.standard.set(Date(timeIntervalSince1970: time), forKey: "Reminder")
                UserDefaults.standard.set(Date(timeIntervalSince1970: time), forKey: "DidShowSetupReminderAlert")
            } else {
                YYCache.set(nil, forKey: "DidFinishMainStudyProgress")
                UserDefaults.standard.set(nil, forKey: "Reminder")
                UserDefaults.standard.set(nil, forKey: "DidShowSetupReminderAlert")
            }

            Growing.setPeopleVariableWithKey("cidan", andStringValue: "0")
        }
    }
    
    // MARK: ---- Tools ----
    
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
        self.homeEntryView.insertSubview(squirrelAnimationView!, at: 1)
        squirrelAnimationView!.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        squirrelAnimationView?.play(completion: { (isFinished) in
            if isFinished {
                self.animationPlayFinished = true
                YXLog("动画播放完成")
            } else {
                self.animationPlayFinished = false
                YXLog("动画未播放完")
            }
        })

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

    private func initDataManager() {
        if (self.homeModel?.newWords ?? 0) == 0 && (self.homeModel?.reviewWords ?? 0) == 0 {
            if service.progress == .learning {
                let wordAmount = self.service.getAllWordAmount()
                countOfWaitForStudyWords.text = "\(wordAmount)"
            }
        }
        
        // 保持当前选中的词书
        YYCache.set(self.homeModel?.bookId, forKey: .currentChooseBookId)
    }
    
    // MARK: ---- Event ----
    @objc private func updateTaskCenterStatus() {
        self.subItemCollectionView.reloadData()
    }
    
    @objc private func playSquirrelAnimation() {
        YYCache.set(true, forKey: YXLocalKey.firstShowHome)
        self.setSquirrelAnimation()
    }

    @objc private func updateMyClassStatus() {
        self.loadData()
    }
    
    @IBAction func showLearnMap(_ sender: UIButton) {
        let vc = YXLearnMapViewController()
        vc.bookId = self.homeModel?.bookId
        vc.unitId = self.homeModel?.unitId
        self.navigationController?.pushViewController(vc, animated: true)
        YXLog("进入单元地图")
    }

    private func toMyClass() {
        if YXUserModel.default.isJoinClass {
            let vc = YXMyClassViewController()
            self.navigationController?.pushViewController(vc, animated: true)
        } else {
            let alertView = YXAlertView(type: .inputable, placeholder: "请输入班级号")
            alertView.titleLabel.text = "如果您有老师的班级号，输入后即可加入班级"
            alertView.shouldOnlyShowOneButton = false
            alertView.shouldClose = false
            alertView.doneClosure = {(classNumer: String?) in
                YXUserDataManager.share.joinClass(code: classNumer) { (result) in
                    if result {
                        alertView.removeFromSuperview()
                        let vc = YXMyClassViewController()
                        YRRouter.sharedInstance().currentNavigationController()?.pushViewController(vc, animated: true)
                    }
                }
                YXLog("班级号：\(classNumer ?? "")")
            }
            alertView.clearButton.isHidden    = true
            alertView.textField.keyboardType  = .numberPad
            alertView.textCountLabel.isHidden = true
            alertView.textMaxLabel.isHidden   = true
            alertView.alertHeight.constant    = 222
            alertView.show()
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
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "YXHomeStudyDataCell", for: indexPath) as! YXHomeStudyDataCell
            
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
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "YXHomeSubItemiPadCell", for: indexPath) as! YXHomeSubItemiPadCell
                cell.setData(indexPath)
                return cell
            } else {
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "YXHomeSubItemCell", for: indexPath) as! YXHomeSubItemCell
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
