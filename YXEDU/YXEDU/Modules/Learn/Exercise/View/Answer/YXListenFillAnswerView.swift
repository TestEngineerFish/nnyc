//
//  YXListenFillAnswerView.swift
//  YXEDU
//
//  Created by sunwu on 2019/12/20.
//  Copyright © 2019 shiji. All rights reserved.
//

import UIKit

class YXListenFillAnswerView: YXBaseAnswerView {
        
    var textField       = YXCharacterTextField()
    var lineView        = YXListenFillAnswerLineView()
    var audioPlayerView = YXAudioPlayerView()
    
    private var audioBackgroundView: UIView = UIView()
    
    private var errorCount = 0

    deinit {
        NotificationCenter.default.removeObserver(self, name: YXNotification.kCloseWordDetailPage, object: nil)
        NotificationCenter.default.removeObserver(self, name: YXNotification.kClickTipsButton, object: nil)
    }
    
    override func createSubviews() {
        super.createSubviews()
        
        self.addSubview(textField)
        self.addSubview(lineView)
        self.addSubview(audioBackgroundView)
        self.addSubview(audioPlayerView)
        self.layer.setDefaultShadow()
    }
    
    override func bindProperty() {
        
        self.audioBackgroundView.backgroundColor     = UIColor.orange3
        self.audioBackgroundView.layer.masksToBounds = true
        self.audioBackgroundView.layer.cornerRadius  = AdaptIconSize(26)
        self.audioBackgroundView.layer.borderWidth   = AdaptIconSize(3)
        self.audioBackgroundView.layer.borderColor   = UIColor.orange2.cgColor

        textField.textColor              = UIColor.clear
        textField.autocorrectionType     = .no
        textField.autocapitalizationType = .none
        textField.keyboardType           = .asciiCapable
        textField.tintColor              = UIColor.clear
        textField.addTarget(self, action: #selector(textChanged), for: .editingChanged)
        textField.becomeFirstResponder()
        
        lineView.allText = exerciseModel.word?.word ?? ""
        lineView.openKeyboard = { [weak self] in
            self?.textField.becomeFirstResponder()
        }
        
        NotificationCenter.default.addObserver(self, selector: #selector(closeWordDetailPage), name: YXNotification.kCloseWordDetailPage, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(clickTipsBtnAction), name: YXNotification.kClickTipsButton, object: nil)
    }
     
    override func layoutSubviews() {
        super.layoutSubviews()
        
        audioBackgroundView.snp.makeConstraints({ (make) in
            make.top.equalTo(AS(35))
            make.centerX.equalToSuperview()
            make.width.height.equalTo(AdaptIconSize(52))
        })

        audioPlayerView.snp.makeConstraints({ (make) in
            make.center.equalTo(audioBackgroundView)
            make.width.height.equalTo(AdaptIconSize(37))
        })
        
        textField.snp.makeConstraints { (make) in
            make.width.equalTo(lineView.viewWidth)
            make.height.equalTo(AdaptIconSize(43))
            make.centerX.equalToSuperview()
            make.bottom.equalTo(AdaptIconSize(-39))
        }

        lineView.snp.makeConstraints { (make) in
            make.edges.equalTo(textField)
        }
    }
    
    override func bindData() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.6) {[weak self] in
            self?.audioPlayerView.urlStr = self?.exerciseModel.word?.voice
            self?.audioPlayerView.play()
        }
    }
    
    
    private func textWidth() -> CGFloat {
        return CGFloat(exerciseModel.word?.word?.count ?? 0) * 25.0
    }

    
    @objc func textChanged() {
        guard let text = textField.text?.trimed else {
            return
        }
        
        let wordLength = YXListenFillAnswerHelp.letterLength(text: exerciseModel.word?.word)
        
        if text.count <= wordLength {
            lineView.text = text
            textField.text = text //去除了空格的，重新设置到文本框中
            
            if lineView.text.count == wordLength {
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.15) { [weak self] in
                    self?.processAnswer(text: text)
                }
            }
        } else {
            textField.text = text.subString(location: 0, length: wordLength)
        }
    }
    
    
    func processAnswer(text: String) {
        let rightWord = YXListenFillAnswerHelp.letterText(text: exerciseModel.word?.word)
        if rightWord == text {
            textField.resignFirstResponder()
            answerCompletion(right: true)
        } else {
            errorCount += 1

            if errorCount > 3 {
                textField.resignFirstResponder()
            }
            answerCompletion(right: false)
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.8) { [weak self] in
                self?.lineView.text = ""
                self?.textField.text = ""
            }
        }
    }

    @objc func clickTipsBtnAction() {
        self.errorCount += 1
        if errorCount > 3 {
            self.textField.resignFirstResponder()
        }
    }

    @objc func closeWordDetailPage() {
        if errorCount > 3 {
            textField.becomeFirstResponder()
        }
    }

    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        textField.resignFirstResponder()
    }
}



