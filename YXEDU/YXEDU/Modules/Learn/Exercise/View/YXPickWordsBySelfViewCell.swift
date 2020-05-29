//
//  YXPickWordsBySelfViewCell.swift
//  YXEDU
//
//  Created by Jake To on 2020/5/29.
//  Copyright © 2020 shiji. All rights reserved.
//

import UIKit

class YXPickWordsBySelfViewCell: UITableViewCell {
    var isPicked = false {
        didSet {
            if isPicked {
                controlLabel.isHidden = false
                controlImageView.image = #imageLiteral(resourceName: "pickedWord")
                
            } else {
                controlLabel.isHidden = true
                controlImageView.image = #imageLiteral(resourceName: "pickNoWord")
            }
        }
    }
    
    @IBOutlet weak var wordLabel: UILabel!
    @IBOutlet weak var controlLabel: UILabel!
    @IBOutlet weak var controlImageView: UIImageView!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
    }
    
}
