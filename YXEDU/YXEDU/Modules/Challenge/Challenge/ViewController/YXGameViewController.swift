//
//  YXGameViewController.swift
//  YXEDU
//
//  Created by 沙庭宇 on 2019/12/14.
//  Copyright © 2019 shiji. All rights reserved.
//

import UIKit

protocol YXGameViewControllerProtocol: NSObjectProtocol {
    func disableView()
    func switchQuestion()
    func skipQuestion()
    func startGame()
    func showResultView()
}

class YXGameViewController: YXViewController, YXGameViewControllerProtocol {

    var gameModel: YXGameModel?
    var gameResultMode: YXGameResultModel?
    var currentQuestionIndex = 0
    var gameLineId: Int?
    var lastTimestamp = 0 //最后一次退到后台的时间戳

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

    deinit {
        NotificationCenter.default.removeObserver(self)
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
        NotificationCenter.default.addObserver(self, selector: #selector(didEnterBackground), name: UIApplication.didEnterBackgroundNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(willEnterForeground), name: UIApplication.willEnterForegroundNotification, object: nil)
    }

    @objc private func didEnterBackground() {
        let request = YXRegisterAndLoginRequest.userInfomation
        YYNetworkService.default.request(YYStructResponse<YXUserInfomationModel>.self, request: request, success: { (response) in
            guard let time = response.time else { return }
            self.lastTimestamp = time
            self.stopTimer()
        }, fail: nil)

    }

    @objc private func willEnterForeground() {
        let request = YXRegisterAndLoginRequest.userInfomation
        YYNetworkService.default.request(YYStructResponse<YXUserInfomationModel>.self, request: request, success: { (response) in
            guard let time = response.time, self.lastTimestamp > 0 else { return }
            let timeOffline = time - self.lastTimestamp
            self.updateTimer(offSet: timeOffline)
        }, fail: { (error) in
            // 哪怕失败，也需要重新启动计时器
            self.updateTimer(offSet: 0)
        })
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
            make.height.equalTo(AdaptIconSize(60))
        }

        questionView.snp.makeConstraints { (make) in
            make.top.equalTo(headerView.snp.bottom)
            make.left.right.equalToSuperview()
            make.height.equalTo(AdaptIconSize(206))
        }
        answerView.snp.makeConstraints { (make) in
            make.left.right.bottom.equalToSuperview()
            make.top.equalTo(questionView.snp.bottom).offset(AdaptSize(isPad() ? 20 : 0))
        }

        headerView.backButton.addTarget(self, action: #selector(backAction), for: .touchUpInside)
    }

    // MARK: ==== Request ===
    private func requestData() {
        guard let gameLineId = self.gameLineId else {
            return
        }
        let request = YXChallengeRequest.playGame(gameId: gameLineId)
        YYNetworkService.default.request(YYStructResponse<YXGameModel>.self, request: request, success: { (response) in
            self.gameModel = response.data
            self.bindData()
        }) { (error) in
            YXUtils.showHUD(kWindow, title: error.message)
        }
    }

    private func requestReport(_ version: Int, total time: Int, question number: Int) {
        YXLog("游戏：上报 版本:\(version), 总时长:\(time)，答对问题数:\(number)")
        let request = YXChallengeRequest.report(version: version, totalTime: time, number: number)
        YYNetworkService.default.request(YYStructResponse<YXGameResultModel>.self, request: request, success: { (response) in
            self.gameResultMode                 = response.data
            self.gameResultMode?.consumeTime    = time
            self.gameResultMode?.questionNumber = number
            if number > 0 {
                if let model = self.gameResultMode {
                    self.resultView.showSuccessView(model)
                    DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 3.0) { [weak self] in
                        guard let self = self else { return }
                        self.resultView.closeView()

                        let shareVC = YXShareViewController()
                        shareVC.shareType   = .challengeResult
                        shareVC.gameModel   = model
                        shareVC.backAction  = {
                            YRRouter.popViewController(2, animated: true)
                        }
                        shareVC.hidesBottomBarWhenPushed = true
                        NotificationCenter.default.removeObserver(self)
                        YRRouter.sharedInstance().currentNavigationController()?.pushViewController(shareVC, animated: true)
                    }
                }
            } else {
                self.resultView.showFailView {
                    self.resultView.closeView()
                    self.navigationController?.popViewController(animated: true)
                }
            }
        }) { (error) in
            YXUtils.showHUD(kWindow, title: error.message)
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
        alertView.titleLabel.text       = "提示"
        alertView.descriptionLabel.text = "挑战尚未完成，是否退出并放弃本次挑战？"
        alertView.leftButton.setTitle("确定退出", for: .normal)
        alertView.rightOrCenterButton.setTitle("继续挑战", for: .normal)
        alertView.cancleClosure = {
            YXLog("游戏：返回首页")
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
            questionView.bindData(wordModel, timeout: config.timeOut)
            answerView.bindData(wordModel)
            currentQuestionIndex += 1
            YXLog("当前挑战的单词：", wordModel.word, "ID：", wordModel.wordId)
        } else {
            // 显示结果视图
            self.showResultView()
        }
    }

    private func stopTimer() {
        self.headerView.stopTimer()
        self.questionView.stopTimer()
    }

    private func updateTimer(offSet time: Int) {
        self.headerView.consumeTime   += time * 1000
        self.questionView.consumeTime += time * 1000
        self.headerView.startTimer()
        self.questionView.startTimer()
    }

    // MARK: ==== YXGameViewControllerProtocol ====

    func disableView() {
        self.answerView.isUserInteractionEnabled = false
    }

    func switchQuestion() {
        YXLog("游戏：切图")
        self.headerView.addQuestionNumber()
        self.showNextQuestion(true)
        self.answerView.isUserInteractionEnabled = true
    }

    func skipQuestion() {
        YXLog("游戏：跳过")
        self.showNextQuestion(false)
    }

    func startGame() {
        YXLog("游戏：开始")
        self.headerView.startTimer()
        self.questionView.restartTimer()
    }

    func showResultView() {
        guard let version = self.gameLineId else {
            return
        }
        YXLog("游戏：展示结果")
        let result = self.headerView.getTimeAndQuestionNumber()
        self.headerView.timer?.invalidate()
        self.questionView.timer?.invalidate()
        self.answerView.isUserInteractionEnabled = false
        self.requestReport(version, total: result.0, question: result.1)
    }
}
