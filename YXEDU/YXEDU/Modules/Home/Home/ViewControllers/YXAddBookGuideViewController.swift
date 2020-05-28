//
//  YXAddBookGuideViewController.swift
//  YXEDU
//
//  Created by Jake To on 2/24/20.
//  Copyright © 2020 shiji. All rights reserved.
//

import UIKit

class YXAddBookGuideViewController: UIViewController {
    private var dataSource: [YXGradeWordBookListModel] = []
    private var selectBook: YXWordBookModel?
    private var selectGrade: YXGradeWordBookListModel?
    private var grades: [String] = ["一年级", "二年级", "三年级", "四年级", "五年级", "六年级", "七年级", "八年级", "九年级"]
    private var versions: [String] = ["人教版", "沪教版", "冀教版", "北师大", "译林版", "粤教版"]
    private var bookNames: [String] = ["人教版七年级上册", "人教版七年级下册"]
    
    private let defaultHeight: CGFloat = 126
    private var gradeHeight: CGFloat {
        return 70 + (self.selectGradeView.collectionView.collectionViewLayout as! YXCollectionViewLeftFlowLayout).contentHeight
    }
    
    private var versionHeight: CGFloat {
        let descriptionHeight = "教材不断添加中,如果没有看到您的教材,可以 选择通用版学习哦~".textHeight(font: UIFont.systemFont(ofSize: 14), width: screenWidth - 88)
        
        return 50 + descriptionHeight + 26 + (self.selectVersionView.collectionView.collectionViewLayout as! YXCollectionViewLeftFlowLayout).contentHeight
    }
    
    private var bookNameHeight: CGFloat {
        return 70 + (self.selectBookNameView.collectionView.collectionViewLayout as! YXCollectionViewLeftFlowLayout).contentHeight
    }
    
    @IBOutlet weak var selectGradeView: YXAddBookGuideView!
    @IBOutlet weak var selectGradeViewTopOffSet: NSLayoutConstraint!
    @IBOutlet weak var selectGradeViewHeight: NSLayoutConstraint!
    @IBOutlet weak var selectVersionView: YXAddBookGuideView!
    @IBOutlet weak var selectVersionViewTopOffSet: NSLayoutConstraint!
    @IBOutlet weak var selectVersionViewHeight: NSLayoutConstraint!
    @IBOutlet weak var selectBookNameView: YXAddBookGuideView!
    @IBOutlet weak var selectBookNameViewTopOffSet: NSLayoutConstraint!
    @IBOutlet weak var selectBookNameViewHeight: NSLayoutConstraint!
    @IBOutlet weak var startButton: YXDesignableButton!
    @IBOutlet weak var homeButton: UIButton!

    @IBAction func start(_ sender: Any) {
        guard let book = selectBook, let bookId = book.bookId, let units = book.units, units.count > 0, let unitId = units.first?.unitId else { return }
        let request = YXWordBookRequest.addWordBook(userId: YXUserModel.default.uuid ?? "", bookId: bookId, unitId: unitId)
        YYNetworkService.default.request(YYStructResponse<YXResultModel>.self, request: request, success: { [weak self] (response) in
            guard let self = self, let uuid = YXUserModel.default.uuid else { return }
            YXUserModel.default.currentBookId   = bookId
            YXStepConfigManager.share.contrastStepConfig()

            let taskModel = YXWordBookResourceModel(type: .single, book: bookId) {
                YXWordBookResourceManager.shared.contrastBookData(by: bookId)
            }
            YXWordBookResourceManager.shared.addTask(model: taskModel)
            
            let request = YXHomeRequest.getBaseInfo(userId: uuid)
            YYNetworkService.default.request(YYStructResponse<YXHomeModel>.self, request: request, success: { (response) in
                guard let userInfomation = response.data else { return }

                YXUserModel.default.currentGrade    = userInfomation.bookGrade
                YXConfigure.shared().isSkipNewLearn = userInfomation.isSkipNewLearn == .some(1)
                
                YYCache.set(Date(), forKey: "LastStoredDate")
                YXLog("====新注册 - 开始主流程的学习====")
                YXLog(String(format: "开始学习书(%ld),第(%ld)单元", bookId, unitId))
                let vc = YXExerciseViewController()
                vc.learnConfig = YXBaseLearnConfig(bookId: bookId, unitId: unitId)
                vc.hidesBottomBarWhenPushed = true
                
                if YYCache.object(forKey: "StartStudyTime") == nil {
                    YYCache.set(Date(), forKey: "StartStudyTime")
                }
                
                self.navigationController?.pushViewController(vc, animated: true)
                
            }) { error in
                YXUtils.showHUD(kWindow, title: error.message)
            }
            self.updateGIO()
            
        }) { error in
            YXUtils.showHUD(kWindow, title: error.message)
        }
    }
    
