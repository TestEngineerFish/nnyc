//
//  YXWordDetailExampleCell.swift
//  YXEDU
//
//  Created by Jake To on 11/11/19.
//  Copyright © 2019 shiji. All rights reserved.
//

import UIKit

class YXWordDeformationsCell: UITableViewCell {
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var contentLabel: UILabel!
    @IBOutlet weak var contentDistance: NSLayoutConstraint!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
}
