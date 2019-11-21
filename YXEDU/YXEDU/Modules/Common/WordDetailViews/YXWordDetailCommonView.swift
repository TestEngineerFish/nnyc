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

        phoneticSymbolLabel.text = word.soundmark

        if let partOfSpeech = word.partOfSpeech, let meaning = word.meaning {
            partOfSpeechAndSenseLabel.text = partOfSpeech + meaning
        }
        
        if let imageUrl = word.imageUrl {
            imageView.sd_setImage(with: URL(string: imageUrl), completed: nil)
        }
                
        if let usage = word.usages, usage.count > 0 {
            partsOfWord.append(["常用用法": usage])
        }
        
        if let synonym = word.synonym, synonym.isEmpty == false  {
            partsOfWord.append(["同义词": synonym])
        }
        
        if let antonym = word.antonym, antonym.isEmpty == false  {
            partsOfWord.append(["反义词": antonym])
        }
        
        if let testCenter = word.testCenter, testCenter.isEmpty == false {
            partsOfWord.append(["考点": testCenter])
        }
        
        if let deformation = word.deformation, deformation.isEmpty == false {
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
            if let englishExample = word.englishExample, let chineseExample = word.chineseExample, let wordContent = word.word {
                let example = englishExample + "\n" + chineseExample
                
                if let range = example.range(of: wordContent) {
                    let location = example.distance(from: example.startIndex, to: range.lowerBound)
                    
                    let attrString = NSMutableAttributedString(string: example)
                    
                    let attr: [NSAttributedString.Key : Any] = [.font: UIFont.pfSCRegularFont(withSize: 16),.foregroundColor: UIColor.black2]
                    attrString.addAttributes(attr, range: NSRange(location: 0, length: attrString.length))
                    let attr2: [NSAttributedString.Key : Any] = [.font: UIFont.pfSCRegularFont(withSize: 16),.foregroundColor: UIColor.orange1]
                    attrString.addAttributes(attr2, range: NSRange(location: location, length: wordContent.count))
                    
                    cell.label.attributedText = attrString
                }
                
                
                
            }
            
            cell.playAuoidButton.isHidden = false
            if let pronunciationUrl = word.examplePronunciation {
                cell.pronunciationUrl = URL(string: pronunciationUrl)
            }
            
        } else {
            if let strings = partsOfWord[indexPath.section].values.first as? [String], strings.count > 0 {
                cell.label.text = strings[indexPath.row]
                
            } else if let string = partsOfWord[indexPath.section].values.first as? String {
                cell.label.text = string
            }

            cell.playAuoidButton.isHidden = true
        }
        
        return cell
    }
}
