//
//  YXWordListCell.swift
//  YXEDU
//
//  Created by Jake To on 12/9/19.
//  Copyright © 2019 shiji. All rights reserved.
//

import UIKit

class YXWordListEditCell: UITableViewCell {
    var selectClosure: (() -> Void)?
    var playAudioClosure: (() -> Void)?
    var removeMaskClosure: (() -> Void)?

    @IBOutlet weak var wordLabel: UILabel!
    @IBOutlet weak var meaningLabel: UILabel!
    @IBOutlet weak var meaningLabelMask: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        meaningLabelMask.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(removeMask)))
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @IBAction func playAudio(_ sender: Any) {
        playAudioClosure?()
    }
    
    @IBAction func selectWord(_ sender: Any) {
        selectClosure?()
    }
    
    @objc
    private func removeMask() {
        removeMaskClosure?()
    }
}
