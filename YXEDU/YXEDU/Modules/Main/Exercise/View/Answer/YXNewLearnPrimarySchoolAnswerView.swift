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
}

/// 答题区状态
 enum AnswerStatus: Int {
     case playingWordInFristStage        = 0   // 第一阶段单词播放中
     case playedWordInFristStage         = 1   // 第一阶段单词播放结束
     case playingExampleInFristStage     = 2   // 第一阶段例句播放中
     case playedExampleInFristStage      = 3   // 第一阶段例句播放结束
     case playingFirstWordInSecondStage  = 4   // 第二阶段第一遍单词播放中
     case playedFirstWrodInSecondStage   = 5   // 第二阶段第一遍单词播放结束
     case playingSecondWordInSecondStage = 6   // 第二阶段第二遍单词播放中
     case playedSecondWordInSecondStage  = 7   // 第二阶段第二遍单词播放结束
     case showGuideView                  = 8   // 显示引导图
     case prepareRecord                  = 9   // 准备录音
     case recording                      = 10  // 录音中
     case reporting                      = 11  // 上报云知声中
     case showResult                     = 12  // 显示结果
     case alreadLearn                    = 13  // 已学习
     case normal                         = -1 //初始状态

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

    var recordAudioButton: YXButton = {
        let button = YXButton()
        button.setImage(UIImage(named: "recordAudio"), for: .normal)
        button.isEnabled = false
        return button
    }()

    var recordAudioLabel: UILabel = {
        let label = UILabel()
        label.text          = "按住跟读"
        label.textColor     = UIColor.black2
        label.font          = UIFont.pfSCRegularFont(withSize: AdaptSize(13))
        label.textAlignment = .center
        return label
    }()

    var titleLabel: UILabel?
    var timer: Timer?
    var dotNumber = 0
    var enginer: USCRecognizer?
    var status: AnswerStatus = .normal
    var alreadyCount = 0 // 当题学习次数,再次学习,无论成绩,都切题
    var lastLevel    = 0 // 最近一次跟读评分
    var tempOpusData = Data() // 缓存当前录音
    var retryCount   = 0
    var retryPath    = {
        return NSTemporaryDirectory() + "tmpData.opus"
    }()    // 缓存录音本地地址

    weak var newLearnDelegate: YXNewLearnProtocol?

    override init(exerciseModel: YXWordExerciseModel) {
        super.init(exerciseModel: exerciseModel)
        self.enginer = USCRecognizer.sharedManager()
        self.enginer?.setIdentifier(YXConfigure.shared()?.uuid)
        self.enginer?.delegate = self
        NotificationCenter.default.addObserver(self, selector: #selector(didBecomeActiveNotification), name: UIApplication.didBecomeActiveNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(didEnterBackgroundNotification), name: UIApplication.didEnterBackgroundNotification, object: nil)
        // 延迟播放.(因为在切题的时候会有动画)
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 1.2) {
            self.playByStatus()
        }
    }

    deinit {
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
        self.playAudioButton.snp.makeConstraints { (make) in
            make.left.top.equalToSuperview()
            make.size.equalTo(CGSize(width: AdaptSize(56), height: AdaptSize(56)))
        }
        self.playAudioLabel.snp.makeConstraints { (make) in
            make.centerX.equalTo(playAudioButton)
            make.top.equalTo(playAudioButton.snp.bottom).offset(AdaptSize(8))
            make.size.equalTo(CGSize(width: AdaptSize(80), height: AdaptSize(18)))
        }
        self.recordAudioButton.snp.makeConstraints { (make) in
            make.right.top.equalToSuperview()
            make.size.equalTo(CGSize(width: AdaptSize(56), height: AdaptSize(56)))
        }
        self.recordAudioLabel.sizeToFit()
        self.recordAudioLabel.snp.makeConstraints { (make) in
            make.centerX.equalTo(recordAudioButton)
            make.top.equalTo(recordAudioButton.snp.bottom).offset(AdaptSize(8))
            make.size.equalTo(recordAudioLabel.size)
        }

        self.playAudioButton.addTarget(self, action: #selector(playButtonAction(_:)), for: .touchUpInside)
        self.recordAudioButton.addTarget(self, action: #selector(startRecordAction(_:)), for: .touchDown)
        self.recordAudioButton.addTarget(self, action: #selector(endRecordAction(_:)), for: .touchUpInside)
    }

    // MARK: ==== Event ====

    /// 点击播放按钮
    @objc private func playButtonAction(_ button: UIButton) {
        if self.status.rawValue > AnswerStatus.showGuideView.rawValue {
            self.playWord()
        }
    }

    /// 长按跟读按钮
    @objc private func startRecordAction(_ btn: UIButton) {
        guard let word = self.exerciseModel.question?.word else {
            return
        }
        YXRecordAudioView.share.show()
        self.enginer?.oralText = word
        self.enginer?.start()
    }
    @objc private func endRecordAction(_ btn: UIButton) {
        YXRecordAudioView.share.hide()
        self.enginer?.stop()
        print("End")
    }

    /// 根据状态来播放
    func playByStatus() {
        switch self.status {
        case .normal:
            self.status.forward()
            self.playWord()
        case .playingWordInFristStage:
            self.playWord()
        case .playedWordInFristStage:
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                self.status.forward()
                self.playExample()
            }
        case .playingExampleInFristStage:
            self.playExample()
        case .playedExampleInFristStage:
            self.newLearnDelegate?.playWordAndExampleFinished()
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                self.status.forward()
                self.playWord()
            }
        case .playingFirstWordInSecondStage:
            self.playWord()
        case .playedFirstWrodInSecondStage:
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                self.status.forward()
                self.playWord()
            }
        case .playingSecondWordInSecondStage:
            self.playWord()
        case .playedSecondWordInSecondStage:
            self.status.forward()
            self.newLearnDelegate?.playWordAndWordFinished()
            self.recordAudioButton.isEnabled = true
        default:
            break
        }
    }

    /// 播放单词
    private func playWord() {
        guard let wordUrlStr = self.exerciseModel.question?.voice, let url = URL(string: wordUrlStr) else {
            return
        }
        self.showPlayAnimation()
        YXAVPlayerManager.share.playAudio(url) {
            self.hidePlayAnimation()
            if self.status.rawValue < AnswerStatus.showGuideView.rawValue {
                self.status.forward()
                self.playByStatus()
            }
        }
    }

    /// 播放例句
    /// - Parameter block: 完成回调
    private func playExample() {
        guard let exampleUrlStr = self.exerciseModel.question?.examplePronunciation, let url = URL(string: exampleUrlStr) else {
            return
        }
        self.showPlayAnimation()
        YXAVPlayerManager.share.playAudio(url) {
            self.hidePlayAnimation()
            if self.status.rawValue < AnswerStatus.showGuideView.rawValue {
                self.status.forward()
                self.playByStatus()
            }
        }
    }

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
            if self.status == .playingExampleInFristStage {
                self.playAudioLabel.textColor = UIColor.orange1
                switch self.dotNumber {
                case 0:
                    self.playAudioLabel.text = "例句播放中"
                case 1:
                    self.playAudioLabel.text = "例句播放中."
                case 2:
                    self.playAudioLabel.text = "例句播放中.."
                default:
                    self.playAudioLabel.text = "例句播放中..."
                }
            } else {
                self.playAudioLabel.textColor = UIColor.orange1
                   switch self.dotNumber {
                   case 0:
                       self.playAudioLabel.text = "单词播放中"
                   case 1:
                       self.playAudioLabel.text = "单词播放中."
                   case 2:
                       self.playAudioLabel.text = "单词播放中.."
                   default:
                       self.playAudioLabel.text = "单词播放中..."
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
        self.playAudioLabel.textColor = UIColor.black2
        self.playAudioButton.layer.removeAllAnimations()
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

    //MARK: ==== TOOL ====
    /// 显示跟读动画
    func showReadAnaimtion() {

    }

    // ==== 测试用 结束收听 ==== 
    @objc private func stopListen() {

        self.enginer?.stop()
    }

    /// 隐藏跟读动画
    private func hideReadAnimation() {

    }

    /// 显示结果动画
    private func showResultAnimation() {

    }

    /// 隐藏结果动画
    private func hideResultAnimation() {
        self.status = .alreadLearn
    }

    /// 页面暂停
    func pauseView() {
        YXAVPlayerManager.share.pauseAudio()
        self.enginer?.cancel()
    }


    // MARK: ==== 云知声SDK: USCRecognizerDelegate ====
    func oralEngineDidInit(_ error: Error!) {
//        print("初始化结束,错误内容: " + String(describing: error))
        return
    }

    func onBeginOral() {
        // 显示录音动画
        self.resetOpusTempData()
        self.showReadAnaimtion()
        self.status = .recording
    }

    func onStopOral() {
        self.setCatchRecordOpus(opus: self.tempOpusData)
        self.titleLabel?.text = "打分中……"
        self.status = .reporting
    }

    func onResult(_ result: String!, isLast: Bool) {
//        print("============录音结果: " + result)
        if isLast {
            // 录音结束,清除临时录音缓存
            self.resetOpusTempData()
            let resultDict = result.convertToDictionary()
            guard let score = resultDict["score"] as? Double else {
                return
            }
//            YXUtils.showHUD(self, title: "当前得分: \(score)")
            self.lastLevel = {
                if score > 90 {
                    return 3
                } else if score > 60 {
                    return 2
                } else if score > 30 {
                    return 1
                } else {
                    if self.alreadyCount > 0 {
                        // 如果已学习次数达到次,默认最低得一星
                        return 1
                    }
                    return 0
                }
            }()
            self.hideReadAnimation()
            // 移除录音视图
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.5) {
                // 显示结果动画
                self.showResultAnimation()
                self.status = .showResult
            }
        }
    }

    func onEndOral(_ error: Error!) {
        guard let _ = error else {
            return
        }
        // 判断重试次数
        if self.retryCount < 3 {
            self.titleLabel?.text = "网络错误,录音重传中……"
            self.enginer?.retry(withFilePath: self.retryPath)
            self.retryCount += 1
        } else {
            self.titleLabel?.text = ""
            YXUtils.showHUD(kWindow, title: "网络连接失败,请稍后再试")
        }
    }

    func onVADTimeout() {
//        print("VAD超时啦")
        return
    }

    func onUpdateVolume(_ volume: Int32) {
//        print("onUpdateVolume: \(volume)")
        YXRecordAudioView.share.updateVolume(volume)
        print(volume)
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
//        print("audio file url" + url)
        return
    }

    func onAsyncResult(_ url: String!) {
//        print("result url: " + url)
        return
    }

    func monitoringLifecycle(_ lifecycle: Int32, error: Error!) {
//        print("lifecycle: \(lifecycle)")
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
