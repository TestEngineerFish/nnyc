//
//  YXNewLearnAnswerView.swift
//  YXEDU
//
//  Created by 沙庭宇 on 2019/11/4.
//  Copyright © 2019 shiji. All rights reserved.
//

import UIKit
import Lottie

class YXNewLearnAnswerView: YXBaseAnswerView, CAAnimationDelegate, USCRecognizerDelegate {

    var resultView: YXLearnResultAnimationSubview?
    var titleLabel: UILabel?
    var readView: AnimationView?
    let showRead   = "ShowReadAnimation"
    var enginer: USCRecognizer?

    override init(exerciseModel: YXWordExerciseModel) {
        super.init(exerciseModel: exerciseModel)
        self.enginer = USCRecognizer.sharedManager()
        self.enginer?.delegate = self
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    //MARK: TOOL
    /// 显示跟读动画
    func showReadAnaimtion() {
        self.readView = AnimationView(name: "readAnimation")
        self.addSubview(readView!)
        readView?.snp.makeConstraints({ (make) in
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
        scaleAnimation.setValue(true, forKey: showRead)
        scaleAnimation.delegate = self


        self.titleLabel = UILabel()
        self.titleLabel?.text = "请跟读"
        self.titleLabel?.font = UIFont.pfSCSemiboldFont(withSize: AdaptSize(13))
        self.titleLabel?.textColor = UIColor.black6
        self.titleLabel?.textAlignment = .center
        self.addSubview(titleLabel!)
        self.titleLabel?.snp.makeConstraints({ (make) in
            make.bottom.equalTo(readView!.snp.top).offset(AdaptSize(-8))
            make.centerX.equalToSuperview()
            make.width.equalToSuperview()
            make.height.equalTo(AdaptSize(15))
        })
        readView?.layer.add(scaleAnimation, forKey: nil)
        titleLabel?.layer.add(scaleAnimation, forKey: nil)
        self.readView?.play()
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 5) {
            self.enginer?.stop()
        }
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
        scaleAnimation.setValue(false, forKey: showRead)
        scaleAnimation.delegate = self
        self.readView?.layer.add(scaleAnimation, forKey: nil)
        titleLabel?.layer.add(scaleAnimation, forKey: nil)
    }

    /// 显示结果动画
    private func showResultAnimation(_ score: Int) {
        resultView = YXLearnResultAnimationSubview(score)
        self.addSubview(resultView!)
        resultView?.snp.makeConstraints({ (make) in
            make.center.equalToSuperview()
            make.width.equalTo(AdaptSize(60))
            make.height.equalTo(AdaptSize(85))
        })
        resultView?.animationComplete = {
            print("add complete")
            self.delegate?.playAudio()
        }
        resultView?.showAnimation()

    }

    /// 隐藏结果动画
    private func hideResultAnimation() {
        resultView?.hideAnimation()
        resultView = nil
    }

    override func endPlayAudio() {
        self.enginer?.oralText = "Hello word"
        self.enginer?.start()
    }

    // MARK: USCRecognizerDelegate
    func oralEngineDidInit(_ error: Error!) {
        print("初始化结束,错误内容: " + String(describing: error))
    }

    func onBeginOral() {
        // 显示录音动画
        self.showReadAnaimtion()
    }

    func onStopOral() {
        self.titleLabel?.text = "打分中……"
    }

    func onResult(_ result: String!, isLast: Bool) {
        print("录音结果: " + result)
        if isLast {
            let resultDict = result.convertToDictionary()
            guard let score = resultDict["score"] as? Double else {
                return
            }
            let starNum: Int = {
                if score > 80 {
                    return 3
                } else if score > 60 {
                    return 2
                } else {
                    return 1
                }
            }()
            self.hideReadAnimation()
            // 移除视图
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.5) {
                self.titleLabel?.removeFromSuperview()
                self.readView?.removeFromSuperview()
                self.titleLabel = nil
                self.readView   = nil
                // 显示结果动画
                self.showResultAnimation(starNum)
            }
        }
    }

    func onEndOral(_ error: Error!) {
        print("录音完成,错误: " + String(describing: error))
    }

    func onVADTimeout() {
        print("VAD超时啦")
    }

    func onUpdateVolume(_ volume: Int32) {
        print("onUpdateVolume: \(volume)")
    }

    func onRecordingBuffer(_ recordingData: Data!) {
        print("录音数据: " + String(describing: recordingData))
    }

    func onRecordingOpusBuffer(_ opusData: Data!) {
        print("音频编码数据: " + String(describing: opusData))
    }

    func audioFileDidRecord(_ url: String!) {
        print("audio file url" + url)
    }

    func onAsyncResult(_ url: String!) {
        print("result url: " + url)
    }

    func monitoringLifecycle(_ lifecycle: Int32, error: Error!) {
        print("lifecycle: \(lifecycle)")
    }
}
