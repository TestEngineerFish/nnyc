//
//  YXWordDetailFeaturedClassicCell.swift
//  YXEDU
//
//  Created by Jake To on 12/5/19.
//  Copyright © 2019 shiji. All rights reserved.
//

import UIKit

class YXWordDetailFeaturedClassicCell: UITableViewCell {
    var expandClosure: (() -> Void)?
    
    var isExpand = false {
        didSet {
            if isExpand {
                contentLabel.numberOfLines = 0
                distanceOfContentLabel.constant = 72
                distanceOfStateIcon.constant = 6
                
            } else {
                contentLabel.numberOfLines = 1
                distanceOfContentLabel.constant = 20
                distanceOfStateIcon.constant = -16
            }
        }
    }

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var contentLabel: UILabel!
    @IBOutlet weak var expandStateIcon: UIImageView!
    @IBOutlet weak var expandButton: UIButton!
    @IBOutlet weak var distanceOfContentLabel: NSLayoutConstraint!
    @IBOutlet weak var distanceOfStateIcon: NSLayoutConstraint!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
    
    @IBAction func expand(_ sender: Any) {
        expandClosure?()
    }
}
