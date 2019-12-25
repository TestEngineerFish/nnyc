//
//  YXReviewPlanTableViewCell.swift
//  YXEDU
//
//  Created by sunwu on 2019/12/9.
//  Copyright © 2019 shiji. All rights reserved.
//

import UIKit

class YXReviewPlanTableViewCell: YXTableViewCell<YXReviewPlanModel> {
    
    var startReviewPlanEvent: (() -> Void)?
    var startListenPlanEvent: (() -> Void)?
    var reviewPlanModel: YXReviewPlanModel? {
        didSet { bindData() }
    }
    
    var bgView = UIView()
    
    var titleLabel = UILabel()
    var countLabel = UILabel()
    var subTitleLabel = UILabel()
    var listenStarView = YXReviewPlanStarContainerView(type: .listen)
    var reviewStarView = YXReviewPlanStarContainerView(type: .plan)
    var reviewProgressView = YXReviewPlanProgressView()
    var listenImageView = UIImageView()
    var listenButton = UIButton()
    var reviewButton = UIButton()
    
    deinit {
        listenButton.removeTarget(self, action: #selector(clickListenButton), for: .touchUpInside)
        reviewButton.removeTarget(self, action: #selector(clickReviewButton), for: .touchUpInside)
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.createSubviews()
        self.bindProperty()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func createSubviews() {
        self.addSubview(bgView)
        
        bgView.addSubview(titleLabel)
        bgView.addSubview(countLabel)
        bgView.addSubview(subTitleLabel)
        bgView.addSubview(listenStarView)
        bgView.addSubview(reviewStarView)
        bgView.addSubview(reviewProgressView)
        
        bgView.addSubview(listenImageView)
        bgView.addSubview(listenButton)
        bgView.addSubview(reviewButton)
    }
    
    override func bindProperty() {
        bgView.backgroundColor = UIColor.white
        bgView.layer.setDefaultShadow(radius: AS(4))
        
        titleLabel.font = UIFont.pfSCRegularFont(withSize: AS(15))
        titleLabel.text = "我的复习计划1"
        titleLabel.textColor = UIColor.black1
        
        countLabel.font = UIFont.pfSCRegularFont(withSize: AS(12))
        countLabel.textColor = UIColor.black3
        
        subTitleLabel.font = UIFont.pfSCRegularFont(withSize: AS(12))
        subTitleLabel.text = "听写进度：80%"
        subTitleLabel.textColor = UIColor.black3
        
                
        listenImageView.image = UIImage(named: "review_listen_icon")
        
        listenButton.setTitle("听写练习", for: .normal)
        listenButton.titleLabel?.font = UIFont.regularFont(ofSize: AS(12))
        listenButton.setTitleColor(UIColor.orange1, for: .normal)
        listenButton.addTarget(self, action: #selector(clickListenButton), for: .touchUpInside)
                                    
        
        reviewButton.titleLabel?.font = UIFont.regularFont(ofSize: AS(14))
        reviewButton.setTitleColor(UIColor.black2, for: .normal)
        reviewButton.layer.masksToBounds = true
        reviewButton.layer.cornerRadius = AS(15)
        reviewButton.layer.borderColor = UIColor.black4.cgColor
        reviewButton.layer.borderWidth = 0.5
        reviewButton.addTarget(self, action: #selector(clickReviewButton), for: .touchUpInside)
    }
    
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        bgView.snp.remakeConstraints { (make) in
            make.top.equalTo(AS(6.5))
            make.left.equalTo(AS(22))
            make.right.equalTo(AS(-22))
            make.bottom.equalTo(AS(-6.5))
        }
        
        let titleWidth = titleLabel.text?.textWidth(font: titleLabel.font, height: AS(21)) ?? 0
        titleLabel.snp.remakeConstraints { (make) in
            make.top.equalTo(AS(15))
            make.left.equalTo(AS(22))
            make.width.equalTo(titleWidth)
            make.height.equalTo(AS(21))
        }
        
        let countWidth = countLabel.text?.textWidth(font: countLabel.font, height: AS(17)) ?? 0
        countLabel.snp.remakeConstraints { (make) in
            make.centerY.equalTo(titleLabel)
            make.left.equalTo(titleLabel.snp.right).offset(AS(10))
            make.width.equalTo(countWidth)
            make.height.equalTo(AS(17))
        }
        
        
        subTitleLabel.isHidden = true
        if reviewPlanModel?.listenState != .normal {
            subTitleLabel.isHidden = false
            let subTitleWidth = subTitleLabel.text?.textWidth(font: subTitleLabel.font, height: AS(17)) ?? 0
            subTitleLabel.snp.remakeConstraints { (make) in
                make.top.equalTo(titleLabel.snp.bottom).offset(AS(5))
                make.left.equalTo(titleLabel)
                make.width.equalTo(subTitleWidth)
                make.height.equalTo(AS(17))
            }
        }
        
        listenStarView.isHidden = true
        if reviewPlanModel?.listenState == .finish {
            listenStarView.isHidden = false
            listenStarView.snp.remakeConstraints { (make) in
                make.centerY.equalTo(subTitleLabel)
                make.left.equalTo(subTitleLabel.snp.right).offset(AS(1))
                make.width.equalTo(AS(48))
                make.height.equalTo(AS(14))
            }
        }
        
        
        listenImageView.snp.remakeConstraints { (make) in
            make.left.equalTo(AS(23))
            make.bottom.equalTo(AS(-23))
            make.width.height.equalTo(AS(15))
        }
        
        listenButton.snp.remakeConstraints { (make) in
            make.left.equalTo(listenImageView.snp.right).offset(AS(7))
            make.width.equalTo(AS(49))
            make.height.equalTo(AS(17))
            make.bottom.equalTo(AS(-22))
        }
        
        
        reviewButton.snp.remakeConstraints { (make) in
            make.right.equalTo(AS(-9))
            make.bottom.equalTo(AS(-14))
            make.width.equalTo(AS(96))
            make.height.equalTo(AS(30))
        }
        
        reviewProgressView.isHidden = true
        if reviewPlanModel?.reviewState == .learning {
            reviewProgressView.isHidden = false
            reviewProgressView.snp.remakeConstraints { (make) in
                make.top.equalTo(AS(18))
                make.right.equalTo(AS(-35))
                make.size.equalTo(AS(40))
            }
        }
        
        reviewStarView.isHidden = true
        if reviewPlanModel?.reviewState == .finish {
            reviewStarView.isHidden = false
            reviewStarView.snp.remakeConstraints { (make) in
                make.top.equalTo(AS(26))
                make.right.equalTo(AS(-17))
                make.width.equalTo(AS(81))
                make.height.equalTo(AS(27))
            }
        }
        
        self.layoutIfNeeded()
    }
    
    
    override func bindData() {
        titleLabel.text = reviewPlanModel?.planName
        countLabel.text = "单词: " + (reviewPlanModel?.wordCount.string ?? "")
        
        
        if reviewPlanModel?.listenState == .learning {
            subTitleLabel.text = "听写进度：\(reviewPlanModel?.listen ?? 0)%"
        } else if reviewPlanModel?.listenState == .finish {
            subTitleLabel.text = "听写成绩："
            listenStarView.count = reviewPlanModel?.listen ?? 0
        }
        
        
        if reviewPlanModel?.reviewState == .normal {
            reviewButton.setTitle("开始复习", for: .normal)
        } else if reviewPlanModel?.reviewState == .learning {
            reviewButton.setTitle("继续复习", for: .normal)
            reviewProgressView.progress = 0.8 //reviewPlanModel?.review ?? 0
        } else if reviewPlanModel?.reviewState == .finish {
            reviewButton.setTitle("继续复习", for: .normal)
            reviewStarView.count = reviewPlanModel?.review ?? 0
        }
        
    }
    
    
    override class func viewHeight(model: YXReviewPlanModel) -> CGFloat {
        let vHeight: CGFloat = model.listenState != .normal || model.reviewState != .normal ? 120 : 103
        return AS(vHeight)
    }
    
    
    
    @objc func clickReviewButton() {
        self.startReviewPlanEvent?()
    }
    
    
    @objc func clickListenButton() {
        self.startListenPlanEvent?()
    }
}



class YXReviewPlanStarContainerView: YXView {
    enum StarType {
        case listen
        case plan
    }
    
    public var count: Int = 0 {
        didSet { bindData() }
    }
    
    private var type: StarType = .listen
    private var imageView1 = UIImageView()
    private var imageView2 = UIImageView()
    private var imageView3 = UIImageView()
    
    init(type: StarType) {
        super.init(frame: .zero)
        
        self.type = type
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
        imageView1.image = UIImage(named: "review_finish_star_dis")
        imageView2.image = UIImage(named: "review_finish_star_dis")
        imageView3.image = UIImage(named: "review_finish_star_dis")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        let imageWidth: CGFloat = type == .listen ? 14 : 28
        let imageHeight: CGFloat = type == .listen ? 14 : 27
        
        imageView1.snp.makeConstraints { (make) in
            make.centerY.left.equalToSuperview()
            make.width.equalTo(AS(imageWidth))
            make.height.equalTo(AS(imageHeight))
        }
        
        imageView2.snp.makeConstraints { (make) in
            make.center.equalToSuperview()
            make.width.equalTo(AS(imageWidth))
            make.height.equalTo(AS(imageHeight))
        }
        
        imageView3.snp.makeConstraints { (make) in
            make.centerY.right.equalToSuperview()
            make.width.equalTo(AS(imageWidth))
            make.height.equalTo(AS(imageHeight))
        }
        
    }
        
    override func bindData() {
        if count >= 1 {
            imageView1.image = UIImage(named: "review_finish_star")
        }
        if count >= 2 {
            imageView2.image = UIImage(named: "review_finish_star")
        }
        if count >= 3 {
            imageView3.image = UIImage(named: "review_finish_star")
        }
    }
    
}


class YXReviewPlanProgressView: YXView {
    
    var progress: CGFloat = 0 {
        didSet { bindData() }
    }
    
    private var titleLabel = UILabel()
    private var shapeLayer: CAShapeLayer?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.createSubviews()
        self.bindProperty()
        self.backgroundARC()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func createSubviews() {
        self.addSubview(titleLabel)
    }
    
    override func bindProperty() {
        titleLabel.font = UIFont.semiboldFont(ofSize: AS(17))
        titleLabel.textColor = UIColor.black1
        titleLabel.textAlignment = .center
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        titleLabel.snp.makeConstraints { (make) in
            make.center.size.equalToSuperview()
        }
    }
    
    override func bindData() {
        
        titleLabel.text = "\(progress)"
            
        shapeLayer?.removeFromSuperlayer()

        let beginAngle = CGFloat(Double.pi * (-0.5)) // 起点
        let finishAngle = CGFloat(Double.pi) * (2 * progress - 0.5) // 终点

        let centerP = CGPoint(x: AS(20), y: AS(20))
        let path = UIBezierPath(arcCenter: centerP, radius: AS(20),
                                startAngle: beginAngle, endAngle: finishAngle, clockwise: true)

        shapeLayer = CAShapeLayer()
        shapeLayer?.lineWidth = AS(6.0)
        shapeLayer?.lineCap = .round
        shapeLayer?.strokeColor = UIColor.orange1.cgColor
        shapeLayer?.fillColor = UIColor.clear.cgColor

        shapeLayer?.path = path.cgPath
        shapeLayer?.frame = self.bounds

        self.layer.addSublayer(shapeLayer!)
    }
    
    func backgroundARC() {
        let beginAngle = CGFloat(Double.pi * (-0.5)) // 起点
        let finishAngle = CGFloat(Double.pi * 3 / 2) // 终点
        
        let centerP = CGPoint(x: AS(20), y: AS(20))
        let path = UIBezierPath(arcCenter: centerP, radius: AS(20),
                                startAngle: beginAngle, endAngle: finishAngle, clockwise: true)
        
        let shapeLayer = CAShapeLayer()
        shapeLayer.lineWidth = AS(6.0)
        shapeLayer.lineCap = .round
        shapeLayer.strokeColor = UIColor.hex(0xEBEBEB).cgColor
        shapeLayer.fillColor = UIColor.clear.cgColor

        shapeLayer.path = path.cgPath
        shapeLayer.frame = CGRect(x: 0, y: 0, width: AS(40), height: AS(40))
        
        self.layer.addSublayer(shapeLayer)
    }
}

