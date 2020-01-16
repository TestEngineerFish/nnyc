//
//  YXExerciseResultView.swift
//  YXEDU
//
//  Created by sunwu on 2020/1/13.
//  Copyright © 2020 shiji. All rights reserved.
//

import UIKit

class YXExerciseResultView: YXView {

    var processEvent: (() -> ())?
    var showWordListEvent: (() -> ())?
    
    
    
    var model: YXExerciseResultDisplayModel!
    
    var contentView = UIView()
    
    var imageView = UIImageView()
    var titleLabel = UILabel()
    var subTitleLabel = UILabel()
    
    var starView = YXReviewResultStarView()
    var progressView = YXReviewProgressView(type: .iKnow, cornerRadius: AS(4))

    var tipsView = YXReviewResultTipsListView()
    
    var operateButton = YXButton()
    
    deinit {
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
        contentView.addSubview(operateButton)
    }
    
    override func bindProperty() {
        contentView.backgroundColor = UIColor.white
        contentView.layer.setDefaultShadow()
        
        titleLabel.font = UIFont.regularFont(ofSize: AS(17))
        titleLabel.textAlignment = .center
        titleLabel.textColor = UIColor.black1
        titleLabel.numberOfLines = 0
                
        subTitleLabel.font = UIFont.regularFont(ofSize: AS(14))
        subTitleLabel.textAlignment = .center
        subTitleLabel.textColor = UIColor.black3
        subTitleLabel.numberOfLines = 0
        
        tipsView.showWordListEvent = { [weak self] in
            self?.showWordListEvent?()
        }
        
        let bgColor = UIColor.gradientColor(with: CGSize(width: AS(273), height: AS(42)), colors: [UIColor.hex(0xFDBA33), UIColor.orange1], direction: .vertical)
        operateButton.backgroundColor = bgColor
        operateButton.layer.masksToBounds = true
        operateButton.layer.cornerRadius = AS(21)
                
        operateButton.setTitleColor(UIColor.white, for: .normal)
        operateButton.titleLabel?.font = UIFont.regularFont(ofSize: AS(17))
        operateButton.addTarget(self, action: #selector(clickOperateButton), for: .touchUpInside)
    
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        contentView.snp.remakeConstraints { (make) in
            make.top.bottom.equalToSuperview()
            make.left.equalTo(AS(21))
            make.right.equalTo(AS(-21))
        }
        
        imageView.snp.remakeConstraints { (make) in
            make.top.equalTo(AS(-8))
            make.centerX.equalToSuperview()
            make.width.equalTo(AS(233))
            make.height.equalTo(AS(141))
        }
        
        starView.snp.remakeConstraints { (make) in
            make.centerX.equalTo(imageView)
            make.bottom.equalTo(imageView).offset(AS(6))
            make.width.equalTo(AS(27 * 2 + 38 + 2))
            make.height.equalTo(AS(45))
        }
        
        titleLabel.snp.remakeConstraints { (make) in
            make.top.equalTo(imageView.snp.bottom).offset(AS(11))
            make.left.equalTo(AS(20))
            make.right.equalTo(AS(-20))
            make.height.equalTo(titleHeight())
        }
        
        var topView: UIView = titleLabel
        if subTitleLabel.isHidden == false {
            subTitleLabel.snp.remakeConstraints { (make) in
                make.top.equalTo(titleLabel.snp.bottom).offset(AS(5))
                make.left.right.equalToSuperview()
                make.height.equalTo(AS(17))
            }
            topView = subTitleLabel
        }
                
        if model.state == false {
            progressView.snp.remakeConstraints { (make) in
                make.top.equalTo(topView.snp.bottom).offset(AS(11))
                make.left.right.equalTo(imageView)
                make.height.equalTo(AS(8))
            }
            topView = progressView
        }
        
        let tipsHeight = tipsView.viewHeight(count: self.createDataSource().count)
        tipsView.snp.remakeConstraints { (make) in
            make.top.equalTo(topView.snp.bottom).offset(AS(28))
            make.left.right.equalToSuperview()
            make.height.equalTo(tipsHeight)
        }
                
        operateButton.snp.remakeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.width.equalTo(AS(273))
            make.height.equalTo(AS(42))
            make.bottom.equalTo(-AS(25))
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
    
    @objc func clickOperateButton() {
        self.processEvent?()
    }
    
    
    @objc func clickCloseButton() {
        NotificationCenter.default.post(name: YXNotification.kRefreshReviewTabPage, object: nil)
        NotificationCenter.default.post(name: YXNotification.kRefreshReviewDetailPage, object: nil)
//        self.removeFromSuperview()
    }

    
    private func setImageValue() {
        if model.state { // 完成
            if model.type == .wrong { // 抽查只有一个图，不显示星星
                starView.isHidden = true
                imageView.image = UIImage(named: "review_result_wrong")
            } else {
                starView.count = model.score
                
                if starView.count <= 1 {
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
                titleLabel.text = "恭喜完成\(model.title ?? "")学习"
            } else if model.type == .aiReview {
                titleLabel.text = "恭喜完成智能复习"
            } else if model.type == .planListenReview {
                titleLabel.text = "恭喜完成\(model.title ?? "")的听力"
            } else if model.type == .planReview {
                titleLabel.text = "恭喜完成\(model.title ?? "")的复习"
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
                if model.score == 1 {
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
        } else {
            if model.type == .planListenReview {
                operateButton.setTitle("继续听写", for: .normal)
            } else if model.type == .planReview {
                operateButton.setTitle("继续复习", for: .normal)
            }
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
            ds.append(("剩余待复习的单词", model.remainWordNum, false))
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
        
        let all: [NSAttributedString.Key : Any] = [.font: UIFont.mediumFont(ofSize: AS(17)),.foregroundColor: UIColor.black1]
        attrString.addAttributes(all, range: NSRange(location: 0, length: attrString.length))
        
        let nicknameAttr: [NSMutableAttributedString.Key: Any] = [.font: UIFont.mediumFont(ofSize: AS(17)),.foregroundColor: UIColor.orange1]
        attrString.addAttributes(nicknameAttr, range: NSRange(location: start, length: "\(score)%".count))

        return attrString
    }
    
    func attrString(_ text: String, _ start: Int, _ lenght: Int) -> NSAttributedString {
        
        let attrString = NSMutableAttributedString(string: text)
                        
        let all: [NSAttributedString.Key : Any] = [.font: UIFont.regularFont(ofSize: AS(14)),.foregroundColor: UIColor.black3]
        attrString.addAttributes(all, range: NSRange(location: 0, length: attrString.length))
        
        let nicknameAttr: [NSMutableAttributedString.Key: Any] = [.font: UIFont.regularFont(ofSize: AS(14)),.foregroundColor: UIColor.orange1]
        attrString.addAttributes(nicknameAttr, range: NSRange(location: start, length: lenght))

        return attrString
    }
    
    private var isHiddenSubTitleLabel: Bool {
        var has = false
        if model.state {// 学完
            if model.type == .base {
                if model.score >= 1 {
                    has = true
                }
            } else if model.type != .aiReview && model.type != .wrong {
                has = true
            }
        } else {
            if model.type == .base {
                has = true
            }
        }
        return !has // (model.state == false) ||  (model.type == .wrong)
    }
    
    
    private func titleHeight() -> CGFloat {
        let font = UIFont.regularFont(ofSize: AS(17))
        let titleWidth = screenWidth - AS(40)
        
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
        allHeight += AS(24 + 109 + 11)
        allHeight += titleHeight()
                
        if isHiddenSubTitleLabel == false {
            allHeight += AS(5 + 17)
        }
        
        if model.state == false {
            allHeight += AS(6 + 8)
        }
        
        let tipsHeight = tipsView.viewHeight(count: self.createDataSource().count)
        allHeight += AS(28) + tipsHeight
        
        allHeight += AS(25 + 42 + 25)
        
        return allHeight
    }
    
}






class YXReviewResultTipsListView: YXView, UITableViewDelegate, UITableViewDataSource {
    
    var showWordListEvent: (() -> ())?
    
    var dataSource: [(String, Int, Bool)] = [] {
        didSet { bindData() }
    }
    var textAlignment: NSTextAlignment = .left
        
    private var maxWidth: CGFloat = 0
    private var tableView = UITableView()
    
    private let cellHeight: CGFloat = AS(40)
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.createSubviews()
        self.bindProperty()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func createSubviews() {
        self.addSubview(tableView)
    }
    
    override func bindProperty() {
        self.tableView.backgroundColor = UIColor.clear
        self.tableView.separatorColor = UIColor.black4.withAlphaComponent(0.5)
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.register(UITableViewCell.classForCoder(), forCellReuseIdentifier: "UITableViewCell")
    }
    
    
    override func layoutSubviews() {
        super.layoutSubviews()
        tableView.snp.remakeConstraints { (make) in
            make.edges.equalToSuperview()
        }
    }
    
    override func bindData() {
        self.processMaxContentWidth()
        self.tableView.reloadData()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSource.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return cellHeight
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let value = dataSource[indexPath.row]
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "UITableViewCell", for: indexPath)
        cell.selectionStyle = .none
        cell.accessoryType = value.2 ? .disclosureIndicator : .none
        
        let titleLabel = self.createTitleLabel()
        let countLabel = self.createCountLabel()
        
        titleLabel.text = value.0
        countLabel.text = "\(value.1)"
        
        cell.contentView.removeAllSubviews()
        cell.contentView.addSubview(titleLabel)
        cell.contentView.addSubview(countLabel)
        
        titleLabel.snp.remakeConstraints { (make) in
            make.centerY.equalToSuperview()
            make.left.equalTo(AS(31))
            make.height.equalTo(AS(20))
        }
        
        countLabel.snp.remakeConstraints { (make) in
            make.centerY.equalToSuperview()
            make.left.equalTo(titleLabel.snp.right).offset(AS(10))
            make.width.equalTo(AS(80))
            make.right.equalTo(AS(value.2 ? -2 : -34))
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let data = dataSource[indexPath.row]
        if data.2 {
            self.showWordListEvent?()
        }
    }
    
    
    private func createTitleLabel() -> UILabel {
        let titleLabel = UILabel()
        titleLabel.font = UIFont.regularFont(ofSize: AS(14))
        titleLabel.textColor = UIColor.black2
        return titleLabel
    }
    
    private func createCountLabel() -> UILabel {
        let titleLabel = UILabel()
        titleLabel.font = UIFont.regularFont(ofSize: AS(17))
        titleLabel.textColor = UIColor.orange1
        titleLabel.textAlignment = .right
        return titleLabel
    }
    
    
    private func processMaxContentWidth() {
        for content in dataSource {
            let w: CGFloat = content.0.textWidth(font: UIFont.regularFont(ofSize: AS(14)), height: AS(20))
            maxWidth = (w > maxWidth) ? w : maxWidth
        }
    }
    
    func viewHeight(count: Int) -> CGFloat {
        return cellHeight * CGFloat(count > 3 ? 3 : count)
    }
    
}
