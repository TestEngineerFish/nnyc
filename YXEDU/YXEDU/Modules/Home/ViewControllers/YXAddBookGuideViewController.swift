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
            guard let self = self else { return }
            YXWordBookResourceManager.shared.contrastBookData(by: bookId, nil)
            
            YYCache.set(Date(), forKey: "LastStoredDate")
            YXLog(String(format: "开始学习书(%ld),第(%ld)单元", bookId, unitId))
            let vc = YXExerciseViewController()
            vc.bookId = bookId
            vc.unitId = unitId
            vc.hidesBottomBarWhenPushed = true
            
            if YYCache.object(forKey: "StartStudyTime") == nil {
                YYCache.set(Date(), forKey: "StartStudyTime")
            }
            
            self.navigationController?.pushViewController(vc, animated: true)
            
        }) { error in
            YXUtils.showHUD(kWindow, title: error.message)
        }
        self.updateGIO()
    }
    
    @IBAction func goHome(_ sender: Any) {
        guard let book = selectBook, let bookId = book.bookId, let units = book.units, units.count > 0, let unitId = units.first?.unitId else { return }
        let request = YXWordBookRequest.addWordBook(userId: YXUserModel.default.uuid ?? "", bookId: bookId, unitId: unitId)
        YYNetworkService.default.request(YYStructResponse<YXResultModel>.self, request: request, success: { [weak self] (response) in
            guard let self = self else { return }
            YXWordBookResourceManager.shared.contrastBookData(by: bookId, nil)
            self.navigationController?.popToRootViewController(animated: true)
            NotificationCenter.default.post(name: YXNotification.kSquirrelAnimation, object: nil)
        }) { error in
            YXUtils.showHUD(kWindow, title: error.message)
        }
        self.updateGIO()
    }

    private func updateGIO() {
        guard let book = selectBook, let _grade = book.bookGrade else {
            return
        }
        YXGrowingManager.share.uploadChangeBook(grade: "\(_grade)", versionName: book.bookVersionName)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        selectGradeView.isHidden    = true
        selectVersionView.isHidden  = true
        selectBookNameView.isHidden = true

        YXDataProcessCenter.get("\(YXEvnOC.baseUrl())/api/v1/book/getbooklist", parameters: [:]) { (response, isSuccess) in
            guard isSuccess, let response = response?.responseObject as? [Any] else { return }

            do {
                let jsonData = try JSONSerialization.data(withJSONObject: response, options: .prettyPrinted)
                guard let jsonString = String(data: jsonData, encoding: .utf8), let grades = [YXGradeWordBookListModel](JSONString: jsonString) else { return }
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
                
            } catch {
                YXLog("获取全部词书列表失败：", error.localizedDescription)
            }
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
                let selectGrade = self.dataSource[selectedIndex]

                if let books = selectGrade.wordBooks {
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
            
            UIView.animate(withDuration: 0.6) {
                self.selectGradeViewHeight.constant = self.defaultHeight
                self.selectVersionViewTopOffSet.constant = 0
                self.selectVersionView.alpha = 1
                self.view.layoutIfNeeded()
            }
            
            self.chengeCenter()
        }
        
        selectGradeView.editClosure = {
            UIView.animate(withDuration: 0.6) {
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
            
            UIView.animate(withDuration: 0.6) {
                self.selectVersionViewHeight.constant = self.defaultHeight
                self.selectBookNameViewTopOffSet.constant = 0
                self.selectBookNameView.alpha = 1
                self.view.layoutIfNeeded()
            }
            
            self.chengeCenter()
        }
        
        selectVersionView.editClosure = {
            UIView.animate(withDuration: 0.6) {
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
            
            UIView.animate(withDuration: 0.6) {
                self.selectBookNameViewHeight.constant = self.defaultHeight
                self.view.layoutIfNeeded()
            }
            
            self.chengeCenter()
        }
        
        selectBookNameView.editClosure = {
            UIView.animate(withDuration: 0.6) {
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
            UIView.animate(withDuration: 0.6) {
                self.view.layoutIfNeeded()
            }
        }
        
        if selectBook != nil, selectGradeViewHeight.constant == defaultHeight, selectVersionViewHeight.constant == defaultHeight, selectBookNameViewHeight.constant == defaultHeight {
            startButton.isHidden = false
            homeButton.isHidden = false
            
        } else {
            startButton.isHidden = true
            homeButton.isHidden = true
        }
    }
}
