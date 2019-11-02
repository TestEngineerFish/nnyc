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
    
    private var grades: [YXGradeModel] = []
    private var selectGradeView: YXSelectGradeView!
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var seleteGradeViewStateImageView: UIImageView!
    
    @IBAction func back(_ sender: UIBarButtonItem) {
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func showOrHideSelectGradeView(_ sender: Any) {
        guard createGradeSelectView != nil else { return }
        
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
        
        loadData()
    }
    
    private func loadData() {
        YXDataProcessCenter.get("\(YXEvnOC.baseUrl())/api/v1/book/indexinfo", modelClass: YXGradeModel.self, parameters: [:]) { (response, isSuccess) in
            guard isSuccess, let response = response?.responseObject else { return }
            let grades = response as! [YXGradeModel]
            
            self.grades = grades
            self.createGradeSelectView()
        }
    }
    
    private func createGradeSelectView() {
        selectGradeView = YXSelectGradeView(frame: CGRect(x: 0, y: 44, width: screenWidth, height: screenHeight), grades: grades, selectClosure: { (grade) in
            self.selectGradeView.isHidden = true
            self.seleteGradeViewStateImageView.image = #imageLiteral(resourceName: "showSelectGrade")
        })
        selectGradeView.isHidden = true
        self.view.addSubview(selectGradeView)
    }
    
    
    
    // MARK: - UITableView
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return grades.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "YXGroupWordBookCell", for: indexPath) as! YXGroupWordBookCell
        let grade = grades[indexPath.row]
        
        cell.gradeTitleLabel.text = grade.gradeName
        
        cell.bookCollectionView.tag = indexPath.row
        cell.bookCollectionView.delegate = self
        cell.bookCollectionView.dataSource = self
        cell.bookCollectionView.register(UINib(nibName: "YXSingleGroupWordBookCell", bundle: nil), forCellWithReuseIdentifier: "YXSingleGroupWordBookCell")

        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if let count = grades[indexPath.row].wordBooks?.count {
            let countOfRow = Int(count / 3) + ((count % 3 != 0) ? 1 : 0)
            return CGFloat(countOfRow * 162 + (countOfRow - 1) * 10)
            
        } else {
            return 0
        }
    }
    
    
    
    // MARK: - UICollectionView
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return grades[collectionView.tag].wordBooks?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "YXSingleGroupWordBookCell", for: indexPath) as! YXSingleGroupWordBookCell
        let wordBookModel = grades[collectionView.tag].wordBooks?[indexPath.row]
        
        cell.coverImageView.sd_setImage(with: URL(string: wordBookModel?.coverImagePath ?? ""), completed: nil)
        cell.nameLabel.text = wordBookModel?.bookName
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let wordBook = grades[collectionView.tag].wordBooks?[indexPath.row], let bookID = wordBook.bookID, let units = wordBook.unitList else { return }
        
        let seleceUnitView = YXSeleceUnitView(frame: self.view.bounds, units: units) { (unit) in
            YXDataProcessCenter.post("\(YXEvnOC.baseUrl())/v2/book/setlearning", parameters: ["bookId": "\(bookID)", "unit": unit]) { (response, isSuccess) in
                guard isSuccess else { return }
                
                if let finishClosure = self.finishClosure {
                    finishClosure()
                    
                } else {
                    self.navigationController?.popToRootViewController(animated: true)
                }
            }
        }
        
        self.view.addSubview(seleceUnitView)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: (screenWidth - 80) / 3, height: 162)
    }
}
