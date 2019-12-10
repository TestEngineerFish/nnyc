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
    
    private var learnedWords: [YXWordModel] = []
    private var notLearnedWords: [YXWordModel] = []
    private var collectedWords: [YXWordModel] = []
    private var wrongWords: [YXWordModel] = []

    private var wordListView: BPSegmentControllerView!
    
    @IBOutlet weak var bottomView: UIView!
    @IBOutlet weak var bottonViewHeight: NSLayoutConstraint!
    
    @IBAction func back(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        bottonViewHeight.constant = bottonViewHeight.constant + kSafeBottomMargin

        wordListView = BPSegmentControllerView(BPSegmentConfig(headerHeight: 44, headerItemSize: CGSize(width: screenWidth / 4, height: 44), headerItemSpacing: 0, contentItemSize: CGSize(width: screenWidth, height: screenHeight - kStatusBarHeight - kNavHeight - bottonViewHeight.constant - 44), contentItemSpacing: 0), frame: CGRect(x: 0, y: 0, width: screenWidth, height: screenHeight - kStatusBarHeight - kNavHeight - bottonViewHeight.constant))
        wordListView.delegate = self
        self.view.addSubview(wordListView)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: segue)
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
        return 4
    }
    
    func segment(_ segment: BPSegmentView, itemForRowAt indexPath: IndexPath) -> UIView {
        let view = UIView()
        view.backgroundColor = .clear
        
        let label = UILabel()
        switch indexPath.row {
        case 0:
            label.text = "已学词"
            break
            
        case 1:
            label.text = "未学词"
            break
            
        case 2:
            label.text = "收藏夹"
            break
            
        case 3:
            label.text = "错词本"
            break
            
        default:
            break
        }
        
        view.addSubview(label)
        label.snp.makeConstraints { (make) in
            make.center.equalToSuperview()
        }
        
        return view
    }
    
    func segment(_ segment: BPSegmentView, contentForRowAt indexPath: IndexPath) -> UIView {
        let view = YXWordListView(frame: .zero)
        
        return view
    }
}
