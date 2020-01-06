//
//  YXWordBookCell.swift
//  YXEDU
//
//  Created by Jake To on 10/24/19.
//  Copyright © 2019 shiji. All rights reserved.
//

import UIKit

class YXWordBookCell: UICollectionViewCell {
    var isCurrentStudy = false
    var didFinished = false
    var isAddBook = false

    @IBOutlet weak var bookCover: UIImageView!
    @IBOutlet weak var currentStudyMark: UIImageView!
    @IBOutlet weak var finishedMark: UIImageView!
    @IBOutlet weak var countOfWordsLabel: UILabel!
    @IBOutlet weak var bookNameLabel: UILabel!
    @IBOutlet weak var indicatorIcon: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func adjustCell() {
        if isAddBook {
            bookCover.image = #imageLiteral(resourceName: "newBook")
            currentStudyMark.isHidden = true
            finishedMark.isHidden = true
            indicatorIcon.isHidden = true
            countOfWordsLabel.isHidden = true

        } else {
            countOfWordsLabel.isHidden = false

            if isSelected {
                bookCover.image = #imageLiteral(resourceName: "selectedBook")
                indicatorIcon.isHidden = false

            } else {
                bookCover.image = #imageLiteral(resourceName: "unselectedBook")
                indicatorIcon.isHidden = true
            }
            
            if isCurrentStudy {
                currentStudyMark.isHidden = false
                
            } else {
                currentStudyMark.isHidden = true
            }
            
            if didFinished {
                finishedMark.isHidden = false

            } else {
                finishedMark.isHidden = true
            }
        }
    }
}
