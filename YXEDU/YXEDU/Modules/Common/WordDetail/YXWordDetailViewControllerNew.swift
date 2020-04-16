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
    }
    
    private func createSubviews() {
        self.customNavigationBar?.addSubview(rightBarView)
        rightBarView.snp.makeConstraints { (make) in
            make.centerY.equalToSuperview()
            make.width.equalTo(AdaptSize(104))
            make.height.equalTo(AdaptSize(30))
            make.right.equalToSuperview().offset(AdaptSize(-2))
        }
    }
    
    // MARK: ---- Event ----
    private func bindProperty() {
        self.title = "单词列表"
//        self.collectionButton.addTarget(self, action: #selector(collectWord(_:)), for: .touchUpInside)
//        self.feedbackButton.addTarget(self, action: #selector(feedbackWord(_:)), for: .touchUpInside)
//        self.relearnButton.addTarget(self, action: #selector(relearnWord(_:)), for: .touchUpInside)
        NotificationCenter.default.addObserver(self, selector: #selector(updateRecordScore(_:)), name: YXNotification.kRecordScore, object: nil)
    }
    
    private func updateBarStatus() {
        guard let wordModel = self.wordModel else {
            return
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
    
    @objc private func relearnWord(_ sender: UIBarButtonItem) {
        guard let wordModel = self.wordModel else {
            return
        }
        YXNewLearnView(wordModel: wordModel).show()
    }
    
}
