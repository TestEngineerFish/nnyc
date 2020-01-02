//
//  YXWordListView.swift
//  YXEDU
//
//  Created by Jake To on 12/9/19.
//  Copyright © 2019 shiji. All rights reserved.
//

import UIKit

class YXWordListView: UIView, UITableViewDelegate, UITableViewDataSource {
    
    var editClosure: (() -> Void)?
    var showWordDetialClosure: ((_ wordId: Int, _ isComplexWord: Int) -> Void)?
    var startReviewClosure: (() -> Void)?
    
    var shouldShowEditButton = false {
        didSet {
            if shouldShowEditButton {
                editButton.isHidden = false
                orderButtonDistance.constant = 90
                
            } else {
                editButton.isHidden = true
                orderButtonDistance.constant = 20
            }
        }
    }
    
    var shouldShowBottomView = false {
        didSet {
            if shouldShowBottomView {
                bottomViewHeight.constant = 68 + kSafeBottomMargin
                bottomView.isHidden = false
                
            } else {
                bottomViewHeight.constant = 0
                bottomView.isHidden = true
            }
        }
    }
    
    var words: [YXWordModel] = [] {
        didSet {
            for index in 0..<words.count {
                if words[index].index == nil {
                    words[index].index = index
                }
            }
            
            let wordsCount = words.count
            if wordsCount == 0 {
                topViewHeight.constant = 0
                topView.isHidden = true

            } else {
                topViewHeight.constant = 44
                topView.isHidden = false
            }
            
            wordCountLabel.text = "\(wordsCount)"
            tableView.reloadData()
        }
    }
    
    var isWrongWordList = false
    var wrongWordSectionData: [[String: [YXWordModel]]]? {
        didSet {
            var wordsCount = 0
            
            if let sectionData = wrongWordSectionData {
                for dataIndex in 0..<sectionData.count {
                    guard let key = sectionData[dataIndex].keys.first, var words = sectionData[dataIndex].values.first, words.count > 0 else { continue }
                    
                    for index in 0..<words.count {
                        wordsCount = wordsCount + 1
                        
                        if words[index].index == nil {
                            words[index].index = index
                        }
                    }
                    
                    wrongWordSectionData?[dataIndex] = [key: words]
                }
            }
            
            if wordsCount == 0 {
                topViewHeight.constant = 0
                topView.isHidden = true
                shouldShowBottomView = false
                
            } else {
                topViewHeight.constant = 44
                topView.isHidden = false
                shouldShowBottomView = true
            }
            
            wordCountLabel.text = "\(wordsCount)"
            tableView.reloadData()
        }
    }
    
    var orderType: YXWordListOrderType = .default {
        didSet {
            self.orderButton.setTitle(orderType.rawValue, for: .normal)

            switch orderType {
            case .default:
                if let data = wrongWordSectionData {
                    for index in 0..<data.count {
                        guard let key = data[index].keys.first, let words = data[index].values.first, words.count > 0 else { continue }
                        wrongWordSectionData?[index] = [key: defaultOrder(words: words)]
                    }
                    
                } else {
                    words = defaultOrder(words: words)
                }
                
            case .az:
                if let data = wrongWordSectionData {
                    for index in 0..<data.count {
                        guard let key = data[index].keys.first, let words = data[index].values.first, words.count > 0 else { continue }
                        wrongWordSectionData?[index] = [key: atoz(words: words)]
                    }
                    
                } else {
                    words = atoz(words: words)
                }

            case .za:
                if let data = wrongWordSectionData {
                    for index in 0..<data.count {
                        guard let key = data[index].keys.first, let words = data[index].values.first, words.count > 0 else { continue }
                        wrongWordSectionData?[index] = [key: ztoa(words: words)]
                    }
                    
                } else {
                    words = ztoa(words: words)
                }
            }
        }
    }

    @IBOutlet var contentView: UIView!
    @IBOutlet weak var topView: UIView!
    @IBOutlet weak var topViewHeight: NSLayoutConstraint!
    @IBOutlet weak var wordCountLabel: UILabel!
    @IBOutlet weak var orderButton: YXDesignableButton!
    @IBOutlet weak var orderButtonDistance: NSLayoutConstraint!
    @IBOutlet weak var editButton: YXDesignableButton!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var bottomView: UIView!
    @IBOutlet weak var bottomViewHeight: NSLayoutConstraint!
    
    @IBAction func order(_ sender: Any) {
        let view = YXWordListOrderView(orderViewLeftTopPoint: CGPoint(x: screenWidth - orderButtonDistance.constant - 116, y: kNavHeight + 88), orderType: orderType)
        view.orderClosure = { type in
            self.orderType = type
        }
        
        kWindow.addSubview(view)
    }
    
    @IBAction func edit(_ sender: Any) {
        editClosure?()
    }
    
    @IBAction func startReview(_ sender: Any) {
        startReviewClosure?()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        initializationFromNib()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        initializationFromNib()
    }
    
    func initializationFromNib() {
        Bundle.main.loadNibNamed("YXWordListView", owner: self, options: nil)
        addSubview(contentView)
        contentView.frame = self.bounds
        
        tableView.register(UINib(nibName: "YXWordListCell", bundle: nil), forCellReuseIdentifier: "YXWordListCell")
        tableView.register(UINib(nibName: "YXWordListEmptyCell", bundle: nil), forCellReuseIdentifier: "YXWordListEmptyCell")

        tableView.delegate = self
        tableView.dataSource = self
        tableView.reloadData()
    }
    
    
    
