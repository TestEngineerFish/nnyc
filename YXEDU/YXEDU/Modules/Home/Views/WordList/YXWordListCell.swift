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

    var removeMaskClosure: (() -> Void)?
    var wordModel: YXWordModel?

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
            
            YXAVPlayerManager.share.playAudio(pronunciationUrl) {
                self.playAuoidButton.layer.removeFlickerAnimation()
            }
        }
    }
    
    @IBAction func showWordDetail(_ sender: Any) {
        guard let wordModel = self.wordModel else {
            return
        }
        let home = UIStoryboard(name: "Home", bundle: nil)
        let wordDetialViewController = home.instantiateViewController(withIdentifier: "YXWordDetailViewControllerNew") as! YXWordDetailViewControllerNew
        wordDetialViewController.wordId        = wordModel.wordId ?? 0
        wordDetialViewController.isComplexWord = wordModel.isComplexWord ?? 0
        self.currentViewController?.navigationController?.pushViewController(wordDetialViewController, animated: true)
     }
    
    @objc
    private func removeMask() {
        removeMaskClosure?()
    }

    func setData(_ wordModel: YXWordModel) {
        self.wordModel             = wordModel
        self.wordLabel.text        = wordModel.word
        self.americanPronunciation = wordModel.americanPronunciation
        self.englishPronunciation  = wordModel.englishPronunciation

        if let partOfSpeechAndMeanings = wordModel.partOfSpeechAndMeanings, partOfSpeechAndMeanings.count > 0 {
            var text = ""

            for index in 0..<partOfSpeechAndMeanings.count {
                guard let partOfSpeech = partOfSpeechAndMeanings[index].partOfSpeech, let meaning = partOfSpeechAndMeanings[index].meaning else { continue }

                if index == 0 {
                    text = partOfSpeech + meaning

                } else {
                    text = text + "；" + partOfSpeech + meaning
                }
            }
            self.meaningLabel.text = text
        }

        if wordModel.hidePartOfSpeechAndMeanings {
            self.meaningLabelMask.image = #imageLiteral(resourceName: "wordListMask")

        } else {
            self.meaningLabelMask.image = nil
        }


    }
}
