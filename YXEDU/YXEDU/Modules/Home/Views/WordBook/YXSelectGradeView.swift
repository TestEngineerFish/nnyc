//
//  YXSelectGradeView.swift
//  YXEDU
//
//  Created by Jake To on 10/24/19.
//  Copyright © 2019 shiji. All rights reserved.
//

import UIKit

class YXSelectGradeView: UIView, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    private var grades: [YXGradeWordBookListModel] = []
    private var selectedGrade: YXGradeWordBookListModel!
    private var selectClosure: ((_ grade: String, _ version: String?) -> Void)!

    @IBOutlet var contentView: UIView!
    @IBOutlet weak var backgroundView: UIView!
    @IBOutlet weak var gradeCollectionView: UICollectionView!
    @IBOutlet weak var versionCollectionView: UICollectionView!
    @IBOutlet weak var collectionViewHeight: NSLayoutConstraint!

    init(frame: CGRect, grades: [YXGradeWordBookListModel], selectClosure: @escaping (_ grade: String, _ version: String?) -> Void) {
        super.init(frame: frame)
        self.grades = grades
        self.selectClosure = selectClosure
        
        initializationFromNib()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        initializationFromNib()
    }
    
    func initializationFromNib() {
        Bundle.main.loadNibNamed("YXSelectGradeView", owner: self, options: nil)
        addSubview(contentView)
        contentView.frame = CGRect(x: 0, y: 0, width: self.frame.width, height: self.frame.height)
        
        selectedGrade = YXGradeWordBookListModel()
        selectedGrade.wordBooks = []
        selectedGrade.gradeName = "所有年级"
        selectedGrade.isSelect = true
        for grade in grades {
            guard let wordBooks = grade.wordBooks, wordBooks.count > 0 else { continue }
            
            for wordBook in wordBooks {
                if selectedGrade.wordBooks!.count == 0 {
                    selectedGrade.wordBooks!.append(wordBook)
                    
                } else {
                    guard selectedGrade.wordBooks!.contains(where: { $0.bookName != wordBook.bookName}) else { continue }
                    selectedGrade.wordBooks!.append(wordBook)
                }
            }
        }
        grades.insert(selectedGrade, at: 0)
        collectionViewHeight.constant = CGFloat(38 * grades.count)
        
        gradeCollectionView.delegate = self
        gradeCollectionView.dataSource = self
        versionCollectionView.delegate = self
        versionCollectionView.dataSource = self
        gradeCollectionView.register(UINib(nibName: "YXSelectGradeCell", bundle: nil), forCellWithReuseIdentifier: "YXSelectGradeCell")
        versionCollectionView.register(UINib(nibName: "YXSelectGradeCell", bundle: nil), forCellWithReuseIdentifier: "YXSelectGradeCell")
        gradeCollectionView.reloadData()
        versionCollectionView.reloadData()
        
        backgroundView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(dismiss)))
    }
    
    @objc private func dismiss() {
        self.isHidden = true
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView.tag == 1 {
            return grades.count
            
        } else {
            return selectedGrade.versions.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "YXSelectGradeCell", for: indexPath) as! YXSelectGradeCell
        
        if collectionView.tag == 1 {
            let grade = grades[indexPath.row]
            cell.gradeLabel.text = grade.gradeName
            
            if grade.isSelect {
                cell.gradeLabel.textColor = .orange1
                cell.backgroundColor = UIColor(red: 0.96, green: 0.96, blue: 0.96, alpha: 1)
                
            } else {
                cell.gradeLabel.textColor = .black
                cell.backgroundColor = .white
            }
            
        } else {
            let version = selectedGrade.versions[indexPath.row]
            cell.gradeLabel.text = version.bookVersion
            
            if version.isSelect {
                cell.gradeLabel.textColor = .orange1
                cell.backgroundColor = UIColor(red: 0.96, green: 0.96, blue: 0.96, alpha: 1)
                
            } else {
                cell.gradeLabel.textColor = .black
                cell.backgroundColor = UIColor(red: 0.96, green: 0.96, blue: 0.96, alpha: 1)
            }
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView.tag == 1 {
            for index in 0..<grades.count {
                grades[index].isSelect = false
                
                for index2 in 0..<grades[index].versions.count {
                    grades[index].versions[index2].isSelect = false
                }
            }
            grades[indexPath.row].isSelect = true
            
            selectedGrade = grades[indexPath.row]
            selectedGrade.versions[0].isSelect = true
            
            gradeCollectionView.reloadData()
            versionCollectionView.reloadData()
            
            guard let gradeName = selectedGrade.gradeName else { return }
            selectClosure(gradeName, nil)

        } else {
            for index in 0..<selectedGrade.versions.count {
                selectedGrade.versions[index].isSelect = false
            }
            
            selectedGrade.versions[indexPath.row].isSelect = true
            versionCollectionView.reloadData()
            
            guard let gradeName = selectedGrade.gradeName, let versionName = selectedGrade.versions[indexPath.row].bookVersion else { return }
            selectClosure(gradeName, versionName)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.bounds.width , height: 38)
    }

}
