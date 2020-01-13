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
    var model: YXReviewResultModel?
    
    var bgView = UIView()
    
    var imageView = UIImageView()
    var titleLabel = UILabel()
    var starView = YXReviewResultStarView()
    
    var progressView = YXReviewProgressView(type: .iKnow, cornerRadius: AS(4))

    var tipsView = YXReviewResultTipsListView()
    
    var operateButton = YXButton()
    
    deinit {
        operateButton.removeTarget(self, action: #selector(clickOperateButton), for: .touchUpInside)
    }
    
    init(model: YXReviewResultModel?) {
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
        self.addSubview(bgView)
        bgView.addSubview(imageView)
        bgView.addSubview(titleLabel)
        bgView.addSubview(starView)
        bgView.addSubview(progressView)
        bgView.addSubview(tipsView)
//        bgView.addSubview(tableView)
        bgView.addSubview(operateButton)
    }
    
    override func bindProperty() {
        bgView.layer.setDefaultShadow()
        
        titleLabel.font = UIFont.regularFont(ofSize: AS(17))
        titleLabel.textAlignment = .center
        titleLabel.textColor = UIColor.black1
        titleLabel.numberOfLines = 0
        
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
        
        bgView.snp.remakeConstraints { (make) in
            make.top.equalTo(AS(68 + kSafeBottomMargin))
            make.left.equalTo(AS(21))
            make.right.equalTo(AS(-21))
            make.height.equalTo(AS(406))
        }
        
        imageView.snp.remakeConstraints { (make) in
            
            make.centerX.equalToSuperview()
            make.width.equalTo(AS(233))
            if model?.type == .base {
                make.top.equalTo(AS(24))
                make.height.equalTo(AS(109))
            } else {
                make.top.equalTo(AS(-8))
                make.height.equalTo(AS(144))
            }
        }
        
        starView.snp.remakeConstraints { (make) in
            make.centerX.equalTo(imageView)
            make.bottom.equalTo(imageView).offset(AS(6))
            make.width.equalTo(AS(27 * 2 + 38 + 2))
            make.height.equalTo(AS(45))
        }
        
        let titleHeight = titleLabel.text?.textHeight(font: titleLabel.font, width: screenWidth - AS(40)) ?? 0
        titleLabel.snp.remakeConstraints { (make) in
            make.top.equalTo(imageView.snp.bottom).offset(AS(11))
            make.left.equalTo(AS(20))
            make.right.equalTo(AS(-20))
            make.height.equalTo(titleHeight)
        }
        
        progressView.snp.remakeConstraints { (make) in
            make.top.equalTo(titleLabel.snp.bottom).offset(AS(11))
            make.left.right.equalTo(imageView)
            make.height.equalTo(AS(8))
        }
        
        let tipsHeight = tipsView.viewHeight(count: self.createDataSource().count)
        tipsView.snp.remakeConstraints { (make) in
            make.top.equalTo(progressView.snp.bottom).offset(AS(28))
            make.left.right.equalToSuperview()
            make.height.equalTo(tipsHeight)
        }
                
        operateButton.snp.remakeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.width.equalTo(AS(273))
            make.height.equalTo(AS(42))
            make.bottom.equalTo(-AS(kSafeBottomMargin + 29))
        }
        
        self.layoutIfNeeded()
    }
    
    override func bindData() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.35) { [weak self] in
            guard let self = self else { return }
            let score = CGFloat(self.model?.score ?? 0)
            self.progressView.progress = score / 100.0
        }
        
        self.setTitleValue()
        self.setImageValue()
        self.setShareButtonValue()
        

        starView.isHidden = isHiddenTipsLabel
                
        tipsView.textAlignment = (model?.words?.count ?? 0) > 0 ? .left : .center
