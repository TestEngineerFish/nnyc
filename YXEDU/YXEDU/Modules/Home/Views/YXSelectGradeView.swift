//
//  YXSelectGradeView.swift
//  YXEDU
//
//  Created by Jake To on 10/24/19.
//  Copyright © 2019 shiji. All rights reserved.
//

import UIKit

class YXSelectGradeView: UIView, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    var grades: [YXGradeModel] = [] {
        didSet {
            var allGrade = YXGradeModel()
            allGrade.gradeName = "全部"
            allGrade.isSelect = true
            grades.insert(allGrade, at: 0)
            
            var countOfRow = Int(grades.count / 3) + ((grades.count % 3) != 0 ? 1 : 0)
            countOfRow = countOfRow == 0 ? 1 : countOfRow
            let baseHeight = 48 + ((countOfRow - 1) * 14)
            let allRowHeight = 28 * countOfRow
            collectionViewHeight.constant = CGFloat(baseHeight + allRowHeight)
            
            collectionView.reloadData()
        }
    }
    
    private var selectClosure: ((_ grade: String) -> Void)!

    @IBOutlet var contentView: UIView!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var collectionViewHeight: NSLayoutConstraint!
    
    init(frame: CGRect, selectClosure: @escaping (_ grade: String) -> Void) {
        super.init(frame: frame)
        initializationFromNib()
        
        self.selectClosure = selectClosure
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        initializationFromNib()
    }
    
    func initializationFromNib() {
        Bundle.main.loadNibNamed("YXSelectGradeView", owner: self, options: nil)
        addSubview(contentView)
        contentView.frame = CGRect(x: 0, y: 0, width: self.frame.width, height: self.frame.height)
        
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(UINib(nibName: "YXSelectGradeCell", bundle: nil), forCellWithReuseIdentifier: "YXSelectGradeCell")
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return grades.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "YXSelectGradeCell", for: indexPath) as! YXSelectGradeCell
        let grade = grades[indexPath.row]
        
        cell.gradeLabel.text = grade.gradeName
        
        if grade.isSelect {
            cell.gradeLabel.textColor = .white
            cell.colorView.backgroundColor = UIColor(red: 251/255, green: 162/255, blue: 23/255, alpha: 1)
            
        } else {
            cell.gradeLabel.textColor = .black
            cell.colorView.backgroundColor = UIColor(red: 244/255, green: 244/255, blue: 244/255, alpha: 1)
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        for var grade in grades {
            grade.isSelect = false
        }
        grades[indexPath.row].isSelect = true
        
        guard let gradeName = grades[indexPath.row].gradeName else { return }
        selectClosure(gradeName)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: (screenWidth - 60) / 3 , height: 28)
    }

}
