//
//  YXExerciseLoadingView.swift
//  YXEDU
//
//  Created by 沙庭宇 on 2019/11/22.
//  Copyright © 2019 shiji. All rights reserved.
//

import UIKit
import Lottie

protocol YXExerciseLoadingViewDelegate: NSObjectProtocol {
    /// 词书下载完成
    func downloadComplete()
    /// 进度条动画执行完成
    func animationComplete()
}

class YXExerciseLoadingView: YXView, CAAnimationDelegate {
    var progressLayer  = CAGradientLayer()
    var dotLayer       = CAGradientLayer()
    let descLabel      = UILabel()
    var fromRatio      = 0.0
    var toRatio        = 0.0
    var speed          = YXExerciseLoadingSpeedEnum.normal
    var addStepTime    = 0.0 // 单步进度停留时间
    var addLoadingTime = 0.0 // 总加载时间
    var timeInterval   = 0.1
    var stepTimeOut    = 4.0
    var loadingTimeOut = 30.0
    var status         = YXExerciseLoadingEnum.normal
    var isLoading      = false // 动画运行中
    var progressWidth  = AdaptIconSize(181.5)
    weak var delegate: YXExerciseLoadingViewDelegate?
    var timer: Timer?
    
    enum YXExerciseLoadingSpeedEnum: CGFloat {
        case normal    = 0.2
        case highSpeed = 1.0
    }
    
    enum YXExerciseLoadingEnum: Int {
        
        case normal       = 0
        case downloadBook = 1
        case requestIng   = 2
        case requestEnd   = 3
        
        func getDesction() -> String {
            switch self {
            case .normal:
                return "努力加载中…"
            case .downloadBook:
                return "正在下载词书…"
            case .requestIng, .requestEnd:
                return "正在加载学习数据…"
            }
        }
        
        func getRatio() -> CGFloat {
            switch self {
            case .normal:
                return 1.0
            case .downloadBook:
                return 0.4
            case .requestIng:
                return 0.9
            case .requestEnd:
                return 1.0
            }
        }
        
        func getDuration() -> Double {
            switch self {
            case .normal:
                return 5.0
            case .downloadBook:
                return 2.0
            case .requestIng:
                return 2.0
            case .requestEnd:
                return 1.0
            }
        }
    }
    
    var exercisType: YXLearnType
    
    init(type: YXLearnType) {
        exercisType = type
        super.init(frame: kWindow.bounds)
        self.createSubviews()
        YXLog("\(self)，被加载")
    }
    
    deinit {
        YXLog("\(self)，被释放")
        self.timer?.invalidate()
        self.timer = nil
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func createSubviews() {
        self.backgroundColor = UIColor.white
        
        let headerView = self.createHeaderView()
        let fooderView = self.createFooterView()
        self.addSubview(headerView)
        self.addSubview(fooderView)
        headerView.snp.makeConstraints { (make) in
            make.top.left.right.equalToSuperview()
            make.height.equalToSuperview().multipliedBy(0.7)
        }
        fooderView.snp.makeConstraints { (make) in
            make.left.bottom.right.equalToSuperview()
            make.height.equalToSuperview().multipliedBy(0.3)
        }
    }
    
    private func createHeaderView() -> UIView {
        let headerView     = UIView()
        let squirrelView   = AnimationView(name: "learnLoading")
        let progressBgView = UIView()
        
        descLabel.textAlignment = .center
        descLabel.textColor     = UIColor.black6
        descLabel.font          = UIFont.pfSCRegularFont(withSize: AdaptFontSize(12))
        descLabel.text          = self.status.getDesction()
        
        progressBgView.layer.cornerRadius  = AdaptIconSize(15)/2
        progressBgView.layer.masksToBounds = true
        progressBgView.backgroundColor     = UIColor.hex(0xF2F2F2)
        
        progressLayer.cornerRadius    = AdaptIconSize(15)/2
        progressLayer.masksToBounds   = true
        progressLayer.backgroundColor = UIColor.clear.cgColor
        
        dotLayer.borderWidth     = 3.0
        dotLayer.borderColor     = UIColor.orange1.cgColor
        dotLayer.cornerRadius    = AdaptIconSize(15)/2
        dotLayer.masksToBounds   = true
        dotLayer.backgroundColor = UIColor.white.cgColor
        
        headerView.addSubview(squirrelView)
        headerView.addSubview(descLabel)
        headerView.addSubview(progressBgView)
        progressBgView.layer.addSublayer(progressLayer)
        progressBgView.layer.addSublayer(dotLayer)
        
        squirrelView.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.top.equalToSuperview().offset(AdaptSize(102))
            make.size.equalTo(CGSize(width: AdaptIconSize(330), height: AdaptIconSize(228)))
        }
        descLabel.snp.makeConstraints { (make) in
            make.top.equalTo(squirrelView.snp.bottom).offset(AdaptSize(21))
            make.left.right.equalToSuperview()
            make.height.equalTo(AdaptSize(25))
        }
        progressBgView.snp.makeConstraints { (make) in
            make.top.equalTo(descLabel.snp.bottom).offset(AdaptSize(4))
            make.width.equalTo(progressWidth + AdaptIconSize(7.5))
            make.height.equalTo(AdaptIconSize(15))
            make.centerX.equalToSuperview()
        }
        self.progressLayer.frame = CGRect(x: 0, y: 0, width: progressWidth + AdaptIconSize(7.5), height: AdaptIconSize(15))
        self.dotLayer.frame      = CGRect(x: 0, y: 0, width: AdaptIconSize(15), height: AdaptIconSize(15))
        squirrelView.play()
        return headerView
    }
    
