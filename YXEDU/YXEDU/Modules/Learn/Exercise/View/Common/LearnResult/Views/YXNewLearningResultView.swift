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

class YXNewLearningResultView: YXView, CAAnimationDelegate, YXNewLearningResultCalendarViewProtocol, UIScrollViewDelegate {

    var fromWordCount = 0
    var toWordCount   = 0
    var fromDayCount  = 0
    var toDayCount    = 0
    var model: YXExerciseResultDisplayModel?

    weak var delegate: YXNewLearningResultViewProtocol?

    var scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.showsVerticalScrollIndicator   = false
        scrollView.showsHorizontalScrollIndicator = false
        return scrollView
    }()
    var scrollViewContentView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.clear
        return view
    }()
    var headerBackgroundView: UIView = {
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
        button.titleLabel?.font = UIFont.mediumFont(ofSize: AdaptFontSize(17))
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
        self.addSubview(scrollView)
        scrollView.addSubview(scrollViewContentView)
        scrollViewContentView.addSubview(headerBackgroundView)
        scrollViewContentView.addSubview(resultView)
        scrollViewContentView.addSubview(closeButton)
        scrollViewContentView.addSubview(collectView)
        scrollViewContentView.addSubview(calendarContentView)
        collectView.addSubview(wordCountLabel)
        collectView.addSubview(wordTitleLabel)
        collectView.addSubview(dayCountLabel)
        collectView.addSubview(dayTitleLabel)
        self.addSubview(punchButton)

        scrollView.snp.makeConstraints { (make) in
            make.left.top.right.equalToSuperview()
            make.bottom.equalTo(punchButton.snp.top)
        }
        scrollViewContentView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
            make.width.equalTo(screenWidth)
            make.bottom.equalTo(calendarContentView)
        }
        headerBackgroundView.size = CGSize(width: screenWidth, height: AdaptSize(243) + kStatusBarHeight)
        headerBackgroundView.snp.makeConstraints { (make) in
            make.top.centerX.equalToSuperview()
            make.size.equalTo(headerBackgroundView.size)
        }
        closeButton.snp.makeConstraints { (make) in
            make.left.equalToSuperview().offset(AdaptSize(20))
            make.top.equalToSuperview().offset(kStatusBarHeight + AdaptSize(10))
            make.size.equalTo(CGSize(width: AdaptSize(22), height: AdaptSize(22)))
        }
        resultView.snp.makeConstraints { (make) in
            make.left.right.equalToSuperview()
            make.top.equalToSuperview().offset(kStatusBarHeight - AdaptSize(8))
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
        self.calendarContentView.delegate   = self
        self.scrollView.delegate            = self
        self.headerBackgroundView.backgroundColor = UIColor.gradientColor(with: headerBackgroundView.size, colors: [UIColor.hex(0xFAB222), UIColor.hex(0xFF7C05)], direction: .horizontal)
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
        if self.calendarContentView.todayCell?.isShowed == .some(false) {
            self.calendarContentView.todayCell?.showAnimation(duration: 0.8)
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.3) { [weak self] in
                guard let self = self else { return }
                self.delegate?.punchAction()
                self.punchButton.setTitle("打卡分享", for: .normal)
            }
        } else {
            self.delegate?.punchAction()
            self.punchButton.setTitle("打卡分享", for: .normal)
        }
    }

    /// 设置数据
    /// - Parameters:
    ///   - currentLearnedWordsCount: 当次学习的单词数
    ///   - model: 学习结果模型对象
    func setData(currentLearnedWordsCount:Int, model: YXExerciseResultDisplayModel) {

        self.model         = model
        self.fromWordCount = model.allWordNum - currentLearnedWordsCount
        self.toWordCount   = model.allWordNum
        self.fromDayCount  = model.studyDay - 1
        self.toDayCount    = model.studyDay
        // 容错处理
        if self.fromWordCount < 0 {
            self.fromWordCount = 0
        }
        if self.fromDayCount < 0 {
            self.fromDayCount = 0
        }

        self.resultView.setData(model: model)
        self.calendarContentView.setData()
        //  首次上报，显示动画
        let cacheKey = YXLocalKey.currentFirstReport.rawValue + NSDate().formatYMD()
        let isFirstStudy: Bool = YYCache.object(forKey: cacheKey) as? Bool ?? true
        YYCache.set(false, forKey: cacheKey)
        if isFirstStudy {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) { [weak self] in
                self?.augmentCount()
            }
        } else {
            self.wordCountLabel.text = "\(toWordCount)"
            self.dayCountLabel.text  = "\(toDayCount)"
        }
    }

    // MARK: ==== Tools ====
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

    private func showNumberAnimation(label: UILabel) {

        let opacityAnimation    = CAKeyframeAnimation(keyPath: "opacity")
        opacityAnimation.values = [1.0, 0.0]

        let upAnimation       = CABasicAnimation(keyPath: "transform.translation.y")
        upAnimation.fromValue = label.frame.origin.y + 2
        upAnimation.toValue   = label.frame.origin.y - 30

        let animationGroup = CAAnimationGroup()
        animationGroup.animations     = [opacityAnimation, upAnimation]
        animationGroup.autoreverses   = false
        animationGroup.duration       = 0.25
        animationGroup.timingFunction = CAMediaTimingFunction(name: .linear)
        animationGroup.delegate       = self

        label.layer.add(animationGroup, forKey: "animationGroup")
    }

    // MARK: ==== CAAnimationDelegate ====
    func animationDidStop(_ anim: CAAnimation, finished flag: Bool) {
        if flag {
            self.augmentCount()
        }
    }

    // MARK: ==== YXNewLearningResultCalendarViewProtocol ====
    func calendarPunchAction() {
        self.punchAction()
    }

    // MARK: ==== UIScrollViewDelegate ====
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView.contentOffset.y < 0 {
            scrollView.contentOffset.y = 0
        }
    }
}
