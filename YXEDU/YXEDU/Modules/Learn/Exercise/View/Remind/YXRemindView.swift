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
    public var exerciseModel: YXExerciseModel
    
    private var remindLabel     = UILabel()
    private var titleLabel      = UILabel()
    private var imageView       = YXKVOImageView()
    private var audioPlayerView = YXAudioPlayerView()
    private var isShowDetail    = false
    /// 当前提示到哪一步了，默认从第一个开始提示
    public var currentRemindIndex = -1
    
    /// 等待播放的语音列表（某一步提示，可能会播放多个语音，需要使用队列顺序播放，例如：单词语音+例句语音）
    private var audioList: [String] = []
    private var playIndex       = 0
    private var remindItemCount = 0 // 一步提示的数量

    weak var delegate: YXRemindViewProtocol?
    
    init(exerciseModel: YXExerciseModel) {
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
        self.remindLabel.snp.remakeConstraints { (make) in
            make.left.equalToSuperview()
            make.top.equalTo(self.snp.bottom)
            make.width.equalTo(AdaptSize(37))
            make.height.equalTo(AdaptSize(20))
        }

        self.titleLabel.snp.remakeConstraints { (make) in
            make.top.equalTo(self.snp.bottom)
            make.left.equalTo(remindLabel.snp.right)
            make.size.equalTo(titleSize())
        }

        self.audioPlayerView.snp.remakeConstraints { (make) in
            make.top.equalTo(self.snp.bottom)
            make.left.equalTo(titleLabel.snp.right).offset(AdaptSize(5))
            make.width.height.equalTo(AdaptSize(22))
        }

        self.imageView.snp.remakeConstraints { (make) in
            make.top.equalTo(self.snp.bottom).offset(AdaptSize(isPad() ? 9 : 0))
            make.left.equalTo(remindLabel.snp.right)
            make.width.equalTo(AdaptSize(isPad() ? 160 : 90))
            make.height.equalTo(AdaptSize(isPad() ? 106 : 66))
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.titleLabel.snp.updateConstraints { (make) in
            make.size.equalTo(titleSize())
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

        imageView.isHidden            = true
        imageView.layer.cornerRadius  = AdaptSize(3.75)
        imageView.layer.masksToBounds = true
        
        
        let tap = UITapGestureRecognizer()
        tap.addTarget(self, action: #selector(clickExampleTitle))
        titleLabel.addGestureRecognizer(tap)
        
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
            if !self.imageView.isHidden {
                return self.imageView.frame.maxY
            } else if !self.titleLabel.isHidden {
                return self.titleLabel.frame.maxY
            } else {
                return self.audioPlayerView.frame.maxY
            }
        }()
        self.delegate?.updateHeightConstraints?(maxHeirht)
    }
    
    //MARK: 提示实现
    /// 处理每一步的提示
    /// - Parameter remindStep: 类型集合
    private func processRedmine(remindStep: [YXRemindType]) {
        self.remindItemCount = remindStep.count
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
                /// 已显示，则不再显示
                if !isShowDetail {
                    remindDetail()
                }
            }
        }
        
    }
    
    private func remindWord() {
        guard let wordModel = exerciseModel.word, let word = wordModel.word else {
            self.remindNextStep()
            return
        }
        titleLabel.text = word
        setAllSubviewStatus()
    }
    
    private func remindExample() {
        guard let wordModel = exerciseModel.word, let englishExample = wordModel.examples?.first?.englishExampleAttributedString else {
            self.remindNextStep()
            return
        }
        titleLabel.attributedText = englishExample
        setAllSubviewStatus()
    }

    private func remindExampleWithDigWord() {
        guard let wordModel = exerciseModel.word, let example = wordModel.examples?.first?.english else {
            self.remindNextStep()
            return
        }
        titleLabel.text = example.formartTag(isHollow: true).1
        setAllSubviewStatus()
    }
    
    private func remindImage() {
        guard let wordModel = exerciseModel.word, let imageUrl = wordModel.imageUrl, !imageUrl.isEmpty else {
            self.remindNextStep()
            return
        }
        imageView.showImage(with: imageUrl, placeholder: UIImage.imageWithColor(UIColor.orange7))
        setAllSubviewStatus()
    }
    
    private func remindSoundmark() {
        guard let wordModel = exerciseModel.word, let soundmark = wordModel.soundmark else {
            self.remindNextStep()
            return
        }
        titleLabel.text = soundmark
        setAllSubviewStatus()
    }
    
    private func remindWordAudio() {
        guard let wordModel = exerciseModel.word, let voiceUrl = wordModel.voice else {
            self.remindNextStep()
            return
        }
        audioList.append(voiceUrl)
        if remindSteps[currentRemindIndex].last == .wordAudio {
            playAudio()
            setAllSubviewStatus()
        }
    }
    
    private func remindExampleAudio() {
        guard let wordModel = exerciseModel.word, let voiceUrl = wordModel.examples?.first?.vocie else {
            self.remindNextStep()
            return
        }
        audioList.append(voiceUrl)
        if remindSteps[currentRemindIndex].last == .exampleAudio {
            playAudio()
            setAllSubviewStatus()
        }
    }
    
    private func remindWordChinese() {
        guard let wordModel = exerciseModel.word, let meaning = wordModel.meaning else {
            self.remindNextStep()
            return
        }
        titleLabel.text = meaning
        setAllSubviewStatus()
    }
    
    private func remindExampleChinese() {
        guard let wordModel = exerciseModel.word, let chineseExample = wordModel.examples?.first?.chinese else {
            self.remindNextStep()
            return
        }
        titleLabel.text = chineseExample
        setAllSubviewStatus()
    }

    public func remindDetail(completion: (() -> Void)? = nil) {
        guard let word = exerciseModel.word else { return }
        NotificationCenter.default.post(name: YXNotification.kShowWordDetailPage, object: nil)
        let detailView = YXWordDetailTipView(word: word)
        detailView.dismissClosure = { [weak self] in
            guard let self = self else { return }
            completion?()
            self.isShowDetail = false
            NotificationCenter.default.post(name: YXNotification.kCloseWordDetailPage, object: nil)
        }
        detailView.showWithAnimation()
        self.isShowDetail = true
    }

    private func remindNextStep() {
        self.remindItemCount -= 1
        if self.remindItemCount == 0 {
            self.show()
        }
    }
    
    //MARK: - 辅助方法
    private func setAllSubviewStatus() {
        
        if remindSteps.count == 0 || currentRemindIndex == -1 {
            return
        }
        self.setNeedsLayout()
        remindLabel.isHidden     = false
        titleLabel.isHidden      = !hasText()
        imageView.isHidden       = !hasImage()
        audioPlayerView.isHidden = !hasAudio()
        UIView.animate(withDuration: 0.5) {
            self.remindLabel.transform = CGAffineTransform(translationX: 0, y: -self.height)
            if self.hasText() {
                self.titleLabel.transform = CGAffineTransform(translationX: 0, y: -self.height)
            }
            if self.hasImage() {
                var top = -self.height
                if !self.titleLabel.isHidden {
                    top += self.titleSize().height + AdaptSize(5)
                }
                self.imageView.transform = CGAffineTransform(translationX: 0, y: top)
            }
            if self.hasAudio() {
                self.audioPlayerView.transform = CGAffineTransform(translationX: 0, y: -self.height)
            }
        }
    }

    /// 隐藏所有子视图
    func hideSubviews() {
        self.remindLabel.isHidden     = true
        self.titleLabel.isHidden      = true
        self.imageView.isHidden       = true
        self.audioPlayerView.isHidden = true
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
    
    
    @objc func clickExampleTitle() {
        if hasAudio(), let url = exerciseModel.word?.voice {
            self.audioPlayerView.urlStr = url
            self.audioPlayerView.play()
        }
    }
    
    //MARK: - 语音播放结束
    func playAudioStart() { }
    func playAudioFinished() {
        self.playAudio()
    }
}