    private func createFooterView() -> UIView {
        let fooderView    = UIView()
        let bgImageView   = UIImageView(image: UIImage(named: "loading_bg"))
        let tipsImageView = UIImageView(image: UIImage(named: "icon_tips"))
        let titleLabel    = UILabel()
        
        titleLabel.textAlignment = .center
        titleLabel.numberOfLines = 2
        titleLabel.textColor     = UIColor.orange1
        titleLabel.font          = UIFont.pfSCMediumFont(withSize: AdaptFontSize(15))
        titleLabel.text          = self.getRandomTips()
        
        fooderView.addSubview(bgImageView)
        fooderView.addSubview(tipsImageView)
        fooderView.addSubview(titleLabel)
        
        bgImageView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        titleLabel.sizeToFit()
        titleLabel.snp.makeConstraints { (make) in
            make.left.right.equalToSuperview()
            make.height.equalTo(titleLabel.height)
            make.bottom.equalToSuperview().offset(AdaptSize(-63)-kSafeBottomMargin)
        }
        tipsImageView.snp.makeConstraints { (make) in
            make.left.equalTo(titleLabel).offset(AdaptSize(32))
            make.bottom.equalTo(titleLabel.snp.top).offset(AdaptSize(-9))
            make.size.equalTo(CGSize(width: AdaptIconSize(42), height: AdaptIconSize(24)))
        }
        
        return fooderView
    }
    
    // MARK: ==== Event ====
    func startAnimation() {
        self.timer = Timer(timeInterval: timeInterval, repeats: true, block: { [weakself = self] (timer) in
            weakself.addStepTime    += weakself.timeInterval
            weakself.addLoadingTime += weakself.timeInterval
            // 更新提示文案
            if weakself.addStepTime >= weakself.stepTimeOut {
                //                YXLog("加载超时，更新文案")
                DispatchQueue.main.async {
                    weakself.descLabel.text = weakself.status.getDesction()
                }
            }
            if weakself.addLoadingTime > weakself.loadingTimeOut {
                weakself.stopAnimation()
                DispatchQueue.main.async {
                    UIView().currentViewController?.navigationController?.popToRootViewController(animated: true)
                    YXUtils.showHUD(kWindow, title: "当前网速较慢，建议稍后重试")
                }
            }
            weakself.updateValue()
        })
        RunLoop.current.add(timer!, forMode: .common)
    }
    
    func stopAnimation() {
        self.timer?.invalidate()
        self.timer = nil
        self.dotLayer.removeAllAnimations()
        self.progressLayer.mask?.removeAllAnimations()
        self.removeFromSuperview()
    }
    
    private func updateValue() {
        if isLoading { return }
        // 更新状态
        let originStatus = self.status
        if exercisType == .base {
            // 防止进度回滚
            if self.status.rawValue < YXExerciseLoadingEnum.downloadBook.rawValue {
                self.status = .downloadBook
            }
            // 下载的任务中不存在未下载的单本词书
            var singleDownloadFinished = true
            YXWordBookResourceManager.taskList.forEach { (task) in
                if task.type == .single && task.bookId == YXUserModel.default.currentBookId && task.status != .finished {
                    singleDownloadFinished = false
                }
            }
            if singleDownloadFinished {
                YXLog("当前词书下载完成，开始主流程的学习")
                self.delegate?.downloadComplete()
                self.speed  = .highSpeed
                // 请求之前需要先下载完词书
                if YXExerciseViewController.requesting != nil {
                    if YXExerciseViewController.requesting == .some(true) {
                        self.status = .requestIng
                        self.speed  = .normal
                    } else {
                        self.status = .requestEnd
                        self.speed  = .highSpeed
                    }
                }
            } else {
                self.speed  = .normal
            }
        } else {
            // 防止进度回滚
            if self.status.rawValue < YXExerciseLoadingEnum.downloadBook.rawValue {
                self.status = .downloadBook
            }
            // 所有任务下载完成，才可以进入下一步
            if YXWordBookResourceManager.taskList.isEmpty {
                self.delegate?.downloadComplete()
                self.speed  = .highSpeed
                // 请求之前需要先下载完词书
                if YXExerciseViewController.requesting != nil {
                    if YXExerciseViewController.requesting == .some(true) {
                        self.status = .requestIng
                        self.speed  = .normal
                    } else {
                        self.status = .requestEnd
                        self.speed  = .highSpeed
                    }
                }
            } else {
                self.speed  = .normal
            }
        }
        
        
        self.fromRatio = self.toRatio
        self.toRatio   = Double(self.status.getRatio())
        
        // 执行动画
        if self.status != originStatus {
            self.isLoading = true
            DispatchQueue.main.async {
                self.showAnimation()
            }
        }
    }
    
