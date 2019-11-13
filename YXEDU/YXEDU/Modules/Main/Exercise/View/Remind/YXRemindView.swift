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
    private var playIndex = 0
    
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
        
        audioPlayerView.delegate    = self
    }
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    public func show() {
        if remindSteps.count == 0 {
            return
        }
        
        self.audioList.removeAll()
        self.playIndex = 0
        
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
        

    private func remindWord() {
        titleLabel.text = exerciseModel.word?.word
        setAllSubviewStatus()
    }
    
    private func remindExample() {
        titleLabel.text = exerciseModel.word?.englishExample
        setAllSubviewStatus()
    }

    private func remindImage() {
        if let url = exerciseModel.word?.imageUrl {
            imageView.showImage(with: url, placeholder: UIImage.imageWithColor(UIColor.orange7))
        }
        setAllSubviewStatus()
    }
    
    private func remindSoundmark() {
        titleLabel.text = exerciseModel.word?.soundmark
        setAllSubviewStatus()
    }
    
    private func remindWordAudio() {
        if let url = exerciseModel.word?.voice {
            audioList.append(url)
            
            if remindSteps[currentRemindIndex].last == .wordAudio {
                playAudio()
                setAllSubviewStatus()
            }
        }
    }
    
    private func remindExampleAudio() {
        if let url = exerciseModel.word?.examplePronunciation {
            audioList.append(url)
            if remindSteps[currentRemindIndex].last == .exampleAudio {
                playAudio()
                setAllSubviewStatus()
            }
        }
    }
    
    private func remindWordChinese() {
        titleLabel.text = exerciseModel.word?.meaning
        setAllSubviewStatus()
    }
    
    private func remindExampleChinese() {
        titleLabel.text = exerciseModel.word?.chineseExample
        setAllSubviewStatus()
    }
    
    
    private func remindDetail() {
        
        
        
        self.setAllSubviewStatus()
    }
    
    private func setAllSubviewStatus() {
        
        if remindSteps.count == 0 {
            return
        }
        
        titleLabel.isHidden = !hasText()
        imageView.isHidden = !hasImage()
        audioPlayerView.isHidden = !hasAudio()
        
        self.layoutIfNeeded()
    }
    
    
    /// 是否有文本提示
    private func hasText() -> Bool {
        let step = remindSteps[currentRemindIndex]
        for type in step {
            if (type == .word || type == .example || type == .soundmark
            || type == .wordChinese || type == . exampleChinese) {
                return true
            }
        }
        return false
    }
    /// 是否有图片提示
    private func hasImage() -> Bool {
        let step = remindSteps[currentRemindIndex]
        for type in step {
            if type == .image {
                return true
            }
        }
        return false
    }
    /// 是否有语音提示
    private func hasAudio() -> Bool {
        let step = remindSteps[currentRemindIndex]
        for type in step {
            if (type == .wordAudio || type == .exampleAudio) {
                return true
            }
        }
        return false
    }
    
    /// 播放语音
    private func playAudio() {
        if let url = audioList.first {
            audioList.removeFirst()
            self.audioPlayerView.urlStr = url
            self.audioPlayerView.play()
        }
    }
    
    //MARK: - 语音播放结束
    func endPlayAudio() {
        self.playAudio()
    }
}

