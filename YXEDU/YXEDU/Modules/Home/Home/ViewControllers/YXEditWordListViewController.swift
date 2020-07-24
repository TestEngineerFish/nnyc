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
    var wordId: Int?
    var isComplexWord: Int?
    
    init() {}
    
    init?(map: Map) {
        self.mapping(map: map)
    }
    
    mutating func mapping(map: Map) {
        wordId        <- map["w"]
        isComplexWord <- map["is"]
    }
}

class YXEditWordListViewController: YXViewController, YXWordListEditCellProtocol, UITableViewDelegate, UITableViewDataSource {

    var editWordListType: YXEditWordListType?
    var words: [YXWordModel] = []
    
    @IBOutlet weak var headerLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var wordCountLabel: UILabel!
    @IBOutlet weak var redButton: YXDesignableButton!
    @IBOutlet weak var bottomView: YXDesignableView!
    @IBOutlet weak var bottonViewHeight: NSLayoutConstraint!
    @IBOutlet weak var viewTopConstraint: NSLayoutConstraint!

    @IBAction func tapRedButton(_ sender: Any) {
        var collectWords: [CollectWord] = []
        
        if editWordListType == .some(.collected) {
            for index in 0..<words.count {
                let word = words[index]
                
                guard word.isSelected else { continue }
                var collectWord = CollectWord()
                collectWord.wordId = word.wordId ?? 0
                collectWord.isComplexWord = word.isSelected ? 1 : 0
                collectWords.append(collectWord)
            }
            
            guard collectWords.count > 0, let cancleCollectWordInfoString = collectWords.toJSONString(), cancleCollectWordInfoString.isEmpty == false else { return }
            
            let request = YXWordListRequest.cancleCollectWord(wordIds: cancleCollectWordInfoString)
            YYNetworkService.default.request(YYStructResponse<YXResultModel>.self, request: request, success: { [weak self] (response) in
                guard let self = self else { return }
                self.navigationController?.popViewController(animated: true)
            }) { error in
                YXUtils.showHUD(kWindow, title: error.message)
            }
            
        } else {
            var wrongWordIds: [Int] = []
            
            for index in 0..<words.count {
                let word = words[index]
                
                guard word.isSelected else { continue }
                wrongWordIds.append(word.wordId ?? 0)
            }
            
            guard wrongWordIds.count > 0, let wrongWordIdsData = try? JSONSerialization.data(withJSONObject: wrongWordIds, options: .prettyPrinted), let string = String(data: wrongWordIdsData, encoding: .utf8) else { return }
            
            let request = YXWordListRequest.deleteWrongWord(wordIds: string)
            YYNetworkService.default.request(YYStructResponse<YXResultModel>.self, request: request, success: { [weak self] (response) in
                guard let self = self else { return }
                self.navigationController?.popViewController(animated: true)
            }) { error in
                YXUtils.showHUD(kWindow, title: error.message)
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.customNavigationBar?.title = "收藏夹"
        self.viewTopConstraint.constant = kNavBarHeight
        bottonViewHeight.constant = bottonViewHeight.constant + kSafeBottomMargin
        
        tableView.register(UINib(nibName: "YXWordListEditCell", bundle: nil), forCellReuseIdentifier: "YXWordListEditCell")

        if editWordListType == .some(.collected) {
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
    }
       
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return words.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "YXWordListEditCell", for: indexPath) as? YXWordListEditCell else {
            return UITableViewCell()
        }
        let wordModel = words[indexPath.row]
        cell.delegate = self
        cell.setData(word: wordModel, indexPath: indexPath)
        return cell
    }

    // MARK: ==== YXWordListEditCellProtocol ====
    func selectCell(indexPath: IndexPath) {
        self.words[indexPath.row].isSelected = !self.words[indexPath.row].isSelected
        self.tableView.reloadData()

        var count = 0
        for word in self.words {
            if word.isSelected {
                count = count + 1
            }
            self.wordCountLabel.text = "\(count)"
        }
    }

    func removeMask(indexPath: IndexPath) {
        self.words[indexPath.row].hidePartOfSpeechAndMeanings = !self.words[indexPath.row].hidePartOfSpeechAndMeanings
        self.tableView.reloadData()
    }
}
