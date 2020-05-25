//
//  YXNewLearnAnswerView.swift
//  YXEDU
//
//  Created by 沙庭宇 on 2019/11/4.
//  Copyright © 2019 shiji. All rights reserved.
//

import UIKit
import Lottie

protocol YXNewLearnProtocol: NSObjectProtocol {
    /// 单词和例句播放结束
    func playWordAndExampleFinished()
    /// 单词和单词播放结束
    func playWordAndWordFinished()
    /// 显示单词详情
    func showNewLearnWordDetail()
    /// 禁用底部所有按钮
    func disableAllButton()
    /// 启用底部所有按钮
    func enableAllButton()
}

enum YXStarLevelEnum: Int {
    case zero  = 0
    case one   = 20
    case two   = 30
    case three = 60
    
    static func getStarNum(_ score: Int) -> Int {
        if score > self.three.rawValue {
            return 3
        } else if score > self.two.rawValue {
            return 2
        } else if score > self.one.rawValue {
            return 1
        } else {
            return 0
        }
    }
}

/// 答题区状态
enum AnswerStatus: Int {
    case normal                         = -1  //初始状态
    case playingWordInFristStage        = 0   // 第一阶段单词播放中
    case playedWordInFristStage         = 1   // 第一阶段单词播放结束
    case playingExampleInFristStage     = 2   // 第一阶段例句播放中
    case playedExampleInFristStage      = 3   // 第一阶段例句播放结束
    case playingFirstWordInSecondStage  = 4   // 第二阶段第一遍单词播放中
    case playedFirstWordInSecondStage   = 5   // 第二阶段第一遍单词播放结束
    case playingSecondWordInSecondStage = 6   // 第二阶段第二遍单词播放中
    case playedSecondWordInSecondStage  = 7   // 第二阶段第二遍单词播放结束
    case showGuideView                  = 8   // 显示引导图
    case prepareRecord                  = 9   // 准备录音
    case recording                      = 10  // 录音中
    case reporting                      = 11  // 上报云知声中
    case showResult                     = 12  // 显示结果
    case alreadLearn                    = 13  // 已学习

    mutating func forward() {
        if self.rawValue < 13 {
            self = AnswerStatus(rawValue: self.rawValue + 1)!
        } else {
            self = .alreadLearn
        }
    }
}

class YXNewLearnAnswerView: YXBaseAnswerView, USCRecognizerDelegate {

