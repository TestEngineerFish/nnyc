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
    private var mostDeformationLength: CGFloat = 30
    private var featuredViewheight: CGFloat    = 0
    private var featuredView: YXWordDetailFeaturedView!
    private var recordView = YXRecordView()
    var exampleCell: YXWordDetailExampleCell?
    var isAutoPlay = false

    @IBOutlet var contentView: UIView!
    @IBOutlet weak var collectionButton: UIButton!
    @IBOutlet weak var wordLabel: UILabel!
    @IBOutlet weak var phoneticSymbolLabel: UILabel!
    @IBOutlet weak var partOfSpeechAndSenseLabel: UILabel!
    @IBOutlet weak var playAuoidButton: UIButton!
    @IBOutlet weak var dividingView: UIView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var dividingTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var playButtonLeftOffset: NSLayoutConstraint!
    
    @IBAction func collectWord(_ sender: UIButton) {
        if self.collectionButton.currentImage == #imageLiteral(resourceName: "unCollectWord") {
            let request = YXWordListRequest.cancleCollectWord(wordIds: "[{\"w\":\(word.wordId ?? 0),\"is\":\(word.isComplexWord ?? 0)}]")
            YYNetworkService.default.request(YYStructResponse<YXResultModel>.self, request: request, success: { [weak self] (response) in
                self?.collectionButton.setImage(#imageLiteral(resourceName: "collectWord"), for: .normal)
            }) { error in
                YXUtils.showHUD(kWindow, title: error.message)
            }
        } else {
            let request = YXWordListRequest.collectWord(wordId: word.wordId ?? 0, isComplexWord: word.isComplexWord ?? 0)
            YYNetworkService.default.request(YYStructResponse<YXResultModel>.self, request: request, success: { [weak self] (response) in
                self?.collectionButton.setImage(#imageLiteral(resourceName: "unCollectWord"), for: .normal)
            }) { error in
                YXUtils.showHUD(kWindow, title: error.message)
            }
        }
    }
    
    @IBAction func feedbackWord(_ sender: UIButton) {
        YXLog("单词详情View中点击反馈按钮")
        YXReportErrorView.show(to: kWindow, withWordId: NSNumber(integerLiteral: word.wordId ?? 0), withWord: word.word ?? "")
    }
    
    @IBAction func playAudio(_ sender: UIButton) {
        YXAVPlayerManager.share.finishedBlock = nil
        self.isAutoPlay = false
        if YXAVPlayerManager.share.isPlaying {
            YXAVPlayerManager.share.pauseAudio()
            playAuoidButton.layer.removeFlickerAnimation()
        } else {
            self.playWord()
        }
    }
    
    init(frame: CGRect, word: YXWordModel) {
        super.init(frame: frame)
        self.word = word
        initializationFromNib()
        requestWordDetail()
        self.bindProperty()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        initializationFromNib()
    }
    
    deinit {
        YXLog("释放\(self.classForCoder)")
        YXAVPlayerManager.share.pauseAudio()
        YXAVPlayerManager.share.finishedBlock = nil
        playAuoidButton.layer.removeFlickerAnimation()
    }
    
    private func initializationFromNib() {
        Bundle.main.loadNibNamed("YXWordDetailCommonView", owner: self, options: nil)
        addSubview(contentView)
        contentView.frame = self.bounds
        
        tableView.register(UINib(nibName: "YXWordDetailExampleCell", bundle: nil), forCellReuseIdentifier: "YXWordDetailExampleCell")
        tableView.register(UINib(nibName: "YXWordDeformationsCell", bundle: nil), forCellReuseIdentifier: "YXWordDeformationsCell")
        tableView.register(UINib(nibName: "YXWordDetailClassicCell", bundle: nil), forCellReuseIdentifier: "YXWordDetailClassicCell")
        tableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 20, right: 0)
        
        featuredView = YXWordDetailFeaturedView(word: word, heightChangeClosure: { height in
            self.featuredViewheight = height
            
            for index in 0..<self.sections.count {
                guard self.sections[index].keys.first == SectionType.featured.rawValue else { continue }
                self.tableView.reloadData()
            }
        })
        featuredView.tableViewBottomLineHeight.constant = 0
        
        let request = YXWordListRequest.didCollectWord(wordId: word.wordId ?? 0)
        YYNetworkService.default.request(YYStructResponse<YXResultModel>.self, request: request, success: { [weak self] (response) in
            if response.data?.didCollectWord == 1 {
                self?.collectionButton.setImage(#imageLiteral(resourceName: "unCollectWord"), for: .normal)
            } else {
                self?.collectionButton.setImage(#imageLiteral(resourceName: "collectWord"), for: .normal)
            }
        }) { error in
            YXUtils.showHUD(kWindow, title: error.message)
        }
        
        wordLabel.text = word.word
        if let pronunciation = word.soundmark, pronunciation.isEmpty == false {
            phoneticSymbolLabel.text = "\(YXUserModel.default.didUseAmericanPronunciation ? "美" : "英")" + pronunciation
            
        } else {
            phoneticSymbolLabel.text = ""
        }

        if let partOfSpeechAndMeanings = word.partOfSpeechAndMeanings, partOfSpeechAndMeanings.count > 0 {
            if partOfSpeechAndMeanings[0].partOfSpeech == "phrase" {
                playButtonLeftOffset.constant = 0
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
            featuredView.tableViewBottomLineHeight.constant = 10

            sections.append([SectionType.synonym.rawValue: synonyms])
            sectionExpandStatus.append(true)
        }
        
        if let antonyms = word.antonyms, antonyms.count > 0 {
            featuredView.tableViewBottomLineHeight.constant = 10

            sections.append([SectionType.antonym.rawValue: antonyms])
            sectionExpandStatus.append(true)
        }
        
        // 设置录音视图
        self.dividingTopConstraint.constant = AdaptSize(40 + 20)
        self.addSubview(recordView)
        recordView.snp.makeConstraints { (make) in
            make.left.right.equalToSuperview()
            make.bottom.equalTo(self.dividingView.snp.top)
            make.height.equalTo(AdaptSize(40))
        }
        let tapRecordView = UITapGestureRecognizer(target: self, action: #selector(recordAction))
        recordView.addGestureRecognizer(tapRecordView)
    }


    
    // ---- Request ----
    /// 不应该调用的。。。，这里仅仅是为了获取这个单词的跟读最好得分，之后有时间将之前的跟读得分写入数据库即可
    /// 查询单词详情
    private func requestWordDetail() {
        guard let wordId = word.wordId else {
            return
        }
        let wordDetailRequest = YXWordBookRequest.wordDetail(wordId: wordId, isComplexWord: 0)
        YYNetworkService.default.request(YYStructResponse<YXWordModel>.self, request: wordDetailRequest, success: { [weak self] (response) in
            guard let self = self, let wordModel = response.data else { return }
            self.word.listenScore      = wordModel.listenScore
            self.recordView.updateState(listenScore: wordModel.listenScore)
        }) { error in
            YXLog("查询单词:\(wordId)详情失败， error:\(error)")
            YXUtils.showHUD(kWindow, title: error.message)
        }
    }
    
    // MARK: ---- Event ----

    @objc private func recordAction() {
        guard let wordModel = self.word else { return }
        self.isAutoPlay     = false
        YXNewLearnView(wordModel: wordModel).show()
    }
    
    private func bindProperty() {
        NotificationCenter.default.addObserver(self, selector: #selector(updateRecordScore(_:)), name: YXNotification.kRecordScore, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(didEnterBackgroundNotification), name: UIApplication.didEnterBackgroundNotification, object: nil)
    }

    /// 播放单词
    private func playWord() {
        guard let _voice = word.voice, let pronunciationUrl = URL(string: _voice) else {
            YXLog("无效的音频地址: \(String(describing: word.voice))")
            YXUtils.showHUD(kWindow, title: "无效音频")
            return
        }
        playAuoidButton.layer.addFlickerAnimation()
        YXAVPlayerManager.share.playAudio(pronunciationUrl) {
            self.playAuoidButton.layer.removeFlickerAnimation()
            if self.isAutoPlay {
                self.playExample()
                self.isAutoPlay = false
            }
        }
    }
    
    private func playExample() {
        self.isAutoPlay = true
        guard let cell = self.exampleCell else {
            return  
        }
        cell.playExample()
    }
    
    /// 自动播放
    func autoPlay() {
        self.isAutoPlay = true
        self.playWord()
    }
    
    // MARK: --- Notifcation ----
    @objc private func updateRecordScore(_ notification: Notification) {
        guard let userInfo = notification.userInfo as? [String:Int], let newScore: Int = userInfo["maxScore"] else {
            return
        }
        word.listenScore = newScore
        self.recordView.updateState(listenScore: newScore)
    }
    
    @objc private func didEnterBackgroundNotification() {
        YXAVPlayerManager.share.pauseAudio()
        self.playAuoidButton.layer.removeFlickerAnimation()
        self.exampleCell?.playAuoidButton.layer.removeFlickerAnimation()
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
            view.shouldShowExpand = false
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
        return 0.01
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
            let deformations              = section.values.first as? [YXWordDeformationModel]
            let deformation               = deformations?[indexPath.row]
            cell.titleLabel.text          = deformation?.deformation
            cell.contentLabel.text        = deformation?.word
            cell.contentDistance.constant = mostDeformationLength
            return cell
            
        case SectionType.examples.rawValue:
            let cell = tableView.dequeueReusableCell(withIdentifier: "YXWordDetailExampleCell", for: indexPath) as! YXWordDetailExampleCell
            let examples = section.values.first as? [YXWordExampleModel]
            let example  = examples?[indexPath.row]
            cell.exampleImageView.sd_setImage(with: URL(string: example?.imageUrl ?? ""))
            let combineExample = (example?.english ?? "") + "\n" + (example?.chinese ?? "")
            cell.label.attributedText = {
                let result = combineExample.formartTag()
                let mAttr  = NSMutableAttributedString(string: result.1, attributes: [NSAttributedString.Key.foregroundColor : UIColor.black1])
                
                let paragraphStyle = NSMutableParagraphStyle()
                paragraphStyle.lineSpacing = 4

                mAttr.addAttribute(NSAttributedString.Key.paragraphStyle, value: paragraphStyle, range: NSMakeRange(0, mAttr.length))
                
                result.0.forEach { (range) in
                    mAttr.addAttributes([NSAttributedString.Key.foregroundColor : UIColor.orange1], range: range)
                }
                return mAttr
                }()
            cell.pronunciation = example?.vocie
            cell.clickPlayBlock = {  [weak self] in
                guard let self = self else { return }
                self.isAutoPlay = true
                self.playAuoidButton.layer.removeFlickerAnimation()
            }
            self.exampleCell   = cell
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
            let combineExample = (example?.english ?? "") + "\n" + (example?.chinese ?? "")

            let result = combineExample.formartTag()
            let mAttr  = NSMutableAttributedString(string: result.1, attributes: [NSAttributedString.Key.foregroundColor : UIColor.black1])
            result.0.forEach { (range) in
                mAttr.addAttributes([NSAttributedString.Key.foregroundColor : UIColor.orange1], range: range)
            }
            let height = mAttr.string.textHeight(font: UIFont.systemFont(ofSize: 13), width: screenWidth - 80) + 130

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