    // MARK: - table view
    func numberOfSections(in tableView: UITableView) -> Int {
        if let wrongWordSectionCount = wrongWordSectionData?.count, wrongWordSectionCount > 0, isWrongWordList {
            return wrongWordSectionCount
            
        } else {
            return 1
        }
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard let wrongWordSectionCount = wrongWordSectionData?.count, wrongWordSectionCount > 0, isWrongWordList else { return nil }
        let wrongWordSection = wrongWordSectionData?[section]
        
        let wordListHeaderView = YXWordListHeaderView()
        wordListHeaderView.titleLabel.text = wrongWordSection?.keys.first
        
        if wrongWordSection?.keys.first?.contains("熟识的单词") ?? false {
            wordListHeaderView.editButton.isHidden = false
            wordListHeaderView.editClosure = editClosure
        }
        
        return wordListHeaderView
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if let wrongWordSectionCount = wrongWordSectionData?.count, wrongWordSectionCount > 0, isWrongWordList {
            return 30

        } else {
            return 0.01
        }
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0.01
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let wrongWordSectionCount = wrongWordSectionData?.count, wrongWordSectionCount > 0, isWrongWordList {
            if let count = wrongWordSectionData?[section].values.first?.count, count > 0 {
                return count
                
            } else {
                return 1
            }
            
        } else {
            if words.count > 0 {
                return words.count
                
            } else {
                return 1
            }
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "YXWordListCell", for: indexPath) as! YXWordListCell
        var word: YXWordModel!
        
        if let wrongWordSectionCount = wrongWordSectionData?.count, wrongWordSectionCount > 0, isWrongWordList {
            if var wrongWords = wrongWordSectionData?[indexPath.section].values.first, wrongWords.count > 0 {
                word = wrongWords[indexPath.row]
                
                cell.removeMaskClosure = {
                    wrongWords[indexPath.row].hidePartOfSpeechAndMeanings = !word.hidePartOfSpeechAndMeanings
                    
                    if let key = self.wrongWordSectionData?[indexPath.section].keys.first {
                        self.wrongWordSectionData?[indexPath.section] = [key: wrongWords]
                    }
                    
                    tableView.reloadRows(at: [indexPath], with: .none)
                }
                
            } else {
                let cell = tableView.dequeueReusableCell(withIdentifier: "YXWordListEmptyCell", for: indexPath) as! YXWordListEmptyCell
                return cell
            }
            
        } else {
            if words.count > 0 {
                word = words[indexPath.row]

                cell.removeMaskClosure = {
                    self.words[indexPath.row].hidePartOfSpeechAndMeanings = !self.words[indexPath.row].hidePartOfSpeechAndMeanings
                    tableView.reloadRows(at: [indexPath], with: .none)
                }
                
            } else {
                let cell = tableView.dequeueReusableCell(withIdentifier: "YXWordListEmptyCell", for: indexPath) as! YXWordListEmptyCell
                return cell
            }
        }
        
        cell.wordLabel.text = word.word

        if let partOfSpeechAndMeanings = word.partOfSpeechAndMeanings, partOfSpeechAndMeanings.count > 0 {
            var text = ""

            for index in 0..<partOfSpeechAndMeanings.count {
                guard let partOfSpeech = partOfSpeechAndMeanings[index].partOfSpeech, let meaning = partOfSpeechAndMeanings[index].meaning else { continue }
                
                if index == 0 {
                    text = partOfSpeech + meaning
                    
                } else {
                    text = text + "；" + partOfSpeech + meaning
                }
            }
            
            cell.meaningLabel.text = text
        }
        
        cell.americanPronunciation = word.americanPronunciation
        cell.englishPronunciation = word.englishPronunciation
        
        if word.hidePartOfSpeechAndMeanings {
            cell.meaningLabelMask.image = #imageLiteral(resourceName: "wordListMask")
            
        } else {
            cell.meaningLabelMask.image = nil
        }
        
        cell.showWordDetailClosure = {
            self.showWordDetialClosure?(word.wordId ?? 0, word.isComplexWord ?? 0)
        }
            
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if let wrongWordSectionCount = wrongWordSectionData?.count, wrongWordSectionCount > 0, isWrongWordList {
            return 44

        } else if words.count > 0 {
            return 44

        } else {
            return tableView.estimatedRowHeight
        }
    }
    
    private func defaultOrder(words: [YXWordModel]) -> [YXWordModel] {
        var newWords = words
        newWords.sort { (a, z) -> Bool in
            a.index ?? 0 < z.index ?? 0
        }
        
        return newWords
    }
    
    private func atoz(words: [YXWordModel]) -> [YXWordModel] {
        var newWords = words
        newWords.sort { (a, z) -> Bool in
            a.word ?? "" < z.word ?? ""
        }
        
        return newWords
    }
    
    private func ztoa(words: [YXWordModel]) -> [YXWordModel] {
        var newWords = words
        newWords.sort { (a, z) -> Bool in
            a.word ?? "" > z.word ?? ""
        }
        
        return newWords
    }
}
