//
//  YXMyClassWorkDetailHeaderView.swift
//  YXEDU
//
//  Created by 沙庭宇 on 2020/6/22.
//  Copyright © 2020 shiji. All rights reserved.
//

import Foundation

class YXMyClassWorkDetailHeaderView: YXView {
    var nameLabel: UILabel = {
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
        label.textColor     = UIColor.black3
        label.font          = UIFont.regularFont(ofSize: AdaptFontSize(13))
        label.textAlignment = .left
        return label
    }()

    var descriptionLabel: UILabel = {
        let label = UILabel()
        label.text          = ""
        label.textColor     = UIColor.black3
        label.font          = UIFont.regularFont(ofSize: AdaptFontSize(13))
        label.textAlignment = .left
        label.numberOfLines = 0
        return label
    }()

    let progressView = YXReviewPlanProgressView()

    var progressLabel: UILabel = {
        let label = UILabel()
        label.text          = "平均正答率"
        label.textColor     = UIColor.black3
        label.font          = UIFont.regularFont(ofSize: AdaptFontSize(13))
        label.textAlignment = .center
        return label
    }()

    var bottomLineView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.hex(0xF4F4F4)
        return view
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.createSubviews()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func bindProperty() {
        super.bindProperty()
        self.backgroundColor = .white
    }

    override func createSubviews() {
        super.createSubviews()
        self.addSubview(nameLabel)
        self.addSubview(classNameLabel)
        self.addSubview(descriptionLabel)
        self.addSubview(progressView)
        self.addSubview(progressLabel)
        self.addSubview(bottomLineView)
        nameLabel.snp.makeConstraints { (make) in
            make.left.equalToSuperview().offset(AdaptSize(20))
            make.top.equalToSuperview().offset(AdaptSize(17))
            make.right.equalTo(progressView.snp.left).offset(AdaptSize(-30))
            make.height.equalTo(AdaptSize(24))
        }
        classNameLabel.snp.makeConstraints { (make) in
            make.left.right.equalTo(nameLabel)
            make.top.equalTo(nameLabel.snp.bottom).offset(AdaptSize(10))
            make.height.equalTo(AdaptSize(18))
        }
        descriptionLabel.snp.makeConstraints { (make) in
            make.left.right.equalTo(nameLabel)
            make.top.equalTo(classNameLabel.snp.bottom).offset(AdaptSize(5))
            make.height.equalTo(18)
        }
        progressView.snp.makeConstraints { (make) in
            make.size.equalTo(CGSize(width: AdaptSize(41), height: AdaptSize(41)))
            make.right.equalToSuperview().offset(AdaptSize(-30))
            make.top.equalToSuperview().offset(AdaptSize(28))
        }
        progressLabel.sizeToFit()
        progressLabel.snp.makeConstraints { (make) in
            make.centerX.equalTo(progressView)
            make.top.equalTo(progressView.snp.bottom).offset(AdaptSize(5))
            make.size.equalTo(progressLabel.size)
        }
        bottomLineView.snp.makeConstraints { (make) in
            make.left.bottom.right.equalToSuperview()
            make.height.equalTo(AdaptSize(10))
            make.top.equalTo(descriptionLabel.snp.bottom).offset(AdaptSize(15))
        }
    }

    func setData(report model: YXMyClassReportModel?) {
        guard let _model = model else { return }
        self.nameLabel.text        = _model.studentName
        self.classNameLabel.text   = "班级：" + _model.grade
        self.progressView.progress = CGFloat(_model.accuracy) / 100
        self.descriptionLabel.text = _model.finishedTime + "完成作业"
        let descHeight = self.descriptionLabel.text?.textHeight(font: self.descriptionLabel.font, width: screenWidth - AdaptSize(106)) ?? 0
        self.descriptionLabel.snp.updateConstraints { (make) in
            make.height.equalTo(descHeight)
        }
    }
}