//        tipsView.dataSource = self.createDataSource()

    }
    
    @objc func clickOperateButton() {
        self.processEvent?()
    }
    
    
    @objc func clickCloseButton() {
        NotificationCenter.default.post(name: YXNotification.kRefreshReviewTabPage, object: nil)
        NotificationCenter.default.post(name: YXNotification.kRefreshReviewDetailPage, object: nil)
//        self.removeFromSuperview()
    }

    
    private func setTitleValue() {
        if model?.state ?? false {
            titleLabel.attributedText = attrString()
        } else {
            if model?.type == .aiReview {
                titleLabel.text = "恭喜完成智能复习"
            } else if model?.type == .planListenReview {
                titleLabel.text = "恭喜完成\(model?.planName ?? "")的听力"
            } else if model?.type == .planReview {
                titleLabel.text = "恭喜完成\(model?.planName ?? "")的复习"
            } else if model?.type == .wrong {
                titleLabel.text = "恭喜完成抽查复习"
            }
        }

    }
    
    private func setImageValue() {
        if model?.state ?? false {
            imageView.image = UIImage(named: "review_learning_progress")
        } else {
            if model?.type == .base {
                imageView.image = UIImage(named: "learnResult\(model?.score ?? 0)")
            } else if model?.type == .wrong {
                imageView.image = UIImage(named: "review_wrong_finish_result")
            } else if model?.type == .planListenReview {
                imageView.image = UIImage(named: "review_listen_finish_result")
            } else {// 计划或者智能
                imageView.image = UIImage(named: "review_finish_result")
            }
        }
    }
    
    private func setShareButtonValue() {
                
        if model?.state ?? false {
            if model?.type == .planListenReview {
                operateButton.setTitle("继续听写", for: .normal)
            } else if model?.type == .planReview {
                operateButton.setTitle("继续复习", for: .normal)
            }
        } else {
            if model?.type == .wrong {
                operateButton.setTitle("完成", for: .normal)
            } else {
                operateButton.setTitle("打卡分享", for: .normal)
            }
        }

    }
    
    
    

    
    private func createDataSource() -> [NSAttributedString] {
        var attrs: [NSAttributedString] = []
        
        if let num = model?.allWordNum, num > 0 {
            let length = "\(num)".count
            attrs.append(attrString(subTitle(num), 3, length))
        }
        if let num = model?.knowWordNum, num > 0 {
            let length = "\(num)".count
            attrs.append(attrString("\(num)个单词掌握的更好了", 0, length))
        }
        if let num = model?.remainWordNum, num > 0 {
            let length = "\(num)".count
            attrs.append(attrString("该计划下剩余\(model?.remainWordNum ?? 0)个单词待复习", 6, length))
        }
        
        return attrs
    }
    
    
    func attrString() -> NSAttributedString {
        var typeName = ""
        if model?.type == .base {
            typeName = "已学"
        } else if model?.type == .planListenReview {
            typeName = "听写完成"
        } else {
            typeName = "完成"
        }
        
        let score = model?.score ?? 0
        
        let attrString = NSMutableAttributedString(string: "\(model?.planName ?? "")\(typeName) \(score)%")
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
    
    private func subTitle(_ num: Int) -> String {
        if model?.type == .planListenReview {
            return "听写了\(num)个单词"
        }
        return "巩固了\(num)个单词"
    }

    
    private var isHiddenTipsLabel: Bool {
        return (model?.state == false) ||  (model?.type == .wrong)
    }
}






class YXReviewResultTipsListView: YXView, UITableViewDelegate, UITableViewDataSource {
    
    var dataSource: [(String, Int)] = [] {
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
        self.tableView.separatorColor = UIColor.clear
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
        let cell = tableView.dequeueReusableCell(withIdentifier: "UITableViewCell", for: indexPath)
        cell.selectionStyle = .none
            
        let value = dataSource[indexPath.row]
        let titleLabel = self.createTitleLabel()
        titleLabel.text = value.0
        
//        cell.addSubview(pointLabel)
        cell.addSubview(titleLabel)
        
        var lr: CGFloat = AS(32)
        if textAlignment == .center {
            lr = (screenWidth - maxWidth - AS(12)) / 2
        }
        
//        pointLabel.snp.remakeConstraints { (make) in
//            make.centerY.equalToSuperview()
//            make.left.equalTo(lr)
//            make.width.height.equalTo(AS(4))
//        }

//        titleLabel.snp.remakeConstraints { (make) in
//            make.centerY.equalToSuperview()
//            make.left.equalTo(pointLabel.snp.right).offset(AS(12))
//            make.width.equalTo(maxWidth)
//            make.height.equalTo(AS(20))
//        }
//        
        return cell
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
        return cellHeight * CGFloat(count)
    }
    
}