    @IBAction func goHome(_ sender: Any) {
        guard let book = selectBook, let bookId = book.bookId, let units = book.units, units.count > 0, let unitId = units.first?.unitId else { return }
        let request = YXWordBookRequest.addWordBook(userId: YXUserModel.default.uuid ?? "", bookId: bookId, unitId: unitId)
        YYNetworkService.default.request(YYStructResponse<YXResultModel>.self, request: request, success: { [weak self] (response) in
            guard let self = self else { return }
            let taskModel = YXWordBookResourceModel(type: .single, book: bookId) {
                YXWordBookResourceManager.shared.contrastBookData(by: bookId)
            }
            YXWordBookResourceManager.shared.addTask(model: taskModel)
            self.navigationController?.popToRootViewController(animated: true)
            NotificationCenter.default.post(name: YXNotification.kSquirrelAnimation, object: nil)
        }) { error in
            YXUtils.showHUD(kWindow, title: error.message)
        }
        self.updateGIO()
    }

    private func updateGIO() {
        guard let book = selectBook, let selectModel = self.selectGrade else {
            return
        }
        let bookGrade: String? = selectModel.gradeId == nil ? nil : "\(selectModel.gradeId ?? 0)"
        YXGrowingManager.share.uploadChangeBook(grade: bookGrade, versionName: book.bookVersionName)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        selectGradeView.isHidden    = true
        selectVersionView.isHidden  = true
        selectBookNameView.isHidden = true

        let request = YXHomeRequest.getBookList
        YYNetworkService.default.request(YYStructDataArrayResponse<YXGradeWordBookListModel>.self, request: request, success: { (response) in
            guard let grades = response.dataArray else { return }
            self.dataSource = grades
            
            for grade in grades {
                if let gradeName = grade.gradeName, gradeName.isEmpty == false, self.grades.contains(gradeName) == false {
                    self.grades.append(gradeName)
                }
            }
            
            self.initSelectViews()
            
            self.selectGradeView.isHidden = false
            self.selectVersionView.isHidden = false
            self.selectBookNameView.isHidden = false
            
            self.chengeCenter(withoutAnimation: true)
            
        }) { error in
            YXLog("获取全部词书失败：", error.localizedDescription)
        }
    }
    
