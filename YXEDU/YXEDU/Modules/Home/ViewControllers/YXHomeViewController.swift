//
//  YXHomeViewController.swift
//  YXEDU
//
//  Created by Jake To on 10/24/19.
//  Copyright © 2019 shiji. All rights reserved.
//

import UIKit

@objc
class YXHomeViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    private var wordListType: YXWordListType = .learned
    
    private var learnedWordsCount    = "--"
    private var collectedWordsCount  = "--"
    private var wrongWordsCount      = "--"
    private var homeModel: YXHomeModel!
    
    @IBOutlet weak var startStudyButton: YXDesignableButton!
    @IBOutlet weak var bookNameButton: UIButton!
    @IBOutlet weak var unitNameButton: UIButton!
    @IBOutlet weak var countOfWaitForStudyWords: YXDesignableLabel!
    @IBOutlet weak var progressBar: UIProgressView!
    @IBOutlet weak var studyDataCollectionView: UICollectionView!
    @IBOutlet weak var subItemCollectionView: UICollectionView!

    @IBAction func startExercise(_ sender: UIButton) {
        if countOfWaitForStudyWords.text == "0" {
            guard let homeData = homeModel else { return }
            
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

            let vc = YXExerciseViewController()
            vc.bookId = homeModel?.bookId
            vc.unitId = homeModel?.unitId
            vc.hidesBottomBarWhenPushed = true
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }

    
    
    // MARK: -
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let lineView = UIView(frame: CGRect(x: 0, y: -0.5, width: screenWidth, height: 0.5))
        lineView.backgroundColor = UIColor.hex(0xDCDCDC)
        self.tabBarController?.tabBar.addSubview(lineView)

        self.navigationController?.interactivePopGestureRecognizer?.delegate = nil
        
        progressBar.progressImage = progressBar.progressImage?.resizableImage(withCapInsets: UIEdgeInsets(top: 0, left: 4, bottom: 0, right: 4))
        
        studyDataCollectionView.register(UINib(nibName: "YXHomeStudyDataCell", bundle: nil), forCellWithReuseIdentifier: "YXHomeStudyDataCell")
        subItemCollectionView.register(UINib(nibName: "YXHomeSubItemCell", bundle: nil), forCellWithReuseIdentifier: "YXHomeSubItemCell")
        
        YXAlertManager.default.checkOldUser()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tabBarController?.tabBar.isHidden = false
        navigationController?.setNavigationBarHidden(true, animated: animated)

        loadData()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.setNavigationBarHidden(false, animated: animated)
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
            
        } else if segue.identifier == "AddBookFromHomeWithoutAnimation" {
            let destinationViewController = segue.destination as! YXAddBookViewController
            destinationViewController.navigationItem.leftBarButtonItems = []
            destinationViewController.navigationItem.hidesBackButton = true
            
        } else if segue.identifier == "WordList" {
            let destinationViewController = segue.destination as! YXWordListViewController
            destinationViewController.wordListType = wordListType
        }
    }
    
    private func loadData() {
        YXDataProcessCenter.get("\(YXEvnOC.baseUrl())/api/v1/learn/getbaseinfo", parameters: ["user_id": YXConfigure.shared().uuid]) { (response, isSuccess) in
            guard isSuccess, let response = response?.responseObject as? [String: Any] else { return }
            
            do {
                let jsonData = try JSONSerialization.data(withJSONObject: response, options: .prettyPrinted)
                self.homeModel = try JSONDecoder().decode(YXHomeModel.self, from: jsonData)
                
                if self.homeModel.bookId == 0 {
                    self.performSegue(withIdentifier: "AddBookFromHomeWithoutAnimation", sender: self)
                    return
                }
                
                self.adjustStartStudyButtonState()

                self.bookNameButton.setTitle(self.homeModel.bookName, for: .normal)
                self.unitNameButton.setTitle(self.homeModel.unitName, for: .normal)
                self.countOfWaitForStudyWords.text = "\((self.homeModel.newWords ?? 0) + (self.homeModel.reviewWords ?? 0))"
                self.progressBar.setProgress(Float(self.homeModel.unitProgress ?? 0), animated: true)
                
                self.learnedWordsCount = "\(self.homeModel.learnedWords ?? 0)"
                self.collectedWordsCount = "\(self.homeModel.collectedWords ?? 0)"
                self.wrongWordsCount = "\(self.homeModel.wrongWords ?? 0)"
                self.studyDataCollectionView.reloadData()
                
                YXWordBookResourceManager.shared.download(by: self.homeModel.bookId) { (isSucess) in
                    guard isSucess else { return }
                    YXUserModel.default.didFinishDownloadCurrentStudyWordBook = true
                    
                    YXWordBookResourceManager.shared.download { (isSucess) in
                        guard isSucess else { return }
                        YXUserModel.default.didFinishDownloadAllStudyWordBooks = true
                    }
                }
                
            } catch {
                print(error)
            }
        }
    }
    
    private func adjustStartStudyButtonState() {
        if let lastStoredDate = YYCache.object(forKey: "LastStoredDate") as? Date {
            if Calendar.current.isDateInToday(lastStoredDate) {
                if YXExcerciseProgressManager.isCompletion(bookId: homeModel?.bookId ?? 0, unitId: homeModel?.unitId ?? 0) {
                    startStudyButton.setTitle("再学一组", for: .normal)
                    
                } else {
                    startStudyButton.setTitle("继续学习", for: .normal)
                }
                
            } else {
                startStudyButton.setTitle("开始背单词", for: .normal)
            }
        }
    }

    
    
    // MARK: Event
    @IBAction func showLearnMap(_ sender: UIButton) {
        self.hidesBottomBarWhenPushed = true
        let vc = YXLearnMapViewController()
        vc.bookId = self.homeModel?.bookId
        vc.unitId = self.homeModel?.unitId
//        let vc = YXLearningResultViewController()
//        vc.newLearnAmount = 5
//        vc.reviewLearnAmount = 9
//        vc.bookId = self.homeModel?.bookId
//        vc.unitId = self.homeModel?.unitId
        self.navigationController?.pushViewController(vc, animated: true)
        self.hidesBottomBarWhenPushed = false
    }

    @objc func enterTaskVC() {
        let missionVC = YXMissionViewController()
        self.navigationController?.pushViewController(missionVC, animated: true)
    }
    
    // MARK: -
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
                cell.titleLabel.text = "已学单词"
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
            
            switch indexPath.row {
            case 0:
                cell.colorView.backgroundColor = UIColor(red: 255/255, green: 239/255, blue: 240/255, alpha: 1)
                cell.iconView.image = #imageLiteral(resourceName: "homeTask")
                cell.titleLabel.text = "任务中心"
                break
                
            case 1:
                cell.colorView.backgroundColor = UIColor(red: 232/255, green: 246/255, blue: 234/255, alpha: 1)
                cell.iconView.image = #imageLiteral(resourceName: "homeCalendar")
                cell.titleLabel.text = "打卡日历"
                break
                
            case 2:
                cell.colorView.backgroundColor = UIColor(red: 240/255, green: 246/255, blue: 255/255, alpha: 1)
                cell.iconView.image = #imageLiteral(resourceName: "homeReport")
                cell.titleLabel.text = "学习报告"
                break
                
            case 3:
                cell.colorView.backgroundColor = UIColor(red: 255/255, green: 244/255, blue: 225/255, alpha: 1)
                cell.iconView.image = #imageLiteral(resourceName: "homeSelectWords")
                cell.titleLabel.text = "自选单词"
                break
                
            default:
                break
            }
            
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView.tag == 1 {
            switch indexPath.row {
            case 0:
                wordListType = .learned
                self.performSegue(withIdentifier: "WordList", sender: self)
                break
                
            case 1:
                wordListType = .collected
                self.performSegue(withIdentifier: "WordList", sender: self)
                break
                
            case 2:
                wordListType = .wrongWords
                self.performSegue(withIdentifier: "WordList", sender: self)
                break
                
            default:
                break
            }
            
        } else {
            switch indexPath.row {
            case 0:
                self.performSegue(withIdentifier: "TaskCenter", sender: self)
                break
                
            case 1:
                self.performSegue(withIdentifier: "Calendar", sender: self)
                break
                
            case 2:
                YXDataProcessCenter.get("\(YXEvnOC.baseUrl())/v1/user/learnreport", parameters: [:]) { (response, isSuccess) in
                    guard isSuccess, let response = response?.responseObject else { return }
                    let data = (response as! [String: Any])["learnReport"] as? [String: Any]
                    
                    guard data?.count != nil, let learnReportModel = YXLearnReportModel.mj_object(withKeyValues: data), learnReportModel.reportUrl != "" else { return }
                    let baseWebViewController = YXBaseWebViewController(link: learnReportModel.reportUrl, title: "学习报告")
                    self.navigationController?.pushViewController(baseWebViewController!, animated: true)
                }
                
//                self.performSegue(withIdentifier: "StudyReport", sender: self)
                break
                
            case 3:
                self.performSegue(withIdentifier: "PickUpWords", sender: self)
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
            return CGSize(width: (screenWidth - 40 - 12) / 2, height: 66)
        }
    }
}
