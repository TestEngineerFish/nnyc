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
    private var mostDeformationLength: CGFloat = 44
    private var featuredView: YXWordDetailFeaturedView!
    private var featuredViewheight: CGFloat = 0

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
        tableView.register(UINib(nibName: "YXWordDeformationsCell", bundle: nil), forCellReuseIdentifier: "YXWordDeformationsCell")
        tableView.register(UINib(nibName: "YXWordDetailClassicCell", bundle: nil), forCellReuseIdentifier: "YXWordDetailClassicCell")

        featuredView = YXWordDetailFeaturedView(word: word, heightChangeClosure: { height in
            self.featuredViewheight = height
            
            for index in 0..<self.sections.count {
                guard self.sections[index].keys.first == SectionType.featured.rawValue else { continue }
                self.tableView.reloadData()
            }
        })
        
        wordLabel.text = word.word
        phoneticSymbolLabel.text = word.soundmark

        if let partOfSpeechAndMeanings = word.partOfSpeechAndMeanings, partOfSpeechAndMeanings.count > 0 {
            var text = ""

            for index in 0..<partOfSpeechAndMeanings.count {
                guard let partOfSpeech = partOfSpeechAndMeanings[index].partOfSpeech, let meaning = partOfSpeechAndMeanings[index].meaning else { continue }
                
                if index == 0 {
                    text = partOfSpeech + meaning
                    
                } else {
                    text = text + "\n" + partOfSpeech + meaning
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
            
            var mostWidth: CGFloat = 0
            
            for deformation in deformations {
                guard let deformation = deformation.deformation else { continue }
                let width = deformation.textWidth(font: UIFont.systemFont(ofSize: 13), height: 20)
                
                if width > mostWidth {
                    mostWidth = width
                }
            }
            
            mostDeformationLength = mostDeformationLength + mostWidth
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
                    self.tableView.reloadData()
                }
                
            } else {
                view.shouldShowExpand = false
            }
            
            return view
        }
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        let scetionType = sections[section].keys.first
               
        if scetionType == SectionType.featured.rawValue {
            return 0
            
        } else {
            return 54
        }
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        let scetionType = sections[section].keys.first
               
        if (section + 1) < sections.count, scetionType == SectionType.examples.rawValue, sections[section + 1].keys.first == SectionType.featured.rawValue {
            return 0
            
        } else {
            return 20
        }
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
            return sectionContent.count > 0 ? 1 : 0
            
        case SectionType.antonym.rawValue:
            return sectionContent.count > 0 ? 1 : 0
            
        default:
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
//        let section = sections[indexPath.section]
//
//        switch section.keys.first {
//        case SectionType.featured.rawValue:
//            guard let sublayers = featuredView.layer.sublayers else { break }
//            for layer in sublayers {
//                layer.removeAllAnimations()
//            }
//
//        default:
//            break
//        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let section = sections[indexPath.section]

        switch section.keys.first {
        case SectionType.deformation.rawValue:
            let cell = tableView.dequeueReusableCell(withIdentifier: "YXWordDeformationsCell", for: indexPath) as! YXWordDeformationsCell
            let deformations = section.values.first as? [YXWordDeformationModel]
            let deformation = deformations?[indexPath.row]
            
            cell.titleLabel.text = deformation?.deformation
            cell.contentLabel.text = deformation?.word
            cell.contentDistance.constant = mostDeformationLength
            
            return cell
            
        case SectionType.examples.rawValue:
            let cell = tableView.dequeueReusableCell(withIdentifier: "YXWordDetailExampleCell", for: indexPath) as! YXWordDetailExampleCell
            let examples = section.values.first as? [YXWordExampleModel]
            let example = examples?[indexPath.row]

            cell.label.text = (example?.english ?? "") + "\n" + (example?.chinese ?? "")
            
            return cell
            
        case SectionType.featured.rawValue:
            let cell = UITableViewCell()
            cell.addSubview(featuredView)
            featuredView.snp.makeConstraints { (make) in
                make.edges.equalToSuperview()
            }
            
            return cell
            
        case SectionType.synonym.rawValue:
            let cell = tableView.dequeueReusableCell(withIdentifier: "YXWordDetailClassicCell", for: indexPath) as! YXWordDetailClassicCell
            let synonyms = section.values.first as? [String]

            var text = ""
            for index in 0..<(synonyms?.count ?? 0) {
                if index == 0 {
                    text = synonyms?[0] ?? ""
                    
                } else {
                    text = text + ", " + (synonyms?[index] ?? "")
                }
            }
            
            cell.label.text = text
            
            return cell
            
        case SectionType.antonym.rawValue:
            let cell = tableView.dequeueReusableCell(withIdentifier: "YXWordDetailClassicCell", for: indexPath) as! YXWordDetailClassicCell
            let antonyms = section.values.first as? [String]

            var text = ""
            for index in 0..<(antonyms?.count ?? 0) {
                if index == 0 {
                    text = antonyms?[0] ?? ""
                    
                } else {
                    text = text + ", " + (antonyms?[index] ?? "")
                }
            }
            
            cell.label.text = text
            
            return cell
            
        default:
            return UITableViewCell()
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let section = sections[indexPath.section]

        switch section.keys.first {
        case SectionType.featured.rawValue:
            return featuredViewheight
            
        default:
            return tableView.estimatedRowHeight
        }
    }
}
