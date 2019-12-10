//
//  YXWordDetailFixedMatchCell.swift
//  YXEDU
//
//  Created by Jake To on 12/5/19.
//  Copyright © 2019 shiji. All rights reserved.
//

import UIKit

class YXWordDetailFixedMatchCell: UITableViewCell {

    @IBOutlet weak var englishLabel: UILabel!
    @IBOutlet weak var chineseLabel: UILabel!
    @IBOutlet weak var exampleLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
