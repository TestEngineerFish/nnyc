//
//  YXWordListView.swift
//  YXEDU
//
//  Created by Jake To on 12/9/19.
//  Copyright © 2019 shiji. All rights reserved.
//

import UIKit

class YXWordListView: UIView, UITableViewDelegate, UITableViewDataSource {
    
    var orderClosure: ((_ orderType: YXWordListOrderType) -> Void)?
    var editClosure: (() -> Void)?

    var isWrongWordList = false
    
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
                bottonViewHeight.constant = bottonViewHeight.constant + kSafeBottomMargin
                
            } else {
                bottonViewHeight.constant = 0
            }
        }
    }
    
    var words: [YXWordModel] = [] {
        didSet {
            wordCountLabel.text = "\(words.count)"
            tableView.reloadData()
        }
    }
    
    var wrongWordList: YXWrongWordListModel? {
        didSet {
            wrongWordSectionData = []
            var wordsCount = 0
            
            if let familiarList = wrongWordList?.familiarList, familiarList.count > 0 {
                let familiarListCount = familiarList.count
                wrongWordSectionData?.append(["熟识的单词（\(familiarListCount)）": familiarList])
                
                wordsCount = wordsCount + familiarListCount
            }
            
            if let recentWrongList = wrongWordList?.recentWrongList, recentWrongList.count > 0 {
                let recentWrongListCount = recentWrongList.count
                wrongWordSectionData?.append(["最近错词（\(recentWrongListCount)）": recentWrongList])
                
                wordsCount = wordsCount + recentWrongListCount
            }
            
            if let reviewList = wrongWordList?.reviewList, reviewList.count > 0 {
                let reviewListCount = reviewList.count
                wrongWordSectionData?.append(["待复习错词（\(reviewListCount)）": reviewList])
                
                wordsCount = wordsCount + reviewListCount
            }
            
            wordCountLabel.text = "\(wordsCount)"
            tableView.reloadData()
        }
    }
    
    private var wrongWordSectionData: [[String: [YXWordModel]]]?
    
    var orderType: YXWordListOrderType = .default {
        didSet {
            self.orderButton.setTitle(orderType.rawValue, for: .normal)
            
            guard words.count > 0 else { return }
        }
    }

    @IBOutlet var contentView: UIView!
    @IBOutlet weak var wordCountLabel: UILabel!
    @IBOutlet weak var orderButton: YXDesignableButton!
    @IBOutlet weak var orderButtonDistance: NSLayoutConstraint!
    @IBOutlet weak var editButton: YXDesignableButton!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var bottomView: UIView!
    @IBOutlet weak var bottonViewHeight: NSLayoutConstraint!
    
    @IBAction func order(_ sender: Any) {
        let view = YXWordListOrderView(frame: CGRect(x: screenWidth - orderButtonDistance.constant - 120, y: 44, width: 120, height: 120), orderType: orderType)
        view.orderClosure = { type in
            self.orderButton.setTitle(type.rawValue, for: .normal)
            self.orderType = type
            self.orderClosure?(type)
        }
        
        self.addSubview(view)
    }
    
    @IBAction func edit(_ sender: Any) {
        editClosure?()
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
        
        tableView.register(UINib(nibName: "YXWordListEmptyCell", bundle: nil), forCellReuseIdentifier: "YXWordListEmptyCell")
        tableView.register(UINib(nibName: "YXWordListCell", bundle: nil), forCellReuseIdentifier: "YXWordListCell")

        tableView.delegate = self
        tableView.dataSource = self
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
        
        if section == 0 {
            wordListHeaderView.editButton.isHidden = false
            wordListHeaderView.editClosure = editClosure
        }
        
        return wordListHeaderView
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if let wrongWordSectionCount = wrongWordSectionData?.count, wrongWordSectionCount > 0, isWrongWordList {
            return 30

        } else {
            return 1
        }
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
        if let wrongWordSectionCount = wrongWordSectionData?.count, wrongWordSectionCount > 0, isWrongWordList {
            if var wrongWords = wrongWordSectionData?[indexPath.section].values.first, wrongWords.count > 0 {
                let cell = tableView.dequeueReusableCell(withIdentifier: "YXWordListCell", for: indexPath) as! YXWordListCell
                let word = wrongWords[indexPath.row]
                
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
                    cell.meaningLabelMask.isHidden = true
                    
                } else {
                    cell.meaningLabelMask.isHidden = false
                }
                
                cell.removeMaskClosure = {
                    wrongWords[indexPath.row].hidePartOfSpeechAndMeanings = !word.hidePartOfSpeechAndMeanings
                    
                    if let key = self.wrongWordSectionData?[indexPath.section].keys.first {
                        self.wrongWordSectionData?[indexPath.section] = [key: wrongWords]
                    }
                    
                    tableView.reloadRows(at: [indexPath], with: .none)
                }
                
                cell.showWordDetailClosure = {
                    if let wordListViewController = self.parentViewController() as? YXWordListViewController {
                        let wordDetailViewController = YXWordDetailViewControllerNew()
                        wordDetailViewController.word = YXWordBookDaoImpl().selectWord(wordId: word.wordId ?? 0)
                        wordListViewController.navigationController?.pushViewController(wordDetailViewController, animated: true)
                    }
                }
                
                return cell
                
            } else {
                let cell = tableView.dequeueReusableCell(withIdentifier: "YXWordListEmptyCell", for: indexPath) as! YXWordListEmptyCell
                return cell
            }
            
        } else {
            if words.count > 0 {
                let cell = tableView.dequeueReusableCell(withIdentifier: "YXWordListCell", for: indexPath) as! YXWordListCell
                let word = words[indexPath.row]
                
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
                    cell.meaningLabelMask.isHidden = true
                    
                } else {
                    cell.meaningLabelMask.isHidden = false
                }
                
                cell.removeMaskClosure = {
                    self.words[indexPath.row].hidePartOfSpeechAndMeanings = !self.words[indexPath.row].hidePartOfSpeechAndMeanings
                    tableView.reloadRows(at: [indexPath], with: .none)
                }
                
                cell.showWordDetailClosure = {
                    if let wordListViewController = self.parentViewController() as? YXWordListViewController {
                        let wordDetailViewController = YXWordDetailViewControllerNew()
                        wordDetailViewController.word = YXWordBookDaoImpl().selectWord(wordId: word.wordId ?? 0)
                        wordListViewController.navigationController?.pushViewController(wordDetailViewController, animated: true)
                    }
                }
                
                return cell
                
            } else {
                let cell = tableView.dequeueReusableCell(withIdentifier: "YXWordListEmptyCell", for: indexPath) as! YXWordListEmptyCell
                return cell
            }
        }
    }
    
    func parentViewController() -> UIViewController? {

        var n = self.next
        
        while n != nil {
            if (n is UIViewController) {
                return n as? UIViewController
            }
            
            n = n?.next
        }
        
        return nil
    }
}
