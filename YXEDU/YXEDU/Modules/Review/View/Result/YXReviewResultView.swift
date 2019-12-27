//
//  YXAIReviewResultView.swift
//  YXEDU
//
//  Created by sunwu on 2019/12/23.
//  Copyright © 2019 shiji. All rights reserved.
//

import UIKit


/// 复习结果页
class YXReviewResultView: YXTopWindowView {

//    var shareEvent: (() -> ())?
    
    var type: YXExerciseDataType = .aiReview
    
    var imageView = UIImageView()
    var starView = YXReviewResultStarView()
    
    var titleLabel = UILabel()
    var starTitleLabel = UILabel()
    
    var subTitleLable1 = UILabel()
    var subTitleLable2 = UILabel()
    
    var pointLabel1 = UILabel()
    var pointLabel2 = UILabel()
    
    var tableView = YXReviewResultTableView()
    
    var shareButton = UIButton()
    var closeButton = UIButton()
    
    var model: YXReviewResultModel? {
        didSet { bindData() }
    }
    
    deinit {
        shareButton.removeTarget(self, action: #selector(clickShareButton), for: .touchUpInside)
        closeButton.removeTarget(self, action: #selector(clickCloseButton), for: .touchUpInside)
    }
    
    init(type: YXExerciseDataType) {
        super.init(frame: .zero)
        self.createSubviews()
        self.bindProperty()
    }
    

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
        
    override func createSubviews() {
        contentView.addSubview(imageView)
        contentView.addSubview(starView)
        
        contentView.addSubview(titleLabel)
        contentView.addSubview(starTitleLabel)
        
        contentView.addSubview(subTitleLable1)
        contentView.addSubview(subTitleLable2)
        
        contentView.addSubview(pointLabel1)
        contentView.addSubview(pointLabel2)
        
        contentView.addSubview(tableView)
        
        contentView.addSubview(shareButton)
        contentView.addSubview(closeButton)
    }
    
    override func bindProperty() {
        
        imageView.image = UIImage(named: "review_finish_result")
        
        titleLabel.font = UIFont.regularFont(ofSize: AS(17))
        titleLabel.textAlignment = .center
        titleLabel.textColor = UIColor.black1
        
        starTitleLabel.font = UIFont.regularFont(ofSize: AS(14))
        starTitleLabel.textAlignment = .center
        starTitleLabel.textColor = UIColor.black3
        
        
        pointLabel1.layer.masksToBounds = true
        pointLabel1.layer.cornerRadius = AS(2)
        pointLabel1.backgroundColor = UIColor.black4
        
        
        pointLabel2.layer.masksToBounds = true
        pointLabel2.layer.cornerRadius = AS(2)
        pointLabel2.backgroundColor = UIColor.black4
        
        shareButton.layer.masksToBounds = true
        shareButton.layer.cornerRadius = AS(21)
        shareButton.setBackgroundImage(UIImage.imageWithColor(UIColor.orange1), for: .normal)
        shareButton.setTitle("打卡分享", for: .normal)
        shareButton.setTitleColor(UIColor.white, for: .normal)
        shareButton.titleLabel?.font = UIFont.pfSCRegularFont(withSize: AS(17))
        shareButton.addTarget(self, action: #selector(clickShareButton), for: .touchUpInside)
        
        closeButton.setImage(UIImage(named: "review_learning_close"), for: .normal)
        closeButton.addTarget(self, action: #selector(clickCloseButton), for: .touchUpInside)
        
        tableView.backgroundColor = UIColor.red.withAlphaComponent(0.4)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        contentView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        
        imageView.snp.makeConstraints { (make) in
            make.top.equalTo(AS(kNavHeight))
            make.centerX.equalToSuperview()
            make.width.equalTo(AS(233))
            make.height.equalTo(AS(141))
        }
        
        starView.snp.makeConstraints { (make) in
            make.centerX.bottom.equalTo(imageView)
            make.width.equalTo(AS(27 * 2 + 38 + 6))
            make.height.equalTo(AS(45))
        }
        
        titleLabel.snp.makeConstraints { (make) in
            make.top.equalTo(imageView.snp.bottom).offset(AS(16))
            make.left.right.equalToSuperview()
            make.height.equalTo(AS(24))
        }

        
        starTitleLabel.snp.makeConstraints { (make) in
            make.top.equalTo(titleLabel.snp.bottom).offset(AS(5))
            make.left.right.equalToSuperview()
            make.height.equalTo(AS(20))
        }
        
        
        pointLabel1.snp.makeConstraints { (make) in
            make.top.equalTo(starTitleLabel.snp.bottom).offset(AS(50))
            make.left.equalTo(AS(32))
            make.width.height.equalTo(AS(4))
        }
        
        pointLabel2.snp.makeConstraints { (make) in
            make.top.equalTo(starTitleLabel.snp.bottom).offset(AS(72))
            make.left.equalTo(AS(32))
            make.width.height.equalTo(AS(4))
        }
        
        
        subTitleLable1.snp.makeConstraints { (make) in
            make.centerY.equalTo(pointLabel1)
            make.left.equalTo(pointLabel1.snp.right).offset(AS(12))
            make.right.equalTo(AS(-85))
            make.height.equalTo(AS(20))
        }
        
        subTitleLable2.snp.makeConstraints { (make) in
            make.centerY.equalTo(pointLabel2)
            make.left.equalTo(pointLabel2.snp.right).offset(AS(12))
            make.right.equalTo(AS(-85))
            make.height.equalTo(AS(20))
        }
    
        
        tableView.snp.makeConstraints { (make) in
            make.top.equalTo(subTitleLable2.snp.bottom).offset(14)
            make.left.equalTo(29)
            make.right.equalTo(AS(-29))
        }
        
        
        shareButton.snp.makeConstraints { (make) in
            make.top.equalTo(tableView.snp.bottom).offset(AS(30))
            make.left.equalTo(AS(51))
            make.right.equalTo(AS(-51))
            make.height.equalTo(AS(42))
            make.bottom.equalTo(-AS(kSafeBottomMargin + 29))
        }
        
        closeButton.snp.makeConstraints { (make) in
            make.top.equalTo(AS(29 + kSafeBottomMargin))
            make.left.equalTo(AS(15))
            make.width.equalTo(AS(28))
            make.height.equalTo(AS(28))
        }
        
        self.layoutIfNeeded()
    }
    
    override func bindData() {
        if type == .aiReview {
            titleLabel.text = "恭喜完成智能复习"
        } else {
            titleLabel.text = "恭喜完成<\("xxxxx")>的复习"
        }
        starTitleLabel.text = " 太棒了，获得了\(3)星呢！"
        subTitleLable1.attributedText = attrString("巩固了 32 个单词", 4, 2)
        subTitleLable2.attributedText = attrString("20 个单词掌握的更好了", 0, 2)
        
        tableView.words = model?.words ?? []
        starView.count = model?.score ?? 0
    }
    
    @objc func clickShareButton() {
//        self.shareEvent?()
        
        let shareVC = YXShareViewController()
        shareVC.shareType = shareType()
        shareVC.titleString = model?.planName ?? ""
        shareVC.wordsAmount = model?.allWordNum ?? 0
        shareVC.daysAmount = model?.studyDay ?? 0
        
        self.removeFromSuperview()
        
        YRRouter.sharedInstance()?.currentNavigationController()?.pushViewController(shareVC, animated: true)
    }
    

    private func shareType() -> YXShareType {
        switch type {
        case .aiReview:
            return .aiReviewReuslt
        case .planListenReview:
            return .listenReviewResult
        case .planReview:
            return .planReviewResult
        case .wrong:
            return .aiReviewReuslt
        default:
            return .aiReviewReuslt
        }
    }
    
    
    @objc func clickCloseButton() {
        self.removeFromSuperview()
    }
    
    func attrString(_ text: String, _ start: Int, _ lenght: Int) -> NSAttributedString {
        
        let attrString = NSMutableAttributedString(string: text)
                        
        let all: [NSAttributedString.Key : Any] = [.font: UIFont.regularFont(ofSize: AS(14)),.foregroundColor: UIColor.black3]
        attrString.addAttributes(all, range: NSRange(location: 0, length: attrString.length))
        
        let nicknameAttr: [NSMutableAttributedString.Key: Any] = [.font: UIFont.regularFont(ofSize: AS(14)),.foregroundColor: UIColor.orange1]
        attrString.addAttributes(nicknameAttr, range: NSRange(location: start, length: lenght))

        return attrString
    }

}


class YXReviewResultStarView: YXView {
    
    public var count: Int = 0 {
        didSet { bindData() }
    }
    
    private var imageView1 = UIImageView()
    private var imageView2 = UIImageView()
    private var imageView3 = UIImageView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.createSubviews()
        self.bindProperty()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func createSubviews() {
        self.addSubview(imageView1)
        self.addSubview(imageView2)
        self.addSubview(imageView3)
    }
    
    override func bindProperty() {
        imageView1.image = UIImage(named: "review_finish_result_star_dis")
        imageView2.image = UIImage(named: "review_finish_result_star_dis")
        imageView3.image = UIImage(named: "review_finish_result_star_dis")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        imageView1.snp.makeConstraints { (make) in
            make.centerY.left.equalToSuperview()
            make.width.equalTo(27)
            make.height.equalTo(45)
        }
        
        imageView2.snp.makeConstraints { (make) in
            make.center.equalToSuperview()
            make.width.equalTo(38)
            make.height.equalTo(45)
        }
        
        imageView3.snp.makeConstraints { (make) in
            make.centerY.right.equalToSuperview()
            make.width.equalTo(27)
            make.height.equalTo(45)
        }
        
    }
        
    override func bindData() {
        if count >= 1 {
            imageView1.image = UIImage(named: "review_finish_result_star")
        }
        if count >= 2 {
            imageView2.image = UIImage(named: "review_finish_result_star")
        }
        if count >= 3 {
            imageView3.image = UIImage(named: "review_finish_result_star")
        }
    }
}



