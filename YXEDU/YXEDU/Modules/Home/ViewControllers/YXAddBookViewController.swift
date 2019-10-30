//
//  YXAddBookViewController.swift
//  YXEDU
//
//  Created by Jake To on 10/24/19.
//  Copyright © 2019 shiji. All rights reserved.
//

import UIKit

class YXAddBookViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    private var groupWordBookModels: [YXGroupWordBookModel] = []
    private var selectGradeView: YXSelectGradeView!
    
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
        
        selectGradeView = YXSelectGradeView(frame: CGRect(x: 0, y: 44, width: screenWidth, height: screenHeight), grades: [], selectClosure: { (grade) in
            self.selectGradeView.isHidden = true
            self.seleteGradeViewStateImageView.image = #imageLiteral(resourceName: "showSelectGrade")
        })
        selectGradeView.isHidden = true
        self.view.addSubview(selectGradeView)
    }
    
    
    
    // MARK: - UITableView
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return groupWordBookModels.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "YXGroupWordBookCell", for: indexPath) as! YXGroupWordBookCell
        let groupWordBookModel = groupWordBookModels[indexPath.row]
        
        cell.gradeTitleLabel.text = groupWordBookModel.grade
        
        cell.bookCollectionView.tag = indexPath.row
        cell.bookCollectionView.delegate = self
        cell.bookCollectionView.dataSource = self
        cell.bookCollectionView.register(UINib(nibName: "YXSingleGroupWordBookCell", bundle: nil), forCellWithReuseIdentifier: "YXSingleGroupWordBookCell")

        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if let count = groupWordBookModels[indexPath.row].wordBookModels?.count {
            let countOfRow = Int(count / 3) + ((count % 3 != 0) ? 1 : 0)
            return CGFloat(countOfRow * 162 + (countOfRow - 1) * 10)
            
        } else {
            return 0
        }
    }
    
    
    
    // MARK: - UICollectionView
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return groupWordBookModels[collectionView.tag].wordBookModels?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "YXSingleGroupWordBookCell", for: indexPath) as! YXSingleGroupWordBookCell
        let wordBookModel = groupWordBookModels[collectionView.tag].wordBookModels?[indexPath.row]
        
        cell.coverImageView.image = wordBookModel?.coverImage
        cell.nameLabel.text = wordBookModel?.bookName
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let wordBookModel = groupWordBookModels[collectionView.tag].wordBookModels?[indexPath.row]
        
        YXDataProcessCenter.post("\(YXEvnOC.baseUrl())/v2/book/setlearning", parameters: ["bookId": ""]) { (response, isSuccess) in
            if isSuccess {
                
            }
        }
        
        navigationController?.popToRootViewController(animated: true)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: (screenWidth - 80) / 3, height: 162)
    }
}
