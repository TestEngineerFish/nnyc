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
    private var partsOfWord: [[String: Any]] = [["例句": ""]]
    
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
            guard let americanPronunciationUrl = word.americanPronunciation, let englishPronunciationUrl = word.englishPronunciation else { return }
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
            phoneticSymbolLabel.text = word.americanPhoneticSymbol
            
        } else {
            phoneticSymbolLabel.text = word.englishPhoneticSymbol
        }
        
        if let partOfSpeech = word.partOfSpeech, let meaning = word.meaning {
            partOfSpeechAndSenseLabel.text = partOfSpeech + meaning
        }
        
        if let imageUrl = word.imageUrl {
            imageView.sd_setImage(with: URL(string: imageUrl), completed: nil)
        }
                
        if let usage = word.usage {
            partsOfWord.append(["常用用法": usage])
        }
        
        if let synonym = word.synonym {
            partsOfWord.append(["同义词": synonym])
        }
        
        if let antonym = word.antonym {
            partsOfWord.append(["反义词": antonym])
        }
        
        if let testCenter = word.testCenter {
            partsOfWord.append(["考点": testCenter])
        }
        
        if let deformation = word.deformation {
            partsOfWord.append(["联想": deformation])
        }
        
        tableView.register(UINib(nibName: "YXWordDetialCell", bundle: nil), forCellReuseIdentifier: "YXWordDetialCell")
    }
    
    
    
    // MARK: -
    func numberOfSections(in tableView: UITableView) -> Int {
        return partsOfWord.count
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let boundsOfTableHeaderView = CGRect(x: 0, y: 0, width: screenWidth, height: 54)
        return YXWordDetailHeaderView(frame: boundsOfTableHeaderView, headerTitle: partsOfWord[section].keys.first!)
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 54
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let strings = partsOfWord[section].values.first as? [String], strings.count > 1 {
            return strings.count
            
        } else {
            return 1
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "YXWordDetialCell", for: indexPath) as! YXWordDetialCell
      
        if indexPath.section == 0 {
            if let englishExample = word.englishExample, let chineseExample = word.chineseExample {
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
            if let americanPronunciationUrl = word.americanPronunciation, let englishPronunciationUrl = word.englishPronunciation {
                if YXUserModel.default.didUseAmericanPronunciation {
                    cell.pronunciationUrl = URL(string: americanPronunciationUrl)
                    
                } else {
                    cell.pronunciationUrl = URL(string: englishPronunciationUrl)
                }
            }
            
        } else {
            if let strings = partsOfWord[indexPath.section].values.first as? [String] {
                cell.label.text = strings[indexPath.row]
                
            } else if let string = partsOfWord[indexPath.section].values.first as? String {
                cell.label.text = string
            }

            cell.playAuoidButton.isHidden = true
        }
        
        return cell
    }
}
