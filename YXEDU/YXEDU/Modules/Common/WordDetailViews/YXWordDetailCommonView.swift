//
//  YXAlertView.swift
//  YXEDU
//
//  Created by Jake To on 11/6/19.
//  Copyright © 2019 shiji. All rights reserved.
//

import UIKit

class YXWordDetailCommonView: UIView, UITableViewDelegate, UITableViewDataSource {
    private enum SectionType: String {
        case deformation = "单词变形"
        case examples = "例句"
        case featured = "念念精选"
        case synonym = "同义词"
        case antonym = "反义词"
    }
    
    private var word: YXWordModel!
    private var sections: [[String: Any]] = []
    private var sectionExpandStatus: [Bool] = []
    
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
        
        tableView.register(UINib(nibName: "YXWordDetailExampleCell", bundle: nil), forCellReuseIdentifier: "YXWordDetailExampleCell")
        tableView.register(UINib(nibName: "YXWordDetailClassicCell", bundle: nil), forCellReuseIdentifier: "YXWordDetailClassicCell")

        wordLabel.text = word.word

        phoneticSymbolLabel.text = word.soundmark

        if let partOfSpeechAndMeanings = word.partOfSpeechAndMeanings, partOfSpeechAndMeanings.count > 0 {
            var text = ""

            for index in 0..<partOfSpeechAndMeanings.count {
                guard let partOfSpeech = partOfSpeechAndMeanings[index].partOfSpeech, let meaning = partOfSpeechAndMeanings[index].meaning else { continue }
                
                if index == 0 {
                    text = partOfSpeech + meaning
                    
                } else {
                    text = "/n" + partOfSpeech + meaning
                }
            }
            
            partOfSpeechAndSenseLabel.text = text
        }
        
        if let imageUrl = word.imageUrl {
            imageView.sd_setImage(with: URL(string: imageUrl), completed: nil)
        }
                
        if let deformations = word.deformations, deformations.count > 0 {
            sections.append([SectionType.deformation.rawValue: deformations])
            sectionExpandStatus.append(false)
        }
        
        if let examples = word.examples, examples.count > 0 {
            sections.append([SectionType.examples.rawValue: examples])
            sectionExpandStatus.append(true)
        }
        
        if (word.fixedMatchs?.count ?? 0) > 0 || (word.commonPhrases?.count ?? 0) > 0 || (word.wordAnalysis?.count ?? 0) > 0 || (word.detailedSyntaxs?.count ?? 0) > 0 {
            sections.append([SectionType.featured.rawValue: []])
            sectionExpandStatus.append(true)
        }
        
        if let synonyms = word.synonyms, synonyms.count > 0 {
            sections.append([SectionType.synonym.rawValue: synonyms])
            sectionExpandStatus.append(true)
        }
        
        if let antonyms = word.antonyms, antonyms.count > 0 {
            sections.append([SectionType.antonym.rawValue: antonyms])
            sectionExpandStatus.append(true)
        }
        
    }
    
    
    
    // MARK: -
    func numberOfSections(in tableView: UITableView) -> Int {
        return sections.count
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let scetionType = sections[section].keys.first
        
        if scetionType == SectionType.featured.rawValue {
            return UIView()
            
        } else {
            let view = YXWordDetailHeaderView(headerTitle: scetionType ?? "")
            
            if scetionType == SectionType.deformation.rawValue {
                view.shouldShowExpand = true
                view.isExpand = sectionExpandStatus[section]
                view.expandClosure = {
                    self.sectionExpandStatus[section] = !self.sectionExpandStatus[section]
                    self.tableView.reloadSections(IndexSet(integer: section), with: .automatic)
                }
                
            } else {
                view.shouldShowExpand = false
            }
            
            return view
        }
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 54
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let sectionExpandState = sectionExpandStatus[section]

        let section = sections[section]
        guard let sectionContent = section.values.first as? [Any] else { return 0 }

        switch section.keys.first {
        case SectionType.deformation.rawValue:
            if sectionExpandState {
                return sectionContent.count
                
            } else {
                return 0
            }
            
        case SectionType.examples.rawValue:
            return sectionContent.count
            
        case SectionType.featured.rawValue:
            return 1
            
        case SectionType.synonym.rawValue:
            return sectionContent.count
            
        case SectionType.antonym.rawValue:
            return sectionContent.count
            
        default:
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let section = sections[indexPath.section]

        switch section.keys.first {
        case SectionType.deformation.rawValue:
            let cell = tableView.dequeueReusableCell(withIdentifier: "YXWordDetailClassicCell", for: indexPath) as! YXWordDetailClassicCell
            return cell
            
        case SectionType.examples.rawValue:
            let cell = tableView.dequeueReusableCell(withIdentifier: "YXWordDetailExampleCell", for: indexPath) as! YXWordDetailExampleCell
            return cell
            
        case SectionType.featured.rawValue:
            let cell = UITableViewCell()
            let view = YXWordDetailFeaturedView(frame: CGRect(x: 0, y: 0, width: screenWidth, height: cell.height), word: word)
//            view.heightChangeClosure = { height in
//                self.tableView.reloadRows(at: [indexPath], with: .automatic)
//            }
            
            cell.contentView.addSubview(view)
            return cell
            
        case SectionType.synonym.rawValue:
            let cell = tableView.dequeueReusableCell(withIdentifier: "YXWordDetailClassicCell", for: indexPath) as! YXWordDetailClassicCell
            return cell
            
        case SectionType.antonym.rawValue:
            let cell = tableView.dequeueReusableCell(withIdentifier: "YXWordDetailClassicCell", for: indexPath) as! YXWordDetailClassicCell
            return cell
            
        default:
            return UITableViewCell()
        }
    }
}
