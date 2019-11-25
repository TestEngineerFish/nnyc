//
//  YXNewLearnAnswerView.swift
//  YXEDU
//
//  Created by 沙庭宇 on 2019/11/4.
//  Copyright © 2019 shiji. All rights reserved.
//

import UIKit
import Lottie

class YXNewLearnAnswerView: YXBaseAnswerView, USCRecognizerDelegate {

    /// 答题区状态
    enum AnswerStatus {
        case normal     // 初始空状态
        case playing    // 播放中
        case listening  // 收听中
        case reporting  // 上报云知声中
        case showResult // 显示结果中
    }

    var resultView: YXLearnResultAnimationSubview?
    var titleLabel: UILabel?
    var listenView: AnimationView?
    var enginer: USCRecognizer?
    var status: AnswerStatus
    var alreadyCount = 0 // 当题学习次数,再次学习,无论成绩,都切题
    var lastLevel    = 0 // 最近一次跟读评分

    override init(exerciseModel: YXWordExerciseModel) {
        self.status = .normal
        super.init(exerciseModel: exerciseModel)
        self.enginer = USCRecognizer.sharedManager()
        self.enginer?.delegate = self
        NotificationCenter.default.addObserver(self, selector: #selector(didBecomeActiveNotification), name: UIApplication.didBecomeActiveNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(didEnterBackgroundNotification), name: UIApplication.didEnterBackgroundNotification, object: nil)
    }
    /// 进入后台, 停止播放音频和语音监听
    @objc private func didEnterBackgroundNotification() {
        print("进入后台, 停止播放音频和语音监听")
        self.pauseView()
    }

    /// 从后台进入前台,
    @objc private func didBecomeActiveNotification() {
        // 该做啥呢?问问产品吧
        self.playView()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    //MARK: TOOL
    /// 显示跟读动画
    func showReadAnaimtion() {
        self.listenView?.removeFromSuperview()
        self.titleLabel?.removeFromSuperview()
        self.listenView = nil
        self.titleLabel = nil
        self.listenView = AnimationView(name: "readAnimation")
        self.addSubview(listenView!)
        listenView?.snp.makeConstraints({ (make) in
            make.center.equalToSuperview()
            make.width.height.equalTo(AdaptSize(52))
        })
        let scaleAnimation = CABasicAnimation(keyPath: "transform.scale")
        scaleAnimation.fromValue      = 0
        scaleAnimation.toValue        = 1
        scaleAnimation.duration       = 0.5
        scaleAnimation.fillMode       = .forwards
        scaleAnimation.autoreverses   = false
        scaleAnimation.repeatCount    = 1
        scaleAnimation.timingFunction = CAMediaTimingFunction(name: .easeInEaseOut)
        scaleAnimation.isRemovedOnCompletion = false

        self.titleLabel = UILabel()
        self.titleLabel?.text = "请跟读"
        self.titleLabel?.font = UIFont.pfSCSemiboldFont(withSize: AdaptSize(13))
        self.titleLabel?.textColor = UIColor.black6
        self.titleLabel?.textAlignment = .center
        self.addSubview(titleLabel!)
        self.titleLabel?.snp.makeConstraints({ (make) in
            make.bottom.equalTo(listenView!.snp.top).offset(AdaptSize(-8))
            make.centerX.equalToSuperview()
            make.width.equalToSuperview()
            make.height.equalTo(AdaptSize(15))
        })
        listenView?.layer.add(scaleAnimation, forKey: nil)
        titleLabel?.layer.add(scaleAnimation, forKey: nil)
        self.listenView?.play(completion: { (finished) in
            if finished {
                self.enginer?.stop()
            }
        })
        // ==== tap action ====
        let tap = UITapGestureRecognizer(target: self, action: #selector(stopListen))
        listenView?.isUserInteractionEnabled = true
        listenView?.addGestureRecognizer(tap)
    }

    // ==== 测试用 结束收听 ==== 
    @objc private func stopListen() {
        self.listenView?.pause()
        self.listenView?.alpha = 0.35
        self.enginer?.stop()
    }

    /// 隐藏跟读动画
    private func hideReadAnimation() {
        let scaleAnimation = CABasicAnimation(keyPath: "transform.scale")
        scaleAnimation.fromValue      = 1
        scaleAnimation.toValue        = 0
        scaleAnimation.duration       = 0.5
        scaleAnimation.fillMode       = .forwards
        scaleAnimation.autoreverses   = false
        scaleAnimation.repeatCount    = 1
        scaleAnimation.timingFunction = CAMediaTimingFunction(name: .easeInEaseOut)
        scaleAnimation.isRemovedOnCompletion = false
        self.listenView?.layer.add(scaleAnimation, forKey: nil)
        titleLabel?.layer.add(scaleAnimation, forKey: nil)
    }

    /// 显示结果动画
    private func showResultAnimation() {
        resultView = YXLearnResultAnimationSubview(self.lastLevel)
        self.addSubview(resultView!)
        resultView?.snp.makeConstraints({ (make) in
            make.center.equalToSuperview()
            make.width.equalTo(AdaptSize(60))
            make.height.equalTo(AdaptSize(85))
        })
        resultView?.animationComplete = {
            var isPlay = true
            self.status = .playing
            self.alreadyCount += 1
            /// 如果已学习次数达到次,或者评分超弱1星,则切题
            if self.alreadyCount > 1 || self.lastLevel > 1 {
                isPlay = self.answerDelegate?.switchQuestionView() ?? false
            }
            if isPlay {
                self.delegate?.playAudio()
            } else {
                self.answerDelegate?.answerCompletion(self.exerciseModel, true)
            }
        }
        resultView?.showAnimation()
    }

    /// 隐藏结果动画
    private func hideResultAnimation() {
        resultView?.hideAnimation()
        resultView = nil
        self.status = .playing
    }

    /// 页面暂停
    func pauseView() {
        YXAVPlayerManager.share.pauseAudio()
        self.enginer?.cancel()
        if self.status == .listening {
            // 置灰显示
            self.listenView?.pause()
            self.listenView?.alpha = 0.35
            self.enginer?.cancel()
            self.status = .playing
        }
    }

    /// 页面播放
    func playView() {
        self.delegate?.playAudio()
    }

    // MARK: YXAudioPlayerViewDelegate

    override func playAudioStart() {
        if self.status == .listening {
            // 置灰显示
            self.listenView?.pause()
            self.listenView?.alpha = 0.35
            self.enginer?.cancel()
            self.status = .playing
        }
        self.status = .playing
    }

    override func playAudioFinished() {
        if self.status != .playing {
            return
        }
        guard let word = self.exerciseModel.question?.word else {
            return
        }
        self.enginer?.cancel()
        self.enginer?.oralText = word
        self.enginer?.start()
    }

    // MARK: ==== 云知声SDK: USCRecognizerDelegate ====
    func oralEngineDidInit(_ error: Error!) {
//        print("初始化结束,错误内容: " + String(describing: error))
        return
    }

    func onBeginOral() {
        // 显示录音动画
        self.showReadAnaimtion()
        self.status = .listening
    }

    func onStopOral() {
        self.titleLabel?.text = "打分中……"
        self.status = .reporting
    }

    func onResult(_ result: String!, isLast: Bool) {
        print("录音结果: " + result)
        if isLast {
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
                self.titleLabel?.removeFromSuperview()
                self.listenView?.removeFromSuperview()
                self.titleLabel = nil
                self.listenView   = nil
                // 显示结果动画
                self.showResultAnimation()
                self.status = .showResult
            }
        }
    }

    func onEndOral(_ error: Error!) {
        print("录音完成,错误: " + String(describing: error))
        return
    }

    func onVADTimeout() {
        print("VAD超时啦")
        return
    }

    func onUpdateVolume(_ volume: Int32) {
//        print("onUpdateVolume: \(volume)")
        return
    }

    func onRecordingBuffer(_ recordingData: Data!) {
//        print("录音数据: " + String(describing: recordingData))
        return
    }

    func onRecordingOpusBuffer(_ opusData: Data!) {
//        print("音频编码数据: " + String(describing: opusData))
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
        print("lifecycle: \(lifecycle)")
        return
    }
}
