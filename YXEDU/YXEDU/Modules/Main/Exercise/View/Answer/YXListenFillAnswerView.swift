//
//  YXListenFillAnswerView.swift
//  YXEDU
//
//  Created by sunwu on 2019/12/20.
//  Copyright © 2019 shiji. All rights reserved.
//

import UIKit

class YXListenFillAnswerView: YXBaseAnswerView {
        
    var textField = UITextField()
    var lineView = YXListenFillAnswerLineView()
    var audioPlayerView = YXAudioPlayerView()
    
    private var audioBackgroundView: UIView = UIView()
    
    private var errorCount = 0
    
    deinit {
        NotificationCenter.default.removeObserver(self, name: YXNotification.kCloseWordDetailPage, object: nil)
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
        
        self.audioBackgroundView.backgroundColor = UIColor.orange3
        self.audioBackgroundView.layer.masksToBounds = true
        self.audioBackgroundView.layer.cornerRadius = AdaptSize(26)
        self.audioBackgroundView.layer.borderWidth = 3
        self.audioBackgroundView.layer.borderColor = UIColor.orange2.cgColor
        
//        textField.backgroundColor = UIColor.red.withAlphaComponent(0.3)
        textField.textColor = UIColor.clear
        textField.autocorrectionType = .no
        textField.autocapitalizationType = .none
        textField.keyboardType = .asciiCapable
        textField.tintColor = UIColor.clear
        textField.addTarget(self, action: #selector(textChanged), for: .editingChanged)
        textField.becomeFirstResponder()
        
        lineView.count = exerciseModel.word?.word?.count ?? 0
        lineView.openKeyboard = { [weak self] in
            self?.textField.becomeFirstResponder()
        }
        
        NotificationCenter.default.addObserver(self, selector: #selector(closeWordDetailPage), name: YXNotification.kCloseWordDetailPage, object: nil)
    }
     
    override func layoutSubviews() {
        super.layoutSubviews()
        
        audioBackgroundView.snp.makeConstraints({ (make) in
            make.top.equalTo(AS(35))
            make.centerX.equalToSuperview()
            make.width.height.equalTo(AS(52))
        })

        audioPlayerView.snp.makeConstraints({ (make) in
            make.center.equalTo(audioBackgroundView)
            make.width.height.equalTo(AdaptSize(37))
        })
    
        lineView.snp.makeConstraints { (make) in
            make.left.right.equalTo(textField)
            make.height.equalTo(AS(43))
            make.bottom.equalTo(AS(-39))
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
        
        let wordLength = exerciseModel.word?.word?.count ?? 0
        
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
        
        if exerciseModel.word?.word?.uppercased() == text.uppercased() {
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
    
    @objc func closeWordDetailPage() {
        if errorCount > 3 {
            textField.becomeFirstResponder()
        }
    }
}



class YXListenFillAnswerLineView: YXView {
    var openKeyboard: (() -> ())?
    var count: Int = 0 {
        didSet { createLineView() }
    }
    var text: String = "" {
        didSet { bindData() }
    }
    
    private var labels: [UILabel] = []
    private var lineWidth: CGFloat = 20
    private var interval: CGFloat = 5
    
    override func bindData() {
        for label in labels {
            label.text = ""
        }
        for (i, v) in text.enumerated() {
            labels[i].text = String(v)
        }
    }
    
    
    func createLineView() {
        
        for i in 0..<self.count {
            
            let lineX = (lineWidth + interval) * CGFloat(i)
            
            let label = UILabel()
            label.textColor = UIColor.black1
            label.font = UIFont.mediumFont(ofSize: AS(26))
            label.textAlignment = .center
            label.frame = CGRect(x: AS(lineX), y: 0, width: AS(lineWidth + interval), height: AS(37))
            self.addSubview(label)
            
            labels.append(label)
            
            let lineView = UIView()
            lineView.backgroundColor = UIColor.black4
            lineView.frame = CGRect(x: AS(lineX + 2.5), y: AS(41), width: AS(lineWidth), height: AS(2))
            
            self.addSubview(lineView)
        }
        
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        openKeyboard?()
    }
    
    
}
