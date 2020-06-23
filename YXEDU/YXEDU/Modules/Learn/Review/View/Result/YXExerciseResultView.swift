//
//  YXExerciseResultView.swift
//  YXEDU
//
//  Created by sunwu on 2020/1/13.
//  Copyright © 2020 shiji. All rights reserved.
//

import UIKit

/// 学习结果页
class YXExerciseResultView: YXView {

    var reportEvent: (() -> ())?
    var processEvent: (() -> ())?
    var showWordListEvent: (() -> ())?
    

    var model: YXExerciseResultDisplayModel!
    
    var contentView   = UIView()
    var imageView     = UIImageView()
    var titleLabel    = UILabel()
    var subTitleLabel = UILabel()
    var starView      = YXStarView()
    var progressView  = YXReviewProgressView(type: .iKnow, cornerRadius: AdaptIconSize(4))
    var tipsView      = YXReviewResultTipsListView()
    var remindButton  = UIButton()
    var reportButton  = UIButton()
    var operateButton = UIButton()
    
    deinit {
        reportButton.removeTarget(self, action: #selector(clickReportButton), for: .touchUpInside)
        operateButton.removeTarget(self, action: #selector(clickOperateButton), for: .touchUpInside)
    }
    
    init(model: YXExerciseResultDisplayModel) {
        super.init(frame: .zero)
        self.model = model
        self.createSubviews()
        self.bindProperty()
        self.bindData()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
        
    override func createSubviews() {
        self.addSubview(contentView)
        contentView.addSubview(imageView)
        contentView.addSubview(titleLabel)
        contentView.addSubview(subTitleLabel)
        contentView.addSubview(starView)
        contentView.addSubview(progressView)
        contentView.addSubview(tipsView)
        contentView.addSubview(reportButton)
        contentView.addSubview(operateButton)
        contentView.addSubview(remindButton)
    }
    
    override func bindProperty() {
        contentView.backgroundColor = UIColor.white
        contentView.layer.setDefaultShadow()
        
        titleLabel.font = UIFont.regularFont(ofSize: AdaptFontSize(17))
        titleLabel.textAlignment = .center
        titleLabel.textColor     = UIColor.black1
        titleLabel.numberOfLines = 0
                
        subTitleLabel.font = UIFont.regularFont(ofSize: AdaptFontSize(14))
        subTitleLabel.textAlignment = .center
        subTitleLabel.textColor     = UIColor.black3
        subTitleLabel.numberOfLines = 0
        
        tipsView.showWordListEvent = { [weak self] in
            self?.showWordListEvent?()
        }
        
        let bgColor = UIColor.gradientColor(with: CGSize(width: AdaptIconSize(isHiddenReportButton ? 273 : 134), height: AdaptIconSize(42)), colors: [UIColor.hex(0xFDBA33), UIColor.orange1], direction: .vertical)
        
        
        reportButton.backgroundColor = bgColor
        reportButton.layer.masksToBounds = true
        reportButton.layer.cornerRadius = AdaptIconSize(21)
                
        reportButton.setTitleColor(UIColor.white, for: .normal)
        reportButton.titleLabel?.font = UIFont.regularFont(ofSize: AdaptFontSize(17))
        reportButton.addTarget(self, action: #selector(clickReportButton), for: .touchUpInside)
                
        operateButton.backgroundColor = bgColor
        operateButton.layer.masksToBounds = true
        operateButton.layer.cornerRadius = AdaptIconSize(21)
                
        operateButton.setTitleColor(UIColor.white, for: .normal)
        operateButton.titleLabel?.font = UIFont.regularFont(ofSize: AdaptFontSize(17))
        operateButton.addTarget(self, action: #selector(clickOperateButton), for: .touchUpInside)

        remindButton.isUserInteractionEnabled = false
        if model.type == .homework {
            remindButton.setTitleColor(.orange1, for: .normal)
            remindButton.titleLabel?.font = UIFont.regularFont(ofSize: AdaptFontSize(13))
            remindButton.setImage(UIImage(named: "iconRemindIcon"), for: .normal)
            if model.sharedPeople == 0 {
                remindButton.setTitle(" 成为第一位打卡学员吧！", for: .normal)
            } else {
                remindButton.setTitle(" \(model.sharedPeople)人已打卡", for: .normal)
            }
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        contentView.snp.remakeConstraints { (make) in
            make.top.bottom.equalToSuperview()
            make.left.equalTo(AdaptIconSize(21))
            make.right.equalTo(AdaptIconSize(-21))
        }
        
        imageView.snp.remakeConstraints { (make) in
            make.top.equalTo(AdaptIconSize(-8))
            make.centerX.equalToSuperview()
            make.width.equalTo(AdaptIconSize(233))
            make.height.equalTo(AdaptIconSize(141))
        }
        
        starView.snp.remakeConstraints { (make) in
            make.centerX.equalTo(imageView)
            make.bottom.equalTo(imageView).offset(AdaptIconSize(6))
            make.width.equalTo(AdaptIconSize(94))
            make.height.equalTo(AdaptIconSize(45))
        }
        
        titleLabel.snp.remakeConstraints { (make) in
            make.top.equalTo(imageView.snp.bottom).offset(AdaptIconSize(11))
            make.left.equalTo(AdaptIconSize(35))
            make.right.equalTo(AdaptIconSize(-35))
            make.height.equalTo(titleHeight())
        }
        
        var topView: UIView = titleLabel
        if subTitleLabel.isHidden == false {
            subTitleLabel.snp.remakeConstraints { (make) in
                make.top.equalTo(titleLabel.snp.bottom).offset(AdaptIconSize(5))
                make.left.right.equalToSuperview()
                make.height.equalTo(AdaptIconSize(17))
            }
            topView = subTitleLabel
        }
                
        if model.state == false {
            progressView.snp.remakeConstraints { (make) in
                make.top.equalTo(topView.snp.bottom).offset(AdaptIconSize(11))
                make.left.right.equalTo(imageView)
                make.height.equalTo(AdaptIconSize(8))
            }
            topView = progressView
        }
        
        let tipsHeight = tipsView.viewHeight(count: self.createDataSource().count)
        tipsView.snp.remakeConstraints { (make) in
            make.top.equalTo(topView.snp.bottom).offset(AdaptIconSize(28))
            make.left.right.equalToSuperview()
            make.height.equalTo(tipsHeight)
        }
          
        if isHiddenReportButton {
            operateButton.snp.remakeConstraints { (make) in
                make.centerX.equalToSuperview()
                make.width.equalTo(AdaptIconSize(273))
                make.height.equalTo(AdaptIconSize(42))
                make.bottom.equalTo(-AdaptIconSize(25))
            }
        } else {
            reportButton.snp.remakeConstraints { (make) in
                make.left.equalTo(AdaptIconSize(28))
                make.width.equalTo(AdaptIconSize(134))
                make.height.equalTo(AdaptIconSize(42))
                make.bottom.equalTo(-AdaptIconSize(25))
            }
            
            operateButton.snp.remakeConstraints { (make) in
                make.right.equalTo(AdaptIconSize(-28))
                make.width.equalTo(AdaptIconSize(134))
                make.height.equalTo(AdaptIconSize(42))
                make.bottom.equalTo(-AdaptIconSize(25))
            }
        }

        if model.type == .homework {
            remindButton.sizeToFit()
            remindButton.snp.remakeConstraints { (make) in
                make.centerX.equalToSuperview()
                make.top.equalTo(tipsView.snp.bottom).offset(AdaptSize(20))
                make.size.equalTo(remindButton.size)
            }
        }
        
        self.layoutIfNeeded()
    }
    
    override func bindData() {
        self.setImageValue()
        self.setTitleValue()
        self.setSubTitleValue()
        self.setProgressViewValue()
        self.setShareButtonValue()
           
        tipsView.textAlignment = (model.words?.count ?? 0) > 0 ? .left : .center
        tipsView.dataSource = self.createDataSource()
        
    }
    
    @objc func clickReportButton() {
        self.reportEvent?()
    }
    @objc func clickOperateButton() {
        self.processEvent?()
    }
    
    @objc func clickCloseButton() {
        NotificationCenter.default.post(name: YXNotification.kRefreshReviewTabPage, object: nil)
        NotificationCenter.default.post(name: YXNotification.kRefreshReviewDetailPage, object: nil)
    }

    private func setRemind() {

    }
    
    private func setImageValue() {
        if model.state { // 完成
            if model.type == .wrong { // 抽查只有一个图，不显示星星
                starView.isHidden = true
                imageView.image = UIImage(named: "review_result_wrong")
            } else {
                let score = model.score == 0 ? 1 : model.score
                self.starView.showLearnResultView(starNum: score)
                if score <= 1 {
                    imageView.image = UIImage(named: "review_result_1star")
                } else {
                    if model.type == .base {
                        imageView.image = UIImage(named: "review_result_base_\(model.score)star")
                    } else if model.type == .planListenReview {
                        imageView.image = UIImage(named: "review_result_listen_\(model.score)star")
                    } else {// 计划或者智能
                        imageView.image = UIImage(named: "review_result_\(model.score)star")
                    }
                }
            }
        } else { // 未完成
            starView.isHidden = true
            imageView.image = UIImage(named: "review_result_progress")
        }
    }
    
    
    private func setTitleValue() {
        if model.state {
            if model.type == .base {
                if model.score <= 1 {
                    titleLabel.text = "恭喜完成\(model.title ?? "")学习"
                } else {
                    titleLabel.text = "\(model.title ?? "")学习完成"
                }                
            } else if model.type == .aiReview {
                titleLabel.text = "恭喜完成智能复习"
            } else if model.type == .planListenReview {
                titleLabel.text = "恭喜完成\(model.title ?? "")的听力"
            } else if model.type == .planReview {
                titleLabel.text = "恭喜完成\(model.title ?? "")的学习"
            } else if model.type == .wrong {
                titleLabel.text = "恭喜完成抽查复习"
            }
        } else {
            titleLabel.attributedText = attrString()
        }
    }
    
    private func setSubTitleValue() {
        
        if model.state {// 学完
            if model.type == .base {
                if model.score <= 1 {
                    subTitleLabel.text = " 有些单词还掌握的不太好呢\n再练习一下吧~"
                } else if model.score == 2 {
                    subTitleLabel.text = " 学得不错，有时间可以再回头巩固一下哦！"
                } else if model.score == 3 {
                    subTitleLabel.text = " 您可以进入下一个单元进行学习哦！"
                }
            } else if model.type != .aiReview && model.type != .wrong {
                if model.score == 0 || model.score == 1 {
                    subTitleLabel.text = " 还有些词需要多多练习才行哦！"
                } else if model.score == 2 {
                    subTitleLabel.text = " 再巩固一下，向3星冲刺哦！"
                } else if model.score == 3 {
                    subTitleLabel.text = " 太棒了，获得了3星呢！"
                }
            }
            
        } else {
            if model.type == .base {
                subTitleLabel.text = " 学得不错，继续学习就可以推进这个单元的进度哦~"
            }
        }
        
        subTitleLabel.isHidden = subTitleLabel.text?.isEmpty ?? true
    }
    
    private func setProgressViewValue() {
        if !model.state {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.35) { [weak self] in
                guard let self = self else { return }
                let score = CGFloat(self.model.score)
                self.progressView.progress = score / 100.0
            }
        }
    }
    
    private func setShareButtonValue() {                
        if model.state {
            if model.type == .wrong {
                operateButton.setTitle("完成", for: .normal)
            } else {
                operateButton.setTitle("打卡分享", for: .normal)
            }
            if !isHiddenReportButton {
                reportButton.setTitle("分享学习报告", for: .normal)
            }
        } else {
            if model.type == .planListenReview {
                operateButton.setTitle("继续听写", for: .normal)
            } else if model.type == .planReview {
                operateButton.setTitle("继续学习", for: .normal)
            } else {
                operateButton.setTitle("打卡分享", for: .normal)
            }
        }
        if model.type == .homework {
            operateButton.setTitle("打卡分享给老师", for: .normal)
        }
    }
    
    
    private func createDataSource() -> [(String, Int, Bool)] {
        var ds: [(String, Int, Bool)] = []
        if model.newStudyWordNum > 0 {
            ds.append(("新学的单词", model.newStudyWordNum, false))
        }
        if model.reviewWordNum > 0 {
            ds.append(("巩固的单词", model.reviewWordNum, false))
        }
        if model.knowWordNum > 0 {
            ds.append(("掌握的更好的单词", model.knowWordNum, false))
        }
        if model.remainWordNum > 0 {
            ds.append(("剩余待学习的单词", model.remainWordNum, false))
        }
        if let num = model.words?.count, num > 0 {
            ds.append(("需要加强的单词", num, true))
        }
        return ds
    }
    
    
    
    func attrString() -> NSAttributedString {
        
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
        
        let all: [NSAttributedString.Key : Any] = [.font: UIFont.mediumFont(ofSize: AdaptFontSize(17)),.foregroundColor: UIColor.black1]
        attrString.addAttributes(all, range: NSRange(location: 0, length: attrString.length))
        
        let nicknameAttr: [NSMutableAttributedString.Key: Any] = [.font: UIFont.mediumFont(ofSize: AdaptFontSize(17)),.foregroundColor: UIColor.orange1]
        attrString.addAttributes(nicknameAttr, range: NSRange(location: start, length: "\(score)%".count))

        return attrString
    }
    
    func attrString(_ text: String, _ start: Int, _ lenght: Int) -> NSAttributedString {
        
        let attrString = NSMutableAttributedString(string: text)
                        
        let all: [NSAttributedString.Key : Any] = [.font: UIFont.regularFont(ofSize: AdaptFontSize(14)),.foregroundColor: UIColor.black3]
        attrString.addAttributes(all, range: NSRange(location: 0, length: attrString.length))
        
        let nicknameAttr: [NSMutableAttributedString.Key: Any] = [.font: UIFont.regularFont(ofSize: AdaptFontSize(14)),.foregroundColor: UIColor.orange1]
        attrString.addAttributes(nicknameAttr, range: NSRange(location: start, length: lenght))

        return attrString
    }
    
    private var isHiddenSubTitleLabel: Bool {
        var has = false
        if model.state {// 学完
            if model.type == .base {
                has = true
            } else if model.type != .aiReview && model.type != .wrong {
                has = true
            }
        } else {
            if model.type == .base {
                has = true
            }
        }
        return !has
    }
    
    private var isHiddenReportButton: Bool {
        return !(model.state && (model.type == .planReview || model.type == .planListenReview))
    }
    
    
    private func titleHeight() -> CGFloat {
        let font = UIFont.regularFont(ofSize: AdaptFontSize(17))
        let titleWidth = screenWidth - AdaptIconSize(40)
        
        if let text = titleLabel.text {
            return text.textHeight(font: font, width: titleWidth)
        }
        
        if let text = titleLabel.attributedText?.string {
            return text.textHeight(font: font, width: titleWidth)
        }
        return 0
    }
    
    
    /// 高度
    func viewHeight() -> CGFloat {
        var allHeight: CGFloat = 0
        allHeight += AdaptIconSize(24 + 109 + 11)
        allHeight += titleHeight()
                
        if isHiddenSubTitleLabel == false {
            allHeight += AdaptIconSize(5 + 17)
        }
        
        if model.state == false {
            allHeight += AdaptIconSize(6 + 8)
        }
        
        let tipsHeight = tipsView.viewHeight(count: self.createDataSource().count)
        allHeight += AdaptIconSize(28) + tipsHeight
        
        allHeight += AdaptIconSize(25 + 42 + 25)

        allHeight += model.type == .homework ? AdaptSize(28) : 0

        return allHeight
    }
    
}
