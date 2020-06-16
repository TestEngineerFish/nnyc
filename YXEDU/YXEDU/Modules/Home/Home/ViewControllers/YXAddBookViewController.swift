//
//  YXAddBookViewController.swift
//  YXEDU
//
//  Created by Jake To on 10/24/19.
//  Copyright © 2019 shiji. All rights reserved.
//

import UIKit
import GrowingCoreKit

class YXAddBookViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {    
    private var grades: [YXGradeWordBookListModel] = []
    private var filterGrades: [YXGradeWordBookListModel] = []
    private var filterVersion = "所有版本"
    private var selectGradeView: YXSelectGradeView?
    
    @IBOutlet weak var filterButton: UIButton!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var seleteGradeViewStateImageView: UIImageView!
    
    @IBAction func back(_ sender: UIBarButtonItem) {
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func showOrHideSelectGradeView(_ sender: Any) {
        if selectGradeView?.isHidden == true {
            selectGradeView?.isHidden = false
            
        } else {
            selectGradeView?.isHidden = true
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.register(UINib(nibName: "YXGroupWordBookCell", bundle: nil), forCellReuseIdentifier: "YXGroupWordBookCell")
        loadData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(false, animated: animated)
    }
    
    private func loadData() {
        let request = YXHomeRequest.getBookList
        YYNetworkService.default.request(YYStructDataArrayResponse<YXGradeWordBookListModel>.self, request: request, success: { (response) in
            guard let data = response.dataArray else { return }
            self.grades       = data
            self.filterGrades = self.grades
            
            self.tableView.reloadData()
            self.createGradeSelectView()
            
        }) { error in
            YXLog("获取全部词书失败：", error.localizedDescription)
        }
    }
        
    private func createGradeSelectView() {
        selectGradeView = YXSelectGradeView(frame: CGRect(x: 0, y: 44, width: screenWidth, height: screenHeight), grades: grades, selectClosure: { gradeName, versionName in
            self.filterButton.setTitle("  " + gradeName + " " + (versionName ?? "所有版本") + "  ", for: .normal)
            self.filterButton.setTitleColor(.orange1, for: .normal)
            self.filterButton.backgroundColor = UIColor.orange1.withAlphaComponent(0.1)
            self.filterButton.layer.cornerRadius = 14
            
            self.filterVersion = versionName ?? "所有版本"
            self.filterGrade(by: gradeName)
            
            if versionName != nil {
                self.selectGradeView?.isHidden = true
            }
        })
        
        selectGradeView?.isHidden = true
        self.view.addSubview(selectGradeView!)
    }
    
    private func filterGrade(by gradeName: String) {
        if gradeName == "所有年级" {
            self.filterGrades = self.grades
            
        } else {
            for grade in self.grades {
                guard grade.gradeName == gradeName else { continue }
                self.filterGrades = [grade]
                break
            }
        }
        
        tableView.reloadData()
        tableView.scrollsToTop = true
    }
    
    
    
    // MARK: - UITableView
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filterGrades.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "YXGroupWordBookCell", for: indexPath) as! YXGroupWordBookCell
        let grade = filterGrades[indexPath.row]

        cell.gradeTitleLabel.text = grade.gradeName

        cell.bookCollectionView.tag = indexPath.row
        cell.bookCollectionView.delegate = self
        cell.bookCollectionView.dataSource = self
        cell.bookCollectionView.register(UINib(nibName: "YXSingleGroupWordBookCell", bundle: nil), forCellWithReuseIdentifier: "YXSingleGroupWordBookCell")
        cell.bookCollectionView.reloadData()

        if indexPath.row == 0 {
            cell.divierView.isHidden = true

        } else {
            cell.divierView.isHidden = false
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if filterVersion == "所有版本" {
            if let count = filterGrades[indexPath.row].wordBooks?.count, count != 0 {
                if count <= 3 {
                    return 228

                } else {
                    var countOfRow = Int(count / 3)
                    
                    if countOfRow != 0 {
                        countOfRow = countOfRow - 1
                    }
                    
                    if count % 3 != 0 {
                        countOfRow = countOfRow + 1
                    }
                    
                    return CGFloat(228 + (countOfRow * 182))
                }

            } else {
                return 0
            }

        } else {
            var count = 0

            for wordBook in filterGrades[indexPath.row].wordBooks ?? [] {
                guard wordBook.bookVersionName == filterVersion else { continue }
                count = count + 1
            }

            if count == 0 {
                return 0

            } else if count <= 3 {
                return 228

            } else {
                var countOfRow = Int(count / 3)
                    
                if countOfRow != 0 {
                    countOfRow = countOfRow - 1
                }
                
                if count % 3 != 0 {
                    countOfRow = countOfRow + 1
                }
                
                return CGFloat(228 + (countOfRow * 182))
            }
        }
    }
    
    
    
    // MARK: - UICollectionView
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if filterVersion == "所有版本" {
            return filterGrades[collectionView.tag].wordBooks?.count ?? 0

        } else {
            var count = 0
            
            for wordBook in filterGrades[collectionView.tag].wordBooks ?? [] {
                guard wordBook.bookVersionName == filterVersion else { continue }
                count = count + 1
            }
            
            return count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "YXSingleGroupWordBookCell", for: indexPath) as! YXSingleGroupWordBookCell
        
        if filterVersion == "所有版本" {
            let wordBookModel = filterGrades[collectionView.tag].wordBooks?[indexPath.row]
            cell.coverImageView.sd_setImage(with: URL(string: wordBookModel?.coverImagePath ?? ""), placeholderImage: nil, options: [.lowPriority], progress: nil, completed: nil)
            cell.nameLabel.text = wordBookModel?.bookName
            
        } else {
            var wordBookModels: [YXWordBookModel] = []
            
            for wordBook in filterGrades[collectionView.tag].wordBooks ?? [] {
                guard wordBook.bookVersionName == filterVersion else { continue }
                wordBookModels.append(wordBook)
            }
            
            let wordBookModel = wordBookModels[indexPath.row]
            cell.coverImageView.sd_setImage(with: URL(string: wordBookModel.coverImagePath ?? ""), placeholderImage: nil, options: [.lowPriority], progress: nil, completed: nil)
            cell.nameLabel.text = wordBookModel.bookName
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        var wordBook: YXWordBookModel!
        
        if filterVersion == "所有版本" {
            guard let wordBookMocel = filterGrades[collectionView.tag].wordBooks?[indexPath.row] else { return }
            wordBook = wordBookMocel
            
        } else {
            var wordBookModels: [YXWordBookModel] = []
            
            for wordBook in filterGrades[collectionView.tag].wordBooks ?? [] {
                guard wordBook.bookVersionName == filterVersion else { continue }
                wordBookModels.append(wordBook)
            }
            
            wordBook = wordBookModels[indexPath.row]
        }
        
        guard let bookId = wordBook.bookId, let units = wordBook.units else { return }
        let seleceUnitView = YXSeleceUnitView(units: units) { (unitId) in
            guard let unitId = unitId else { return }

            // ---- Growing ----
            let gradeId = self.filterGrades[collectionView.tag].gradeId
            let bookGrade: String? = gradeId == nil ? nil : "\(gradeId ?? 0)"
            YXGrowingManager.share.uploadChangeBook(grade: bookGrade, versionName: wordBook.bookVersionName)
            YXGrowingManager.share.uploadSkipNewLearn()

            let request = YXWordBookRequest.addWordBook(userId: YXUserModel.default.uuid ?? "", bookId: bookId, unitId: unitId)
            YYNetworkService.default.request(YYStructResponse<YXResultModel>.self, request: request, success: { [weak self] (response) in
                guard let self = self else { return }
                YXUserModel.default.currentBookId   = bookId
                YXUserModel.default.currentGrade    = gradeId
                self.navigationController?.popToRootViewController(animated: true)
                let taskModel = YXWordBookResourceModel(type: .single, book: bookId) {
                    YXWordBookResourceManager.shared.contrastBookData(by: bookId)
                }
                YXWordBookResourceManager.shared.addTask(model: taskModel)
            }) { error in
                YXUtils.showHUD(kWindow, title: error.message)
            }
        }
        
        seleceUnitView.show()
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: (screenWidth - 100) / 3, height: 156)
    }
}
