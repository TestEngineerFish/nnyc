//
//  YXWorkWithMyClassCell.swift
//  YXEDU
//
//  Created by 沙庭宇 on 2020/6/16.
//  Copyright © 2020 shiji. All rights reserved.
//

import Foundation

class YXWorkWithMyClassCell: UITableViewCell {

    var model: YXMyWorkModel?
    var hashDic: [String:String] = [:]

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

    func setData(work model: YXMyWorkModel, hashDic:[String:String]) {
        self.model   = model
        self.hashDic = hashDic
        self.nameLabel.text        = model.workName
        if model.type == .punch {
            self.progressLabel.text = String(format: "完成%ld/%ld天", model.shareCount, model.shareAmount)
        } else {
            self.progressLabel.text = String(format: "完成%0.0f%@", model.progress * 100, "%")
        }
        self.desciptionLabel.text  = String(format: "%@ l %@", model.className, model.timeStr)
        DispatchQueue.main.async {
            self.progressView.progress = model.progress
        }
        self.createSubviews()

        if model.type == .punch {
            switch model.shareWorkStatus {
            case .unexpiredUnlearned, .unexpiredLearnedUnshare:
                self.statusImage.isHidden  = true
                self.actionButton.isHidden = false
                self.actionButton.type = .border
                self.actionButton.setStatus(.normal)
                self.actionButton.setTitleColor(.orange1, for: .normal)
                self.actionButton.setTitle("去打卡", for: .normal)
            case .unexpiredLearnedShare:
                self.statusImage.isHidden  = false
                self.actionButton.isHidden = false
                self.statusImage.image    = UIImage(named: "work_finished")
                self.actionButton.type    = .normal
                self.actionButton.setTitleColor(.black6, for: .normal)
                self.actionButton.backgroundColor = UIColor.hex(0xF4F4F4)
                self.actionButton.setTitleColor(UIColor.black6, for: .normal)
                self.actionButton.layer.borderColor = UIColor.clear.cgColor
                self.actionButton.layer.borderWidth = 0
                self.actionButton.setTitle("已打卡", for: .normal)
            case .beExpiredUnfinished:
                self.statusImage.isHidden  = false
                self.actionButton.isHidden = true
                self.statusImage.image     = UIImage(named: "work_unfinished")
            case .beExpiredFinished:
                self.statusImage.isHidden  = false
                self.actionButton.isHidden = true
                self.statusImage.image     = UIImage(named: "work_finished")
            }
        } else {
            switch model.exerciseWorkStatus {
            case .unexpiredUnfinished:
                self.statusImage.isHidden  = true
                self.actionButton.isHidden = false
                self.actionButton.type = .border
                self.actionButton.setStatus(.normal)
                self.actionButton.setTitleColor(.orange1, for: .normal)
                self.actionButton.setTitle("做作业", for: .normal)
            case .unexpiredFinished, .beExpiredFinished:
                self.statusImage.isHidden  = false
                self.actionButton.isHidden = false
                self.statusImage.image = UIImage(named: "work_finished")
                self.actionButton.type = .normal
                self.actionButton.setStatus(.normal)
                self.actionButton.setTitleColor(.black1, for: .normal)
                self.actionButton.setTitleColor(.black2, for: .normal)
                self.actionButton.layer.borderColor = UIColor.black4.cgColor
                self.actionButton.layer.borderWidth = AdaptSize(1)
                self.actionButton.setTitle("查看报告", for: .normal)
            case .beExpiredUnfinished:
                self.statusImage.isHidden  = false
                self.actionButton.isHidden = false
                self.statusImage.image = UIImage(named: "work_unfinished")
                self.actionButton.type = .border
                self.actionButton.setStatus(.normal)
                self.actionButton.setTitleColor(.orange1, for: .normal)
                self.actionButton.setTitle("补作业", for: .normal)
            }
        }
    }

    // MARK: ==== Event ====
    @objc private func actionEvent() {
        YXLog("查看详情")
        guard let _model = self.model else {
            return
        }
        let exerciseStatusList: [YXExerciseWorkStatusTypes] = [.unexpiredUnfinished,
                                                               .beExpiredUnfinished]
        let checkReport: [YXExerciseWorkStatusTypes] = [.unexpiredFinished, .beExpiredFinished]
        // 已完成
        if _model.type == .punch {
            if _model.shareWorkStatus == .unexpiredLearnedUnshare {
                self.punch()
            } else {
                self.startExercise(learn: .homeworkPunch)
            }
        } else {
            if checkReport.contains(_model.exerciseWorkStatus) {
                // 查看报告
                let vc = YXMyClassWorkReportViewController()
                vc.workId  = model?.workId
                YRRouter.sharedInstance().currentNavigationController()?.pushViewController(vc, animated: true)
            } else if exerciseStatusList.contains(_model.exerciseWorkStatus) {
                // 做、补作业
                if _model.type == .listen {
                    self.startExercise(learn: .homeworkListen)
                } else {
                    self.startExercise(learn: .homeworkWord)
                }
                
            }
        }
    }

    /// 开始学习
    private func startExercise(learn type: YXLearnType) {
        guard let _model = self.model, let workId = _model.workId else {
            return
        }
        YXLog(String(format: "==== 开始做作业，作业ID：%ld ====", workId))
        YXWordBookResourceManager.stop = false
        let dataList = self.getBookHashDic()
        YXWordBookResourceManager.shared.saveReviewPlan(dataList: dataList, type: .homework)

        // 跳转学习
        let vc = YXExerciseViewController()
        let bookId = type == .homeworkPunch ? (_model.bookIdList.first ?? 0) : 0
        let unitId = type == .homeworkPunch ? _model.unitId : 0
        vc.learnConfig = YXLearnConfigImpl(bookId: bookId, unitId: unitId, planId: 0, learnType: type, homeworkId: workId)
        YRRouter.sharedInstance().currentNavigationController()?.pushViewController(vc, animated: true)
    }

    private func punch() {
        guard let _model = self.model, let workId = _model.workId else {
            return
        }
        // 打卡分享
        let shareVC = YXShareViewController()
        shareVC.wordId      = workId
        shareVC.shareType   = .homeworkResult
        shareVC.wordsAmount = _model.studyWordCount
        shareVC.daysAmount  = _model.studyDayCount
        YRRouter.sharedInstance().currentNavigationController()?.pushViewController(shareVC, animated: true)
    }

    // MARK: ==== Tools ====
    private func getBookHashDic() -> [(Int, String)] {
        var bookHash = [(Int, String)]()
        guard let _model = self.model else {
            return bookHash
        }
        _model.bookIdList.forEach { (bookId) in
            if let hash = self.hashDic["\(bookId)"] {
                bookHash.append((bookId,hash))
            }
        }
        return bookHash
    }

}
