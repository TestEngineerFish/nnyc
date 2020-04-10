//
//  YXWordListViewController.swift
//  YXEDU
//
//  Created by Jake To on 12/9/19.
//  Copyright © 2019 shiji. All rights reserved.
//

import UIKit

enum YXWordListType: Int {
    case learned    = 0
    case notLearned = 1
    case collected  = 2
    case wrongWords = 3
    case reviewPlanDetail      = 4
    case reviewPlanShareDetail = 5

}

class YXWordListViewController: UIViewController, BPSegmentDataSource {

    var wordListType: YXWordListType = .learned
    var learnedTableView   = YXWordListView(frame: .zero)
    var notLearnTableView  = YXWordListView(frame: .zero)
    var collectedTableView = YXWordListView(frame: .zero)
    var wrongTableView     = YXWordListView(frame: .zero)

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
                label.text = "本书已学"
            case 2:
                label.text = "本书未学"
            case 3:
                label.text = "收藏夹"
            case 4:
                label.text = "错词本"
            default:
                break
            }
            
            view.addSubview(label)
            label.snp.makeConstraints { (make) in
                make.center.equalToSuperview()
            }
            
            let bottomView = YXDesignableView()
            bottomView.tag = 2
            bottomView.backgroundColor = .white
            bottomView.cornerRadius = 2
            
            view.addSubview(bottomView)
            bottomView.snp.makeConstraints { (make) in
                make.width.equalTo(50)
                make.height.equalTo(4)
                make.bottom.equalToSuperview().offset(-4)
                make.centerX.equalToSuperview()
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
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
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
        self.navigationController?.navigationBar.barStyle = .black
        self.navigationController?.setNavigationBarHidden(false, animated: animated)
        
        self.navigationController?.navigationBar.barTintColor = UIColor.orange1
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white, NSAttributedString.Key.font : UIFont.boldSystemFont(ofSize: 18)]
        self.navigationController?.navigationBar.tintColor = UIColor.white
        
        if wordListType == .collected {
            wordListControllerView.selectItem(with: IndexPath(item: 2, section: 0))
            
        } else if wordListType == .wrongWords {
            wordListControllerView.selectItem(with: IndexPath(item: 3, section: 0))
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.navigationBar.barStyle = .default

        self.navigationController?.navigationBar.barTintColor = UIColor.white
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.black]
        self.navigationController?.navigationBar.tintColor = UIColor.black
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "EditWordList" {
            let editWordListViewController = segue.destination as! YXEditWordListViewController
            var words: [YXWordModel] = []

            switch wordListType {
            case .collected:
                editWordListViewController.editWordListType = .collected
                
                for var word in wordListViews[2]?.words ?? [] {
                    word.hidePartOfSpeechAndMeanings = true
                    words.append(word)
                }
                                
            case .wrongWords:
                editWordListViewController.editWordListType = .familiar
                
                guard let wrongWordSectionData = wordListViews[3]?.wrongWordSectionData else { return }
                for sectionData in wrongWordSectionData {
                    
                    guard let key = sectionData.keys.first, key.contains("熟识的单词"), let wrongWords = sectionData.values.first else { continue }
                    for var word in wrongWords {
                        word.hidePartOfSpeechAndMeanings = true
                        words.append(word)
                    }
                }
            default:
                break
            }
            
            editWordListViewController.words = words
        }
    }

    // MARK: ---- Request ----
    /// 根据类型，获取单词列表
