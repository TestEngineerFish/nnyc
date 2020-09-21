//
//  YXWordListCell.swift
//  YXEDU
//
//  Created by Jake To on 12/9/19.
//  Copyright © 2019 shiji. All rights reserved.
//

import UIKit

protocol YXWordListEditCellProtocol: NSObjectProtocol {
    func selectCell(indexPath: IndexPath)
    func removeMask(indexPath: IndexPath)
}

class YXWordListEditCell: UITableViewCell {
    var americanPronunciation: String?
    var englishPronunciation: String?
    
    weak var delegate: YXWordListEditCellProtocol?
    var indexPath: IndexPath?
    
    @IBOutlet weak var selectButton: UIButton!
    @IBOutlet weak var playAuoidButton: UIButton!
    @IBOutlet weak var wordLabel: UILabel!
    @IBOutlet weak var meaningLabel: UILabel!
    @IBOutlet weak var meaningLabelMask: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        meaningLabelMask.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(removeMask)))
    }

    deinit {
        YXLog("释放啊啊啊！！！")
        self.selectButton = nil
        self.playAuoidButton = nil
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
            
            var pronunciationUrl: URL?
            if YXUserModel.default.didUseAmericanPronunciation {
                pronunciationUrl = URL(string: americanPronunciationUrl)
                
            } else {
                pronunciationUrl = URL(string: englishPronunciationUrl)
            }
            guard let _pronunciationUrl = pronunciationUrl else {
                return
            }
            YXAVPlayerManager.share.playAudio(_pronunciationUrl) { [weak self] in
                guard let self = self else { return }
                self.playAuoidButton.layer.removeFlickerAnimation()
            }
        }
    }

    func setData(word model: YXWordModel, indexPath: IndexPath) {
        self.indexPath      = indexPath
        self.wordLabel.text = model.word

        if let partOfSpeechAndMeanings = model.partOfSpeechAndMeanings, partOfSpeechAndMeanings.count > 0 {
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

        self.americanPronunciation = model.americanPronunciation
        self.englishPronunciation  = model.englishPronunciation

        if model.hidePartOfSpeechAndMeanings {
            self.meaningLabelMask.image = #imageLiteral(resourceName: "wordListMask")
        } else {
            self.meaningLabelMask.image = nil
        }

        if model.isSelected {
            self.selectButton.setImage(#imageLiteral(resourceName: "word_selected"), for: .normal)

        } else {
            self.selectButton.setImage(#imageLiteral(resourceName: "word_unselected"), for: .normal)
        }
    }

    @IBAction func selectWord(_ sender: Any) {
        guard let _indexPath = self.indexPath else {
            return
        }
        self.delegate?.selectCell(indexPath: _indexPath)
    }

    @objc
    private func removeMask() {
//        self.removeMaskClosure?()
        guard let _indexPath = self.indexPath else {
            return
        }
        self.delegate?.removeMask(indexPath: _indexPath)
    }
}

class BigButton: UIButton {
    override func point(inside point: CGPoint, with event: UIEvent?) -> Bool {
        let margin: CGFloat = 20
        let area = self.bounds.insetBy(dx: -margin, dy: -margin)
        return area.contains(point)
    }
}
