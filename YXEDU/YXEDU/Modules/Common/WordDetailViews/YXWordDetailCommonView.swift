//
//  YXAlertView.swift
//  YXEDU
//
//  Created by Jake To on 11/6/19.
//  Copyright © 2019 shiji. All rights reserved.
//

import UIKit

class YXWordDetailCommonView: UIView, UITableViewDelegate, UITableViewDataSource {
    private var word: YXWordModel!

    @IBOutlet var contentView: UIView!
    @IBOutlet weak var wordLabel: UILabel!
    @IBOutlet weak var phoneticSymbolLabel: UILabel!
    @IBOutlet weak var partOfSpeechAndSenseLabel: UILabel!
    @IBOutlet weak var playAuoidButton: UIButton!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var tableView: UITableView!
    
    @IBAction func playAudio(_ sender: UIButton) {
        if YXAVPlayerManager.share.isPlaying {
            YXAVPlayerManager.share.pauseAudio()
            playAuoidButton.layer.removeFlickerAnimation()
            
        } else {
            guard let americanPronunciationUrl = word.voiceUS, let englishPronunciationUrl = word.voiceUK else { return }
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
    
    init(frame: CGRect, word: YXWordModel) {
        super.init(frame: frame)
        self.word = word
        
        initializationFromNib()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        initializationFromNib()
    }
    
    deinit {
        YXAVPlayerManager.share.pauseAudio()
        playAuoidButton.layer.removeFlickerAnimation()
    }
    
    private func initializationFromNib() {
        Bundle.main.loadNibNamed("YXWordDetailCommonView", owner: self, options: nil)
        addSubview(contentView)
        contentView.frame = self.frame
        
        wordLabel.text = word.word
        
        if YXUserModel.default.didUseAmericanPronunciation {
            phoneticSymbolLabel.text = "美" + (word.soundmarkUS ?? "")
            
        } else {
            phoneticSymbolLabel.text = "英" + (word.soundmarkUK ?? "")
        }
        
        if let propertys = word.property {
            var propertyString = ""
            for index in 0..<propertys.count {
                let property = propertys[index]
                guard let partOfSpeech = property.name, let sense = property.paraphrase else { continue }
                propertyString = propertyString + partOfSpeech + sense
            }
            
            partOfSpeechAndSenseLabel.text = propertyString
        }
        
        if let imageUrl = word.imageUrl {
            imageView.sd_setImage(with: URL(string: imageUrl), completed: nil)
        }
        
        tableView.register(UINib(nibName: "YXWordDetialCell", bundle: nil), forCellReuseIdentifier: "YXWordDetialCell")
    }
    
    
    
    // MARK: -
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let boundsOfTableHeaderView = tableView.headerView(forSection: section)!.bounds
        
        switch section {
        case 0:
            return YXWordDetailHeaderView(frame: boundsOfTableHeaderView, headerTitle: "例句")
            
        case 1:
            return YXWordDetailHeaderView(frame: boundsOfTableHeaderView, headerTitle: "常用用法")

        default:
            return nil
        }
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 54
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return word.examples?.count ?? 0
            
        case 1:
            return word.usage?.count ?? 0

        default:
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "YXWordDetialCell", for: indexPath) as! YXWordDetialCell
        
        switch indexPath.section {
        case 0:
            if let example = word.examples?[indexPath.row] {
                cell.label.text = "\(example.en ?? "")/n\(example.cn ?? "")"
            }
            
            cell.playAuoidButton.isHidden = false
            if let americanPronunciationUrl = word.voiceUS, let englishPronunciationUrl = word.voiceUK {
                if YXUserModel.default.didUseAmericanPronunciation {
                    cell.pronunciationUrl = URL(string: americanPronunciationUrl)
                    
                } else {
                    cell.pronunciationUrl = URL(string: englishPronunciationUrl)
                }
            }
            break
            
        case 1:
            if let usage = word.usage?[indexPath.row] {
                cell.label.text = usage
            }
            
            cell.playAuoidButton.isHidden = true
            break

        default:
            break
        }
    
        return cell
    }
}
