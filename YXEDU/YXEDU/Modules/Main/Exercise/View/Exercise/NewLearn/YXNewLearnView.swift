//
//  YXNewLearnView.swift
//  YXEDU
//
//  Created by 沙庭宇 on 2020/3/7.
//  Copyright © 2020 shiji. All rights reserved.
//

import UIKit
import Lottie

class YXNewLearnView: UIView {
    
    var closeButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "close_black"), for: .normal)
        return button
    }()
    
    var titleLabel: UILabel = {
        let label = UILabel()
        label.font          = UIFont.semiboldFont(ofSize: AdaptSize(26))
        label.textColor     = UIColor.black1
        label.textAlignment = .center
        return label
    }()
    
    var subtitleLabel: UILabel = {
        let label = UILabel()
        label.font          = UIFont.regularFont(ofSize: AdaptSize(14))
        label.textColor     = UIColor.black1
        label.textAlignment = .center
        return label
    }()
    
    var answerView: YXNewLearnAnswerView!
    var wordModel: YXWordModel!
    
    init(wordModel: YXWordModel) {
        self.wordModel = wordModel
        answerView = YXNewLearnAnswerView(wordModel: wordModel, exerciseModel: nil)
        super.init(frame: CGRect.zero)
        self.createSubviews()
        self.bindProperty()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func createSubviews() {
        self.addSubview(closeButton)
        self.addSubview(titleLabel)
        self.addSubview(subtitleLabel)
        self.addSubview(answerView)
        
        closeButton.snp.makeConstraints { (make) in
            make.left.equalToSuperview().offset(AdaptSize(15))
            make.top.equalToSuperview().offset(AdaptSize(35))
            make.size.equalTo(CGSize(width: AdaptSize(32), height: AdaptSize(32)))
        }
        titleLabel.snp.makeConstraints { (make) in
            make.left.equalToSuperview().offset(AdaptSize(15))
            make.right.equalToSuperview().offset(AdaptSize(-15))
            make.height.equalTo(AdaptSize(37))
            make.top.equalTo(closeButton.snp.bottom).offset(AdaptSize(140))
        }
        subtitleLabel.snp.makeConstraints { (make) in
            make.left.equalToSuperview().offset(AdaptSize(15))
            make.right.equalToSuperview().offset(AdaptSize(-15))
            make.height.equalTo(AdaptSize(20))
            make.top.equalTo(titleLabel.snp.bottom).offset(AdaptSize(2))
        }
        answerView.snp.makeConstraints({ (make) in
            make.centerX.equalToSuperview()
            make.bottom.equalToSuperview().offset(AdaptSize(-148))
            make.height.equalTo(AdaptSize(111))
            make.width.equalToSuperview()
        })
    }
    
    private func bindProperty() {
        
        self.backgroundColor    = UIColor.white.withAlphaComponent(0.95)
        self.titleLabel.text    = wordModel.word
        self.subtitleLabel.text = (wordModel.partOfSpeech ?? "") + " " + (wordModel.meaning ?? "")
        self.closeButton.addTarget(self, action: #selector(closeAction), for: .touchUpInside)
    }
    
    // MARK: ---- Event ----
    @objc private func closeAction() {
        self.answerView.pauseView()
        self.removeFromSuperview()
    }
    
    func show() {
        kWindow.addSubview(self)
        self.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
    }
    
}