class YXListenFillAnswerLineView: YXView {
    var openKeyboard: (() -> ())?
    
    var allText: String = "" {
        didSet { createLineView(); createFrontView() }
    }
    var text: String = "" {
        didSet { bindData() }
    }
    var viewWidth: CGFloat = 0
    private var lineWidth: CGFloat {
        let maxWidth = AdaptIconSize(332) / CGFloat(allText.count)
        let defaultWidth = AdaptIconSize(23)
        return (maxWidth < defaultWidth ? maxWidth : defaultWidth)
    }
    private var sysbolWidth: CGFloat = AdaptIconSize(12)
    
    private let interval: CGFloat = AdaptIconSize(2.5)
    private var letterLabels: [UILabel] = []
    private var symbolLabels: [UILabel] = []
    private var frontView = UIView()
    
    override func bindData() {
        for label in letterLabels {
            label.text = ""
        }
        for (i, v) in text.enumerated() {
            letterLabels[i].text = String(v)
        }
    }
    
    
    func createLineView() {
        var lastView: UIView?
        for (_, v) in self.allText.enumerated() {
            let lineX: CGFloat = {
                guard let _lastView = lastView else {
                    return .zero
                }
                return _lastView.origin.x + _lastView.size.width
            }()
        
            let letter = String(v)
            if YXListenFillAnswerHelp.isLetter(text: letter) {
                let letterLabel = createLetterLabel()
                letterLabel.frame = CGRect(x: lineX, y: 0, width: lineWidth, height: AdaptIconSize(42))
                self.addSubview(letterLabel)
                letterLabels.append(letterLabel)
                
                lastView = letterLabel
            } else {
                let symbolLabel = createSymbolLabel(text: letter)
                symbolLabel.frame = CGRect(x: lineX, y: 0, width: sysbolWidth, height: AdaptIconSize(42))
                self.addSubview(symbolLabel)
                symbolLabels.append(symbolLabel)
                
                lastView = symbolLabel
            }

        }
        if let _lastView = lastView {
            viewWidth = _lastView.origin.x + _lastView.size.width
        }
    }

    
    private func createLetterLabel() -> UILabel {
        let letterLabel = UILabel()
        letterLabel.textColor = UIColor.black1
        letterLabel.font = UIFont.mediumFont(ofSize: AdaptFontSize(26))
        letterLabel.textAlignment = .center
        letterLabel.adjustsFontSizeToFitWidth = true
        letterLabel.minimumScaleFactor = 0.2
        let lineView = UIView()
        lineView.backgroundColor = UIColor.black4
        letterLabel.addSubview(lineView)
        lineView.snp.makeConstraints { (make) in
            make.left.equalTo(interval)
            make.right.equalTo(-interval)
            make.height.equalTo(AS(1))
            make.bottom.equalToSuperview()
        }
        
        return letterLabel
    }
    
    private func createSymbolLabel(text: String) -> UILabel {
        let letterLabel = UILabel()
        letterLabel.text = text
        letterLabel.textColor = UIColor.black1
        letterLabel.font = UIFont.mediumFont(ofSize: AdaptFontSize(17))
        letterLabel.textAlignment = .center
        letterLabel.adjustsFontSizeToFitWidth = true
        letterLabel.minimumScaleFactor = 0.2
        return letterLabel
    }
    
    private func createFrontView() {
        let tap = UITapGestureRecognizer()
        tap.addTarget(self, action: #selector(openKeyboardEvent))
        frontView.isUserInteractionEnabled = true
        frontView.addGestureRecognizer(tap)
        
        self.addSubview(frontView)
        frontView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
    }
    
    @objc private func openKeyboardEvent() {
        openKeyboard?()
    }
}



struct YXListenFillAnswerHelp {
    static let letters = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz"
    static func isLetter(text: String) -> Bool {
        return letters.contains(text)
    }
    
    static func letterLength(text: String?) -> Int {
        return letterText(text: text)?.count ?? 0
    }
    
    static func letterText(text: String?) -> String? {
        guard let t = text else { return nil }
        var letters = ""
        for (_, v) in t.enumerated() {
            if isLetter(text: String(v)) {
                letters.append(String(v))
            }
        }
        return letters
    }
}
