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
    var tipsLabel = UILabel()
    
    var closeButton = UIButton()
    
    private var model: YXReviewResultModel?
    
    deinit {
        shareButton.removeTarget(self, action: #selector(clickShareButton), for: .touchUpInside)
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
        mainView.addSubview(starView)
        
        mainView.addSubview(titleLabel)
        mainView.addSubview(starTitleLabel)
        
        mainView.addSubview(subTitleLable1)
        mainView.addSubview(subTitleLable2)
        
        mainView.addSubview(pointLabel1)
        mainView.addSubview(pointLabel2)
        
        mainView.addSubview(tableView)
        
        mainView.addSubview(shareButton)
        mainView.addSubview(tipsLabel)
        mainView.addSubview(closeButton)
    }
    
    override func bindProperty() {
        self.backgroundColor = UIColor.black.withAlphaComponent(0.7)
        
        titleLabel.font = UIFont.regularFont(ofSize: AS(17))
        titleLabel.textAlignment = .center
        titleLabel.textColor = UIColor.black1
        
        starTitleLabel.font = UIFont.regularFont(ofSize: AS(14))
        starTitleLabel.textAlignment = .center
        starTitleLabel.textColor = UIColor.black3
        starTitleLabel.numberOfLines = 0
        
        pointLabel1.layer.masksToBounds = true
        pointLabel1.layer.cornerRadius = AS(2)
        pointLabel1.backgroundColor = UIColor.black4
        
        
        pointLabel2.layer.masksToBounds = true
        pointLabel2.layer.cornerRadius = AS(2)
        pointLabel2.backgroundColor = UIColor.black4

        
        shareButton.layer.masksToBounds = true
        shareButton.layer.cornerRadius = AS(21)
        shareButton.setBackgroundImage(UIImage.imageWithColor(UIColor.orange1), for: .normal)
        
        shareButton.setTitleColor(UIColor.white, for: .normal)
        shareButton.titleLabel?.font = UIFont.pfSCRegularFont(withSize: AS(17))
        shareButton.addTarget(self, action: #selector(clickShareButton), for: .touchUpInside)
        
        tipsLabel.font = UIFont.regularFont(ofSize: AS(12))
        tipsLabel.textAlignment = .center
        tipsLabel.textColor = UIColor.black3
        tipsLabel.text = "*已经熟识的单词，可以在错词本中清除哦～"
                
        closeButton.setImage(UIImage(named: "review_learning_close"), for: .normal)
        closeButton.addTarget(self, action: #selector(clickCloseButton), for: .touchUpInside)
        
        
        if type == .wrong {
            imageView.image = UIImage(named: "review_wrong_finish_result")
            shareButton.setTitle("完成", for: .normal)
            tipsLabel.isHidden = false
            starView.isHidden = true
            starTitleLabel.isHidden = true
        } else {
            imageView.image = UIImage(named: "review_finish_result")
            shareButton.setTitle("打卡分享", for: .normal)
            tipsLabel.isHidden = true
            starView.isHidden = false
            starTitleLabel.isHidden = false
        }
        
        
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        mainView.snp.remakeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        
        imageView.snp.remakeConstraints { (make) in
            make.top.equalTo(AS(kNavHeight))
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
        
        let titleWidth = titleLabel.text?.textWidth(font: titleLabel.font, height: AS(24)) ?? 0
        titleLabel.snp.remakeConstraints { (make) in
            make.top.equalTo(imageView.snp.bottom).offset(AS(16))
            make.centerX.equalToSuperview()
            make.width.equalTo(titleWidth)
            make.height.equalTo(AS(24))
        }

        
        starTitleLabel.snp.remakeConstraints { (make) in
            make.top.equalTo(titleLabel.snp.bottom).offset(AS(5))
            make.left.right.equalToSuperview()
            make.height.equalTo(AS(20))
        }
        

        pointLabel1.snp.remakeConstraints { (make) in
            make.top.equalTo(starTitleLabel.snp.bottom).offset(AS(50))
            if (model?.words?.count ?? 0) == 0 {
                make.left.equalTo(titleLabel).offset(AS(-10))
            } else {
                make.left.equalTo(AS(32))
            }
            make.width.height.equalTo(AS(4))
        }
        
        pointLabel2.snp.remakeConstraints { (make) in
            make.top.equalTo(pointLabel1.snp.bottom).offset(AS(18))
            make.left.equalTo(pointLabel1)
            make.width.height.equalTo(AS(4))
        }
        
        
        subTitleLable1.snp.remakeConstraints { (make) in
            make.centerY.equalTo(pointLabel1)
            make.left.equalTo(pointLabel1.snp.right).offset(AS(12))
            make.right.equalTo(AS(-85))
            make.height.equalTo(AS(20))
        }
        
        subTitleLable2.snp.remakeConstraints { (make) in
            make.centerY.equalTo(pointLabel2)
            make.left.equalTo(pointLabel2.snp.right).offset(AS(12))
            make.right.equalTo(AS(-85))
            make.height.equalTo(AS(20))
        }
    
        
        tableView.snp.remakeConstraints { (make) in
            make.top.equalTo(subTitleLable2.snp.bottom).offset(AS(14))
            make.left.equalTo(AS(29))
            make.right.equalTo(AS(-29))
        }
        
        if type == .wrong {
            shareButton.snp.remakeConstraints { (make) in
                make.top.equalTo(tableView.snp.bottom).offset(AS(30))
                make.left.equalTo(AS(51))
                make.right.equalTo(AS(-51))
                make.height.equalTo(AS(42))
            }
            
            tipsLabel.snp.remakeConstraints { (make) in
                make.top.equalTo(shareButton.snp.bottom).offset(AS(12))
                make.left.right.equalToSuperview()
                make.height.equalTo(AS(17))
                make.bottom.equalTo(-AS(kSafeBottomMargin + 29))
            }
        } else {
            shareButton.snp.remakeConstraints { (make) in
                make.top.equalTo(tableView.snp.bottom).offset(AS(30))
                make.left.equalTo(AS(51))
                make.right.equalTo(AS(-51))
                make.height.equalTo(AS(42))
                make.bottom.equalTo(-AS(kSafeBottomMargin + 29))
            }
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
        if type == .aiReview {
            titleLabel.text = "恭喜完成智能复习"
        } else if type == .planListenReview {
            titleLabel.text = "恭喜完成\(model?.planName ?? "")的听力"
        } else if type == .planReview {
            titleLabel.text = "恭喜完成\(model?.planName ?? "")的复习"
        } else if type == .wrong {
            titleLabel.text = "恭喜完成抽查复习"
        }
        
        if let score = model?.score {
            if score == 0 || score == 1 {
                starTitleLabel.text = " 还有些词需要多多练习才行哦！"
            } else if score == 2 {
                starTitleLabel.text = " 再巩固一下，向3星冲刺哦！"
            } else if score == 3 {
                starTitleLabel.text = " 太棒了，获得了3星呢！"
            }
        }
    
        
        if let num = model?.allWordNum, num > 0 {
            let length = "\(num)".count
            subTitleLable1.attributedText = attrString(subTitle(num), 3, length)
        }
        if let num = model?.knowWordNum, num > 0 {
            let length = "\(num)".count
            subTitleLable2.attributedText = attrString("\(num)个单词掌握的更好了", 0, length)
        }
        
        
        tableView.words = model?.words ?? []
        tableView.isHidden = (tableView.words.count == 0)
        
        starView.count = model?.score ?? 0
        
//        self.layoutSubviews()
    }
    
    @objc func clickShareButton() {
        
        if type == .wrong {
            YRRouter.popViewController(true)
            return
        }
        
        let shareVC = YXShareViewController()
        shareVC.shareType = shareType()
        shareVC.wordsAmount = model?.allWordNum ?? 0
        shareVC.daysAmount = model?.studyDay ?? 0
        shareVC.hidesBottomBarWhenPushed = true
        YRRouter.sharedInstance()?.currentNavigationController()?.pushViewController(shareVC, animated: true)
    }
    

    private func shareType() -> YXShareImageType {
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
    
    
    @objc private func clickCloseButton() {
        NotificationCenter.default.post(name: YXNotification.kCloseResultPage, object: nil)
        YRRouter.popViewController(true)
    }
    
    private func attrString(_ text: String, _ start: Int, _ lenght: Int) -> NSAttributedString {
        
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
        } else if type == .wrong {
            return "复习了\(num)个单词"
        }
        return "巩固了\(num)个单词"
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
            make.width.equalTo(AS(27))
            make.height.equalTo(AS(45))
        }
        
        imageView2.snp.makeConstraints { (make) in
            make.center.equalToSuperview()
            make.width.equalTo(AS(38))
            make.height.equalTo(AS(45 * 38 / 27))
        }
        
        imageView3.snp.makeConstraints { (make) in
            make.centerY.right.equalToSuperview()
            make.width.equalTo(AS(27))
            make.height.equalTo(AS(45))
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



