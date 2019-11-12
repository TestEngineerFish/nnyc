//
//  YXRemindView.swift
//  YXEDU
//
//  Created by 沙庭宇 on 2019/11/2.
//  Copyright © 2019 shiji. All rights reserved.
//

import Foundation

enum YXRemindType: Int {
    case example                // 例句
    case wordAudio              // 单词读音
    case exampleAudio           // 例句读音
    case wordChinese            // 单词中文意思
    case exampleChinese         // 例句中文意思
    case image                  // 图片
    case detail                 // 详情页
}


class YXRemindView: UIView, YXAudioPlayerViewDelegate {
    
    public var remindSteps: [[YXRemindType]] = []
    public var exerciseModel: YXWordExerciseModel
    
    private var remindLabel = UILabel()
        
//    private var titleLabel = UILabel()
    /// 播放器
    private var audioPlayerView = YXAudioPlayerView()
    
    /// 当前提示到哪一步了，默认从第一个开始提示
    private var currentRemindIndex = 0
    
    init(exerciseModel: YXWordExerciseModel) {
        self.exerciseModel = exerciseModel
        super.init(frame: CGRect.zero)
        self.createSubview()
        self.bindProperty()
    }

    private func createSubview() {
        self.addSubview(self.remindLabel)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        self.remindLabel.snp.makeConstraints { (make) in
            make.top.equalTo(0)
            make.left.equalTo(22)
            make.right.equalTo(-22)
            make.height.equalTo(20)
        }
    }
    
    private func bindProperty() {
        remindLabel.font          = UIFont.pfSCRegularFont(withSize: 12)
        remindLabel.text          = "提示:"
        remindLabel.textColor     = UIColor.gray1
        remindLabel.textAlignment = .center
        remindLabel.isHidden = true
        
    }
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    public func show() {
        if remindSteps.count == 0 {
            return
        }
        
        let step = remindSteps[currentRemindIndex]
        self.processRedmine(remindStep: step)
        
        if currentRemindIndex < step.count - 1 {
            currentRemindIndex += 1
        }
    }
    
    
    private func processRedmine(remindStep: [YXRemindType]) {
        
        for type in remindStep {            
            switch type {
                case .example:
                    remindExample()
                case .image:
                    remindImage()
                case .wordAudio:
                    remindWordAudio()
                case .exampleAudio:
                    remindExampleAudio()
                case .wordChinese:
                    remindWordChinese()
                case .exampleChinese:
                    remindExampleChinese()
                case .detail:
                    remindDetail()
            }
        }
        
    }
    
    
    private func remindExample() {
        remindLabel.isHidden = false
        remindLabel.text = "提示：" + (exerciseModel.question?.examples?.first?.en ?? "")
    }
    
    private func remindImage() {
        
    }
    
    private func remindWordAudio() {
        
    }
    
    private func remindExampleAudio() {
        
    }
    
    private func remindWordChinese() {
        
    }
    
    private func remindExampleChinese() {
        remindLabel.isHidden = false
        remindLabel.text = "提示：" + (exerciseModel.question?.examples?.first?.cn ?? "")
    }
    

    private func remindDetail() {
        
    }
    
    
    
    
    //MARK: -
    func endPlayAudio() {
        
    }
}