    private func initSelectViews() {
        // MARK: selectGradeView
        selectGradeView.titleLabel.text = "你现在学到几年级呢"
        selectGradeView.select(grades)
        selectGradeView.collectionView.collectionViewLayout.prepare()
        selectGradeViewHeight.constant = gradeHeight
        selectGradeView.selectedClosure = {
            self.versions = []

            if let selectedIndex = self.selectGradeView.selectedIndex {
                self.selectGrade = self.dataSource[selectedIndex]

                if let books = self.selectGrade?.wordBooks {
                    for book in books {
                        if let version = book.bookVersionName, version.isEmpty == false, self.versions.contains(version) == false {
                            self.versions.append(version)
                        }
                    }
                }
            }
            
            self.selectVersionView.select(self.versions)
            self.selectVersionView.collectionView.collectionViewLayout.prepare()
            self.selectVersionView.descriptionLabel.alpha = 1
            self.selectVersionViewTopOffSet.constant = 88
            self.selectVersionViewHeight.constant = self.versionHeight
            
            UIView.animate(withDuration: 0.4) {
                self.selectGradeViewHeight.constant = self.defaultHeight
                self.selectVersionViewTopOffSet.constant = 0
                self.selectVersionView.alpha = 1
                self.view.layoutIfNeeded()
            }
            
            self.chengeCenter()
        }
        
        selectGradeView.editClosure = {
            UIView.animate(withDuration: 0.4) {
                self.selectGradeViewHeight.constant = self.gradeHeight
                self.selectVersionViewTopOffSet.constant = 88
                self.selectVersionView.alpha = 0
                self.selectBookNameView.alpha = 0
                self.view.layoutIfNeeded()
            }
                            
            self.chengeCenter()
        }
        
        // MARK: selectVersionView
        selectVersionView.alpha = 0
        selectVersionView.titleLabel.text = "你现在在学哪个版本的教材呢"
        selectVersionView.descriptionLabel.isHidden = false
        selectVersionView.descriptionLabel.text = "教材不断添加中,如果没有看到您的教材,可以 选择通用版学习哦~"
        selectVersionView.select(versions)
        selectVersionView.selectedClosure = {
            self.bookNames = []

            if let gradeIndex = self.selectGradeView.selectedIndex, let versionIndex = self.selectVersionView.selectedIndex {
                let grade = self.dataSource[gradeIndex]

                if let books = grade.wordBooks {
                    for book in books {
                        guard let bookName = book.bookShortName, bookName.isEmpty == false, book.bookVersionName == self.versions[versionIndex] else { continue }
                        self.bookNames.append(bookName)
                    }
                }
            }
            
            self.selectBookNameView.select(self.bookNames)
            self.selectBookNameViewTopOffSet.constant = 88
            self.selectBookNameView.collectionView.collectionViewLayout.prepare()
            self.selectBookNameViewHeight.constant = self.bookNameHeight
            
            UIView.animate(withDuration: 0.4) {
                self.selectVersionViewHeight.constant = self.defaultHeight
                self.selectBookNameViewTopOffSet.constant = 0
                self.selectBookNameView.alpha = 1
                self.view.layoutIfNeeded()
            }
            
            self.chengeCenter()
        }
        
        selectVersionView.editClosure = {
            UIView.animate(withDuration: 0.4) {
                self.selectVersionViewTopOffSet.constant = 0
                self.selectVersionViewHeight.constant = self.versionHeight
                self.selectBookNameViewTopOffSet.constant = 88
                self.selectBookNameView.alpha = 0
                self.view.layoutIfNeeded()
            }
            
            self.chengeCenter()
        }
        
        // MARK: selectBookNameView
        selectBookNameView.alpha = 0
        selectBookNameView.titleLabel.text = "词书"
        selectBookNameView.select(bookNames)
        selectBookNameView.selectedClosure = {
            if let gradeIndex = self.selectGradeView.selectedIndex, let bookIndex = self.selectBookNameView.selectedIndex  {
                let grade = self.dataSource[gradeIndex]
                
                if let books = grade.wordBooks {
                    for book in books {
                        guard let bookName = book.bookShortName, bookName == self.bookNames[bookIndex] else { continue }
                        self.selectBook = book
                        break
                    }
                }
            }
            
            UIView.animate(withDuration: 0.4) {
                self.selectBookNameViewHeight.constant = self.defaultHeight
                self.view.layoutIfNeeded()
            }
            
            if self.selectBook != nil, self.selectGradeViewHeight.constant == self.defaultHeight, self.selectVersionViewHeight.constant == self.defaultHeight, self.selectBookNameViewHeight.constant == self.defaultHeight {
                self.startButton.isHidden = false
                self.homeButton.isHidden = false
                
            } else {
                self.startButton.isHidden = true
                self.homeButton.isHidden = true
            }
        }
        
        selectBookNameView.editClosure = {
            UIView.animate(withDuration: 0.4) {
                self.selectBookNameViewHeight.constant = self.bookNameHeight
                self.view.layoutIfNeeded()
            }

            self.chengeCenter()
        }
    }
    
    private func chengeCenter(withoutAnimation: Bool = false) {
        var totalHeight: CGFloat = 0
        
        if selectGradeView.alpha == 1 {
            totalHeight = totalHeight + selectGradeViewHeight.constant
        }
        
        if selectVersionView.alpha == 1 {
            totalHeight = totalHeight + selectVersionViewHeight.constant
        }
        
        if selectBookNameView.alpha == 1 {
            totalHeight = totalHeight + selectBookNameViewHeight.constant
        }
        
        selectGradeViewTopOffSet.constant = (screenHeight - totalHeight - 44) / 3
        
        if withoutAnimation {
            self.view.layoutIfNeeded()

        } else {
            UIView.animate(withDuration: 0.4) {
                self.view.layoutIfNeeded()
            }
        }
    }
}
