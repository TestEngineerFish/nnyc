//
//  YXWordDetailFeaturedClassicCell.swift
//  YXEDU
//
//  Created by Jake To on 12/5/19.
//  Copyright © 2019 shiji. All rights reserved.
//

import UIKit

class YXWordDetailFeaturedClassicCell: UITableViewCell {
    var totalCount = 0

    var expandClosure: (() -> Void)?
    
    var isExpand = false {
        didSet {
            if isExpand {
                contentLabel.numberOfLines = 0
                expandButton.setTitle("收起", for: .normal)
                expandStateIcon.image = #imageLiteral(resourceName: "collapsed")
                
            } else {
                contentLabel.numberOfLines = 1
                expandButton.setTitle("展开剩余\(totalCount - 1)条", for: .normal)
                expandStateIcon.image = #imageLiteral(resourceName: "expand")
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
