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
        let button = UIButton(type: UIButton.ButtonType.custom)
        button.size = CGSize(width: AdaptSize(20), height: AdaptSize(20))
        button.setImage(UIImage(named: "collectWord")?.withRenderingMode(.alwaysOriginal), for: .normal)
        button.addTarget(self, action: #selector(collectWord(_:)), for: .touchUpInside)
//        button.widthAnchor.constraint(equalToConstant: AdaptSize(20)).isActive  = true
//        button.heightAnchor.constraint(equalToConstant: AdaptSize(20)).isActive = true
        
        let item = UIBarButtonItem(customView: button)
        return item
    }()
    lazy var feedbackItem: UIBarButtonItem = {
        let button = UIButton(type: UIButton.ButtonType.custom)
        button.size = CGSize(width: AdaptSize(20), height: AdaptSize(20))
        button.setImage(UIImage(named: "feedbackWord")?.withRenderingMode(.alwaysOriginal), for: .normal)
        button.addTarget(self, action: #selector(feedbackWord(_:)), for: .touchUpInside)
//        button.widthAnchor.constraint(equalToConstant: AdaptSize(20)).isActive  = true
//        button.heightAnchor.constraint(equalToConstant: AdaptSize(20)).isActive = true
        
        let item = UIBarButtonItem(customView: button)
        return item
    }()
    lazy var relearnWord: UIBarButtonItem = {
        let button = UIButton(type: UIButton.ButtonType.custom)
        button.size = CGSize(width: AdaptSize(20), height: AdaptSize(20))
        button.setImage(UIImage(named: "recordedIcon")?.withRenderingMode(.alwaysOriginal), for: .normal)
        button.addTarget(self, action: #selector(relearnWord(_:)), for: .touchUpInside)
//        button.widthAnchor.constraint(equalToConstant: AdaptSize(20)).isActive  = true
//        button.heightAnchor.constraint(equalToConstant: AdaptSize(20)).isActive = true
        let item = UIBarButtonItem(customView: button)
        return item
    }()
    
    @objc var wordId        = -1
    @objc var isComplexWord = 0
    var wordModel: YXWordModel?
    private var wordDetailView: YXWordDetailCommonView!

    override func handleData(withQuery query: [AnyHashable : Any]!) {
        self.wordId        = query["word_id"] as? Int ?? -1
        self.isComplexWord = query["is_complex_word"] as? Int ?? 0
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.bindProperty()
        self.requestWordDetail()
        self.requestWordCollectStatus()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationItem.setLeftBarButton(backButton, animated: true)
        self.navigationItem.setRightBarButtonItems([relearnWord, feedbackItem, collectionButton], animated: true)
        self.navigationController?.setNavigationBarHidden(false, animated: animated)
    }
    
    // MARK: ---- Event ----
    private func bindProperty() {
        NotificationCenter.default.addObserver(self, selector: #selector(updateRecordScore(_:)), name: YXNotification.kRecordScore, object: nil)
    }
    
    private func updateBarStatus() {
        guard let wordModel = self.wordModel else {
            return
        }
        if wordModel.listenScore > YXStarLevelEnum.three.rawValue {
            self.relearnWord.image = UIImage(named: "didRecordedIcon")?.withRenderingMode(.alwaysOriginal)
        } else {
            self.relearnWord.image = UIImage(named: "recordedIcon")?.withRenderingMode(.alwaysOriginal)
        }
    }
    
    // MARK: --- Notifcation ----
    @objc private func updateRecordScore(_ notification: Notification) {
        guard let userInfo = notification.userInfo as? [String:Int], let newScore: Int = userInfo["maxScore"] else {
            return
        }
        self.wordModel?.listenScore = newScore
        self.updateBarStatus()
    }
    
    // MARK: ---- Request ----
    /// 查询单词收藏状态
    private func requestWordCollectStatus() {
        let didCollectWordRequest = YXWordListRequest.didCollectWord(wordId: wordId)
        YYNetworkService.default.request(YYStructResponse<YXResultModel>.self, request: didCollectWordRequest, success: { (response) in
            if response.data?.didCollectWord == 1 {
                (self.collectionButton.customView as? UIButton)?.setImage(#imageLiteral(resourceName: "unCollectWord"), for: .normal)
            } else {
                (self.collectionButton.customView as? UIButton)?.setImage(#imageLiteral(resourceName: "collectWord"), for: .normal)
            }
        }) { error in
            YXLog("查询单词:\(self.wordId)收藏状态失败， error:\(error)")
            YXUtils.showHUD(kWindow, title: error.message)
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
            YXLog("查询单词:\(self.wordId)详情失败， error:\(error)")
            YXUtils.showHUD(kWindow, title: error.message)
        }
    }
    
    // MARK: ---- Event ----
    
    @objc private func back(_ sender: UIBarButtonItem) {
        navigationController?.popViewController(animated: true)
    }
    
    @objc private func collectWord(_ sender: UIBarButtonItem) {
        if (self.collectionButton.customView as? UIButton)?.currentImage == #imageLiteral(resourceName: "unCollectWord") {
            let request = YXWordListRequest.cancleCollectWord(wordIds: "[{\"w\":\(wordId),\"is\":\(isComplexWord)}]")
            YYNetworkService.default.request(YYStructResponse<YXResultModel>.self, request: request, success: { (response) in
                (self.collectionButton.customView as? UIButton)?.setImage(#imageLiteral(resourceName: "collectWord"), for: .normal)
                UIView.toast("取消收藏")
            }) { error in
                YXLog("取消收藏单词:\(self.wordId)失败， error:\(error)")
            }
        } else {
            let request = YXWordListRequest.collectWord(wordId: wordId, isComplexWord: isComplexWord)
            YYNetworkService.default.request(YYStructResponse<YXResultModel>.self, request: request, success: { (response) in
                (self.collectionButton.customView as? UIButton)?.setImage(#imageLiteral(resourceName: "unCollectWord"), for: .normal)
                UIView.toast("已收藏")
            }) { error in
                YXLog("收藏单词:\(self.wordId)失败， error:\(error)")
                YXUtils.showHUD(kWindow, title: error.message)
            }
        }
    }
    
    @objc private func feedbackWord(_ sender: UIBarButtonItem) {
        YXLog("单词详情VC中点击反馈按钮")
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
