//
//  YXNewLearnPrimarySchoolWordGroupExerciseView.swift
//  YXEDU
//
//  Created by 沙庭宇 on 2019/11/14.
//  Copyright © 2019 shiji. All rights reserved.
//

import UIKit

class YXNewLearnPrimarySchoolWordGroupExerciseView: YXBaseExerciseView {
    
    var firstQuestionView: YXNewLearnPrimarySchoolWordGroupQuestionView?
    var secondQuestionView: YXNewLearnPrimarySchoolWordGroupQuestionView?
    var currentQuestionView: YXNewLearnPrimarySchoolWordGroupQuestionView?
    
    var contentView = UIScrollView()
    let contentViewW = screenWidth - AdaptSize(44)
    
    override func createSubview() {
        super.createSubview()
        self.addSubview(contentView)
        
        firstQuestionView  = YXNewLearnPrimarySchoolWordGroupQuestionView(exerciseModel: exerciseModel, type: .wordAndAudio)
        secondQuestionView = YXNewLearnPrimarySchoolWordGroupQuestionView(exerciseModel: exerciseModel, type: .wordAndImageAndAudio)
        self.contentView.addSubview(firstQuestionView!)
        self.contentView.addSubview(secondQuestionView!)
        self.currentQuestionView = firstQuestionView
        
        answerView = YXNewLearnAnswerView(exerciseModel: self.exerciseModel)
        self.addSubview(answerView!)
        
        answerView?.delegate        = firstQuestionView
        answerView?.answerDelegate  = self
        
        firstQuestionView?.audioPlayerView?.delegate = answerView
        
        // 延迟播放.(因为在切题的时候会有动画)
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 1.2) {
            var isPlay = true
            kWindow.subviews.forEach { (subview) in
                if subview.tag != 0 {
                    isPlay = false
                }
            }
            if isPlay {
                self.playerAudio()
            }
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        contentView.frame = CGRect(x: AdaptSize(22), y: AdaptSize(37), width: contentViewW, height: AdaptSize(250))
        
        firstQuestionView?.snp.makeConstraints({ (make) in
            make.left.top.bottom.equalToSuperview()
            make.height.equalTo(AdaptSize(250))
            make.width.equalTo(contentViewW)
        })
        
        secondQuestionView?.snp.makeConstraints({ (make) in
            make.left.equalTo(firstQuestionView!.snp.right)
            make.top.equalToSuperview()
            make.width.height.equalTo(firstQuestionView!)
        })
        
        contentView.contentSize = CGSize(width: contentViewW*3, height: AdaptSize(250))
        
        answerView?.snp.makeConstraints({ (make) in
            make.centerX.equalToSuperview()
            make.bottom.equalToSuperview()
            make.width.equalToSuperview().offset(AdaptSize(-44))
            make.height.equalTo(AdaptSize(200))
        })
    }
    
    deinit {
        guard let _answerView = answerView else {
            return
        }
        NotificationCenter.default.removeObserver(_answerView)
    }
    
    /// 播放音频
    private func playerAudio() {
        guard let currentQuestionView = currentQuestionView else {
            return
        }
        currentQuestionView.playAudio()
    }
    
    // MARK: YXAnswerViewDelegate
    
    override func switchQuestionView() -> Bool {
        guard let currentQuestionView = self.currentQuestionView else {
            return false
        }
        var offsetX = CGFloat.zero
        switch currentQuestionView {
        case firstQuestionView:
            offsetX = contentViewW
            // 更新当前视图
            self.currentQuestionView = secondQuestionView
            // 重新指定Delegate
            secondQuestionView?.audioPlayerView?.delegate = answerView
            answerView?.delegate = secondQuestionView
        case secondQuestionView:
            return false
        default:
            break
        }
        self.contentView.setContentOffset(CGPoint(x: offsetX, y: 0), animated: true)
        if let _answerView = answerView as? YXNewLearnAnswerView {
            _answerView.alreadyCount = 0
        }
        return true
    }
}
