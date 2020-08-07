//
//  YXWordDetailViewController.swift
//  YXEDU
//
//  Created by Jake To on 11/12/19.
//  Copyright © 2019 shiji. All rights reserved.
//

import UIKit

class YXWordDetailViewControllerNew: YXViewController {
    
    @objc var wordId        = -1
    @objc var isComplexWord = 0
    var wordModel: YXWordModel?
    private var wordDetailView: YXWordDetailCommonView?

    override func handleData(withQuery query: [AnyHashable : Any]!) {
        self.wordId        = query["word_id"] as? Int ?? -1
        self.isComplexWord = query["is_complex_word"] as? Int ?? 0
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.bindProperty()
        self.requestWordDetail()
    }

    deinit {
        NotificationCenter.default.removeObserver(self, name: YXNotification.kRecordScore, object: nil)
    }
    
    // MARK: ---- Event ----
    private func bindProperty() {
        self.title = "单词列表"
        NotificationCenter.default.addObserver(self, selector: #selector(updateRecordScore(_:)), name: YXNotification.kRecordScore, object: nil)
    }
    
    // MARK: --- Notifcation ----
    @objc private func updateRecordScore(_ notification: Notification) {
        guard let userInfo = notification.userInfo as? [String:Int], let newScore: Int = userInfo["maxScore"] else {
            return
        }
        self.wordModel?.listenScore = newScore
    }
    
    // MARK: ---- Request ----
    /// 查询单词详情
    private func requestWordDetail() {
        YXUtils.showHUD(self.view)
        let wordDetailRequest = YXWordBookRequest.wordDetail(wordId: wordId, isComplexWord: isComplexWord)
        YYNetworkService.default.request(YYStructResponse<YXWordModel>.self, request: wordDetailRequest, success: { [weak self] (response) in
            guard let self = self, var word = response.data else { return }
            YXUtils.hideHUD(self.view)
            word.isComplexWord  = self.isComplexWord
            self.wordModel      = word
            self.wordDetailView = YXWordDetailCommonView(frame: CGRect(x: 0, y: kNavHeight, width: screenWidth, height: screenHeight - kNavHeight), word: word)
            self.view.addSubview(self.wordDetailView!)
        }) { [weak self] error in
            guard let self = self else { return }
            YXUtils.hideHUD(self.view)
            YXLog("查询单词:\(self.wordId)详情失败， error:\(error)")
            YXUtils.showHUD(nil, title: error.message)
        }
    }
}
