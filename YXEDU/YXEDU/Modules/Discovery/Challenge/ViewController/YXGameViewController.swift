//
//  YXGameViewController.swift
//  YXEDU
//
//  Created by 沙庭宇 on 2019/12/14.
//  Copyright © 2019 shiji. All rights reserved.
//

import UIKit

class YXGameViewController: YXViewController {

    var gameModel: YXGameModel?
    var currentQuestionIndex = 0

    var headerView   = YXGameHeaderView()
    var questionView = YXGameQuestionView()
    var answerView   = YXGameAnswerView()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.setSubviews()
        self.requestData()
    }

    private func bindData() {
        guard let gameModel = self.gameModel, let config = gameModel.config else {
            return
        }
        self.currentQuestionIndex = 0
        headerView.bindData(config)
        self.switchQuestionView()
    }

    private func setSubviews() {
        let backgroundImageView: UIImageView = {
            let imageView = UIImageView()
            imageView.image = UIImage(named: "gameBackground")
            return imageView
        }()
        self.view.addSubview(backgroundImageView)
        self.view.addSubview(headerView)
        self.view.addSubview(questionView)
        self.view.addSubview(answerView)

        backgroundImageView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        let top = iPhoneXLater ? 24 : 0
        headerView.snp.makeConstraints { (make) in
            make.left.right.equalToSuperview()
            make.top.equalToSuperview().offset(top)
            make.height.equalTo(AdaptSize(60))
        }

        questionView.snp.makeConstraints { (make) in
            make.top.equalTo(headerView.snp.bottom)
            make.left.right.equalToSuperview()
            make.bottom.equalTo(answerView.snp.top)
        }
        answerView.snp.makeConstraints { (make) in
            make.left.right.bottom.equalToSuperview()
            make.height.equalTo(AdaptSize(396) + kSafeBottomMargin)
        }

        headerView.backButton.addTarget(self, action: #selector(backAction), for: .touchUpInside)
    }

    // MARK: ==== Request ===
    private func requestData() {
        let request = YXChallengeRequest.playGame
        YYNetworkService.default.request(YYStructResponse<YXGameModel>.self, request: request, success: { (response) in
            self.gameModel = response.data
            self.bindData()
        }) { (error) in
            YXUtils.showHUD(self.view, title: "\(error)")
        }
    }

    // MARK: ==== Event ====
    private func switchQuestionView() {
        guard let gameModel = self.gameModel, self.currentQuestionIndex < gameModel.wordModelList.count else {
            return
        }
        
        let wordModel = gameModel.wordModelList[currentQuestionIndex]
        questionView.bindData(wordModel)
        answerView.bindData(wordModel)
        currentQuestionIndex += 1
    }

    @objc private func backAction() {
        self.navigationController?.popViewController(animated: true)
    }

}