//    private func requestWordsList(_ type: YXWordListType, page: Int) {
//        ///因为后台定义的type和前端定义的顺序不一致
//        let requestType: Int = {
//            switch type {
//            case .learned:
//                return 1
//            case .notLearned:
//                return 2
//            case .collected:
//                return 0
//            case .wrongWords:
//                return 3
//            }
//        }()
//        // 错词本不在此请求
//        if requestType > 2 { return }
//        let request = YXWordListRequest.wordList(type: requestType, page: page)
////        YYNetworkService.default.request(YYStructResponse<YXWordListModel>.self, request: request, success: { [weak self] (response) in
//        YYNetworkService.default.request(YYStructDataArrayResponse<YXWordModel>.self, request: request, success: { [weak self] (response) in
//            guard let self = self, let wordsList = response.dataArray else { return }
//            self.wordListViews[type.rawValue]?.words += wordsList
//        }) { (error) in
//            YXUtils.showHUD(kWindow, title: error.message)
//        }
//    }

    /// 获取错词本单词列表
    private func requestWrongWordsList() {
        let request = YXWordListRequest.wrongWordList
        YYNetworkService.default.request(YYStructResponse<YXWrongWordListModel>.self, request: request, success: { (response) in
            guard let wrongWordList = response.data else { return }

            var wrongWordSectionData: [[String: [YXWordModel]]]?
            if let familiarList = wrongWordList.familiarList, familiarList.count > 0 {
                if wrongWordSectionData == nil {
                    wrongWordSectionData = []
                }
                wrongWordSectionData?.append(["熟识的单词（\(familiarList.count)）": familiarList])
            }

            if let recentWrongList = wrongWordList.recentWrongList, recentWrongList.count > 0 {
                if wrongWordSectionData == nil {
                    wrongWordSectionData = []
                }
                wrongWordSectionData?.append(["最近错词（\(recentWrongList.count)）": recentWrongList])
            }

            if let reviewList = wrongWordList.reviewList, reviewList.count > 0 {
                if wrongWordSectionData == nil {
                    wrongWordSectionData = []
                }
                wrongWordSectionData?.append(["待复习错词（\(reviewList.count)）": reviewList])
            }

            self.wordListViews[YXWordListType.wrongWords.rawValue]?.wrongWordSectionData = wrongWordSectionData
        }) { error in
            YXUtils.showHUD(kWindow, title: error.message)
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
            wordListView.editClosure = { [weak self] in
                self?.performSegue(withIdentifier: "EditWordList", sender: self)
            }
            switch indexPath.row {
            case 0:
                wordListView.shouldShowEditButton = false
                wordListView.shouldShowBottomView = false
                wordListView.type                 = .learned
                self.wordListViews[indexPath.row] = wordListView
                wordListView.requestWordsList(page: 1)
            case 1:
                wordListView.shouldShowEditButton = false
                wordListView.shouldShowBottomView = false
                wordListView.type                 = .notLearned
                self.wordListViews[indexPath.row] = wordListView
                wordListView.requestWordsList(page: 1)
            case 2:
                wordListView.shouldShowEditButton = true
                wordListView.shouldShowBottomView = false
                wordListView.type                 = .collected
                self.wordListViews[indexPath.row] = wordListView
                wordListView.requestWordsList(page: 1)
            case 3:
                wordListView.shouldShowEditButton = false
                wordListView.shouldShowBottomView = true
                wordListView.type                 = .wrongWords
                self.wordListViews[indexPath.row] = wordListView
                self.wordListViews[indexPath.row]?.startReviewClosure   = {
                    let exerciseViewController = YXExerciseViewController()
                    exerciseViewController.dataType = .wrong
                    self.navigationController?.pushViewController(exerciseViewController, animated: true)
                }
                self.requestWrongWordsList()
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
        case 1:
            wordListType = .notLearned
        case 2:
            wordListType = .collected
        case 3:
            wordListType = .wrongWords
        default:
            return
        }
        
        for index in 0..<wordListHeaderViews.count {
            let label = wordListHeaderViews[index].viewWithTag(1) as! UILabel
            let view = wordListHeaderViews[index].viewWithTag(2) as! YXDesignableView

            if index == indexPath.row {
                label.textColor = .white
                view.isHidden = false
                
            } else {
                label.textColor = UIColor.hex(0xFFD99E)
                view.isHidden = true
            }
        }
    }
}
