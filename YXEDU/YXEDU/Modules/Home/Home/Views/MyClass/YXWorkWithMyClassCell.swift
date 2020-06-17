//
//  YXWorkWithMyClassCell.swift
//  YXEDU
//
//  Created by 沙庭宇 on 2020/6/16.
//  Copyright © 2020 shiji. All rights reserved.
//

import Foundation

enum YXWorkCompletionStatus {
    case unfinished
    case unreport
    case finished
    case delay
}

enum YXWorkType: Int {
    case listen   = 0
    case exercise = 1
    case punchIn  = 2
}

class YXWorkWithMyClassCell: UITableViewCell {

    var workCompletion: YXWorkCompletionStatus = .unfinished
    var workTyep: YXWorkType = .listen

    var wrapView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.white
        return view
    }()

    var nameLabel: UILabel = {
        let label = UILabel()
        label.text          = ""
        label.textColor     = UIColor.black1
        label.font          = UIFont.regularFont(ofSize: AdaptSize(15))
        label.textAlignment = .left
        label.numberOfLines = 0
        return label
    }()

    var desciptionLabel: UILabel = {
        let label = UILabel()
        label.text          = ""
        label.textColor     = UIColor.black3
        label.font          = UIFont.regularFont(ofSize: AdaptSize(12))
        label.textAlignment = .left
        label.lineBreakMode = .byTruncatingMiddle
        return label
    }()

    var progressLabel: UILabel = {
        let label = UILabel()
        label.text          = ""
        label.textColor     = UIColor.black3
        label.font          = UIFont.regularFont(ofSize: AdaptSize(12))
        label.textAlignment = .center
        return label
    }()

    var statusImage: UIImageView = {
        let imageView = UIImageView()
        return imageView
    }()

    var actionButton: YXButton = {
        let button = YXButton(.border, frame: .zero)
        button.cornerRadius     = AdaptSize(15)
        button.titleLabel?.font = UIFont.regularFont(ofSize: AdaptSize(14))
        return button
    }()

    let progressView = YXReviewProgressView(type: .iKnow, cornerRadius: AdaptSize(2))

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.bindProperty()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func createSubviews() {
        self.addSubview(wrapView)
        wrapView.addSubview(statusImage)
        wrapView.addSubview(nameLabel)
        wrapView.addSubview(desciptionLabel)
        wrapView.addSubview(progressLabel)
        wrapView.addSubview(progressView)
        wrapView.addSubview(actionButton)
        wrapView.snp.remakeConstraints { (make) in
            make.left.equalToSuperview().offset(AdaptSize(20))
            make.right.equalToSuperview().offset(AdaptSize(-20))
            make.top.equalToSuperview().offset(AdaptSize(7.5))
            make.bottom.equalToSuperview().offset(AdaptSize(-7.5))
        }
        statusImage.snp.remakeConstraints { (make) in
            make.top.right.equalToSuperview()
            make.size.equalTo(CGSize(width: AdaptSize(46), height: AdaptSize(46)))
        }
        let nameLabelHeight = self.nameLabel.text?.textHeight(font: nameLabel.font, width: screenWidth - AdaptSize(70)) ?? 0
        nameLabel.snp.remakeConstraints { (make) in
            make.left.top.equalToSuperview().offset(AdaptSize(15))
            make.right.equalToSuperview().offset(AdaptSize(-15))
            make.height.equalTo(nameLabelHeight)
        }
        desciptionLabel.snp.remakeConstraints { (make) in
            make.left.equalTo(nameLabel)
            make.top.equalTo(nameLabel.snp.bottom).offset(AdaptSize(5))
            make.right.equalToSuperview().offset(AdaptSize(-15))
            make.height.equalTo(AdaptSize(17))
        }
        progressLabel.sizeToFit()
        progressLabel.snp.remakeConstraints { (make) in
            make.left.equalTo(nameLabel)
            make.height.equalTo(AdaptSize(17))
            make.bottom.equalToSuperview().offset(AdaptSize(-15))
            make.width.equalTo(progressLabel.width)
            make.top.equalTo(desciptionLabel.snp.bottom).offset(AdaptSize(20))
        }
        progressView.size = CGSize(width: AdaptSize(113), height: AdaptSize(4))
        progressView.snp.remakeConstraints { (make) in
            make.centerY.equalTo(progressLabel)
            make.left.equalTo(progressLabel.snp.right).offset(AdaptSize(5))
            make.size.equalTo(progressView.size)
        }
        actionButton.snp.remakeConstraints { (make) in
            make.right.equalToSuperview().offset(AdaptSize(-15))
            make.centerY.equalTo(progressLabel)
            make.size.equalTo(CGSize(width: AdaptSize(95), height: AdaptSize(30)))
        }
    }

    private func bindProperty() {
        self.selectionStyle = .none
        self.backgroundColor = UIColor.white
        self.wrapView.layer.setDefaultShadow(cornerRadius: 12, shadowRadius: 10)
        self.actionButton.addTarget(self, action: #selector(actionEvent), for: .touchUpInside)
    }

    func setData(indexPath: IndexPath) {
        let completionList: [YXWorkCompletionStatus] = [.unfinished, .unreport, .finished, .delay]
        let typeList: [YXWorkType] = [.listen, .listen, .punchIn]
        let nameList = ["6月4日单词练习作业6月4日单词练习作业6月4日单词练习作业6月4日单词练习作业6月4日单词练习作业6月4日单词练习作业6月4日单词练习作业6月4日单词练习作业6月4日单词练习作业6月4日单词练习作业6月4日单词练习作业6月4日单词练习作业", "6月4日单词练习作业"]
        self.nameLabel.text        = nameList[indexPath.row % nameList.count]
        self.progressLabel.text    = "完成50%"
        self.desciptionLabel.text  = "3班  l  3天后截止"
        DispatchQueue.main.async {
            self.progressView.progress = 0.5
        }
        self.workCompletion        = completionList[indexPath.row % completionList.count]
        self.workTyep              = typeList[indexPath.row % typeList.count]
        self.createSubviews()

        self.statusImage.isHidden = false
        switch self.workCompletion {
        case .unfinished:
            self.actionButton.type = .border
            self.actionButton.setStatus(.normal)
            self.actionButton.setTitle("做作业", for: .normal)
        case .unreport:
            self.actionButton.type = .border
            self.actionButton.setStatus(.normal)
            self.actionButton.setTitle("去打卡", for: .normal)
        case .finished:
            self.actionButton.type = .normal
            self.statusImage.image = UIImage(named: "work_finished")
            if self.workTyep == .listen || self.workTyep == .exercise {
                self.actionButton.setTitleColor(.black2, for: .normal)
                self.actionButton.layer.borderColor = UIColor.black4.cgColor
                self.actionButton.layer.borderWidth = AdaptSize(1)
                self.actionButton.setTitle("查看报告", for: .normal)
            } else {
                self.actionButton.backgroundColor = UIColor.hex(0xF4F4F4)
                self.actionButton.setTitleColor(UIColor.black6, for: .normal)
                self.actionButton.layer.borderColor = UIColor.clear.cgColor
                self.actionButton.layer.borderWidth = 0
                self.actionButton.setTitle("已打卡", for: .normal)
            }
        case .delay:
            self.statusImage.image = UIImage(named: "work_unfinished")
            self.actionButton.type = .border
            self.actionButton.setStatus(.normal)
            self.actionButton.setTitle("补作业", for: .normal)
        }
    }

    // MARK: ==== Event ====
    @objc private func actionEvent() {
        YXLog("查看详情")
    }

}