    var playAudioButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "playAudio"), for: .normal)
        if isPad() {
            button.imageView?.snp.makeConstraints({ (make) in
                make.edges.equalToSuperview()
            })
        }
        return button
    }()

    var playAudioLabel: UILabel = {
        let label = UILabel()
        label.text          = "播放"
        label.textColor     = UIColor.black2
        label.font          = UIFont.pfSCRegularFont(withSize: AdaptFontSize(13))
        label.textAlignment = .center
        return label
    }()
    
    var starView: YXStarView = {
        let view = YXStarView()
        view.isHidden = true
        return view
    }()
    
    var recordAnimationView: AnimationView = {
        let animationView = AnimationView(name: "readAnimation")
        animationView.isHidden = true
        return animationView
    }()

    var recordAudioButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "recordAudio"), for: .normal)
        if isPad() {
            button.imageView?.snp.makeConstraints({ (make) in
                make.edges.equalToSuperview()
            })
        }
        return button
    }()

    lazy var recordAudioLabel: UILabel = {
        let label = UILabel()
        label.textColor     = UIColor.black2
        label.font          = UIFont.pfSCRegularFont(withSize: AdaptFontSize(13))
        label.textAlignment = .center
        label.text          = {
            if (self.exerciseModel.word?.listenScore ?? -1) != -1 {
                return "再次跟读"
            } else {
                return "跟读"
            }
        }()
        return label
    }()
    
    lazy var learnResultView = YXNewLearnResultView()

    var timer: Timer?
    var dotNumber = 0
    var enginer: USCRecognizer?
    var status       = AnswerStatus.normal
    var isNewLearn   = true
    var isReport     = false // 是否播完并通知
    var isViewPause  = false // 弹框，页面暂停播放
    var coin         = 0 // 跟读获得金币数
    var maxScore     = 0 // 最高得分
    var lastScore    = 0 // 最新得分
    // TODO: ---- 缓存重传机制
    var tempOpusData = Data() // 缓存当前录音
    var retryCount   = 0
    var retryPath    = {
        // 缓存录音本地地址
        return NSTemporaryDirectory() + "tmpData.opus"
    }()

    weak var newLearnDelegate: YXNewLearnProtocol?
    
    init(wordModel: YXWordModel?, exerciseModel: YXWordExerciseModel?) {
        if let exerciseModel = exerciseModel {
            super.init(exerciseModel: exerciseModel)
            self.isNewLearn = true
        } else {
            var exerciseModel = YXWordExerciseModel()
            exerciseModel.word = wordModel
            super.init(exerciseModel: exerciseModel)
            self.isNewLearn = false
        }
        // 云之声设置
//        self.enginer = USCRecognizer.sharedManager()
        USCRecognizer.sharedManager().setIdentifier(YXUserModel.default.uuid)
        USCRecognizer.sharedManager().delegate        = self
        USCRecognizer.sharedManager().vadControl      = true
        USCRecognizer.sharedManager().setVadFrontTimeout(5000, backTimeout: 700)
        
        self.recordAudioButton.isEnabled    = false
        self.recordAudioLabel.layer.opacity = 0.3

        NotificationCenter.default.addObserver(self, selector: #selector(didBecomeActiveNotification), name: UIApplication.didBecomeActiveNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(didEnterBackgroundNotification), name: UIApplication.didEnterBackgroundNotification, object: nil)
        // 新学跟读流程
        if self.isNewLearn {
            // 小学新学页面
            // 设置初始状态
            self.starView.isHidden              = true
            // 如果没有例句,则跳过第一阶段
            if (self.exerciseModel.word?.examples?.first?.english?.isEmpty ?? true) || self.exerciseModel.word?.imageUrl == nil {
                self.status = .playedExampleInFristStage
                self.newLearnDelegate?.playWordAndExampleFinished()
            }
            // 延迟播放.(因为在切题的时候会有动画)
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 1.2) { [weak self] in
                guard let self = self else { return }
                self.playByStatus()
            }
        } else {
            // 从单词详情进入
            if (self.exerciseModel.word?.listenScore ?? -1) != -1 {
                self.starView.isHidden      = false
                self.starView.layer.opacity = 0.3
            }
            self.status = .playingSecondWordInSecondStage
            self.playByStatus()
            self.starView.showLastNewLearnResultView(score: wordModel?.listenScore ?? 0)
        }
    }

    deinit {
        self.endRecordAction()
        self.timer?.invalidate()
        self.timer = nil
        USCRecognizer.sharedManager().delegate = nil
        YXLog("---- 移除")
        NotificationCenter.default.removeObserver(self)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func createSubviews() {
        super.createSubviews()
        self.addSubview(playAudioButton)
        self.addSubview(playAudioLabel)
        self.addSubview(starView)
        self.addSubview(recordAudioButton)
        self.addSubview(recordAudioLabel)
        self.addSubview(recordAnimationView)
        self.playAudioButton.snp.makeConstraints { (make) in
            make.top.equalTo(recordAudioButton)
            make.left.equalToSuperview().offset(AdaptSize(80))
            make.size.equalTo(CGSize(width: AdaptIconSize(56), height: AdaptIconSize(56)))
        }
        self.playAudioLabel.snp.makeConstraints { (make) in
            make.centerX.equalTo(playAudioButton)
            make.top.equalTo(playAudioButton.snp.bottom).offset(AdaptSize(8))
            make.size.equalTo(CGSize(width: AdaptSize(isPad() ? 110 : 100), height: AdaptSize(18)))
        }
        self.starView.snp.makeConstraints { (make) in
            make.top.equalToSuperview()
            make.centerX.equalTo(recordAudioButton)
            make.width.equalTo(AdaptIconSize(74))
            make.height.equalTo(AdaptIconSize(35))
        }
        self.recordAudioButton.snp.makeConstraints { (make) in
            make.top.equalTo(starView.snp.bottom)
            make.right.equalToSuperview().offset(AdaptSize(-80))
            make.size.equalTo(CGSize(width: AdaptIconSize(56), height: AdaptIconSize(56)))
        }
        self.recordAudioLabel.snp.makeConstraints { (make) in
            make.centerX.equalTo(recordAudioButton)
            make.top.equalTo(recordAudioButton.snp.bottom).offset(AdaptSize(8))
            make.width.equalTo(AdaptIconSize(70))
            make.height.equalTo(AdaptSize(18))
        }
        self.recordAnimationView.snp.makeConstraints { (make) in
            make.left.top.right.bottom.equalTo(self.recordAudioButton)
        }

        self.playAudioButton.addTarget(self, action: #selector(playButtonAction(_:)), for: .touchUpInside)
        self.recordAudioButton.addTarget(self, action: #selector(startRecordAction(_:)), for: .touchUpInside)
    }

    // MARK: ==== Event ====

    /// 点击播放按钮
    @objc private func playButtonAction(_ button: UIButton) {
        if self.status.rawValue > AnswerStatus.showGuideView.rawValue {
            self.playWord()
        }
    }

    /// 点击跟读按钮
    @objc private func startRecordAction(_ button: UIButton) {
        YXAuthorizationManager.authorizeMicrophoneWith { [weak self] (isAuth) in
            guard let self = self else { return }
            if isAuth {
                guard let word = self.exerciseModel.word?.word else {
                    return
                }
                USCRecognizer.sharedManager().oralText = word
                YXLog("开始录制")
                USCRecognizer.sharedManager().start()
                self.status = .recording
                self.disablePlayButton()
            } else {
                self.endRecordAction()
            }
        }
        YXAVPlayerManager.share.pauseAudio()
    }

    private func endRecordAction() {
        if self.status == .recording {
            USCRecognizer.sharedManager().stop()
            self.status = .alreadLearn
        }
    }

    /// 根据状态来播放
    func playByStatus() {
        YXLog("新学：当前状态：\(self.status)")
        switch self.status {
        case .normal:
            self.status.forward()
            self.playWord()
            YXLog("新学：初始状态")
        case .playingWordInFristStage:
            self.playWord()
            YXLog("新学：第一阶段 - 播放单词中")
        case .playedWordInFristStage:
            DispatchQueue.main.asyncAfter(deadline: .now()) {
                self.status.forward()
                self.playExample()
            }
            YXLog("新学：第一阶段 - 播放单词结束")
        case .playingExampleInFristStage:
            self.playExample()
            YXLog("新学：第一阶段 - 播放例句中")
        case .playedExampleInFristStage:
            self.newLearnDelegate?.playWordAndExampleFinished()
            DispatchQueue.main.asyncAfter(deadline: .now()) {
                self.status.forward()
                self.playWord()
            }
            YXLog("新学：第一阶段 - 播放例句结束")
        case .playingFirstWordInSecondStage:
            self.playWord()
            YXLog("新学：第二阶段 - 第一遍播放单词中")
        case .playedFirstWordInSecondStage:
            DispatchQueue.main.asyncAfter(deadline: .now()) { [weak self] in
                guard let self = self else { return }
                self.status.forward()
                self.playWord()
            }
            YXLog("新学：第二阶段 - 第一遍播放单词结束")
        case .playingSecondWordInSecondStage:
            self.playWord()
            YXLog("新学：第二阶段 - 第二遍播放单词中")
        case .playedSecondWordInSecondStage:
            self.status.forward()
            self.isReport = true
            self.autoPlayFinished()
            YXLog("新学：第二阶段 - 第二遍播放单词结束")
            self.hidePlayAnimation()
        default:
            if !self.isReport {
                self.autoPlayFinished()
            }
            break
        }
    }

    private func autoPlayFinished() {
        YXLog("新学：自动播放结束")
        self.newLearnDelegate?.playWordAndWordFinished()
        self.recordAudioButton.isEnabled     = true
        self.recordAudioLabel.layer.opacity  = 1.0
        self.recordAudioButton.layer.opacity = 1.0
    }

    /// 播放单词
    private func playWord() {
        guard let wordUrlStr = self.exerciseModel.word?.voice, let url = URL(string: wordUrlStr), !self.isViewPause else {
            self.status.forward()
            self.playByStatus()
            return
        }
        self.showPlayAnimation()
        YXAVPlayerManager.share.playAudio(url) { [weak self] in
            guard let self = self else { return }
            if self.status.rawValue < AnswerStatus.showGuideView.rawValue {
                self.status.forward()
                self.playByStatus()
            } else {
                self.hidePlayAnimation()
            }
        }
    }

    /// 播放例句
    /// - Parameter block: 完成回调
    private func playExample() {
        guard let exampleUrlStr = self.exerciseModel.word?.examples?.first?.vocie, let url = URL(string: exampleUrlStr), !self.isViewPause else {
            self.status.forward()
            self.playByStatus()
            return
        }
        self.showPlayAnimation()
        YXAVPlayerManager.share.playAudio(url) { [weak self] in
            guard let self = self else { return }
            if self.status.rawValue < AnswerStatus.showGuideView.rawValue {
                self.status.forward()
                self.playByStatus()
            } else {
                self.hidePlayAnimation()
            }
        }
    }
    
    /// 页面暂停
    func pauseView() {
        self.isViewPause = true
        self.hideRecordAnimation()
        YXAVPlayerManager.share.pauseAudio()
        YXAVPlayerManager.share.finishedBlock = nil
        if self.status == .recording {
            USCRecognizer.sharedManager().cancel()
        }
    }

    // 页面播放
    func startView() {
        self.isViewPause = false
        self.playByStatus()
    }
    
    // MARK: ---- 动画 ----

    /// 显示播放单词动画
    private func showPlayAnimation() {
        let animation = CABasicAnimation(keyPath: "opacity")
        animation.fromValue    = 1.0
        animation.toValue      = 0.5
        animation.duration     = 0.4
        animation.autoreverses = true
        animation.repeatCount  = MAXFLOAT
        self.playAudioButton.layer.add(animation, forKey: "flickerAnimation")

        timer?.invalidate()
        timer = Timer(timeInterval: 0.4, repeats: true, block: { (timer) in
            self.playAudioLabel.textAlignment = .left
            if self.status == .playingExampleInFristStage {
                self.playAudioLabel.textColor = UIColor.orange1
                switch self.dotNumber {
                case 0:
                    self.playAudioLabel.text = "    例句播放中"
                case 1:
                    self.playAudioLabel.text = "    例句播放中."
                case 2:
                    self.playAudioLabel.text = "    例句播放中.."
                default:
                    self.playAudioLabel.text = "    例句播放中..."
                }
            } else {
                self.playAudioLabel.textColor = UIColor.orange1
                switch self.dotNumber {
                case 0:
                    self.playAudioLabel.text = "    单词播放中"
                case 1:
                    self.playAudioLabel.text = "    单词播放中."
                case 2:
                    self.playAudioLabel.text = "    单词播放中.."
                default:
                    self.playAudioLabel.text = "    单词播放中..."
                }
            }
            self.dotNumber += 1
            self.dotNumber = self.dotNumber > 3 ? 0 : self.dotNumber
        })
        RunLoop.current.add(timer!, forMode: .common)
    }

    /// 隐藏播放单词动画
    private func hidePlayAnimation() {
        dotNumber = 0
        timer?.invalidate()
        self.playAudioLabel.text          = "播放"
        self.playAudioLabel.textAlignment = .center
        self.playAudioLabel.textColor     = UIColor.black2
        self.playAudioButton.layer.removeAllAnimations()
        if (self.exerciseModel.word?.listenScore ?? -1) != -1 {
            self.starView.layer.opacity = 1.0
        }
    }
    
    /// 禁用播放按钮
    private func disablePlayButton() {
        self.playAudioLabel.layer.opacity  = 0.3
        self.playAudioButton.isEnabled     = false
    }
    
    /// 启用播放按钮
    private func enablePlayButton() {
        self.playAudioLabel.layer.opacity  = 1.0
        self.playAudioButton.isEnabled     = true
    }
    
    /// 显示录音动画
    private func showRecordAnimation() {
        self.recordAudioButton.isHidden    = true
        self.recordAnimationView.isHidden  = false
        self.recordAudioLabel.text         = "请跟读"
        self.recordAudioLabel.textColor    = UIColor.orange1
        self.starView.isHidden             = true
        self.newLearnDelegate?.disableAllButton()
        self.recordAnimationView.play()
    }
    
    /// 隐藏录音动画
    private func hideRecordAnimation() {
        self.recordAudioButton.isHidden    = false
        self.recordAnimationView.isHidden  = true
        self.recordAudioLabel.text         = "再次跟读"
        self.recordAudioLabel.textColor    = UIColor.black2
        self.newLearnDelegate?.enableAllButton()
        self.recordAnimationView.stop()
    }
    
    /// 显示上报动画
    private func showReportAnimation() {
        self.status = .reporting
        self.learnResultView.showReportView()
    }
    
    // 隐藏上报动画
    private func hideReportAnimation() {
        self.learnResultView.hideReportView()
    }
    
    /// 显示结果动画
    private func showResultAnimation() {
        self.status = .showResult
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) { [weak self] in
            guard let self = self else { return }
            self.learnResultView.showResultView(self.lastScore, coin: self.coin)
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 3.0) { [weak self] in
            guard let self = self else { return }
            self.hideResultAnimation()
        }
    }

    /// 隐藏结果动画
    private func hideResultAnimation() {
        self.learnResultView.hideView()
        self.starView.isHidden = self.isNewLearn
        self.starView.showLastNewLearnResultView(score: self.maxScore)
        NotificationCenter.default.post(name: YXNotification.kRecordScore, object: nil, userInfo: ["maxScore":self.maxScore, "lastScore":self.lastScore])
        // 如果得分大于1，则直接显示单词详情页
        if self.lastScore > YXStarLevelEnum.two.rawValue {
            self.newLearnDelegate?.showNewLearnWordDetail()
        }
    }
    
    /// 显示网络错误视图
    private func showNetworkErrorAnimation() {
        self.endRecordAction()
        self.learnResultView.showNetworkErrorView()
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) { [weak self] in
            self?.learnResultView.hideView()
        }
    }

    // MARK: ==== Notification ====

    /// 进入后台, 停止播放音频和语音监听
    @objc private func didEnterBackgroundNotification() {
        YXLog("进入后台, 停止播放音频和语音监听")
        self.pauseView()
    }

    /// 从后台进入前台,
    @objc private func didBecomeActiveNotification() {
        if self.status == .showResult || self.status == .reporting {
            return
        }
        self.startView()
    }
    
    // MARK: ---- Request ----
    /// 上报当次跟读得分
    private func requestReportListenScore() {
        guard let wordId = self.exerciseModel.word?.wordId else {
            return
        }
        let request = YXExerciseRequest.reportListenScore(wordId: wordId, score: self.lastScore)
        YYNetworkService.default.request(YYStructResponse<YXListenScoreModel>.self, request: request, success: { [weak self] (response) in
            guard let self = self, let model = response.data else {
                return
            }
            self.coin     = model.coin
            self.maxScore = model.listenScore // 返回最高分，跟新本地得分
            self.hideReportAnimation()
            self.showResultAnimation()
        }) { (error) in
            self.showNetworkErrorAnimation()
            YXLog("上报跟读结果失败")
        }
    }

    // MARK: ==== 云知声SDK: USCRecognizerDelegate ====
    func oralEngineDidInit(_ error: Error!) {
        if error != nil {
            YXLog("初始化结束,错误内容: " + String(describing: error))
            self.showNetworkErrorAnimation()
        }
        return
    }

    func onBeginOral() {
        // 显示录音动画
        self.showRecordAnimation()
        YXAVPlayerManager.share.pauseAudio()
        self.resetOpusTempData()
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 5) { [weak self] in
            self?.endRecordAction()
        }
    }

    func onStopOral() {
        self.setCatchRecordOpus(opus: self.tempOpusData)
        self.hideRecordAnimation()
        self.enablePlayButton()
        self.showReportAnimation()
    }

    func onResult(_ result: String!, isLast: Bool) {
        if isLast {
            // 录音结束,清除临时录音缓存
            self.resetOpusTempData()
            let resultDict = result.convertToDictionary()
            guard let score = resultDict["score"] as? Double else {
                return
            }
            #if DEBUG
            YXUtils.showHUD(self, title: "当前得分: \(score)")
            #endif
            YXLog("============录音得分: \(score)")
            self.lastScore = Int(score)
            self.requestReportListenScore()
        }
    }

    func onEndOral(_ error: Error!) {
        guard let _ = error else {
            return
        }
        // 判断重试次数
        if self.retryCount < 3 {
            USCRecognizer.sharedManager().retry(withFilePath: self.retryPath)
            self.retryCount += 1
        } else {
            self.showNetworkErrorAnimation()
        }
    }

    func onVADTimeout() {
        return
    }

    func onUpdateVolume(_ volume: Int32) {
//        YXRecordAudioView.share.updateVolume(volume)
        return
    }

    func onRecordingBuffer(_ recordingData: Data!) {
        return
    }

    func onRecordingOpusBuffer(_ opusData: Data!) {
        // 存当前音频数据
        tempOpusData.append(opusData)
        return
    }

    func audioFileDidRecord(_ url: String!) {
        return
    }

    func onAsyncResult(_ url: String!) {
        return
    }

    func monitoringLifecycle(_ lifecycle: Int32, error: Error!) {
        return
    }

    // TODO: USC Tools

    private func setCatchRecordOpus(opus data: Data) {
        NSData(data: data).write(toFile: self.retryPath, atomically: true)
    }

    private func resetOpusTempData() {
        self.tempOpusData.removeAll()
        self.retryCount = 0
    }
}
