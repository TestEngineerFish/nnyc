//
//  YXWordListViewController.swift
//  YXEDU
//
//  Created by Jake To on 12/9/19.
//  Copyright © 2019 shiji. All rights reserved.
//

import UIKit

enum YXWordListType: Int {
    case learned = 0
    case notLearned = 1
    case collected = 2
    case wrongWords = 3
}

class YXWordListViewController: UIViewController, BPSegmentDataSource {

    var wordListType: YXWordListType = .learned

    private var wordListControllerView: BPSegmentControllerView!
    private var wordListHeaderViews: [UIView] = {
        var views: [UIView] = []
        
        for index in 1...4 {
            let view = UIView()
            view.backgroundColor = UIColor.orange1
            
            let label = UILabel()
            label.tag = 1
            label.font = UIFont.systemFont(ofSize: 15, weight: .medium)
            label.textColor = .white
            switch index {
            case 1:
                label.text = "已学词"
                break
                
            case 2:
                label.text = "未学词"
                break
                
            case 3:
                label.text = "收藏夹"
                break
                
            case 4:
                label.text = "错词本"
                break
                
            default:
                break
            }
            
            view.addSubview(label)
            label.snp.makeConstraints { (make) in
                make.center.equalToSuperview()
            }
            
            views.append(view)
        }
        
        return views
    }()
    
    private var wordListViews: [YXWordListView?] = [nil, nil, nil, nil]
    
