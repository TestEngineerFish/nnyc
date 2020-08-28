//
//  YXNewLearningResultView.swift
//  YXEDU
//
//  Created by 沙庭宇 on 2020/8/26.
//  Copyright © 2020 shiji. All rights reserved.
//

import Foundation

protocol YXNewLearningResultViewProtocol: NSObjectProtocol {
    func closedAction()
    func punchAction()
}

class YXNewLearningResultView: YXView, CAAnimationDelegate {

    var fromWordCount = 0
    var toWordCount   = 0
    var fromDayCount  = 0
    var toDayCount    = 0
    var model: YXExerciseResultDisplayModel?

    weak var delegate: YXNewLearningResultViewProtocol?

    var backgroundView: UIView = {
        let view = UIView()
        return view
    }()
    var closeButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "close_white"), for: .normal)
        return button
    }()
    let resultView = YXNewLearningResultHeaderView()
    var collectView: UIView = {
        let view = UIView()
        view.backgroundColor    = UIColor.white
        view.layer.cornerRadius = AdaptSize(8)
        return view
    }()
    var wordCountLabel: UILabel = {
        let label = UILabel()
        label.text          = ""
        label.textColor     = UIColor.orange1
        label.font          = UIFont.DINAlternateBold(ofSize: AdaptFontSize(32))
        label.textAlignment = .center
        return label
    }()
    var wordTitleLabel: UILabel = {
        let label = UILabel()
        label.text          = "今日单词"
        label.textColor     = UIColor.gray1
        label.font          = UIFont.regularFont(ofSize: AdaptFontSize(12))
        label.textAlignment = .center
        return label
    }()
    var dayCountLabel: UILabel = {
        let label = UILabel()
        label.text          = ""
        label.textColor     = UIColor.orange1
        label.font          = UIFont.DINAlternateBold(ofSize: AdaptFontSize(32))
        label.textAlignment = .center
        return label
    }()
    var dayTitleLabel: UILabel = {
        let label = UILabel()
        label.text          = "坚持天数"
        label.textColor     = UIColor.gray1
        label.font          = UIFont.regularFont(ofSize: AdaptFontSize(12))
        label.textAlignment = .center
        return label
    }()
    let calendarContentView = YXNewLearningResultCalendarView()
    var punchButton: UIButton = {
        let button = UIButton()
        button.setTitle("打卡", for: .normal)
        button.setTitleColor(UIColor.white, for: .normal)
        button.titleLabel?.font = UIFont.regularFont(ofSize: AdaptFontSize(15))
        button.titleEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: kSafeBottomMargin, right: 0)
        return button
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.createSubviews()
        self.bindProperty()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func createSubviews() {
        super.createSubviews()
        self.addSubview(backgroundView)
        self.addSubview(resultView)
        self.addSubview(closeButton)
        self.addSubview(collectView)
        self.addSubview(calendarContentView)
        self.addSubview(punchButton)
        collectView.addSubview(wordCountLabel)
        collectView.addSubview(wordTitleLabel)
        collectView.addSubview(dayCountLabel)
        collectView.addSubview(dayTitleLabel)

        backgroundView.size = CGSize(width: screenWidth, height: AdaptSize(243) + kStatusBarHeight)
        backgroundView.snp.makeConstraints { (make) in
            make.top.centerX.equalToSuperview()
            make.size.equalTo(backgroundView.size)
        }
        closeButton.snp.makeConstraints { (make) in
            make.left.equalToSuperview().offset(AdaptSize(20))
            make.top.equalToSuperview().offset(kStatusBarHeight + AdaptSize(10))
            make.size.equalTo(CGSize(width: AdaptSize(22), height: AdaptSize(22)))
        }
        resultView.snp.makeConstraints { (make) in
            make.left.right.equalToSuperview()
            make.top.equalToSuperview().offset(kStatusBarHeight)
            make.height.equalTo(AdaptSize(178))
        }
        collectView.snp.makeConstraints { (make) in
            make.left.equalToSuperview().offset(AdaptFontSize(20))
            make.right.equalToSuperview().offset(AdaptSize(-20))
            make.top.equalTo(resultView.snp.bottom).offset(AdaptFontSize(20))
            make.height.equalTo(AdaptSize(90))
        }
        wordCountLabel.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview().multipliedBy(0.5)
            make.top.equalToSuperview().offset(AdaptSize(15))
        }
        wordTitleLabel.snp.makeConstraints { (make) in
            make.top.equalTo(wordCountLabel.snp.bottom).offset(AdaptSize(1))
            make.centerX.equalTo(wordCountLabel)
        }
        dayCountLabel.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview().multipliedBy(1.5)
            make.top.equalToSuperview().offset(AdaptSize(15))
        }
        dayTitleLabel.snp.makeConstraints { (make) in
            make.top.equalTo(dayCountLabel.snp.bottom).offset(AdaptSize(1))
            make.centerX.equalTo(dayCountLabel)
        }
        calendarContentView.snp.makeConstraints { (make) in
            make.top.equalTo(collectView.snp.bottom).offset(AdaptFontSize(25))
            make.left.right.equalToSuperview()
            make.height.equalTo(AdaptSize(350))
        }
        punchButton.size = CGSize(width: screenWidth, height: AdaptSize(50) + kSafeBottomMargin)
        punchButton.snp.makeConstraints { (make) in
            make.bottom.centerX.equalToSuperview()
            make.size.equalTo(punchButton.size)
        }
    }

    override func bindProperty() {
        super.bindProperty()
        self.collectView.layer.setDefaultShadow()
        self.backgroundView.backgroundColor = UIColor.gradientColor(with: backgroundView.size, colors: [UIColor.hex(0xFAB222), UIColor.hex(0xFF7C05)], direction: .horizontal)
        self.punchButton.backgroundColor = UIColor.gradientColor(with: punchButton.size, colors: [UIColor.hex(0xFDBA33), UIColor.hex(0xFB8417)], direction: .horizontal)
        self.closeButton.addTarget(self, action: #selector(self.closedAction), for: .touchUpInside)
        self.punchButton.addTarget(self, action: #selector(self.punchAction), for: .touchUpInside)
    }

    // MARK: ==== Event ====
    @objc
    private func closedAction() {
        self.delegate?.closedAction()
    }

    @objc
    private func punchAction() {
        self.delegate?.punchAction()
    }

    func setData(model: YXExerciseResultDisplayModel) {
        self.model = model
        self.fromWordCount = 15
        self.toWordCount   = 26
        self.fromDayCount  = 10
        self.toDayCount    = 11
        self.wordCountLabel.text = "\(fromWordCount)"
        self.dayCountLabel.text  = "\(fromDayCount)"
        self.resultView.setData(model: model)
        self.calendarContentView.setData()
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) { [weak self] in
            self?.augmentCount()
        }
    }

    // MARK: ==== Tools ====
    private func showNumberAnimation(label: UILabel) {

        let opacityAnimation    = CAKeyframeAnimation(keyPath: "opacity")
        opacityAnimation.values = [1.0, 0.0]

        let upAnimation     = CABasicAnimation(keyPath: "transform.translation.y")
        upAnimation.toValue = label.frame.origin.y - 40

        let animationGroup = CAAnimationGroup()
        animationGroup.animations = [opacityAnimation, upAnimation]
        animationGroup.autoreverses   = false
        animationGroup.duration       = 0.25
        animationGroup.timingFunction = CAMediaTimingFunction(name: .linear)
        animationGroup.delegate       = self

        label.layer.add(animationGroup, forKey: "animationGroup")
    }

    private func augmentCount() {
        self.wordCountLabel.text = "\(self.fromWordCount)"
        self.dayCountLabel.text  = "\(self.fromDayCount)"
        if self.fromWordCount < self.toWordCount {
            self.showNumberAnimation(label: self.wordCountLabel)
            self.fromWordCount += 1
        }
        if self.fromDayCount < self.toDayCount {
            self.showNumberAnimation(label: self.dayCountLabel)
            self.fromDayCount += 1
        }
    }

    // MARK: ==== CAAnimationDelegate ====
    func animationDidStop(_ anim: CAAnimation, finished flag: Bool) {
        if flag {
            self.augmentCount()
        }
    }
}
