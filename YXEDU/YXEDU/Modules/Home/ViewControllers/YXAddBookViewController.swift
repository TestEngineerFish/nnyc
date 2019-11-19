//
//  YXAddBookViewController.swift
//  YXEDU
//
//  Created by Jake To on 10/24/19.
//  Copyright © 2019 shiji. All rights reserved.
//

import UIKit

class YXAddBookViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    var finishClosure: (() -> Void)?
    
    private var grades: [YXGradeWordBookListModel] = []
    private var filterGrades: [YXGradeWordBookListModel] = []
    private var selectGradeView: YXSelectGradeView!
    
    @IBOutlet weak var filterButton: UIButton!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var seleteGradeViewStateImageView: UIImageView!
    
    @IBAction func back(_ sender: UIBarButtonItem) {
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func showOrHideSelectGradeView(_ sender: Any) {
        if selectGradeView.isHidden == true {
            selectGradeView.isHidden = false
            seleteGradeViewStateImageView.image = #imageLiteral(resourceName: "hideSelectGrade")
            
        } else {
            selectGradeView.isHidden = true
            seleteGradeViewStateImageView.image = #imageLiteral(resourceName: "showSelectGrade")
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.register(UINib(nibName: "YXGroupWordBookCell", bundle: nil), forCellReuseIdentifier: "YXGroupWordBookCell")
        
        createGradeSelectView()
        loadData()
    }
    
    private func loadData() {
        YXDataProcessCenter.get("\(YXEvnOC.baseUrl())/api/v1/book/getbooklist", parameters: [:]) { (response, isSuccess) in
            guard isSuccess, let response = response?.responseObject as? [Any] else { return }
            
            do {
                let jsonData = try JSONSerialization.data(withJSONObject: response, options: .prettyPrinted)
                guard let jsonString = String(data: jsonData, encoding: .utf8), let grades = [YXGradeWordBookListModel](JSONString: jsonString) else { return }
                self.grades = grades
                self.filterGrades = self.grades
                
                self.createGradeSelectView()
                self.tableView.reloadData()
                
            } catch {
                print(error)
            }
        }
    }
    
    private func createGradeSelectView() {
        selectGradeView = YXSelectGradeView(frame: CGRect(x: 0, y: 44, width: screenWidth, height: screenHeight), selectClosure: { (gradeName) in
            self.filterButton.setTitle(gradeName, for: .normal)
            self.filterGrade(by: gradeName)
            
            self.selectGradeView.isHidden = true
            self.seleteGradeViewStateImageView.image = #imageLiteral(resourceName: "showSelectGrade")
        })
        selectGradeView.grades.append(contentsOf: grades)
        selectGradeView.isHidden = true
        self.view.addSubview(selectGradeView)
        
        seleteGradeViewStateImageView.image = #imageLiteral(resourceName: "showSelectGrade")
    }
    
    private func filterGrade(by gradeName: String) {
        if gradeName == "全部" {
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
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if let count = filterGrades[indexPath.row].wordBooks?.count {
            let countOfRow = Int(count / 3) + ((count % 3 != 0) ? 1 : 0)
            return CGFloat(208 + ((countOfRow - 1) * 162))
            
        } else {
            return 0
        }
    }
    
    
    
    // MARK: - UICollectionView
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return filterGrades[collectionView.tag].wordBooks?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "YXSingleGroupWordBookCell", for: indexPath) as! YXSingleGroupWordBookCell
        let wordBookModel = filterGrades[collectionView.tag].wordBooks?[indexPath.row]
        
        cell.coverImageView.sd_setImage(with: URL(string: wordBookModel?.coverImagePath ?? ""), completed: nil)
        cell.nameLabel.text = wordBookModel?.bookName
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let wordBook = filterGrades[collectionView.tag].wordBooks?[indexPath.row], let bookID = wordBook.bookId, let units = wordBook.units else { return }
        
        let seleceUnitView = YXSeleceUnitView(units: units) { (unitID) in
            guard let unitID = unitID else { return }

            YXDataProcessCenter.get("\(YXEvnOC.baseUrl())/api/v1/book/adduserbook", parameters: ["user_id": YXConfigure.shared().uuid, "book_id": "\(bookID)", "unit_id": "\(unitID)"]) { [weak self] (response, isSuccess) in
                guard let self = self, isSuccess else { return }
                
                DispatchQueue.global().async {
                    YXWordBookResourceManager.shared.download(wordBook) { (isSucess) in
                        guard isSucess else { return }
                        
                        DispatchQueue.main.async {
                            if let finishClosure = self.finishClosure {
                                finishClosure()
                                
                            } else {
                                self.navigationController?.popToRootViewController(animated: true)
                            }
                        }
                    }
                }
            }
        }
        
        seleceUnitView.show()
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: (screenWidth - 96) / 3, height: 136)
    }
}
