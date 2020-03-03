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
        return button
    }()

    var playAudioLabel: UILabel = {
        let label = UILabel()
        label.text          = "播放"
        label.textColor     = UIColor.black2
        label.font          = UIFont.pfSCRegularFont(withSize: AdaptSize(13))
        label.textAlignment = .center
        return label
    }()
    
    var recordAnimationView: AnimationView = {
        let animationView = AnimationView(name: "readAnimation")
        animationView.isHidden = true
        return animationView
    }()

    var recordAudioButton: YXButton = {
        let button = YXButton()
        button.setImage(UIImage(named: "recordAudio"), for: .normal)
        button.isEnabled     = false
        button.layer.opacity = 0.3
        return button
    }()

    var recordAudioLabel: UILabel = {
        let label = UILabel()
        label.text          = "跟读"
        label.textColor     = UIColor.black2
        label.font          = UIFont.pfSCRegularFont(withSize: AdaptSize(13))
        label.textAlignment = .center
        label.layer.opacity = 0.3
        return label
    }()
    
    lazy var learnResultView = YXNewLearnResultView()

    var timer: Timer?
    var dotNumber = 0
    var enginer: USCRecognizer?
    var status: AnswerStatus = .normal
    var lastLevel    = 0 // 最近一次跟读评分
    var isReport     = false // 是否播完并通知
    var isViewPause  = false // 弹框，页面暂停播放
    // TODO: ---- 缓存重传机制
    var tempOpusData = Data() // 缓存当前录音
    var retryCount   = 0
    var retryPath    = {
        // 缓存录音本地地址
        return NSTemporaryDirectory() + "tmpData.opus"
    }()

    weak var newLearnDelegate: YXNewLearnProtocol?

    override init(exerciseModel: YXWordExerciseModel) {
        super.init(exerciseModel: exerciseModel)
        // 如果没有例句,则跳过第一阶段
        if (exerciseModel.word?.examples?.first?.english?.isEmpty ?? true) || exerciseModel.word?.imageUrl == nil {
            self.status = .playedExampleInFristStage
            self.newLearnDelegate?.playWordAndExampleFinished()
        }
        // 云之声设置
        self.enginer = USCRecognizer.sharedManager()
        self.enginer?.setIdentifier(YXConfigure.shared()?.uuid)
        self.enginer?.delegate        = self
        self.enginer?.vadControl      = true
        self.enginer?.setVadFrontTimeout(5000, backTimeout: 700)
        
        NotificationCenter.default.addObserver(self, selector: #selector(didBecomeActiveNotification), name: UIApplication.didBecomeActiveNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(didEnterBackgroundNotification), name: UIApplication.didEnterBackgroundNotification, object: nil)
        // 延迟播放.(因为在切题的时候会有动画)
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 1.2) { [weak self] in
            guard let self = self else { return }
            self.playByStatus()
        }
    }

    deinit {
        self.endRecordAction()
        self.timer?.invalidate()
        self.timer = nil
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func createSubviews() {
        super.createSubviews()
        self.addSubview(playAudioButton)
        self.addSubview(playAudioLabel)
        self.addSubview(recordAudioButton)
        self.addSubview(recordAudioLabel)
        self.addSubview(recordAnimationView)
        self.playAudioButton.snp.makeConstraints { (make) in
            make.top.equalToSuperview()
            make.left.equalToSuperview().offset(AdaptSize(80))
            make.size.equalTo(CGSize(width: AdaptSize(56), height: AdaptSize(56)))
        }
        self.playAudioLabel.snp.makeConstraints { (make) in
            make.centerX.equalTo(playAudioButton)
            make.top.equalTo(playAudioButton.snp.bottom).offset(AdaptSize(8))
            make.size.equalTo(CGSize(width: AdaptSize(100), height: AdaptSize(18)))
        }
        self.recordAudioButton.snp.makeConstraints { (make) in
            make.top.equalToSuperview()
            make.right.equalToSuperview().offset(AdaptSize(-80))
            make.size.equalTo(CGSize(width: AdaptSize(56), height: AdaptSize(56)))
        }
        self.recordAudioLabel.snp.makeConstraints { (make) in
            make.centerX.equalTo(recordAudioButton)
            make.top.equalTo(recordAudioButton.snp.bottom).offset(AdaptSize(8))
            make.width.equalTo(AdaptSize(52))
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
                self.enginer?.oralText = word
                self.enginer?.start()
                self.disablePlayButton()
            } else {
                self.endRecordAction()
            }
        }
        YXAVPlayerManager.share.pauseAudio()
    }

    private func endRecordAction() {
        if self.status == .recording {
            self.enginer?.stop()
        }
    }

    /// 根据状态来播放
    func playByStatus() {
        DDLogInfo("新学：当前状态：\(self.status)")
        switch self.status {
        case .normal:
            self.showPlayAnimation()
            self.status.forward()
            self.playWord()
            DDLogInfo("新学：初始状态")
        case .playingWordInFristStage:
            self.playWord()
            DDLogInfo("新学：第一阶段 - 播放单词中")
        case .playedWordInFristStage:
            DispatchQueue.main.asyncAfter(deadline: .now()) {
                self.status.forward()
                self.playExample()
            }
            DDLogInfo("新学：第一阶段 - 播放单词结束")
        case .playingExampleInFristStage:
            self.playExample()
            DDLogInfo("新学：第一阶段 - 播放例句中")
        case .playedExampleInFristStage:
            self.showPlayAnimation()
            self.newLearnDelegate?.playWordAndExampleFinished()
            DispatchQueue.main.asyncAfter(deadline: .now()) {
                self.status.forward()
                self.playWord()
            }
            DDLogInfo("新学：第一阶段 - 播放例句结束")
        case .playingFirstWordInSecondStage:
            self.playWord()
            DDLogInfo("新学：第二阶段 - 第一遍播放单词中")
        case .playedFirstWordInSecondStage:
            DispatchQueue.main.asyncAfter(deadline: .now()) { [weak self] in
                guard let self = self else { return }
                self.status.forward()
                self.playWord()
            }
            DDLogInfo("新学：第二阶段 - 第一遍播放单词结束")
        case .playingSecondWordInSecondStage:
            self.playWord()
            DDLogInfo("新学：第二阶段 - 第二遍播放单词中")
        case .playedSecondWordInSecondStage:
            self.status.forward()
            self.isReport = true
            self.autoPlayFinished()
            DDLogInfo("新学：第二阶段 - 第二遍播放单词结束")
        default:
            if !self.isReport {
                self.autoPlayFinished()
            }
            break
        }
    }

    private func autoPlayFinished() {
        DDLogInfo("新学：自动播放结束")
        self.hidePlayAnimation()
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
        YXAVPlayerManager.share.playAudio(url) { [weak self] in
            guard let self = self else { return }
            if self.status.rawValue < AnswerStatus.showGuideView.rawValue {
                self.status.forward()
                self.playByStatus()
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
        YXAVPlayerManager.share.playAudio(url) { [weak self] in
            guard let self = self else { return }
            if self.status.rawValue < AnswerStatus.showGuideView.rawValue {
                self.status.forward()
                self.playByStatus()
            }
        }
    }
    
    /// 页面暂停
    func pauseView() {
        self.isViewPause = true
        YXAVPlayerManager.share.pauseAudio()
        YXAVPlayerManager.share.finishedBlock = nil
        if self.status == .recording {
            self.enginer?.cancel()
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
                    self.playAudioLabel.text = "   例句播放中"
                case 1:
                    self.playAudioLabel.text = "   例句播放中."
                case 2:
                    self.playAudioLabel.text = "   例句播放中.."
                default:
                    self.playAudioLabel.text = "   例句播放中..."
                }
            } else {
                self.playAudioLabel.textColor = UIColor.orange1
                switch self.dotNumber {
                case 0:
                    self.playAudioLabel.text = "   单词播放中"
                case 1:
                    self.playAudioLabel.text = "   单词播放中."
                case 2:
                    self.playAudioLabel.text = "   单词播放中.."
                default:
                    self.playAudioLabel.text = "   单词播放中..."
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
        self.playAudioLabel.text = "播放"
        self.playAudioLabel.textAlignment = .center
        self.playAudioLabel.textColor = UIColor.black2
        self.playAudioButton.layer.removeAllAnimations()
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
        self.recordAnimationView.play()
    }
    
    /// 隐藏录音动画
    private func hideRecordAnimation() {
        self.recordAudioButton.isHidden    = false
        self.recordAnimationView.isHidden  = true
        self.recordAnimationView.stop()
    }
    
    /// 显示上报动画
    private func showReportAnimation() {
        self.status = .reporting
        self.learnResultView.showReportView()
    }
    
    // 隐藏上报动画
    private func hideReportAnimation() {
        self.learnResultView.hideView()
    }
    
    /// 显示结果动画
    private func showResultAnimation() {
        self.status = .showResult
        self.learnResultView.showResultView(self.lastLevel)
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) { [weak self] in
            guard let self = self else { return }
            self.hideResultAnimation()
        }
    }

    /// 隐藏结果动画
    private func hideResultAnimation() {
        self.learnResultView.hideView()
        // 如果得分大于1，则直接显示单词详情页
        if self.lastLevel > 1 {
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
        //        print("进入后台, 停止播放音频和语音监听")
        self.pauseView()
    }

    /// 从后台进入前台,
    @objc private func didBecomeActiveNotification() {
        // 该做啥呢?问问产品吧
        if self.status == .showResult || self.status == .reporting {
            return
        }
        self.playByStatus()
    }

    // MARK: ==== 云知声SDK: USCRecognizerDelegate ====
    func oralEngineDidInit(_ error: Error!) {
        if error != nil {
            DDLogInfo("初始化结束,错误内容: " + String(describing: error))
            self.showNetworkErrorAnimation()
        }
        return
    }

    func onBeginOral() {
        // 显示录音动画
        self.status = .recording
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
        //        print("============录音结果: " + result)
        if isLast {
            self.lastLevel = 0
            // 录音结束,清除临时录音缓存
            self.resetOpusTempData()
            let resultDict = result.convertToDictionary()
            guard let score = resultDict["score"] as? Double else {
                return
            }
            //            YXUtils.showHUD(self, title: "当前得分: \(score)")
            self.lastLevel = {
                if score > 60 {
                    return 3
                } else if score > 30 {
                    return 2
                } else if score > 20 {
                    return 1
                } else {
                    return 0
                }
            }()
            // 显示结果动画
            self.exerciseModel.listenScore = self.lastLevel
            self.hideReportAnimation()
            self.showResultAnimation()
        }
    }

    func onEndOral(_ error: Error!) {
        guard let _ = error else {
            return
        }
        // 判断重试次数
        if self.retryCount < 3 {
            self.enginer?.retry(withFilePath: self.retryPath)
            self.retryCount += 1
        } else {
            self.showNetworkErrorAnimation()
        }
    }

    func onVADTimeout() {
        return
    }

    func onUpdateVolume(_ volume: Int32) {
        //        print("onUpdateVolume: \(volume)")
//        YXRecordAudioView.share.updateVolume(volume)
        //        print(volume)
        return
    }

    func onRecordingBuffer(_ recordingData: Data!) {
        //        print("录音数据: " + String(describing: recordingData))
        return
    }

    func onRecordingOpusBuffer(_ opusData: Data!) {
        //        print("音频编码数据: " + String(describing: opusData))
        // 存当前音频数据
        tempOpusData.append(opusData)
        return
    }

    func audioFileDidRecord(_ url: String!) {
//        print("audio file url=======" + url)
        return
    }

    func onAsyncResult(_ url: String!) {
        //        print("result url: " + url)
        return
    }

    func monitoringLifecycle(_ lifecycle: Int32, error: Error!) {
//        if error != nil {
//            self.showNetworkErrorAnimation()
//        }
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
