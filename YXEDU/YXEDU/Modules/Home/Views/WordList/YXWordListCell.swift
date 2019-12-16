//
//  YXWordListCell.swift
//  YXEDU
//
//  Created by Jake To on 12/9/19.
//  Copyright © 2019 shiji. All rights reserved.
//

import UIKit

class YXWordListCell: UITableViewCell {
    var americanPronunciation: String?
    var englishPronunciation: String?

    var showWordDetailClosure: (() -> Void)?
    var removeMaskClosure: (() -> Void)?

    @IBOutlet weak var playAuoidButton: UIButton!
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
        if YXAVPlayerManager.share.isPlaying {
            YXAVPlayerManager.share.pauseAudio()
            playAuoidButton.layer.removeFlickerAnimation()
            
        } else {
            guard let americanPronunciationUrl = americanPronunciation, let englishPronunciationUrl = englishPronunciation else { return }
            playAuoidButton.layer.addFlickerAnimation()
            
            var pronunciationUrl: URL!
            if YXUserModel.default.didUseAmericanPronunciation {
                pronunciationUrl = URL(string: americanPronunciationUrl)
                
            } else {
                pronunciationUrl = URL(string: englishPronunciationUrl)
            }
            
            YXAVPlayerManager.share.playerAudio(pronunciationUrl) {
                self.playAuoidButton.layer.removeFlickerAnimation()
            }
        }
    }
    
    @IBAction func showWordDetail(_ sender: Any) {
        showWordDetailClosure?()
     }
    
    @objc
    private func removeMask() {
        removeMaskClosure?()
    }
}