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
    @IBOutlet weak var exampleImageView: UIImageView!
    @IBOutlet weak var playAuoidButtonDistance: NSLayoutConstraint!
    @IBOutlet weak var labelDistance: NSLayoutConstraint!
    
    var clickPlayBlock: (()->Void)?

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    @IBAction func playAudio(_ sender: UIButton) {
        self.clickPlayBlock?()
        self.playExample()
    }
    
    /// 播放例句
    func playExample() {
        if YXAVPlayerManager.share.isPlaying {
            YXAVPlayerManager.share.pauseAudio()
            playAuoidButton.layer.removeFlickerAnimation()
        } else {
            guard let _pronunciation = pronunciation, let pronunciationUrl = URL(string: _pronunciation) else {
                YXLog("无效的音频地址: \(String(describing: pronunciation))")
                YXUtils.showHUD(kWindow, title: "无效音频")
                return
            }
            playAuoidButton.layer.addFlickerAnimation()
            YXAVPlayerManager.share.playAudio(pronunciationUrl) { [weak self] in
                guard let self = self else { return }
                self.playAuoidButton.layer.removeFlickerAnimation()
            }
        }
    }
}