    // MARK: Animation
    private func showAnimation() {
        YXLog("开始加载动画，当前状态\(self.status)")
        let dotAnimation = CABasicAnimation(keyPath: "position.x")
        let dotFrom: CGFloat = { [weak self] in
            guard let self = self else { return .zero }
            if self.fromRatio > .zero {
                return progressWidth * CGFloat(self.fromRatio)
            } else {
                return .zero
            }
        }()
        let dotTo: CGFloat = { [weak self] in
            guard let self = self else { return .zero }
            if self.toRatio > .zero {
                return progressWidth * CGFloat(self.toRatio)
            } else {
                return .zero
            }
        }()
        dotAnimation.fromValue      = dotFrom
        dotAnimation.toValue        = dotTo
        dotAnimation.repeatCount    = 1
        dotAnimation.duration       = self.status.getDuration()
        dotAnimation.autoreverses   = false
        dotAnimation.timingFunction = CAMediaTimingFunction(name: .linear)
        dotAnimation.fillMode       = .forwards
        dotAnimation.isRemovedOnCompletion = false
        dotLayer.add(dotAnimation, forKey: "dotAnimation")
        
        let proMaskLayer = CAShapeLayer()
        let path         = UIBezierPath()
        path.move(to: CGPoint(x: 0, y: AdaptIconSize(15)/2))
        path.addLine(to: CGPoint(x: progressWidth, y: AdaptIconSize(15)/2))
        proMaskLayer.path        = path.cgPath
        proMaskLayer.lineWidth   = AdaptIconSize(15)
        proMaskLayer.lineJoin    = .round
        proMaskLayer.strokeColor = UIColor.blue.cgColor
        proMaskLayer.fillColor   = nil
        self.progressLayer.mask  = proMaskLayer
        
        let proAnimation = CABasicAnimation(keyPath: "strokeEnd")
        proAnimation.fromValue      = self.fromRatio
        proAnimation.toValue        = self.toRatio
        proAnimation.repeatCount    = 1
        proAnimation.duration       = self.status.getDuration()
        proAnimation.autoreverses   = false
        proAnimation.fillMode       = .forwards
        proAnimation.timingFunction = CAMediaTimingFunction(name: .linear)
        proAnimation.delegate       = self
        proAnimation.isRemovedOnCompletion = false
        proMaskLayer.add(proAnimation, forKey: "proAnimation")
        self.progressLayer.backgroundColor = UIColor.orange1.cgColor
    }
    
    // MARK: CAAnimationDelegate
    
    func animationDidStop(_ anim: CAAnimation, finished flag: Bool) {
        if flag {
            self.isLoading   = false
            self.addStepTime = 0
            if self.toRatio >= 1.0 {
                self.stopAnimation()
                self.delegate?.animationComplete()
            }
        }
    }
    
    // TODO: ==== Tools ====
    private func getRandomTips() -> String {
        let tipsArray = ["阅读碰到不认识的单词\n主页点击右上角放大镜图片",
                         "已经学会的单词，可以点击已掌握\n增加学习效率",
                         "遇到实用的词，可以收藏起来\n经常看看，可以温故而知新",
                         "错词本就在首页，经常温习\n错误就会越来越少",
                         "好用的话记得给我们的App来个五星好评哦",
                         "分享给你的好朋友\n一起进步，才是牢固的羁绊"]
        let encourageArray = ["学习不在于学习的量有多少\n而在于坚持与质量",
                              "天天要读书是很累\n不过累着累着就突破了",
                              "学霸就是要在别人不知道的时候努力",
                              "越倒霉越努力，努力着努力着就顺了",
                              "要说天才的优势是什么\n那就是他天生会学习"]
        let totalArray = tipsArray + encourageArray
        return totalArray.randomElement() ?? ""
    }
}
