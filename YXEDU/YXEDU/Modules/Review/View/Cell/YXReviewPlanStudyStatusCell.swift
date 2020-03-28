//
//  YXReviewPlanStudyStatusCell.swift
//  YXEDU
//
//  Created by Jake To on 3/27/20.
//  Copyright © 2020 shiji. All rights reserved.
//

import UIKit

class YXReviewPlanStudyStatusCell: UICollectionViewCell {

    @IBOutlet weak var avatarImageView: YXDesignableImageView!
    @IBOutlet weak var nameLabel: UILabel!
    
    @IBOutlet weak var noListenLabel: UILabel!
    @IBOutlet weak var listenStarsView: UIStackView!
    @IBOutlet weak var listenStart1: UIImageView!
    @IBOutlet weak var listenStart2: UIImageView!
    @IBOutlet weak var listenStart3: UIImageView!
    @IBOutlet weak var listenProgressView: UIProgressView!
    @IBOutlet weak var listenProgressLabel: UILabel!
    
    @IBOutlet weak var noReviewLabel: UILabel!
    @IBOutlet weak var reviewStarsView: UIStackView!
    @IBOutlet weak var reviewStart1: UIImageView!
    @IBOutlet weak var reviewStart2: UIImageView!
    @IBOutlet weak var reviewStart3: UIImageView!
    @IBOutlet weak var reviewProgressView: UIProgressView!
    @IBOutlet weak var reviewProgressLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
}
