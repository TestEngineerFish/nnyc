//
//  YXWordListViewController.swift
//  YXEDU
//
//  Created by Jake To on 12/9/19.
//  Copyright © 2019 shiji. All rights reserved.
//

import UIKit

enum YXWordListType {
    case learned
    case notLearned
    case collected
    case wrongWords
}

class YXWordListViewController: UIViewController, BPSegmentDataSource {

    var wordListType: YXWordListType = .learned
    var wordId: Int!
    var isComplexWord: Int!
    
    private var learnedWords: [YXWordModel]!
    private var notLearnedWords: [YXWordModel]!
    private var collectedWords: [YXWordModel]!
    private var wrongWordList: YXWrongWordListModel!
    private var orderType: [YXWordListOrderType] = [.default, .default, .default, .default]

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
    private var wordListView: BPSegmentControllerView!
    
    @IBAction func back(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    
    override func handleData(withQuery query: [AnyHashable : Any]!) {
        self.wordListType = (query["type"] as? YXWordListType) ?? .learned
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        wordListView = BPSegmentControllerView(BPSegmentConfig(headerHeight: 44, headerItemSize: CGSize(width: screenWidth / 4, height: 44), headerItemSpacing: 0, contentItemSize: CGSize(width: screenWidth, height: screenHeight - kNavHeight - 44), contentItemSpacing: 0), frame: CGRect(x: 0, y: 0, width: screenWidth, height: screenHeight - kNavHeight))
        wordListView.delegate = self
        
        self.view.addSubview(wordListView)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.navigationController?.navigationBar.barTintColor = UIColor.orange1
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white, NSAttributedString.Key.font : UIFont.boldSystemFont(ofSize: 18)]
        self.navigationController?.navigationBar.tintColor = UIColor.white
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
                editWordListViewController.words = collectedWords ?? []
                editWordListViewController.redClosure = { indexs in
                    for index in indexs {
                        self.collectedWords.remove(at: index)
                    }
                    
                    self.wordListView.reloadData()
                }
                
            case .wrongWords:
                editWordListViewController.editWordListType = .familiar
                editWordListViewController.words = wrongWordList?.familiarList ?? []
                editWordListViewController.redClosure = { indexs in
                    for index in indexs {
                        guard let familiarList = self.wrongWordList.familiarList, index < familiarList.count - 1 else { continue }
                        self.wrongWordList.familiarList!.remove(at: index)
                    }
                    
                    self.wordListView.reloadData()
                }
                
            default:
                break
            }
            
        } else if segue.identifier == "WordDetail" {
            let wordDetailViewController = segue.destination as! YXWordDetailViewControllerNew
            wordDetailViewController.wordId = wordId
            wordDetailViewController.isComplexWord = isComplexWord
        }
    }
    
    
    
    // MARK: -
    func firstSelectedIndex() -> IndexPath? {
        switch wordListType {
        case .learned:
            return IndexPath(row: 0, section: 0)
            
        case .notLearned:
            return IndexPath(row: 1, section: 0)

        case .collected:
            return IndexPath(row: 2, section: 0)

        case .wrongWords:
            return IndexPath(row: 3, section: 0)
        }
    }
    
    
    func pagesNumber() -> Int {
        return wordListHeaderViews.count
    }
    
    func segment(_ segment: BPSegmentView, itemForRowAt indexPath: IndexPath) -> UIView {
        return wordListHeaderViews[indexPath.row]
    }
    
    func segment(_ segment: BPSegmentView, contentForRowAt indexPath: IndexPath) -> UIView {
        let wordListView = YXWordListView(frame: .zero)
        wordListView.editClosure = {
            self.performSegue(withIdentifier: "EditWordList", sender: self)
        }
        
        switch indexPath.row {
        case 0:
            if learnedWords == nil {
                let request = YXWordListRequest.wordList(type: 0)
                YYNetworkService.default.request(YYStructDataArrayResponse<YXWordModel>.self, request: request, success: { (response) in
                    guard let learnedWords = response.dataArray else { return }
                    self.learnedWords = learnedWords
                    wordListView.words = self.learnedWords
                    
                }) { error in
                    wordListView.words = []
                    print("❌❌❌\(error)")
                }
                
            } else {
                wordListView.words = learnedWords
            }
            
            wordListView.isWrongWordList = false
            wordListView.shouldShowEditButton = false
            wordListView.shouldShowBottomView = false
            wordListView.orderType = orderType[0]
            wordListView.orderClosure = { type in
                self.orderType[0] = type
            }
            
            break
            
        case 1:
            if notLearnedWords == nil {
                let request = YXWordListRequest.wordList(type: 1)
                YYNetworkService.default.request(YYStructDataArrayResponse<YXWordModel>.self, request: request, success: { (response) in
                    guard let notLearnedWords = response.dataArray else { return }
                    self.notLearnedWords = notLearnedWords
                    wordListView.words = self.notLearnedWords
                    
                }) { error in
                    wordListView.words = []
                    print("❌❌❌\(error)")
                }
                
            } else {
                wordListView.words = notLearnedWords
            }
            
            wordListView.isWrongWordList = false
            wordListView.shouldShowEditButton = false
            wordListView.shouldShowBottomView = false
            wordListView.orderType = orderType[1]
            wordListView.orderClosure = { type in
                self.orderType[1] = type
            }
            
            break
            
        case 2:
            if collectedWords == nil {
                let request = YXWordListRequest.wordList(type: 2)
                YYNetworkService.default.request(YYStructDataArrayResponse<YXWordModel>.self, request: request, success: { (response) in
                    guard let collectedWords = response.dataArray else { return }
                    self.collectedWords = collectedWords
                    wordListView.words = self.collectedWords
                    
                }) { error in
                    wordListView.words = []
                    print("❌❌❌\(error)")
                }
                
            } else {
                wordListView.words = collectedWords
            }
            
            wordListView.isWrongWordList = false
            wordListView.shouldShowEditButton = true
            wordListView.shouldShowBottomView = false
            wordListView.orderType = orderType[2]
            wordListView.orderClosure = { type in
                self.orderType[2] = type
            }
            
            break
            
        case 3:
            if wrongWordList == nil {
                let request = YXWordListRequest.wrongWordList
                YYNetworkService.default.request(YYStructResponse<YXWrongWordListModel>.self, request: request, success: { (response) in
                    guard let wrongWordList = response.data else { return }
                    self.wrongWordList = wrongWordList
                    wordListView.wrongWordList = self.wrongWordList
                    
                }) { error in
                    wordListView.wrongWordList = nil
                    print("❌❌❌\(error)")
                }
                
            } else {
                wordListView.wrongWordList = wrongWordList
            }
            
            wordListView.isWrongWordList = true
            wordListView.shouldShowEditButton = false
            wordListView.orderType = orderType[3]
            wordListView.orderClosure = { type in
                self.orderType[3] = type
            }
            
            wordListView.startReviewClosure = { exerciseResultModel in
                let exerciseViewController = YXExerciseViewController()
                exerciseViewController.dataType = .wrong
                self.navigationController?.pushViewController(exerciseViewController, animated: true)
            }
            
            break
            
        default:
            break
        }
        
        return wordListView
    }
    
    func segment(_ segment: BPSegmentView, didSelectRowAt indexPath: IndexPath, previousSelectRowAt preIndexPath: IndexPath) {
        switch indexPath.row {
        case 0:
            wordListType = .learned
            break
            
        case 1:
            wordListType = .notLearned
            break
            
        case 2:
            wordListType = .collected
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
