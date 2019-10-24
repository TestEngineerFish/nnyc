//
//  YXHomeViewController.swift
//  YXEDU
//
//  Created by Jake To on 10/24/19.
//  Copyright © 2019 shiji. All rights reserved.
//

import UIKit

public var screenWidth = UIScreen.main.bounds.size.width
public var screenHeight = UIScreen.main.bounds.size.height

class YXHomeViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    @IBOutlet weak var countOfWaitForStudyWords: YXDesignableLabel!
    @IBOutlet weak var progressBar: UIProgressView!
    @IBOutlet weak var studyDataCollectionView: UICollectionView!
    @IBOutlet weak var subItemCollectionView: UICollectionView!

    override func viewDidLoad() {
        super.viewDidLoad()

        studyDataCollectionView.register(UINib(nibName: "YXHomeStudyDataCell", bundle: nil), forCellWithReuseIdentifier: "YXHomeStudyDataCell")
        subItemCollectionView.register(UINib(nibName: "YXHomeSubItemCell", bundle: nil), forCellWithReuseIdentifier: "YXHomeSubItemCell")
    }
    

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
                cell.dataLabel.text = "20"
                break
                
            case 1:
                cell.titleLabel.text = "收藏夹"
                cell.dataLabel.text = "20"
                break
                
            case 2:
                cell.titleLabel.text = "错词本"
                cell.dataLabel.text = "20"
                break
                
            default:
                break
            }
            
            return cell
            
        } else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "YXHomeSubItemCell", for: indexPath) as! YXHomeSubItemCell
            
            switch indexPath.row {
            case 0:
                cell.colorView.backgroundColor = UIColor(red: 255, green: 239, blue: 240, alpha: 1)
                cell.iconView.image = #imageLiteral(resourceName: "homeTask")
                cell.titleLabel.text = "任务中心"
                break
                
            case 1:
                cell.colorView.backgroundColor = UIColor(red: 240, green: 246, blue: 255, alpha: 1)
                cell.iconView.image = #imageLiteral(resourceName: "homeReport")
                cell.titleLabel.text = "学习报告"
                break
                
            case 2:
                cell.colorView.backgroundColor = UIColor(red: 232, green: 246, blue: 234, alpha: 1)
                cell.iconView.image = #imageLiteral(resourceName: "homeCalendar")
                cell.titleLabel.text = "打卡日历"
                break
                
            case 3:
                cell.colorView.backgroundColor = UIColor(red: 255, green: 244, blue: 225, alpha: 1)
                cell.iconView.image = #imageLiteral(resourceName: "homeSelectWords")
                cell.titleLabel.text = "自选单词"
                break
                
            default:
                break
            }
            
            return cell
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
