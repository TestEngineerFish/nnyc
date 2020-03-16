//
//  YXWordDetailViewController.swift
//  YXEDU
//
//  Created by Jake To on 11/12/19.
//  Copyright © 2019 shiji. All rights reserved.
//

import UIKit

class YXWordDetailViewControllerNew: UIViewController {
    lazy var backButton: UIBarButtonItem = {
        let item = UIBarButtonItem(image: UIImage(named: "back")?.withRenderingMode(.alwaysOriginal), style: .plain, target: self, action: #selector(back(_:)))
        return item
    }()
    lazy var collectionButton: UIBarButtonItem = {
        let item = UIBarButtonItem(image: UIImage(named: "collectWord")?.withRenderingMode(.alwaysOriginal), style: .plain, target: self, action: #selector(collectWord(_:)))
        return item
    }()
    lazy var feedbackItem: UIBarButtonItem = {
        let item = UIBarButtonItem(image: UIImage(named: "feedbackWord")?.withRenderingMode(.alwaysOriginal), style: .plain, target: self, action: #selector(feedbackWord(_:)))
        return item
    }()
    lazy var relearnWord: UIBarButtonItem = {
        let item = UIBarButtonItem(image: UIImage(named: "recordedIcon")?.withRenderingMode(.alwaysOriginal), style: .plain, target: self, action: #selector(relearnWord(_:)))
        return item
    }()
    
    @objc var wordId        = -1
    @objc var isComplexWord = 0
    var wordModel: YXWordModel?
    private var wordDetailView: YXWordDetailCommonView!

    override func handleData(withQuery query: [AnyHashable : Any]!) {
        self.wordId = query["word_id"] as? Int ?? -1
        self.isComplexWord = query["is_complex_word"] as? Int ?? 0
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.requestWordDetail()
        self.requestWordCollectStatus()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationItem.setLeftBarButton(backButton, animated: true)
        self.navigationItem.setRightBarButtonItems([relearnWord, feedbackItem, collectionButton], animated: true)
        self.navigationController?.setNavigationBarHidden(false, animated: animated)
    }
    
    private func updateBarStatus() {
        guard let wordModel = self.wordModel else {
            return
        }
        if wordModel.listenScore >= 0 {
            self.relearnWord.image = UIImage(named: "didRecordedIcon")
        } else {
            self.relearnWord.image = UIImage(named: "recordedIcon")
        }
    }
    
    // MARK: ---- Request ----
    /// 查询单词收藏状态
    private func requestWordCollectStatus() {
        let didCollectWordRequest = YXWordListRequest.didCollectWord(wordId: wordId)
        YYNetworkService.default.request(YYStructResponse<YXResultModel>.self, request: didCollectWordRequest, success: { (response) in
            if response.data?.didCollectWord == 1 {
                self.collectionButton.image = #imageLiteral(resourceName: "unCollectWord")
            } else {
                self.collectionButton.image = #imageLiteral(resourceName: "collectWord")
            }
        }) { error in
            DDLogInfo("查询单词:\(self.wordId)收藏状态失败， error:\(error)")
        }
    }
    
    /// 查询单词详情
    private func requestWordDetail() {
        let wordDetailRequest = YXWordBookRequest.wordDetail(wordId: wordId, isComplexWord: isComplexWord)
        YYNetworkService.default.request(YYStructResponse<YXWordModel>.self, request: wordDetailRequest, success: { [weak self] (response) in
            guard let self = self, var word = response.data else { return }
            word.isComplexWord  = self.isComplexWord
            self.wordModel      = word
            self.wordDetailView = YXWordDetailCommonView(frame: CGRect(x: 0, y: 0, width: screenWidth, height: screenHeight - kNavHeight), word: word)
            self.updateBarStatus()
            self.view.addSubview(self.wordDetailView)
        }) { error in
            DDLogInfo("查询单词:\(self.wordId)详情失败， error:\(error)")
        }
    }
    
    // MARK: ---- Event ----
    
    @objc private func back(_ sender: UIBarButtonItem) {
        navigationController?.popViewController(animated: true)
    }
    
    @objc private func collectWord(_ sender: UIBarButtonItem) {
        if self.collectionButton.image == #imageLiteral(resourceName: "unCollectWord") {
            let request = YXWordListRequest.cancleCollectWord(wordIds: "[{\"w\":\(wordId),\"is\":\(isComplexWord)}]")
            YYNetworkService.default.request(YYStructResponse<YXResultModel>.self, request: request, success: { (response) in
                self.collectionButton.image = #imageLiteral(resourceName: "collectWord")
                UIView.toast("取消收藏")
            }) { error in
                DDLogInfo("取消收藏单词:\(self.wordId)失败， error:\(error)")
            }
        } else {
            let request = YXWordListRequest.collectWord(wordId: wordId, isComplexWord: isComplexWord)
            YYNetworkService.default.request(YYStructResponse<YXResultModel>.self, request: request, success: { (response) in
                self.collectionButton.image = #imageLiteral(resourceName: "unCollectWord")
                UIView.toast("已收藏")
            }) { error in
                DDLogInfo("收藏单词:\(self.wordId)失败， error:\(error)")
            }
        }
    }
    
    @objc private func feedbackWord(_ sender: UIBarButtonItem) {
        DDLogInfo("单词详情VC中点击反馈按钮")
        YXLogManager.share.report()
        YXReportErrorView.show(to: kWindow, withWordId: NSNumber(integerLiteral: wordId), withWord: wordModel?.word ?? "")
    }
    
    @objc private func relearnWord(_ sender: UIBarButtonItem) {
        guard let wordModel = self.wordModel else {
            return
        }
        YXNewLearnView(wordModel: wordModel).show()
    }
    
}
