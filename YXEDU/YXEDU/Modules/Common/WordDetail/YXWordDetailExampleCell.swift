//
//  YXWordDetailExampleCell.swift
//  YXEDU
//
//  Created by Jake To on 11/11/19.
//  Copyright © 2019 shiji. All rights reserved.
//

import UIKit

class YXWordDetailExampleCell: UITableViewCell {
    var pronunciation: String?
    
    @IBOutlet weak var label: UILabel!
    @IBOutlet weak var playAuoidButton: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    @IBAction func playAudio(_ sender: UIButton) {
        if YXAVPlayerManager.share.isPlaying {
            YXAVPlayerManager.share.pauseAudio()
            playAuoidButton.layer.removeFlickerAnimation()
            
        } else {
            guard let pronunciation = pronunciation, let pronunciationUrl = URL(string: pronunciation) else { return }
            playAuoidButton.layer.addFlickerAnimation()
            
            YXAVPlayerManager.share.playAudio(pronunciationUrl) {
                self.playAuoidButton.layer.removeFlickerAnimation()
            }
        }
    }
}
