//
//  YXReviewLearningProgressView.swift
//  YXEDU
//
//  Created by sunwu on 2019/12/23.
//  Copyright © 2019 shiji. All rights reserved.
//

import UIKit


/// 学习中【听写、复习计划】
class YXReviewLearningProgressView: YXTopWindowView {

    var reviewEvent: (() -> ())?
    var type: YXExerciseDataType = .aiReview
        
    var imageView = UIImageView()
    var titleLabel = UILabel()
    var progressView = YXReviewProgressView(type: .iKnow, cornerRadius: AS(4))

    var tipsView = YXReviewResultTipsView()
    var tableView = YXReviewResultWordTableView()
    
    var reviewButton = YXButton()
    var closeButton = UIButton()
    
    var model: YXReviewResultModel?
    
    deinit {
        reviewButton.removeTarget(self, action: #selector(clickReviewButton), for: .touchUpInside)
        closeButton.removeTarget(self, action: #selector(clickCloseButton), for: .touchUpInside)
    }
    
    init(type: YXExerciseDataType, model: YXReviewResultModel?) {
        super.init(frame: .zero)
        self.type = type
        self.model = model
        self.createSubviews()
        self.bindProperty()
        self.bindData()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
        
    override func createSubviews() {
        
        mainView.addSubview(imageView)
        mainView.addSubview(titleLabel)
        mainView.addSubview(progressView)
        mainView.addSubview(tipsView)
        mainView.addSubview(tableView)
        mainView.addSubview(reviewButton)
        mainView.addSubview(closeButton)
    }
    
    override func bindProperty() {
        
        imageView.image = UIImage(named: "review_learning_progress")
        
        titleLabel.textAlignment = .center
        titleLabel.numberOfLines = 0
        
        reviewButton.layer.masksToBounds = true
        reviewButton.layer.cornerRadius = AS(21)
        let bgColor = UIColor.gradientColor(with: CGSize(width: AS(273), height: AS(42)), colors: [UIColor.hex(0xFDBA33), UIColor.orange1], direction: .vertical)

        reviewButton.backgroundColor = bgColor
        if type == .planListenReview {
            reviewButton.setTitle("继续听写", for: .normal)
        } else if type == .planReview {
            reviewButton.setTitle("继续复习", for: .normal)
        }
        
        reviewButton.setTitleColor(UIColor.white, for: .normal)
        reviewButton.titleLabel?.font = UIFont.pfSCRegularFont(withSize: AS(17))
        reviewButton.addTarget(self, action: #selector(clickReviewButton), for: .touchUpInside)
        
        closeButton.setImage(UIImage(named: "review_learning_close"), for: .normal)
        closeButton.addTarget(self, action: #selector(clickCloseButton), for: .touchUpInside)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        mainView.snp.remakeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        
        imageView.snp.remakeConstraints { (make) in
            make.top.equalTo(AS(103))
            make.centerX.equalToSuperview()
            make.width.equalTo(AS(233))
            make.height.equalTo(AS(109))
        }
        let titleHeight = titleLabel.text?.textHeight(font: titleLabel.font, width: screenWidth - AS(40)) ?? 0
        titleLabel.snp.remakeConstraints { (make) in
            make.top.equalTo(imageView.snp.bottom).offset(AS(13))
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

        
        tableView.snp.remakeConstraints { (make) in
            make.top.equalTo(tipsView.snp.bottom).offset(AS(14))
            make.left.right.equalToSuperview()
            if (model?.words?.count ?? 0) > 3 {
                make.height.equalTo(AS(268))
            } else {
                make.height.equalTo(AS(173))
            }
        }
                
        reviewButton.snp.remakeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.width.equalTo(AS(273))
            make.height.equalTo(AS(42))
            make.bottom.equalTo(-AS(kSafeBottomMargin + 29))
        }
    
        closeButton.snp.remakeConstraints { (make) in
            make.top.equalTo(AS(29 + kSafeBottomMargin))
            make.left.equalTo(AS(15))
            make.width.equalTo(AS(28))
            make.height.equalTo(AS(28))
        }
        
        self.layoutIfNeeded()
    }
    
    override func bindData() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.35) { [weak self] in
            guard let self = self else { return }
            let score = CGFloat(self.model?.score ?? 0)
            self.progressView.progress = score / 100.0
        }
        
        titleLabel.attributedText = attrString()
                
        tipsView.textAlignment = (model?.words?.count ?? 0) > 0 ? .left : .center
        tipsView.dataSource = self.createDataSource()
        
        tableView.words = model?.words ?? []
        tableView.isHidden = (tableView.words.count == 0)
    }
    
    @objc func clickReviewButton() {
        self.reviewEvent?()
        self.clickCloseButton()
    }
    
    
    @objc func clickCloseButton() {
        NotificationCenter.default.post(name: YXNotification.kRefreshReviewTabPage, object: nil)
        NotificationCenter.default.post(name: YXNotification.kRefreshReviewDetailPage, object: nil)
        self.removeFromSuperview()
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
        let typeName = type == .planListenReview ? "听写" : ""
        
        let score = model?.score ?? 0
        
        let attrString = NSMutableAttributedString(string: "\(model?.planName ?? "")\(typeName)完成 \(score)%")
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
        if type == .planListenReview {
            return "听写了\(num)个单词"
        }
        return "巩固了\(num)个单词"
    }
}



class YXReviewResultTipsView: YXView, UITableViewDelegate, UITableViewDataSource {
    
    var dataSource: [NSAttributedString] = [] {
        didSet { bindData() }
    }
    var textAlignment: NSTextAlignment = .left
        
    private var maxWidth: CGFloat = 0
    private var tableView = UITableView()
    
    private let cellHeight: CGFloat = AS(22)
    
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
            
        
        let pointLabel = self.createPointLabel()
        let titleLabel = self.createTitleLabel(attr: dataSource[indexPath.row])
        
        cell.addSubview(pointLabel)
        cell.addSubview(titleLabel)
        
        var lr: CGFloat = AS(32)
        if textAlignment == .center {
            lr = (screenWidth - maxWidth - AS(12)) / 2
        }
        
        pointLabel.snp.remakeConstraints { (make) in
            make.centerY.equalToSuperview()
            make.left.equalTo(lr)
            make.width.height.equalTo(AS(4))
        }

        titleLabel.snp.remakeConstraints { (make) in
            make.centerY.equalToSuperview()
            make.left.equalTo(pointLabel.snp.right).offset(AS(12))
            make.width.equalTo(maxWidth)
            make.height.equalTo(AS(20))
        }
        
        return cell
    }
    
    
    private func createPointLabel() -> UILabel {
        let pointLabel1 = UILabel()
        pointLabel1.layer.masksToBounds = true
        pointLabel1.layer.cornerRadius = AS(2)
        pointLabel1.backgroundColor = UIColor.black4
        return pointLabel1
    }
    
    private func createTitleLabel(attr: NSAttributedString) -> UILabel {
        let titleLabel = UILabel()
        titleLabel.attributedText = attr
        return titleLabel
    }
    
    private func processMaxContentWidth() {
        for content in dataSource {
            let w: CGFloat = content.string.textWidth(font: UIFont.regularFont(ofSize: AS(14)), height: AS(20))
            maxWidth = (w > maxWidth) ? w : maxWidth
        }
    }
    
    func viewHeight(count: Int) -> CGFloat {
        return cellHeight * CGFloat(count)
    }
    
}

