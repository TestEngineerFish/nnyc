//
//  YXHomeViewController.swift
//  YXEDU
//
//  Created by Jake To on 10/24/19.
//  Copyright © 2019 shiji. All rights reserved.
//

import UIKit
import Lottie

@objc
class YXHomeViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    private var wordListType: YXWordListType = .learned
    
    private var learnedWordsCount    = "--"
    private var collectedWordsCount  = "--"
    private var wrongWordsCount      = "--"
    private var homeModel: YXHomeModel!
    public var progressManager = YXExcerciseProgressManager()
    
    @IBOutlet weak var homeEntryView: YXDesignableView!
    @IBOutlet weak var bookNameButton: UIButton!
    @IBOutlet weak var startStudyView: YXDesignableView!
    @IBOutlet weak var startStudyButton: YXDesignableButton!
    @IBOutlet weak var changeBookButton: UIButton!
    @IBOutlet weak var unitNameButton: UIButton!
    @IBOutlet weak var countOfWaitForStudyWords: YXDesignableLabel!
    @IBOutlet weak var progressBar: UIProgressView!
    @IBOutlet weak var studyDataCollectionView: UICollectionView!
    @IBOutlet weak var subItemCollectionView: UICollectionView!
    var squirrelAnimationView: AnimationView?
    @IBOutlet weak var entryViewHeightConstraint: NSLayoutConstraint!
    
    @IBAction func startExercise(_ sender: UIButton) {
        if YXWordBookResourceManager.shared.isDownloading {
            YXUtils.showHUD(kWindow, title: "正在下载词书，请稍后再试～")
            return
        }
        YXLog("====开始主流程的学习====")
        if self.countOfWaitForStudyWords.text == "0" {
            guard let homeData = self.homeModel else { return }
            
            let alertView = YXAlertView(type: .normal)
            if homeData.isLastUnit == 1 {
                alertView.descriptionLabel.text = "你太厉害了，已经背完这本书拉，你可以……"
                alertView.closeButton.isHidden = false
                alertView.leftButton.setTitle("换单元", for: .normal)
                alertView.rightOrCenterButton.setTitle("换本书学", for: .normal)
                
                alertView.cancleClosure = {
                    self.showLearnMap(alertView.rightOrCenterButton)
                }
                
                alertView.doneClosure = { _ in
                    self.performSegue(withIdentifier: "AddBookFromHome", sender: self)
                }
                
            } else {
                alertView.descriptionLabel.text = "你太厉害了，暂时没有需要新学或复习的单词，你可以……"
                alertView.rightOrCenterButton.setTitle("换单元", for: .normal)
                alertView.doneClosure = { _ in
                    self.showLearnMap(alertView.rightOrCenterButton)
                }
            }
            
            alertView.adjustAlertHeight()
            alertView.show()
            
        } else {
            YYCache.set(Date(), forKey: "LastStoredDate")
            YXLog(String(format: "开始学习书(%ld),第(%ld)单元", self.homeModel?.bookId ?? 0, self.homeModel?.unitId ?? 0))
            let vc = YXExerciseViewController()
            vc.bookId = self.homeModel?.bookId
            vc.unitId = self.homeModel?.unitId
            vc.hidesBottomBarWhenPushed = true
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let lineView = UIView(frame: CGRect(x: 0, y: -0.5, width: screenWidth, height: 0.5))
        lineView.backgroundColor = UIColor.hex(0xDCDCDC)
        self.tabBarController?.tabBar.addSubview(lineView)
                
        progressBar.progressImage = progressBar.progressImage?.resizableImage(withCapInsets: UIEdgeInsets(top: 0, left: 4, bottom: 0, right: 4))
        
        studyDataCollectionView.register(UINib(nibName: "YXHomeStudyDataCell", bundle: nil), forCellWithReuseIdentifier: "YXHomeStudyDataCell")
        subItemCollectionView.register(UINib(nibName: "YXHomeSubItemCell", bundle: nil), forCellWithReuseIdentifier: "YXHomeSubItemCell")
        
        self.checkUserState()
        self.adjustEntryViewContraints()
        self.setSquirrelAnimation()
        self.registerNotification()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.startStudyButton.isEnabled   = true
        tabBarController?.tabBar.isHidden = false
        navigationController?.setNavigationBarHidden(true, animated: animated)
        loadData()
        YXAlertCheckManager.default.checkLatestBadgeWhenBackTabPage()
        YXBadgeManager.share.updateTaskCenterBadge()
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let careerModel = YXCareerModel(item: "learn", bookId: 0, sort: 1)
        
        if segue.identifier == "LearnedWords" {
            let destinationViewController = segue.destination as! YXCareerViewController
            destinationViewController.selectedIndex = 0
            destinationViewController.careerModel = careerModel
            
        } else if segue.identifier == "FavoritesWords" {
            let destinationViewController = segue.destination as! YXCareerViewController
            destinationViewController.selectedIndex = 1
            destinationViewController.careerModel = careerModel
            
        } else if segue.identifier == "WrongWords" {
            let destinationViewController = segue.destination as! YXCareerViewController
            destinationViewController.selectedIndex = 2
            destinationViewController.careerModel = careerModel
            
        } else if segue.identifier == "WordList" {
            let destinationViewController = segue.destination as! YXWordListViewController
            destinationViewController.wordListType = wordListType
        }
    }
    
    // MARK: ---- Notification ----
    /// 注册通知
    private func registerNotification() {
        NotificationCenter.default.addObserver(self, selector: #selector(updateTaskCenterStatus), name: YXNotification.kUpdateTaskCenterBadge, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(playSquirrelAnimation), name: YXNotification.kSquirrelAnimation, object: nil)
    }
    
    // MARK: ---- Request ----
    private func loadData() {
        YXDataProcessCenter.get("\(YXEvnOC.baseUrl())/api/v1/learn/getbaseinfo", parameters: ["user_id": YXConfigure.shared().uuid]) { (response, isSuccess) in
            guard isSuccess, let response = response?.responseObject as? [String: Any] else { return }
            
            do {
                let jsonData = try JSONSerialization.data(withJSONObject: response, options: .prettyPrinted)
                self.homeModel = try JSONDecoder().decode(YXHomeModel.self, from: jsonData)
                
                self.adjustStartStudyButtonState()
                self.bookNameButton.setTitle(self.homeModel.bookName, for: .normal)
                self.unitNameButton.setTitle(self.homeModel.unitName, for: .normal)
                self.countOfWaitForStudyWords.text = "\((self.homeModel.newWords ?? 0) + (self.homeModel.reviewWords ?? 0))"
                self.progressBar.setProgress(Float(self.homeModel.unitProgress ?? 0), animated: true)
                
                self.learnedWordsCount   = "\(self.homeModel.learnedWords ?? 0)"
                self.collectedWordsCount = "\(self.homeModel.collectedWords ?? 0)"
                self.wrongWordsCount     = "\(self.homeModel.wrongWords ?? 0)"
                self.studyDataCollectionView.reloadData()
                
                YXWordBookResourceManager.shared.contrastBookData()
                
                self.initDataManager()
            } catch {
                YXLog("获取主页基础数据失败：", error.localizedDescription)
            }
        }
    }
    
    private func checkUserState() {
        let request = YXRegisterAndLoginRequest.userInfomation
        YYNetworkService.default.request(YYStructResponse<YXUserInfomationModel>.self, request: request, success: { [weak self] (response) in
            guard let self = self, let userInfomation = response.data else { return }

            if userInfomation.didSelectBook == 0 {
                self.performSegue(withIdentifier: "AddBookGuide", sender: self)
                
            } else {
                self.navigationController?.interactivePopGestureRecognizer?.delegate = nil
            }
            YXConfigure.shared()?.showKeyboard = (userInfomation.fillType == .keyboard)
            YXUserModel.default.coinExplainUrl = userInfomation.coinExplainUrl
            YXUserModel.default.gameExplainUrl = userInfomation.gameExplainUrl
            YXUserModel.default.reviewNameType = userInfomation.reviewNameType
        }) { error in
            YXUtils.showHUD(kWindow, title: error.message)
        }
    }
    
    // MARK: ---- Tools ----
    
    private func setSquirrelAnimation() {
        if self.squirrelAnimationView?.superview != nil {
            self.squirrelAnimationView?.removeFromSuperview()
        }
        let isFirstShowHome = YYCache.object(forKey: YXLocalKey.firstShowHome) as? Bool ?? true
        if isFirstShowHome {
            squirrelAnimationView = AnimationView(name: "homeFirst")
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 1.5) { [weak self] in
                let animation = CAKeyframeAnimation(keyPath: "transform.scale")
                animation.values         = [1.0, 0.8, 1.0, 0.8, 1.0]
                animation.duration       = 3.5
                animation.timingFunction = CAMediaTimingFunction(name: .easeIn)
                self?.startStudyButton.layer.add(animation, forKey: nil)
                self?.startStudyView.layer.add(animation, forKey: nil)
            }
        } else {
            squirrelAnimationView = AnimationView(name: "homeNormal")
        }
        YYCache.set(false, forKey: YXLocalKey.firstShowHome)
        self.homeEntryView.insertSubview(squirrelAnimationView!, at: 1)
        squirrelAnimationView!.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        squirrelAnimationView?.play()
    }
    
    private func adjustEntryViewContraints() {
        let entryViewH = (screenWidth - 40) / 332 * 381
        self.entryViewHeightConstraint.constant = entryViewH
    }
    
    private func adjustStartStudyButtonState() {
        if let lastStoredDate = YYCache.object(forKey: "LastStoredDate") as? Date {
            if Calendar.current.isDateInToday(lastStoredDate) {
                if YXExcerciseProgressManager.isCompletion(bookId: homeModel?.bookId ?? 0, unitId: homeModel?.unitId ?? 0, dataType: .base) {
                    startStudyButton.setTitle("再学一组", for: .normal)
                    
                } else {
                    startStudyButton.setTitle("继续学习", for: .normal)
                }
                
            } else {
                startStudyButton.setTitle("开始背单词", for: .normal)
            }
        }
    }

    private func initDataManager() {
        // 只有基础学习的bookId才是真实bookId，复习的bookId是后端虚构的ID
        progressManager.bookId = self.homeModel?.bookId
        progressManager.unitId = self.homeModel?.unitId
        progressManager.dataType = .base
        
        if (self.homeModel.newWords ?? 0) == 0 && (self.homeModel.reviewWords ?? 0) == 0 {
            if progressManager.isCompletion() == false {
                let data = progressManager.loadLocalWordsProgress()
                countOfWaitForStudyWords.text = "\(data.0.count + data.1.count)"
            }
        }
    }
    
    // MARK: ---- Event ----
    @objc private func updateTaskCenterStatus() {
        self.subItemCollectionView.reloadData()
    }
    
    @objc private func playSquirrelAnimation() {
        YYCache.set(true, forKey: YXLocalKey.firstShowHome)
        self.setSquirrelAnimation()
    }
    
    @IBAction func showLearnMap(_ sender: UIButton) {
        self.hidesBottomBarWhenPushed = true
        let vc = YXLearnMapViewController()
        vc.bookId = self.homeModel?.bookId
        vc.unitId = self.homeModel?.unitId
        self.navigationController?.pushViewController(vc, animated: true)
        self.hidesBottomBarWhenPushed = false
    }

    @objc func enterTaskVC() {
        let missionVC = YXMissionViewController()
        self.navigationController?.pushViewController(missionVC, animated: true)
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
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "YXHomeSubItemCell", for: indexPath) as! YXHomeSubItemCell
            cell.setData(indexPath)
            return cell
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
                self.performSegue(withIdentifier: "Calendar", sender: self)
                break
                
            case 2:
                let request = YXHomeRequest.report
                YYNetworkService.default.request(YYStructResponse<YXReportModel>.self, request: request, success: { [weak self] (response) in
                    guard let self = self else { return }
                    if let report = response.data, let url = report.reportUrl, url.isEmpty == false {
                        let baseWebViewController = YXBaseWebViewController(link: url, title: "我的学习报告")
                        baseWebViewController?.hidesBottomBarWhenPushed = true
                        self.navigationController?.pushViewController(baseWebViewController!, animated: true)
                    } else if let report = response.data, let description = report.description {
                        self.view.toast(description)
                    }
                }) { error in
                    YXUtils.showHUD(kWindow, title: error.message)
                }
                break
            case 3:
                tabBarController?.selectedIndex = 2
                break
                
            default:
                break
            }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if collectionView.tag == 1 {
            return CGSize(width: (screenWidth - 60) / 3, height: 88)
            
        } else {
            return CGSize(width: (screenWidth - 40 - 12) / 2, height: 60)
        }
    }
}
