//
//  YXNewLearningResultHeaderView.swift
//  YXEDU
//
//  Created by 沙庭宇 on 2020/8/26.
//  Copyright © 2020 shiji. All rights reserved.
//

import Foundation

class YXNewLearningResultHeaderView: YXView {

    var model: YXExerciseResultDisplayModel?

    var imageView: UIImageView = {
        let imageView = UIImageView()
        return imageView
    }()
    let starView = YXStarView()
    var titleLabel: UILabel = {
        let label = UILabel()
        label.text          = ""
        label.textColor     = UIColor.white
        label.font          = UIFont.mediumFont(ofSize: AdaptFontSize(20))
        label.textAlignment = .center
        label.numberOfLines = 0
        return label
    }()
    var descriptionLabel: UILabel = {
        let label = UILabel()
        label.text          = ""
        label.textColor     = UIColor.white
        label.font          = UIFont.regularFont(ofSize: AdaptFontSize(12))
        label.textAlignment = .center
        label.numberOfLines = 0
        return label
    }()
    var progressView: YXProgressView = {
        let view = YXProgressView()
        view.backgroundColor              = UIColor.white.withAlphaComponent(0.23)
        view.progressView.backgroundColor = UIColor.white
        return view
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
        self.addSubview(imageView)
        self.addSubview(starView)
        self.addSubview(titleLabel)
        self.addSubview(descriptionLabel)
        self.addSubview(progressView)
        imageView.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.top.equalToSuperview().offset(AdaptSize(-18))
            make.size.equalTo(CGSize(width: AdaptIconSize(260), height: AdaptIconSize(169)))
        }
        starView.snp.makeConstraints { (make) in
            make.centerX.equalTo(imageView)
            make.bottom.equalTo(imageView).offset(AdaptSize(-12))
            make.width.equalTo(AdaptIconSize(90))
            make.height.equalTo(AdaptIconSize(45))
        }
        titleLabel.snp.makeConstraints { (make) in
            make.left.equalToSuperview().offset(AdaptSize(20))
            make.right.equalToSuperview().offset(AdaptFontSize(-20))
            make.top.equalTo(starView.snp.bottom)
        }
        descriptionLabel.snp.makeConstraints { (make) in
            make.left.right.equalTo(titleLabel)
            make.top.equalTo(titleLabel.snp.bottom).offset(AdaptSize(2))
        }
        progressView.size = CGSize(width: AdaptSize(233), height: AdaptSize(8))
        progressView.snp.makeConstraints { (make) in
            make.size.equalTo(progressView.size)
            make.top.equalTo(titleLabel.snp.bottom).offset(AdaptSize(10))
            make.centerX.equalToSuperview()
        }
    }

    override func bindProperty() {
        super.bindProperty()
        self.progressView.isHidden = true
    }

    // MARK: ==== Event ====
    func setData(model: YXExerciseResultDisplayModel) {
        self.model = model
        self.setStarView()
        self.setResultImage()
        self.setTitleValue()
        self.setDescriptionValue()
        self.setProgressView()

        self.progressView.isHidden     = self.isHiddenProgress()
        self.descriptionLabel.isHidden = self.isHiddenDescriptionLabel()
        if model.score <= 1, self.superview != nil {
            self.snp.updateConstraints { (make) in
                make.height.equalTo(AdaptSize(200))
            }
        }
    }

    // MARK: ==== Tools ====

    private func setResultImage() {
        guard let model = self.model else { return }
        if model.state { // 完成
            if model.type == .wrong {
                self.imageView.image = UIImage(named: "review_result_wrong")
            } else {
                let score = model.score == 0 ? 1 : model.score
                if score < 1 {
                    self.imageView.image = UIImage(named: "review_result_progress_new")
                } else {
                    let score: Int = {
                        if model.score > 3 {
                            return 3
                        } else if model.score < 1 {
                            return 1
                        } else {
                            return model.score
                        }
                    }()
                    if model.type == .base || model.type == .homeworkPunch {
                        self.imageView.image =  UIImage(named: "review_result_base_\(score)star_new")
                    } else if model.type == .planListenReview || model.type == .homeworkListen {
                        self.imageView.image = UIImage(named: "review_result_listen_\(score)star")
                    } else {// 计划或者智能
                        self.imageView.image = UIImage(named: "review_result_\(score)star")
                    }
                }
            }
        } else { // 未完成
            self.imageView.image = UIImage(named: "review_result_progress_new")
        }
    }

    private func setStarView() {
        guard let model = self.model else { return }
        if model.state { // 完成
            if model.type == .wrong { // 抽查只有一个图，不显示星星
                starView.isHidden = true
            } else {
                starView.isHidden = false
                let score = model.score == 0 ? 1 : model.score
                self.starView.showLearnResultView(starNum: score)
            }
        } else { // 未完成
            starView.isHidden = true
        }
    }

    private func setTitleValue() {
        guard let model = self.model else { return }
        if model.state {
            switch model.type {
            case .base:
                if model.score <= 1 {
                    titleLabel.text = "恭喜完成\(model.title ?? "")学习"
                } else {
                    titleLabel.text = "\(model.title ?? "")学习完成"
                }
            case .aiReview:
                titleLabel.text = "恭喜完成智能复习"
            case .planListenReview:
                titleLabel.text = "恭喜完成\(model.title ?? "")的听力"
            case .planReview, .homeworkWord, .homeworkListen, .homeworkPunch:
                titleLabel.text = "恭喜完成\(model.title ?? "")的学习"
            case .wrong:
                titleLabel.text = "恭喜完成抽查复习"
            default:
                break
            }
        } else {
            titleLabel.attributedText = attrString()
        }
    }

    private func setDescriptionValue() {
        guard let model = self.model else { return }
        if model.state {// 学完
            if model.type == .base || model.type == .homeworkPunch {
                if model.score <= 1 {
                    self.descriptionLabel.text = " 有些单词还掌握的不太好呢\n再练习一下吧~"
                } else if model.score == 2 {
                    self.descriptionLabel.text = " 学得不错，有时间可以再回头巩固一下哦！"
                } else if model.score == 3 {
                    self.descriptionLabel.text = " 您可以进入下一个单元进行学习哦！"
                }
            } else if model.type != .aiReview && model.type != .wrong {
                if model.score == 0 || model.score == 1 {
                    self.descriptionLabel.text = " 还有些词需要多多练习才行哦！"
                } else if model.score == 2 {
                    self.descriptionLabel.text = " 再巩固一下，向3星冲刺哦！"
                } else if model.score == 3 {
                    self.descriptionLabel.text = " 太棒了，获得了3星呢！"
                }
            }
        } else {
            if model.type == .base || model.type == .homeworkPunch {
                self.descriptionLabel.text = " 学得不错，继续学习就可以推进这个单元的进度哦~"
            }
        }
    }

    private func setProgressView() {
        guard let model = self.model else { return }
        if !model.state {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.35) { [weak self] in
                guard let self = self else { return }
                let score = CGFloat(model.score)
                self.progressView.progress = score / 100.0
            }
        }
    }

    func attrString() -> NSAttributedString? {
        guard let model = self.model else { return nil }
        var typeName = ""
        if model.type == .base {
            typeName = "已学"
        } else if model.type == .planListenReview {
            typeName = "听写完成"
        } else {
            typeName = "完成"
        }

        let score = model.score

        let attrString = NSMutableAttributedString(string: "\(model.title ?? "")\(typeName) \(score)%")
        let start = attrString.length - "\(score)%".count

        let all: [NSAttributedString.Key : Any] = [.font: UIFont.mediumFont(ofSize: AdaptFontSize(17)),.foregroundColor: UIColor.white]
        attrString.addAttributes(all, range: NSRange(location: 0, length: attrString.length))

        let nicknameAttr: [NSMutableAttributedString.Key: Any] = [.font: UIFont.mediumFont(ofSize: AdaptFontSize(17)),.foregroundColor: UIColor.white]
        attrString.addAttributes(nicknameAttr, range: NSRange(location: start, length: "\(score)%".count))

        return attrString
    }

    private func isHiddenDescriptionLabel() -> Bool {
        var _isHide = true
        if let model = self.model {
            if model.state {// 学完
                if model.type == .base {
                    _isHide = false
                } else if model.type != .aiReview && model.type != .wrong {
                    _isHide = false
                }
            } else {
                if model.type == .base {
                    _isHide = true
                }
            }
        }
        return _isHide
    }

    private func isHiddenProgress() -> Bool {
        var _isHide = true
        if let model = self.model {
            if model.state {// 学完
                _isHide = true
            } else {
                if model.type == .base {
                    _isHide = false
                }
            }
        }
        return _isHide
    }
}