    @IBAction func back(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    
    override func handleData(withQuery query: [AnyHashable : Any]!) {
        self.wordListType = (query["type"] as? YXWordListType) ?? .learned
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        var config = BPSegmentConfig(headerHeight: 44, headerItemSize: CGSize(width: screenWidth / 4, height: 44), headerItemSpacing: 0, contentItemSize: CGSize(width: screenWidth, height: screenHeight - kNavHeight - 44), contentItemSpacing: 0, firstIndexPath: IndexPath(item: wordListType.rawValue, section: 0))
        config.headerBackgroundColor  = UIColor.orange1
        config.contentBackgroundColor = UIColor.orange1
        wordListControllerView = BPSegmentControllerView(config, frame: CGRect(x: 0, y: 0, width: screenWidth, height: screenHeight - kNavHeight))
        wordListControllerView.delegate = self
        wordListControllerView.reloadData()
        
        self.view.addSubview(wordListControllerView)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(false, animated: animated)

        self.navigationController?.navigationBar.barTintColor = UIColor.orange1
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white, NSAttributedString.Key.font : UIFont.boldSystemFont(ofSize: 18)]
        self.navigationController?.navigationBar.tintColor = UIColor.white
        
        if wordListType == .collected {
            wordListControllerView.selectItem(with: IndexPath(item: 2, section: 0))
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)

        self.navigationController?.navigationBar.barTintColor = UIColor.white
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.black]
        self.navigationController?.navigationBar.tintColor = UIColor.black
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "EditWordList" {
            let editWordListViewController = segue.destination as! YXEditWordListViewController
            
            switch wordListType {
            case .collected:
                editWordListViewController.editWordListType = .collected
                
                var words: [YXWordModel] = []
                for var word in wordListViews[2]?.words ?? [] {
                    word.hidePartOfSpeechAndMeanings = true
                    words.append(word)
                }
                
                editWordListViewController.words = words
                editWordListViewController.redClosure = { indexs in
                    var sordedIndex = indexs
                    sordedIndex.sort() { $0 > $1 }
                    
                    for index in sordedIndex {
                        self.wordListViews[2]?.words.remove(at: index)
                    }
                }
                
            case .wrongWords:
                editWordListViewController.editWordListType = .familiar
                
                var words: [YXWordModel] = []
                for var word in wordListViews[3]?.wrongWordList?.familiarList ?? [] {
                    word.hidePartOfSpeechAndMeanings = true
                    words.append(word)
                }
                
                editWordListViewController.words = words
                editWordListViewController.redClosure = { indexs in
                    var sordedIndex = indexs
                    sordedIndex.sort() { $0 > $1 }
                    
                    for index in sordedIndex {
                        self.wordListViews[3]?.wrongWordList?.familiarList!.remove(at: index)
                    }
                }
                
            default:
                break
            }
        }
    }
    
    
    
    // MARK: -
    func pagesNumber() -> Int {
        return wordListHeaderViews.count
    }
    
    func segment(_ segment: BPSegmentView, itemForRowAt indexPath: IndexPath) -> UIView {
        return wordListHeaderViews[indexPath.row]
    }
    
    func segment(_ segment: BPSegmentView, contentForRowAt indexPath: IndexPath) -> UIView {
        if wordListViews[indexPath.row] == nil {
            let wordListView = YXWordListView(frame: .zero)
            wordListView.editClosure = {
                self.performSegue(withIdentifier: "EditWordList", sender: self)
            }
            
            wordListView.showWordDetialClosure = { (wordId, isComplexWord) in
                let home = UIStoryboard(name: "Home", bundle: nil)
                let wordDetialViewController = home.instantiateViewController(withIdentifier: "YXWordDetailViewControllerNew") as! YXWordDetailViewControllerNew
                wordDetialViewController.wordId = wordId
                wordDetialViewController.isComplexWord = isComplexWord
                self.navigationController?.pushViewController(wordDetialViewController, animated: true)
            }
            
            switch indexPath.row {
            case 0, 1:
                self.wordListViews[indexPath.row] = wordListView
                self.wordListViews[indexPath.row]?.isWrongWordList = false
                self.wordListViews[indexPath.row]?.shouldShowEditButton = false
                self.wordListViews[indexPath.row]?.shouldShowBottomView = false
                
                let request = YXWordListRequest.wordList(type: indexPath.row + 1)
                YYNetworkService.default.request(YYStructDataArrayResponse<YXWordModel>.self, request: request, success: { (response) in
                    guard let learnedWords = response.dataArray else { return }
                    self.wordListViews[indexPath.row]?.words = learnedWords
                    
                }) { error in
                    self.wordListViews[indexPath.row]?.words = []
                    print("❌❌❌\(error)")
                }
                
            case 2:
                self.wordListViews[indexPath.row] = wordListView
                self.wordListViews[indexPath.row]?.isWrongWordList = false
                self.wordListViews[indexPath.row]?.shouldShowEditButton = true
                self.wordListViews[indexPath.row]?.shouldShowBottomView = false
                
                let request = YXWordListRequest.wordList(type: 0)
                YYNetworkService.default.request(YYStructDataArrayResponse<YXWordModel>.self, request: request, success: { (response) in
                    guard let learnedWords = response.dataArray else { return }
                    self.wordListViews[indexPath.row]?.words = learnedWords
                    
                }) { error in
                    self.wordListViews[indexPath.row]?.words = []
                    print("❌❌❌\(error)")
                }
                
            case 3:
                self.wordListViews[indexPath.row] = wordListView
                self.wordListViews[indexPath.row]?.isWrongWordList = true
                self.wordListViews[indexPath.row]?.shouldShowEditButton = false
                self.wordListViews[indexPath.row]?.shouldShowBottomView = true
                self.wordListViews[indexPath.row]?.startReviewClosure = {
                    let exerciseViewController = YXExerciseViewController()
                    exerciseViewController.dataType = .wrong
                    self.navigationController?.pushViewController(exerciseViewController, animated: true)
                }
                
                let request = YXWordListRequest.wrongWordList
                YYNetworkService.default.request(YYStructResponse<YXWrongWordListModel>.self, request: request, success: { (response) in
                    guard let wrongWordList = response.data else { return }
                    self.wordListViews[indexPath.row]?.wrongWordList = wrongWordList
                    
                }) { error in
                    self.wordListViews[indexPath.row]?.wrongWordList = nil
                    print("❌❌❌\(error)")
                }
                
            default:
                break
            }
        }
        
        return wordListViews[indexPath.row]!
    }
    
    func segment(didSelectRowAt indexPath: IndexPath, previousSelectRowAt preIndexPath: IndexPath) {
        switch indexPath.row {
        case 0:
            wordListType = .learned
            break
            
        case 1:
            wordListType = .notLearned
            break
            
        case 2:
            wordListType = .collected
            
            if wordListViews[2] != nil {
                let request = YXWordListRequest.wordList(type: 0)
                YYNetworkService.default.request(YYStructDataArrayResponse<YXWordModel>.self, request: request, success: { (response) in
                    guard let learnedWords = response.dataArray else { return }
                    
                    var newWords: [YXWordModel] = []
                    for var learnedWord in learnedWords {
                        for word in self.wordListViews[indexPath.row]?.words ?? [] {
                            if learnedWord.wordId == word.wordId {
                                learnedWord.hidePartOfSpeechAndMeanings = word.hidePartOfSpeechAndMeanings
                            }
                        }
                                            
                        newWords.append(learnedWord)
                    }
                    
                    self.wordListViews[indexPath.row]?.words = newWords
                    
                    let orderType = self.wordListViews[indexPath.row]?.orderType ?? .default
                    self.wordListViews[indexPath.row]?.orderType = orderType
                    
                }) { error in
                    self.wordListViews[indexPath.row]?.words = []
                    print("❌❌❌\(error)")
                }
            }
            break
            
        case 3:
            wordListType = .wrongWords
            break
            
        default:
            break
        }
        
        for index in 0..<wordListHeaderViews.count {
            let label = wordListHeaderViews[index].viewWithTag(1) as! UILabel

            if index == indexPath.row {
                label.textColor = .white
                
            } else {
                label.textColor = UIColor.hex(0xFFD99E)
            }
        }
    }
}
