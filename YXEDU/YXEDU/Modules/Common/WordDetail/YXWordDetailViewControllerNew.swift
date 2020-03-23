//
//  YXWordDetailViewController.swift
//  YXEDU
//
//  Created by Jake To on 11/12/19.
//  Copyright © 2019 shiji. All rights reserved.
//

import UIKit

class YXWordDetailViewControllerNew: YXViewController {
    lazy var backButton: UIBarButtonItem = {
        let item = UIBarButtonItem(image: UIImage(named: "back")?.withRenderingMode(.alwaysOriginal), style: .plain, target: self, action: #selector(back(_:)))
        return item
    }()
    
    var collectionButton: UIButton = {
        let button = UIButton(type: UIButton.ButtonType.custom)
        button.size = CGSize(width: AdaptSize(30), height: AdaptSize(30))
        button.imageEdgeInsets = UIEdgeInsets(top: 4, left: 4, bottom: 4, right: 4)
        button.setImage(UIImage(named: "collectWord")?.withRenderingMode(.alwaysOriginal), for: .normal)
       return button
    }()
    
    var feedbackButton: UIButton = {
        let button = UIButton(type: UIButton.ButtonType.custom)
        button.size = CGSize(width: AdaptSize(30), height: AdaptSize(25))
        button.imageEdgeInsets = UIEdgeInsets(top: 4, left: 4, bottom: 4, right: 4)
        button.setImage(UIImage(named: "feedbackWord")?.withRenderingMode(.alwaysOriginal), for: .normal)
        return button
    }()

    var relearnButton: UIButton = {
        let button = UIButton(type: UIButton.ButtonType.custom)
        button.size = CGSize(width: AdaptSize(30), height: AdaptSize(30))
        button.imageEdgeInsets = UIEdgeInsets(top: 4, left: 4, bottom: 4, right: 14)
        button.setImage(UIImage(named: "recordedIcon")?.withRenderingMode(.alwaysOriginal), for: .normal)
        return button
    }()
    
    var rightBarView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.clear
        return view
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
        self.createSubviews()
        self.bindProperty()
        self.requestWordDetail()
        self.requestWordCollectStatus()
    }
    
    private func createSubviews() {
        self.customNavigationBar?.addSubview(rightBarView)
        rightBarView.addSubview(self.collectionButton)
        rightBarView.addSubview(self.feedbackButton)
        rightBarView.addSubview(self.relearnButton)
        rightBarView.snp.makeConstraints { (make) in
            make.centerY.equalToSuperview()
            make.width.equalTo(AdaptSize(104))
            make.height.equalTo(AdaptSize(30))
            make.right.equalToSuperview().offset(AdaptSize(-2))
        }
        collectionButton.snp.makeConstraints { (make) in
            make.left.centerY.equalToSuperview()
            make.width.height.equalTo(AdaptSize(30))
        }
        feedbackButton.snp.makeConstraints { (make) in
            make.left.equalTo(collectionButton.snp.right).offset(AdaptSize(2))
            make.centerY.equalToSuperview()
            make.width.height.equalTo(AdaptSize(30))
        }
        relearnButton.snp.makeConstraints { (make) in
            make.right.centerY.equalToSuperview()
            make.height.equalTo(AdaptSize(30))
            make.width.equalTo(AdaptSize(40))
        }
    }
    
    // MARK: ---- Event ----
    private func bindProperty() {
        self.title = "单词列表"
        self.collectionButton.addTarget(self, action: #selector(collectWord(_:)), for: .touchUpInside)
        self.feedbackButton.addTarget(self, action: #selector(feedbackWord(_:)), for: .touchUpInside)
        self.relearnButton.addTarget(self, action: #selector(relearnWord(_:)), for: .touchUpInside)
        NotificationCenter.default.addObserver(self, selector: #selector(updateRecordScore(_:)), name: YXNotification.kRecordScore, object: nil)
    }
    
    private func updateBarStatus() {
        guard let wordModel = self.wordModel else {
            return
        }
        if wordModel.listenScore > YXStarLevelEnum.three.rawValue {
            self.relearnButton.setImage(UIImage(named: "didRecordedIcon"), for: .normal)
        } else {
            self.relearnButton.setImage(UIImage(named: "recordedIcon"), for: .normal)
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
                self.collectionButton.setImage(#imageLiteral(resourceName: "unCollectWord"), for: .normal)
            } else {
                self.collectionButton.setImage(#imageLiteral(resourceName: "collectWord"), for: .normal)
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
            self.wordDetailView = YXWordDetailCommonView(frame: CGRect(x: 0, y: kNavHeight, width: screenWidth, height: screenHeight - kNavHeight), word: word)
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
        if self.collectionButton.currentImage == #imageLiteral(resourceName: "unCollectWord") {
            let request = YXWordListRequest.cancleCollectWord(wordIds: "[{\"w\":\(wordId),\"is\":\(isComplexWord)}]")
            YYNetworkService.default.request(YYStructResponse<YXResultModel>.self, request: request, success: { (response) in
                self.collectionButton.setImage(#imageLiteral(resourceName: "collectWord"), for: .normal)
                UIView.toast("取消收藏")
            }) { error in
                YXLog("取消收藏单词:\(self.wordId)失败， error:\(error)")
            }
        } else {
            let request = YXWordListRequest.collectWord(wordId: wordId, isComplexWord: isComplexWord)
            YYNetworkService.default.request(YYStructResponse<YXResultModel>.self, request: request, success: { (response) in
                self.collectionButton.setImage(#imageLiteral(resourceName: "unCollectWord"), for: .normal)
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
