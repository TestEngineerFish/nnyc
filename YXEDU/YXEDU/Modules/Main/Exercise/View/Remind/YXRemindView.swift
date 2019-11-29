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
    case exampleWithDigWord     // 例句，单词挖空
    case soundmark              // 音标
    case wordAudio              // 单词读音
    case exampleAudio           // 例句读音
    case wordChinese            // 单词中文意思
    case exampleChinese         // 例句中文意思
    case image                  // 图片
    case detail                 // 详情页
}

/// 提示区域更新约束
@objc protocol YXRemindViewProtocol: NSObjectProtocol {
    @objc optional func updateHeightConstraints(_ height: CGFloat)
//    @objc optional func dismissRemindView()
}

class YXRemindView: UIView, YXAudioPlayerViewDelegate {
    
    public var remindSteps: [[YXRemindType]] = []
    public var exerciseModel: YXWordExerciseModel
    
    private var remindLabel = UILabel()
        
    private var titleLabel = UILabel()
    private var imageView = YXKVOImageView()
    private var audioPlayerView = YXAudioPlayerView()
    
    /// 当前提示到哪一步了，默认从第一个开始提示
    public var currentRemindIndex = -1
    
    /// 等待播放的语音列表（某一步提示，可能会播放多个语音，需要使用队列顺序播放，例如：单词语音+例句语音）
    private var audioList: [String] = []
    private var playIndex = 0

    weak var delegate: YXRemindViewProtocol?
    
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
            make.size.equalTo(titleSize())
        }
        
        self.audioPlayerView.snp.remakeConstraints { (make) in
            make.top.equalTo(0)
            make.left.equalTo(titleLabel.snp.right).offset(5)
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
        remindLabel.isHidden         = true
                
        titleLabel.font             = UIFont.pfSCRegularFont(withSize: 14)
        titleLabel.textColor        = UIColor.black1
        titleLabel.numberOfLines    = 0
        titleLabel.isHidden         = true
        
        audioPlayerView.isHidden    = true
        audioPlayerView.delegate    = self
        
        imageView.isHidden          = true
    }
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: 外部调用方法
    public func show() {
        if remindSteps.isEmpty {
            return
        }
        
        // 下标必须要放在前面，由于layout布局有延迟，如果放后面，会有取值错误
        if currentRemindIndex < remindSteps.count - 1 {
            currentRemindIndex += 1
        }
        
        self.audioList.removeAll()
        self.playIndex = 0
        
        let step = remindSteps[currentRemindIndex]
        self.processRedmine(remindStep: step)
        // 更新高度
        let maxHeirht: CGFloat = {
            if self.titleLabel.isHidden {
                return self.imageView.frame.maxY
            } else {
                return self.titleLabel.frame.maxY
            }
        }()
        self.delegate?.updateHeightConstraints?(maxHeirht)
    }
    
    //MARK: 提示实现
    /// 处理每一步的提示
    /// - Parameter remindStep: 类型集合
    private func processRedmine(remindStep: [YXRemindType]) {
        
        for type in remindStep {
            switch type {
                case .word:
                    remindWord()
                case .soundmark:
                    remindSoundmark()
                case .example:
                    remindExample()
                case .exampleWithDigWord:
                    remindExampleWithDigWord()
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
        titleLabel.attributedText = exerciseModel.word?.exampleAttr
        setAllSubviewStatus()
    }

    private func remindExampleWithDigWord() {
        if let word = exerciseModel.word?.word {
            titleLabel.text = exerciseModel.word?.example?.replacingOccurrences(of: word, with: "____")
        }
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
    
    
    public func remindDetail(completion: (() -> Void)? = nil) {
        guard let word = exerciseModel.word else { return }
        
        let detailView = YXWordDetailTipView(word: word)
        detailView.dismissClosure = {
            completion?()
//            self?.delegate?.dismissRemindView?()
        }
        detailView.showWithAnimation()
    }
    
    //MARK: - 辅助方法
    private func setAllSubviewStatus() {
        
        if remindSteps.count == 0 || currentRemindIndex == -1 {
            return
        }
        
        remindLabel.isHidden = false
        titleLabel.isHidden = !hasText()
        imageView.isHidden = !hasImage()        
        audioPlayerView.isHidden = !hasAudio()
        
        self.setNeedsLayout()
    }
    
    
    /// 是否有文本提示
    private func hasText() -> Bool {
        let step = remindSteps[currentRemindIndex]
        for type in step {
            if (type == .word || type == .example || type == .exampleWithDigWord || type == .soundmark
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
    
    
    private func titleSize() -> CGSize {
        if currentRemindIndex == -1 {
            return CGSize.zero
        }
        
        var maxWidth = screenWidth - 22 * 2 - 37
        if hasAudio() {
            maxWidth -= 25
        }
        let realWidth = titleLabel.text?.textWidth(font: titleLabel.font, height: 20) ?? 0
                    
        if realWidth > maxWidth {
            let height = titleLabel.text?.textHeight(font: titleLabel.font, width: maxWidth) ?? 20
            return CGSize(width: maxWidth, height: height)
        } else {
            return CGSize(width: realWidth, height: 20)
        }

    }
    //MARK: - 语音播放结束
    func playAudioStart() { }
    func playAudioFinished() {
        self.playAudio()
    }
}

