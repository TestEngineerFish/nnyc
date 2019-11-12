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
        contentView.frame = self.bounds
        
        wordLabel.text = word.word
        
        if YXUserModel.default.didUseAmericanPronunciation {
            phoneticSymbolLabel.text = word.soundmarkUS
            
        } else {
            phoneticSymbolLabel.text = word.soundmarkUK
        }
        
        if let propertys = word.property {
            var propertyString = ""
            for index in 0..<propertys.count {
                let property = propertys[index]
                guard let partOfSpeech = property.name, let sense = property.paraphrase else { continue }
                propertyString = propertyString + "\(index == 0 ? "" : "\n")" + partOfSpeech + sense
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
        let boundsOfTableHeaderView = CGRect(x: 0, y: 0, width: screenWidth, height: 54)
        
        switch section {
        case 0:
            return YXWordDetailHeaderView(frame: boundsOfTableHeaderView, headerTitle: "例句")
            
        case 1:
            return YXWordDetailHeaderView(frame: boundsOfTableHeaderView, headerTitle: "常用用法")
            
        case 2:
            return YXWordDetailHeaderView(frame: boundsOfTableHeaderView, headerTitle: "同义词")
            
        case 3:
            return YXWordDetailHeaderView(frame: boundsOfTableHeaderView, headerTitle: "反义词")
            
        default:
            return nil
        }
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 54
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        var count = 0
        
        if let _ = word.examples {
            count = count + 1
            
        }
        
        if let _ = word.usage {
            count = count + 1

        }
    
        if let _ = word.synonym {
            count = count + 1

        }
        
        if let _ = word.antonym {
            count = count + 1
        }
        
        return count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return word.examples?.count ?? 0
            
        case 1:
            return word.usage?.count ?? 0
            
        case 2:
            return 1
            
        case 3:
            return 1
            
        default:
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "YXWordDetialCell", for: indexPath) as! YXWordDetialCell
        cell.contentView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        switch indexPath.section {
        case 0:
            if let example = word.examples?[indexPath.row], let englishExample = example.en, let chineseExample = example.cn {
//                let hashtagIndex = englishExample.firstIndex(of: "#")!
//                let startColorIndex = englishExample.index(hashtagIndex, offsetBy: 1)
//                let endColorIndex = englishExample.index(startColorIndex, offsetBy: 6)
//                let colorString = String(englishExample[startColorIndex..<endColorIndex])
                
                let firstRightBracket = englishExample.firstIndex(of: ">")!
                let startHighLightIndex = englishExample.index(firstRightBracket, offsetBy: 1)
                let lastLeftBracket = englishExample.lastIndex(of: "<")!
                let highLightString = String(englishExample[startHighLightIndex..<lastLeftBracket])
                
                let firstLeftBracket = englishExample.firstIndex(of: "<")!
                let lastRightBracket = englishExample.lastIndex(of: ">")!
                let endHighLightIndex = englishExample.index(lastRightBracket, offsetBy: 1)
                let string = String(englishExample[englishExample.startIndex..<firstLeftBracket]) + highLightString + String(englishExample[endHighLightIndex..<englishExample.endIndex]) + "\n\(chineseExample)"
                
                let attrString = NSMutableAttributedString(string: string)
                let highLightRange = string.range(of: highLightString)!
                let highLightLocation = string.distance(from: string.startIndex, to: highLightRange.lowerBound)
                attrString.addAttributes([.foregroundColor: UIColor.hex(0xFBA217)], range: NSRange(location: highLightLocation, length: highLightString.count))
                
                cell.label.attributedText = attrString
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
            
        case 2:
            if let synonym = word.synonym {
                cell.label.text = synonym
            }
            
            cell.playAuoidButton.isHidden = true
            break
            
        case 3:
            if let antonym = word.antonym {
                cell.label.text = antonym
            }
            
            cell.playAuoidButton.isHidden = true
            break

        default:
            break
        }
    
        return cell
    }
}
