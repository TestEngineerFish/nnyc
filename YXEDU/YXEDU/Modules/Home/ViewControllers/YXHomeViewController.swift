//
//  YXHomeViewController.swift
//  YXEDU
//
//  Created by Jake To on 10/24/19.
//  Copyright © 2019 shiji. All rights reserved.
//

import UIKit

class YXHomeViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    private var learnedWordsCount = "--"
    private var collectedWordsCount = "--"
    private var wrongWordsCount = "--"

    @IBOutlet weak var bookNameButton: UIButton!
    @IBOutlet weak var unitNameButton: UIButton!
    @IBOutlet weak var countOfWaitForStudyWords: YXDesignableLabel!
    @IBOutlet weak var progressBar: UIProgressView!
    @IBOutlet weak var studyDataCollectionView: UICollectionView!
    @IBOutlet weak var subItemCollectionView: UICollectionView!

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.tabBarController?.tabBar.isHidden = false
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.interactivePopGestureRecognizer?.delegate = nil
        
        studyDataCollectionView.register(UINib(nibName: "YXHomeStudyDataCell", bundle: nil), forCellWithReuseIdentifier: "YXHomeStudyDataCell")
        subItemCollectionView.register(UINib(nibName: "YXHomeSubItemCell", bundle: nil), forCellWithReuseIdentifier: "YXHomeSubItemCell")
        
        checkLoginState()
    }
    private func checkLoginState() {
        YXComHttpService.shared().requestConfig({ (response, isSuccess) in
            if isSuccess, let response = response?.responseObject {
                let config = response as! YXConfigModel

                guard config.baseConfig.learning else {
                    self.performSegue(withIdentifier: "AddWordsBook", sender: self)
                    return
                }
                
                self.loadData()
                
            } else if let error = response?.error {
                print(error.desc)
            }
        })
    }
    
    private func loadData() {
        YXDataProcessCenter.get("\(YXEvnOC.baseUrl())/v1/learning/indexinfo", modelClass: YXMainModel.self, parameters: [:]) { (response, isSuccess) in
            if isSuccess, let response = response?.responseObject {
                let mainModel = response as! YXMainModel
                YXConfigure.shared().currLearningBookId = mainModel.noteIndex.bookId
                
                self.bookNameButton.setTitle(mainModel.noteIndex.bookName, for: .normal)
                self.unitNameButton.setTitle("Unit 1", for: .normal)
                self.countOfWaitForStudyWords.text = mainModel.noteIndex.planRemain

                self.learnedWordsCount = mainModel.noteRecord.learned
                self.collectedWordsCount = mainModel.noteRecord.fav
                self.wrongWordsCount = mainModel.noteRecord.wrong
                self.studyDataCollectionView.reloadData()
                
            } else {
                
            }
        }
    }
    
    @IBAction func startExercise(_ sender: UIButton) {
        let vc = YXExerciseViewController()
        vc.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(vc, animated: true)
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
                cell.colorView.backgroundColor = UIColor(red: 240/255, green: 246/255, blue: 255/255, alpha: 1)
                cell.iconView.image = #imageLiteral(resourceName: "homeReport")
                cell.titleLabel.text = "学习报告"
                break
                
            case 2:
                cell.colorView.backgroundColor = UIColor(red: 232/255, green: 246/255, blue: 234/255, alpha: 1)
                cell.iconView.image = #imageLiteral(resourceName: "homeCalendar")
                cell.titleLabel.text = "打卡日历"
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
                self.performSegue(withIdentifier: "LearnedWords", sender: self)
                break
                
            case 1:
                self.performSegue(withIdentifier: "FavoritesWords", sender: self)
                break
                
            case 2:
                self.performSegue(withIdentifier: "WrongWords", sender: self)
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
                self.performSegue(withIdentifier: "StudyReport", sender: self)
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
