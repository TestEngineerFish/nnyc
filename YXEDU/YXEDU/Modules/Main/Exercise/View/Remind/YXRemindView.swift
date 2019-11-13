//
//  YXRemindView.swift
//  YXEDU
//
//  Created by 沙庭宇 on 2019/11/2.
//  Copyright © 2019 shiji. All rights reserved.
//

import Foundation

enum YXRemindType: Int {
    case word                   // 单词拼写
    case example                // 例句
    case soundmark              // 音标
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
        
    private var titleLabel = UILabel()
    private var imageView = YXKVOImageView()
    private var audioPlayerView = YXAudioPlayerView()
    
    /// 当前提示到哪一步了，默认从第一个开始提示
    private var currentRemindIndex = 0
    
    /// 等待播放的语音列表（某一步提示，可能会播放多个语音，需要使用队列顺序播放，例如：单词语音+例句语音）
    private var audioList: [String] = []
    
    init(exerciseModel: YXWordExerciseModel) {
        self.exerciseModel = exerciseModel
        super.init(frame: CGRect.zero)
        self.createSubview()
        self.bindProperty()
    }

    private func createSubview() {
        self.addSubview(self.remindLabel)
        self.addSubview(self.titleLabel)
        self.addSubview(self.imageView)
        self.addSubview(self.audioPlayerView)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        self.remindLabel.snp.remakeConstraints { (make) in
            make.top.left.equalTo(0)
            make.width.equalTo(37)
            make.height.equalTo(20)
        }
        
        self.titleLabel.snp.remakeConstraints { (make) in
            make.top.equalTo(0)
            make.left.equalTo(remindLabel.snp.right)
            make.right.equalTo(audioPlayerView.snp.left)
            
            let width = screenWidth - 22 * 2 - 37 - 5 - 22
            let height = titleLabel.text?.textHeight(font: titleLabel.font, width: width) ?? 20
            make.height.equalTo(height)
        }
        
        self.audioPlayerView.snp.remakeConstraints { (make) in
            make.top.equalTo(0)
            make.width.height.equalTo(22)
        }
        
        self.imageView.snp.remakeConstraints { (make) in
            if titleLabel.isHidden {
                make.top.equalTo(0)
            } else {
                make.top.equalTo(titleLabel.snp.bottom).offset(5)
            }
            
            make.left.equalTo(remindLabel.snp.right)
            make.width.equalTo(89)
            make.height.equalTo(70)
        }
        
    }
    
    private func bindProperty() {
        remindLabel.font            = UIFont.pfSCRegularFont(withSize: 12)
        remindLabel.text            = "提示:"
        remindLabel.textColor       = UIColor.black3
                
        titleLabel.font             = UIFont.pfSCRegularFont(withSize: 14)
        titleLabel.textColor        = UIColor.black3
        titleLabel.isHidden         = true
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
                case .word:
                    remindWord()
                case .soundmark:
                    remindSoundmark()
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
                default:
                    remindDetail()
            }
        }
        
    }
        


    
    private func remindExample() {
        titleLabel.isHidden = false
        titleLabel.text = exerciseModel.word?.englishExample
    }

    private func remindImage() {
        imageView.isHidden = false
        if let url = exerciseModel.word?.imageUrl {
            imageView.showImage(with: url, placeholder: UIImage.imageWithColor(UIColor.orange7))
        }
    }
    
    private func remindSoundmark() {
        titleLabel.isHidden = false
        titleLabel.text = exerciseModel.word?.americanPhoneticSymbol
    }
    
    private func remindWordAudio() {
//        if let url = exerciseModel.word?.soundmarkUS
//        audioList.append(exerciseModel.)
    }
    
    private func remindExampleAudio() {
        
    }
    
    private func remindWordChinese() {
        titleLabel.isHidden = false
        titleLabel.text = exerciseModel.word?.meaning
    }
    
    private func remindExampleChinese() {
        titleLabel.isHidden = false
        titleLabel.text = exerciseModel.word?.chineseExample
    }
    

    private func remindWord() {
        titleLabel.isHidden = false
        titleLabel.text = exerciseModel.word?.word
    }
    
    
    private func remindDetail() {
        
    }
    
    
    
    private func hiddenTitleLabel() {
        
    }
    
    
    //MARK: -
    func endPlayAudio() {
        
    }
}
