//
//  YXHomeworkDetailView.swift
//  YXEDU
//
//  Created by 沙庭宇 on 2020/8/19.
//  Copyright © 2020 shiji. All rights reserved.
//

import Foundation

protocol YXHomeworkDetailViewProperty: NSObjectProtocol {
    func showWordList()
    func downAction()
}

class YXHomeworkDetailView: YXView {

    var detailModel: YXHomeworkDetailModel?
    weak var delegate: YXHomeworkDetailViewProperty?

    var homeworkNameLabel: UILabel = {
        let label = UILabel()
        label.text          = ""
        label.textColor     = UIColor.black1
        label.font          = UIFont.mediumFont(ofSize: AdaptFontSize(17))
        label.textAlignment = .left
        return label
    }()
    var classNameLabel: UILabel = {
        let label = UILabel()
        label.text          = ""
        label.textColor     = UIColor.gray1
        label.font          = UIFont.regularFont(ofSize: AdaptFontSize(13))
        label.textAlignment = .left
        return label
    }()
    var progressLabel: UILabel = {
        let label = UILabel()
        label.text          = ""
        label.textColor     = UIColor.gray1
        label.font          = UIFont.regularFont(ofSize: AdaptFontSize(13))
        label.textAlignment = .left
        return label
    }()
    var statusImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image    = UIImage(named: "work_finished")
        imageView.isHidden = true
        return imageView
    }()
    var lineView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.hex(0xF4F4F4)
        return view
    }()
    var deadlineLabel: UILabel = {
        let label = UILabel()
        label.text          = ""
        label.textColor     = UIColor.gray1
        label.font          = UIFont.regularFont(ofSize: AdaptFontSize(14))
        label.textAlignment = .left
        return label
    }()
    var targetLabel: UILabel = {
        let label = UILabel()
        label.text          = ""
        label.textColor     = UIColor.gray1
        label.font          = UIFont.regularFont(ofSize: AdaptFontSize(14))
        label.textAlignment = .left
        return label
    }()
    var bookNameLabel: UILabel = {
        let label = UILabel()
        label.text          = ""
        label.textColor     = UIColor.gray1
        label.font          = UIFont.regularFont(ofSize: AdaptFontSize(14))
        label.textAlignment = .left
        return label
    }()
    var wordNumView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.clear
        return view
    }()
    var wordNumLabel: UILabel = {
        let label = UILabel()
        label.text          = ""
        label.textColor     = UIColor.gray1
        label.font          = UIFont.mediumFont(ofSize: AdaptFontSize(14))
        label.textAlignment = .right
        return label
    }()
    var arrowImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "arrow_right_grey")
        return imageView
    }()
    var bottomLineView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.black4
        return view
    }()
    var downButton: YXButton = {
        let button = YXButton(.theme, frame: .zero)
        button.titleLabel?.font = UIFont.regularFont(ofSize: AdaptFontSize(17))
        return button
    }()
    var progressView = YXReviewProgressView(type: .iKnow, cornerRadius: AdaptIconSize(4))

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
        self.addSubview(homeworkNameLabel)
        self.addSubview(classNameLabel)
        self.addSubview(progressLabel)
        self.addSubview(progressView)
        self.addSubview(statusImageView)
        self.addSubview(lineView)
        self.addSubview(deadlineLabel)
        self.addSubview(targetLabel)
        self.addSubview(bookNameLabel)
        self.addSubview(wordNumView)
        self.addSubview(downButton)
        self.addSubview(bottomLineView)
        wordNumView.addSubview(wordNumLabel)
        wordNumView.addSubview(arrowImageView)
        homeworkNameLabel.snp.makeConstraints { (make) in
            make.left.equalToSuperview().offset(AdaptSize(20))
            make.top.equalToSuperview().offset(AdaptSize(17))
            make.right.equalToSuperview().offset(AdaptSize(-20))
        }
        classNameLabel.snp.makeConstraints { (make) in
            make.left.equalToSuperview().offset(AdaptSize(20))
            make.right.equalToSuperview().offset(AdaptSize(-20))
            make.top.equalTo(homeworkNameLabel.snp.bottom).offset(AdaptSize(10))
        }
        progressLabel.snp.makeConstraints { (make) in
            make.left.equalToSuperview().offset(AdaptSize(20))
            make.top.equalTo(classNameLabel.snp.bottom).offset(AdaptSize(10))
        }
        progressView.size = CGSize(width: AdaptSize(200), height: AdaptSize(8))
        progressView.snp.makeConstraints { (make) in
            make.left.equalTo(progressLabel.snp.right).offset(AdaptSize(5))
            make.centerY.equalTo(progressLabel)
            make.size.equalTo(progressView.size)
        }
        statusImageView.snp.makeConstraints { (make) in
            make.right.equalToSuperview()
            make.centerY.equalTo(progressLabel)
            make.size.equalTo(CGSize(width: AdaptSize(46), height: AdaptSize(46)))
        }
        lineView.snp.makeConstraints { (make) in
            make.left.right.equalToSuperview()
            make.top.equalTo(progressLabel.snp.bottom).offset(AdaptSize(20))
            make.height.equalTo(AdaptSize(10))
        }
        deadlineLabel.snp.makeConstraints { (make) in
            make.left.equalToSuperview().offset(AdaptSize(20))
            make.right.equalToSuperview().offset(AdaptSize(-20))
            make.top.equalTo(lineView.snp.bottom).offset(AdaptSize(20))
        }
        targetLabel.snp.makeConstraints { (make) in
            make.left.equalToSuperview().offset(AdaptSize(20))
            make.right.equalToSuperview().offset(AdaptSize(-20))
            make.top.equalTo(deadlineLabel.snp.bottom).offset(AdaptSize(10))
        }
        bookNameLabel.snp.makeConstraints { (make) in
            make.left.equalToSuperview().offset(AdaptSize(20))
            make.right.greaterThanOrEqualTo(wordNumView.snp.left).offset(AdaptSize(-15))
            make.top.equalTo(targetLabel.snp.bottom).offset(AdaptSize(10))
        }
        wordNumView.snp.makeConstraints { (make) in
            make.centerY.equalTo(bookNameLabel)
            make.right.equalToSuperview().offset(AdaptSize(-20))
            make.size.equalTo(CGSize(width: AdaptSize(80), height: AdaptSize(40)))
        }
        wordNumLabel.snp.makeConstraints { (make) in
            make.height.centerY.equalToSuperview()
            make.right.equalTo(arrowImageView.snp.left).offset(AdaptSize(-5))
        }
        arrowImageView.snp.makeConstraints { (make) in
            make.centerY.right.equalToSuperview()
            make.size.equalTo(CGSize(width: AdaptSize(6), height: AdaptSize(12)))
        }
        bottomLineView.snp.makeConstraints { (make) in
            make.left.equalToSuperview().offset(AdaptSize(20))
            make.right.equalToSuperview().offset(AdaptSize(-20))
            make.top.equalTo(bookNameLabel.snp.bottom).offset(AdaptSize(20))
            make.height.equalTo(0.6)
        }
        downButton.size = CGSize(width: AdaptSize(273), height: AdaptSize(42))
        downButton.snp.makeConstraints { (make) in
            make.top.equalTo(bottomLineView.snp.bottom).offset(AdaptSize(40))
            make.centerX.equalToSuperview()
            make.size.equalTo(downButton.size)
        }
    }

    override func bindProperty() {
        super.bindProperty()
        self.downButton.addTarget(self, action: #selector(self.downAction), for: .touchUpInside)
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.showWordList))
        self.wordNumView.addGestureRecognizer(tap)
    }

    func setDate(model: YXHomeworkDetailModel, punchAmount: Int) {
        self.detailModel = model
        self.homeworkNameLabel.text = model.workName
        self.classNameLabel.text    = model.className
        self.deadlineLabel.text     = "截止日期：\(model.endDateStr)"
        self.targetLabel.text       = "目标：" + model.type.description()
        self.bookNameLabel.text     = "词书：\(model.bookName)"
        self.wordNumLabel.text      = "\(model.wordCount)个单词"

        var progress: CGFloat = 0
        if model.type == .punch {
            self.wordNumView.isHidden = true
            self.progressLabel.text   = String(format: "完成%ld/%ld天", model.punchDayCount, punchAmount)
            progress = CGFloat(model.punchDayCount) / CGFloat(punchAmount)
        } else {
            self.wordNumView.isHidden = false
            self.progressLabel.text   = "完成\(model.progress)%"
            progress = CGFloat(model.progress) / 100
        }
        DispatchQueue.main.async { [weak self] in
            self?.progressView.progress = progress
        }

        if model.type == .punch {
            switch model.punchStatus {
            case .unexpiredUnlearned:
                self.downButton.setTitle("做作业", for: .normal)
            case .unexpiredLearnedUnshare:
                self.downButton.setTitle("去打卡", for: .normal)
            case .unexpiredLearnedShare:
                self.downButton.setTitle("今日已打卡", for: .normal)
                self.downButton.setStatus(.disable)
            case .beExpiredUnfinished:
                self.downButton.isHidden      = true
                self.statusImageView.isHidden = false
                self.statusImageView.image    = UIImage(named: "work_unfinished")
            case .beExpiredFinished:
                self.downButton.isHidden      = true
                self.statusImageView.isHidden = false
                self.statusImageView.image    = UIImage(named: "work_finished")
            }
        } else {
            switch model.otherStatus {
            case .unexpiredUnfinished:
                self.downButton.setTitle("做作业", for: .normal)
            case .unexpiredFinished, .beExpiredFinished:
                self.downButton.setTitle("查看报告", for: .normal)
                self.statusImageView.isHidden = false
                self.statusImageView.image    = UIImage(named: "work_finished")
            case .beExpiredUnfinished:
                self.downButton.setTitle("补作业", for: .normal)
                self.statusImageView.isHidden = false
                self.statusImageView.image    = UIImage(named: "work_unfinished")
            }
        }
    }

    // MARK: ==== Event ====
    @objc
    private func showWordList() {
        self.delegate?.showWordList()
    }

    @objc
    private func downAction() {
        self.delegate?.downAction()
    }
}
