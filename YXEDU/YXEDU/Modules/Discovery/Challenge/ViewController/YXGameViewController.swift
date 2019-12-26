//
//  YXGameViewController.swift
//  YXEDU
//
//  Created by 沙庭宇 on 2019/12/14.
//  Copyright © 2019 shiji. All rights reserved.
//

import UIKit

protocol YXGameViewControllerProtocol: NSObjectProtocol {
    func switchQuestion()
    func skipQuestion()
    func startGame()
    func showResultView()
}

class YXGameViewController: YXViewController, YXGameViewControllerProtocol {

    var gameModel: YXGameModel?
    var gameResultMode: YXGameResultModel?
    var currentQuestionIndex = 0

    var launchView: YXGameLaunchView?
    var headerView   = YXGameHeaderView()
    var questionView = YXGameQuestionView()
    var answerView   = YXGameAnswerView()
    let resultView   = YXGameResultView()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.setSubviews()
        self.bindProperty()
        self.requestData()
    }

    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        self.headerView.timer?.invalidate()
        self.questionView.timer?.invalidate()
    }

    private func bindData() {
        guard let gameModel = self.gameModel, let config = gameModel.config else {
            return
        }
        self.showLaunchView(config)
        self.currentQuestionIndex = 0
        headerView.bindData(config)
        self.skipQuestion()
    }

    private func bindProperty() {
        self.headerView.vcDelegate   = self
        self.questionView.vcDelegate = self
        self.answerView.selectedWordView.vcDelegate = self
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

    private func requestReport(_ version: Int, total time: Double, question number: Int) {
        let request = YXChallengeRequest.report(version: version, totalTime: time, number: number)
        YYNetworkService.default.request(YYStructResponse<YXGameResultModel>.self, request: request, success: { (response) in
            self.gameResultMode                 = response.data
            self.gameResultMode?.consumeTime    = time
            self.gameResultMode?.questionNumber = number
            if number > 0 {
                self.resultView.showSuccessView(self.gameResultMode!)
                DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 3.0) {
                    self.resultView.closeView()
                    print("-----跳转----")
                    YRRouter.popViewController(false)
                    let shareVC = YXShareViewController()
                    shareVC.titleString = "挑战分享"
                    shareVC.shareType   = .challengeResult
                    shareVC.hidesBottomBarWhenPushed = true
                    YRRouter.sharedInstance()?.currentNavigationController()?.pushViewController(shareVC, animated: true)

                }
            } else {
                self.resultView.showFailView {
                    self.resultView.closeView()
                    self.navigationController?.popViewController(animated: true)
                }
            }
        }) { (error) in
            YXUtils.showHUD(self.view, title: "\(error)")
        }
    }

    // MARK: ==== Event ====

    private func showLaunchView(_ config: YXGameConfig) {
        launchView = YXGameLaunchView(config.totalTime)
        kWindow.addSubview(launchView!)
        launchView?.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        launchView?.delegate = self
    }

    @objc private func backAction() {
        let alertView = YXAlertView()
        alertView.titleLabel.text = "提示"
        alertView.descriptionLabel.text = "挑战尚未完成，是否退出并放弃本次挑战？"
        alertView.leftButton.setTitle("确定退出", for: .normal)
        alertView.rightOrCenterButton.setTitle("继续挑战", for: .normal)
        alertView.cancleClosure = {
            self.navigationController?.popViewController(animated: true)
        }
        alertView.show()
    }

    /// - Parameter isRecord: 上题是否回答正确,正确数是否增加1
    private func showNextQuestion(_ isRecord: Bool) {
        guard let gameModel = self.gameModel, let config = gameModel.config else {
            return
        }
        if self.currentQuestionIndex < gameModel.wordModelList.count {
            let wordModel = gameModel.wordModelList[currentQuestionIndex]
            questionView.bindData(wordModel, timeout: Double(config.timeOut))
            answerView.bindData(wordModel)
            currentQuestionIndex += 1
        } else {
            // 显示结果视图
            self.showResultView()
        }
    }

    // MARK: ==== YXGameViewControllerProtocol ====
    func switchQuestion() {
        self.headerView.addQuestionNumber()
        self.showNextQuestion(true)
    }

    func skipQuestion() {
        self.showNextQuestion(false)
    }

    func startGame() {
        self.headerView.startTimer()
        self.questionView.restartTimer()
    }

    func showResultView() {
        guard let gameModel = self.gameModel, let config = gameModel.config else {
            return
        }
        let result = self.headerView.getTimeAndQuestionNumber()
        self.headerView.timer?.invalidate()
        self.questionView.timer?.invalidate()
        self.answerView.isUserInteractionEnabled = false
        self.requestReport(config.version, total: result.0, question: result.1)
    }
}
