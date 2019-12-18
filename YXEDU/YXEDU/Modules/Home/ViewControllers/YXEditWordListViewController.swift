//
//  YXEditWordListViewController.swift
//  YXEDU
//
//  Created by Jake To on 12/9/19.
//  Copyright © 2019 shiji. All rights reserved.
//

import UIKit
import ObjectMapper

enum YXEditWordListType {
    case collected
    case familiar
}

struct CollectWord: Mappable {
    var wordId: String!
    var isComplexWord: Int!
    
    init() {}
    
    init?(map: Map) {
        self.mapping(map: map)
    }
    
    mutating func mapping(map: Map) {
        wordId <- map["w"]
        isComplexWord <- map["is"]
    }
}

class YXEditWordListViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    var editWordListType: YXEditWordListType!
    var words: [YXWordModel] = []

    @IBOutlet weak var headerLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var wordCountLabel: UILabel!
    @IBOutlet weak var redButton: YXDesignableButton!
    @IBOutlet weak var bottomView: YXDesignableView!
    @IBOutlet weak var bottonViewHeight: NSLayoutConstraint!
    
    @IBAction func back(_ sender: UIBarButtonItem) {
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func tapRedButton(_ sender: Any) {
        var collectWords: [CollectWord] = []
        
        if editWordListType == .collected {
            for word in words {
                guard word.isSelected else { continue }
                
                var collectWord = CollectWord()
                collectWord.wordId = "\(word.wordId ?? 0)"
                collectWord.isComplexWord = word.isSelected ? 1 : 0
                collectWords.append(collectWord)
            }
            
            guard collectWords.count > 0, let cancleCollectWordInfoString = collectWords.toJSONString(), cancleCollectWordInfoString.isEmpty == false else { return }
            
            let request = YXWordListRequest.cancleCollectWord(wordIds: cancleCollectWordInfoString)
            YYNetworkService.default.request(YYStructResponse<YXResultModel>.self, request: request, success: { (response) in
              
            }) { (error) in
                
            }
            
        } else {
            var wrongWordIds: [Int] = []

            for word in words {
                guard word.isSelected else { continue }
                wrongWordIds.append(word.wordId ?? 0)
            }
            
            guard wrongWordIds.count > 0, let wrongWordIdsData = try? JSONSerialization.data(withJSONObject: wrongWordIds, options: .prettyPrinted), let string = String(data: wrongWordIdsData, encoding: .utf8) else { return }
            
            let request = YXWordListRequest.deleteWrongWord(wordIds: string)
            YYNetworkService.default.request(YYStructResponse<YXResultModel>.self, request: request, success: { (response) in
              
            }) { (error) in
                
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        bottonViewHeight.constant = bottonViewHeight.constant + kSafeBottomMargin
        
        tableView.register(UINib(nibName: "YXWordListEditCell", bundle: nil), forCellReuseIdentifier: "YXWordListEditCell")

        if editWordListType == .collected {
            title = "收藏夹"
            headerLabel.text = "请选择想取消收藏的单词"
            redButton.setTitle("取消收藏", for: .normal)
            
        } else {
            title = "熟识的单词"
            headerLabel.text = "请选择想删除的熟识的单词"
            redButton.setTitle("清除", for: .normal)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        redButton.setTitleColor(UIColor.hex(0xFF532B), for: .normal)
        bottomView.layer.setDefaultShadow()
    }
       
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return words.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "YXWordListEditCell", for: indexPath) as! YXWordListEditCell
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
            cell.meaningLabelMask.image = nil
            
        } else {
            cell.meaningLabelMask.image = #imageLiteral(resourceName: "wordListMask")
        }
        
        cell.removeMaskClosure = {
            self.words[indexPath.row].hidePartOfSpeechAndMeanings = !self.words[indexPath.row].hidePartOfSpeechAndMeanings
            tableView.reloadRows(at: [indexPath], with: .none)
        }
        
        if word.isSelected {
            cell.selectButton.setImage(#imageLiteral(resourceName: "word_selected"), for: .normal)
            
        } else {
            cell.selectButton.setImage(nil, for: .normal)
        }
        
        cell.selectClosure = {
            self.words[indexPath.row].isSelected = !self.words[indexPath.row].isSelected
            tableView.reloadRows(at: [indexPath], with: .none)
            
            var count = 0
            for word in self.words {
                guard word.isSelected else { continue }
                
                count = count + 1
                self.wordCountLabel.text = "\(count)"
            }
        }
        
        return cell
    }
}
