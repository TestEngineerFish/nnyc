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

class YXNewLearningResultView: YXView, YXNewLearningResultCalendarViewProtocol, UIScrollViewDelegate {

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
        scrollView.isScrollEnabled = true
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
//    var wordCountLabel: UILabel = {
//        let label = UILabel()
//        label.text          = ""
//        label.textColor     = UIColor.orange1
//        label.font          = UIFont.DINAlternateBold(ofSize: AdaptFontSize(32))
//        label.textAlignment = .center
//        label.isHidden      = true
//        return label
//    }()
    var wordTitleLabel: UILabel = {
        let label = UILabel()
        label.text          = "今日单词"
        label.textColor     = UIColor.gray1
        label.font          = UIFont.regularFont(ofSize: AdaptFontSize(12))
        label.textAlignment = .center
        return label
    }()
//    var dayCountLabel: UILabel = {
//        let label = UILabel()
//        label.text          = ""
//        label.textColor     = UIColor.orange1
//        label.font          = UIFont.DINAlternateBold(ofSize: AdaptFontSize(32))
//        label.textAlignment = .center
//        label.isHidden      = true
//        return label
//    }()
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
        let _title   = YXUserModel.default.isFirstStudy ? "打卡" : "分享海报"
        let button = UIButton()
        button.setTitle(_title, for: .normal)
        button.setTitleColor(UIColor.white, for: .normal)
        button.titleLabel?.font = UIFont.mediumFont(ofSize: AdaptFontSize(17))
        button.titleEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: kSafeBottomMargin, right: 0)
        return button
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.createSubviews()
        self.bindProperty()
        self.addNotification()
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
//        collectView.addSubview(wordCountLabel)
        collectView.addSubview(wordTitleLabel)
//        collectView.addSubview(dayCountLabel)
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
            make.left.equalToSuperview().offset(AdaptSize(20))
            make.right.equalToSuperview().offset(AdaptSize(-20))
            make.top.equalTo(resultView.snp.bottom).offset(AdaptFontSize(20))
            make.height.equalTo(AdaptSize(90))
        }
//        wordCountLabel.snp.makeConstraints { (make) in
//            make.centerX.equalToSuperview().multipliedBy(0.5)
//            make.top.equalToSuperview().offset(AdaptSize(15))
//        }
        wordTitleLabel.snp.makeConstraints { (make) in
            make.bottom.equalToSuperview().offset(AdaptSize(-20))
            make.centerX.equalToSuperview().multipliedBy(0.5)
        }
//        dayCountLabel.snp.makeConstraints { (make) in
//            make.centerX.equalToSuperview().multipliedBy(1.5)
//            make.top.equalToSuperview().offset(AdaptSize(15))
//        }
        dayTitleLabel.snp.makeConstraints { (make) in
            make.centerY.equalTo(wordTitleLabel)
            make.centerX.equalToSuperview().multipliedBy(1.5)
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

    private func addNotification() {
        NotificationCenter.default.addObserver(self, selector: #selector(self.resultPlayFinishedNotification), name: YXNotification.kResultPlayFinished, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.wordAnimationPlayFinished), name: YXNotification.kWordAnimationPlayFinished, object: nil)
    }

    // MARK: ==== Event ====
    @objc
    private func closedAction() {
        self.delegate?.closedAction()
    }

    @objc
    private func punchAction() {
        if self.calendarContentView.todayCell?.isShowedAnimation == .some(true) {
            self.calendarContentView.todayCell?.showAnimation(duration: 0.8)
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.3) { [weak self] in
                guard let self = self else { return }
                self.delegate?.punchAction()
                self.punchButton.setTitle("分享海报", for: .normal)
            }
        } else {
            self.delegate?.punchAction()
            self.punchButton.setTitle("分享海报", for: .normal)
        }
    }

    @objc
    private func resultPlayFinishedNotification() {
        // 学完需要等结果星星动画播放结束后才播放
        self.showWordRollAnimation()
    }

    @objc
    private func wordAnimationPlayFinished() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) { [weak self] in
            self?.showDayRollAnimation()
        }
    }

    /// 设置数据
    /// - Parameters:
    ///   - currentLearnedWordsCount: 当次学习的单词数
    ///   - model: 学习结果模型对象
    func setData(currentLearnedWordsCount:Int, model: YXExerciseResultDisplayModel) {
        self.model         = model
        self.fromWordCount = YXUserModel.default.isFirstStudy ? model.allWordNum - currentLearnedWordsCount : model.allWordNum
        self.toWordCount   = model.allWordNum
        self.fromDayCount  = model.studyDay - 1
        self.toDayCount    = model.studyDay
        // 更新学习记录
        YXUserModel.default.isFirstStudy = false
        // 容错处理
        if self.fromWordCount < 0 {
            self.fromWordCount = 0
        }
        if self.fromDayCount < 0 {
            self.fromDayCount = 0
        }
        // 未学完，自动播放动画
        if !model.state {
            self.showWordRollAnimation()
        }
        self.resultView.setData(model: model)
        self.calendarContentView.setData(model.studyModelList)
    }

    private func showWordRollAnimation() {
        let wordRollView = YXRollNumberView(from: fromWordCount, to: toWordCount, font: UIFont.DINAlternateBold(ofSize: AdaptFontSize(32)), color: UIColor.orange1, type: .word, frame: CGRect(x: 0, y: AdaptSize(15), width: screenWidth/2 - AdaptSize(20), height: AdaptSize(37)))
        self.collectView.addSubview(wordRollView)
        wordRollView.show()
    }

    private func showDayRollAnimation() {
        let dayRollView  = YXRollNumberView(from: fromDayCount, to: toDayCount, font: UIFont.DINAlternateBold(ofSize: AdaptFontSize(32)), color: UIColor.orange1, type: .day, frame: CGRect(x: screenWidth/2 - AdaptSize(20), y: AdaptSize(15), width: screenWidth/2 - AdaptSize(20), height: AdaptSize(37)))
        self.collectView.addSubview(dayRollView)
        dayRollView.show()
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
