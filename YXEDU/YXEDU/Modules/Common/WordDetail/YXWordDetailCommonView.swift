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
        case examples    = "例句"
        case featured    = "念念精选"
        case synonym     = "同义词"
        case antonym     = "反义词"
    }
    
    private var word: YXWordModel!
    private var sections: [[String: Any]]      = []
    private var sectionExpandStatus: [Bool]    = []
    private var mostDeformationLength: CGFloat = 44
    private var featuredViewheight: CGFloat    = 0
    private var featuredView: YXWordDetailFeaturedView!

    @IBOutlet var contentView: UIView!
    @IBOutlet weak var wordLabel: UILabel!
    @IBOutlet weak var phoneticSymbolLabel: UILabel!
    @IBOutlet weak var recordButton: UIButton!
    @IBOutlet weak var partOfSpeechAndSenseLabel: UILabel!
    @IBOutlet weak var playAuoidButton: UIButton!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var dividingView: UIView!
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
            
            YXAVPlayerManager.share.playAudio(pronunciationUrl) {
                self.playAuoidButton.layer.removeFlickerAnimation()
            }
        }
    }
    
    @IBAction func recordAction(_ sender: UIButton) {
        guard let wordModel = self.word else { return }
        YXNewLearnView(wordModel: wordModel).show()
    }
    
    init(frame: CGRect, word: YXWordModel) {
        super.init(frame: frame)
        self.word = word
        
        initializationFromNib()
        self.bindProperty()
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
        if let pronunciation = word.soundmark, pronunciation.isEmpty == false {
            phoneticSymbolLabel.text = "\(YXUserModel.default.didUseAmericanPronunciation ? "美" : "英")" + pronunciation
            
        } else {
            phoneticSymbolLabel.text = ""
        }

        if let partOfSpeechAndMeanings = word.partOfSpeechAndMeanings, partOfSpeechAndMeanings.count > 0 {
            if partOfSpeechAndMeanings[0].partOfSpeech == "phrase" {
                partOfSpeechAndSenseLabel.text = partOfSpeechAndMeanings[0].meaning
                
            } else {
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
        }
        
//        if let imageUrl = word.imageUrl, word?.isComplexWord != 1 {
//            imageView.sd_setImage(with: URL(string: imageUrl), completed: nil)
//        }
                
        if let deformations = word.deformations, deformations.count > 0 {
            sections.append([SectionType.deformation.rawValue: deformations])
            sectionExpandStatus.append(true)
            
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
        self.updateRecordStatus()
    }
    
    // MARK: ---- Event ----
    
    private func bindProperty() {
        NotificationCenter.default.addObserver(self, selector: #selector(updateRecordScore(_:)), name: YXNotification.kRecordScore, object: nil)
    }
    
    private func updateRecordStatus() {
        if word.listenScore > YXStarLevelEnum.three.rawValue {
            self.recordButton.setImage(UIImage(named: "didRecordedIcon"), for: .normal)
        } else {
            self.recordButton.setImage(UIImage(named: "recordedIcon"), for: .normal)
        }
    }
    
    // MARK: --- Notifcation ----
    @objc private func updateRecordScore(_ notification: Notification) {
        guard let userInfo = notification.userInfo as? [String:Int], let newScore: Int = userInfo["maxScore"] else {
            return
        }
        word.listenScore = newScore
        self.updateRecordStatus()
    }
    
    
    // MARK: ---- UITableViewDelegate && UITableViewDataSource ----
    func numberOfSections(in tableView: UITableView) -> Int {
        return sections.count
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let scetionType = sections[section].keys.first
        
        if scetionType == SectionType.featured.rawValue {
            return UIView()
            
        } else {
            let view = YXWordDetailHeaderView(headerTitle: scetionType ?? "")
            
//            if scetionType == SectionType.deformation.rawValue {
//                view.shouldShowExpand = true
//                view.isExpand = sectionExpandStatus[section]
//                view.expandClosure = {
//                    self.sectionExpandStatus[section] = !self.sectionExpandStatus[section]
//                    self.tableView.reloadData()
//                }
//
//            } else {
                view.shouldShowExpand = false
//            }
            
            return view
        }
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        let scetionType = sections[section].keys.first
               
        if scetionType == SectionType.featured.rawValue {
            return 0.01
            
        } else {
            return 54
        }
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
//        let scetionType = sections[section].keys.first
//
//        if (section + 1) < sections.count, scetionType == SectionType.examples.rawValue, sections[section + 1].keys.first == SectionType.featured.rawValue {
//            return 0
//
//        } else {
            return 0.01
//        }
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
            cell.exampleImageView.sd_setImage(with: URL(string: example?.imageUrl ?? ""))
            let combineExample = (example?.english ?? "") + "\n" + (example?.chinese ?? "")
            cell.label.attributedText = {

                let result = combineExample.formartTag()

                let mAttr = NSMutableAttributedString(string: result.1, attributes: [NSAttributedString.Key.font : UIFont.pfSCSemiboldFont(withSize: AdaptSize(16)), NSAttributedString.Key.foregroundColor : UIColor.black1])
                result.0.forEach { (range) in
                    mAttr.addAttributes([NSAttributedString.Key.foregroundColor : UIColor.orange1], range: range)
                }
                return mAttr
            }()
            cell.pronunciation = example?.vocie
            
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
        case SectionType.deformation.rawValue:
            return 20

        case SectionType.examples.rawValue:
            let examples = section.values.first as? [YXWordExampleModel]
            let example = examples?[indexPath.row]
            
            var string = ""
            let combineExample = (example?.english ?? "") + "\n" + (example?.chinese ?? "")
            if let firstAddressSymbolIndex = combineExample.firstIndex(of: "@"), let lastAddressSymbolIndex = combineExample.lastIndex(of: "@") {
                let startHighLightIndex = combineExample.index(firstAddressSymbolIndex, offsetBy: 1)
                let endHighLightIndex = combineExample.index(lastAddressSymbolIndex, offsetBy: 1)
                let highLightString = String(combineExample[startHighLightIndex..<lastAddressSymbolIndex])
                string = String(combineExample[combineExample.startIndex..<firstAddressSymbolIndex]) + highLightString + String(combineExample[endHighLightIndex..<combineExample.endIndex])
                                
            } else if let firstRightBracket = combineExample.firstIndex(of: ">"), let lastLeftBracket = combineExample.lastIndex(of: "<"), let firstLeftBracket = combineExample.firstIndex(of: "<"), let lastRightBracket = combineExample.lastIndex(of: ">") {
                let startHighLightIndex = combineExample.index(firstRightBracket, offsetBy: 1)
                let endHighLightIndex = combineExample.index(lastRightBracket, offsetBy: 1)
                let highLightString = String(combineExample[startHighLightIndex..<lastLeftBracket])
                string = String(combineExample[combineExample.startIndex..<firstLeftBracket]) + highLightString + String(combineExample[endHighLightIndex..<combineExample.endIndex])
            
            } else {
                string = combineExample
            }
            
            var height = string.textHeight(font: UIFont.pfSCSemiboldFont(withSize: AdaptSize(16)), width: screenWidth - 80) + 130
//            if word?.isComplexWord == 1 {
//                height = string.textHeight(font: UIFont.systemFont(ofSize: 13), width: screenWidth - 164) + 4 + 10
//                height = height > 70 ? height : 70
//            }
                        
            return height

        case SectionType.synonym.rawValue:
            let synonyms = section.values.first as? [String]

            var text = ""
            for index in 0..<(synonyms?.count ?? 0) {
                if index == 0 {
                    text = synonyms?[0] ?? ""

                } else {
                    text = text + ", " + (synonyms?[index] ?? "")
                }
            }

            let height = text.textHeight(font: UIFont.systemFont(ofSize: 13), width: screenWidth - 50) + 4
            return height

        case SectionType.antonym.rawValue:
            let antonyms = section.values.first as? [String]

            var text = ""
            for index in 0..<(antonyms?.count ?? 0) {
                if index == 0 {
                    text = antonyms?[0] ?? ""
                    
                } else {
                    text = text + ", " + (antonyms?[index] ?? "")
                }
            }
            
            let height = text.textHeight(font: UIFont.systemFont(ofSize: 13), width: screenWidth - 50) + 4
            return height
            
        case SectionType.featured.rawValue:
            return featuredViewheight
            
        default:
            return 0
        }
    }
}
