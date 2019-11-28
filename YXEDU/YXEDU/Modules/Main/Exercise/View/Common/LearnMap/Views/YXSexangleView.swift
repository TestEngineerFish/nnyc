//
//  YXSexangleView.swift
//  BaseProject
//
//  Created by 沙庭宇 on 2019/11/6.
//  Copyright © 2019 沙庭宇. All rights reserved.
//

import UIKit


protocol YXSexangleViewClickProcotol: NSObjectProtocol {
    func clickSexangleView(_ view: YXSexangleView)
}

class YXSexangleView: UIView {

    var model: YXLearnMapUnitModel
    var progressLabel: YXLabel?
    weak var delegate: YXSexangleViewClickProcotol?
    var isExtension: Bool
    var gradientLayer: CAGradientLayer?
    var avatarView: UIView?
    var isShowProgress: Bool

    init(_ model: YXLearnMapUnitModel, isExtension: Bool, isShowProgress: Bool) {
        self.model          = model
        self.isExtension    = isExtension
        self.isShowProgress = isShowProgress
        super.init(frame: CGRect(origin: .zero, size: CGSize(width: AdaptSize(81), height: AdaptSize(81))))
        self.createSubview(isShowProgress: isShowProgress)
        if model.status == .uniteEnd {
            // 设置星星等级
            self.setScoreStarView(model.stars)
        }
        self.isUserInteractionEnabled = true
        let tap = UITapGestureRecognizer(target: self, action: #selector(clickEvent))
        self.addGestureRecognizer(tap)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func createSubview(isShowProgress: Bool) {
        // 外部的六边形
        let outSideColor = self.getOutSideColor()
        let outSideLayer = self.getSexangleLayer(self.width, strokeColor: outSideColor.cgColor)
        self.layer.addSublayer(outSideLayer)
        // 内部的六边形
        let inSideSexangleView = UIView()
        inSideSexangleView.frame  = CGRect(origin: CGPoint.zero, size: CGSize(width: AdaptSize(70), height: AdaptSize(70)))
        let inSideFillColor = self.getInSideFillColor()
        let inSideLayer     = self.getSexangleLayer(inSideSexangleView.width, strokeColor: UIColor.white.cgColor, fillColor: inSideFillColor.cgColor)
        inSideSexangleView.layer.addSublayer(inSideLayer)
        inSideLayer.frame = inSideSexangleView.bounds

        self.addSubview(inSideSexangleView)
        inSideSexangleView.center = CGPoint(x: self.width/2, y: self.height/2)

        let contentView = self.createContentView()
        self.addSubview(contentView)
        contentView.snp.makeConstraints { (make) in
            make.center.equalToSuperview()
            make.height.equalTo(AdaptSize(42))
            make.width.equalToSuperview()
        }
        if model.status == .uniteIng, isShowProgress {
            self.showProgressAnimation()
        }
    }

     // 设置进度动画
    func showProgressAnimation() {
        self.hideProgressAnimtion()
        let maskLayer = self.getSexangleLayer(self.width, strokeColor: UIColor.red.cgColor)
        // 获取渐变图层
        gradientLayer = self.getGradientLayer()

        self.layer.addSublayer(gradientLayer!)
        gradientLayer?.frame = self.bounds

        gradientLayer?.mask  = maskLayer

        let progressAnimation = CABasicAnimation(keyPath: "strokeEnd")
        progressAnimation.fromValue   = 0.0
        progressAnimation.toValue     = self.model.rate
        progressAnimation.duration    = 2
        progressAnimation.repeatCount = 1
        progressAnimation.fillMode    = .forwards
        progressAnimation.isRemovedOnCompletion = false
        maskLayer.add(progressAnimation, forKey: nil)
    }

    func hideProgressAnimtion() {
        self.gradientLayer?.removeFromSuperlayer()
    }

    /// 获得内容视图
    private func createContentView() -> UIView {

        if  model.status == .uniteIng {
            let view = UIView()
            let unitLabel = UILabel()
            unitLabel.text          = model.unitName
            unitLabel.textColor     = UIColor.hex(0xE38B03)
            unitLabel.textAlignment = .center
            unitLabel.font          = UIFont.boldSystemFont(ofSize: AdaptSize(12))
            self.progressLabel = YXLabel()
            progressLabel?.text          = "0"
            progressLabel?.textColor     = self.getTitleColor()
            progressLabel?.textAlignment = .center
            progressLabel?.font          = UIFont.boldSystemFont(ofSize: AdaptSize(12))
            progressLabel?.maxNum        = Int(model.rate * 100)
            view.addSubview(unitLabel)
            view.addSubview(progressLabel!)
            unitLabel.snp.makeConstraints { (make) in
                make.centerX.equalToSuperview()
                make.top.equalToSuperview()
                make.width.equalToSuperview()
                make.height.equalTo(AdaptSize(17))
            }
            progressLabel!.snp.makeConstraints { (make) in
                make.centerX.equalToSuperview()
                make.top.equalTo(unitLabel.snp.bottom)
                make.width.equalToSuperview()
                make.height.equalTo(AdaptSize(17))
            }
            // 设置进度数字动画
            let interval = Double(2/(model.rate*100))
            if isShowProgress {
                self.progressLabel?.startCount(interval: interval)
            } else {
                self.progressLabel?.text = String(format: "%d%%", Int(model.rate * 100))
            }
            return view
        } else {
            let view = UIView()
            let imageView = UIImageView()
            imageView.image = {
                if model.status == .uniteEnd {
                    return UIImage(named: "fruit_enable")
                } else if model.status == .uniteUnstart || model.status == .uniteIngProgressZero {
                    return UIImage(named: "fruit_disable")
                } else {
                    return nil
                }
            }()
            let label = UILabel()
            label.textAlignment = .center
            label.text = model.unitName
            label.textColor = self.getTitleColor()
            label.font = UIFont.boldSystemFont(ofSize: AdaptSize(12))
            view.addSubview(imageView)
            imageView.snp.makeConstraints { (make) in
                make.centerX.equalToSuperview()
                make.top.equalToSuperview()
                make.height.width.equalTo(AdaptSize(25))
            }
            view.addSubview(label)
            label.snp.makeConstraints { (make) in
                make.centerX.equalToSuperview()
                make.top.equalTo(imageView.snp.bottom)
                make.width.equalToSuperview()
                make.height.equalTo(AdaptSize(17))
            }
            return view
        }
    }

    /// 设置星星等级
    /// - Parameter stars: 分数,也代表星星数
    private func setScoreStarView(_ stars: Int) {
        let firstStar  = UIImageView()
        let secondStar = UIImageView()
        let thirdStar  = UIImageView()
        self.addSubview(firstStar)
        self.addSubview(secondStar)
        self.addSubview(thirdStar)
        secondStar.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.bottom.equalToSuperview().offset(AdaptSize(10))
            make.width.height.equalTo(
            AdaptSize(25))
        }
        firstStar.snp.makeConstraints { (make) in
            make.right.equalTo(secondStar.snp.left).offset(AdaptSize(2))
            make.top.equalTo(secondStar).offset(AdaptSize(-5))
            make.width.height.equalTo(AdaptSize(25))
        }
        thirdStar.snp.makeConstraints { (make) in
            make.left.equalTo(secondStar.snp.right).offset(AdaptSize(-2))
            make.top.equalTo(secondStar).offset(AdaptSize(-5))
            make.width.height.equalTo(AdaptSize(25))
        }

        if stars > 0 {
            firstStar.image = UIImage(named: "star_enable")
        } else {
            firstStar.image = UIImage(named: "star_disable")
        }
        if stars > 1 {
            secondStar.image = UIImage(named: "star_enable")
        } else {
            secondStar.image = UIImage(named: "star_disable")
        }
        if stars > 2 {
            thirdStar.image = UIImage(named: "star_enable")
        } else {
            thirdStar.image = UIImage(named: "star_disable")
        }
    }

    /// 获取六边形Layer
    /// - Parameters:
    ///   - width: layer宽度
    ///   - strokeColor: layer的边框颜色
    ///   - fillColor: layer的填充颜色,默认为空
    private func getSexangleLayer(_ width: CGFloat, strokeColor: CGColor, fillColor: CGColor? = nil) -> CAShapeLayer {
        let startX = CGFloat(sin(M_1_PI / 180 * 60)) * (width/2)
        let path   = UIBezierPath()
        path.move(to: CGPoint(x: width/2, y: 0))
        path.addLine(to: CGPoint(x: width - startX, y: width/4))
        path.addLine(to: CGPoint(x: width - startX, y: width/2 + width/4))
        path.addLine(to: CGPoint(x: width/2, y: width))
        path.addLine(to: CGPoint(x: startX, y: width/2 + width/4))
        path.addLine(to: CGPoint(x: startX, y: width/4))
        path.close()

        let shapLayer         = CAShapeLayer()
        shapLayer.path        = path.cgPath
        shapLayer.lineWidth   = AdaptSize(5)
        shapLayer.lineCap     = .round
        shapLayer.strokeColor = strokeColor
        shapLayer.fillColor   = fillColor
        return shapLayer
    }

    /// 获得渐变图层
    private func getGradientLayer() -> CAGradientLayer {
        let offset = CGFloat(AdaptSize(5))
        let gradientLayer = CAGradientLayer()
        let layer0    = CAGradientLayer()
        layer0.frame  = CGRect(x: width/2, y: -offset, width: width/2, height: width/4 + offset)
        layer0.colors = [UIColor.hex(0xFFCA27).cgColor, UIColor.hex(0xFFBE26).cgColor]
        layer0.startPoint = CGPoint(x: 0, y: 0)
        layer0.endPoint   = CGPoint(x: 0.9, y: 1)
        gradientLayer.addSublayer(layer0)

        let layer1    = CAGradientLayer()
        layer1.frame  = CGRect(x: width/2, y: width/4, width: width/2, height: width/2)
        layer1.colors = [UIColor.hex(0xFFBE26).cgColor, UIColor.hex(0xFEA724).cgColor]
        layer1.startPoint = CGPoint(x: 0.9, y: 0)
        layer1.endPoint   = CGPoint(x: 0.9, y: 1)
        gradientLayer.addSublayer(layer1)

        let layer2    = CAGradientLayer()
        layer2.frame  = CGRect(x: width/2, y: width - width/4, width: width/2, height: width/4 + offset)
        layer2.colors = [UIColor.hex(0xFEA724).cgColor, UIColor.hex(0xFE9B23).cgColor]
        layer2.startPoint = CGPoint(x: 0.9, y: 0)
        layer2.endPoint   = CGPoint(x: 0, y: 1)
        gradientLayer.addSublayer(layer2)

        let layer3    = CAGradientLayer()
        layer3.frame  = CGRect(x: 0, y: width - width/4, width: width/2, height: width/4 + offset)
        layer3.colors = [UIColor.hex(0xFE9B23).cgColor, UIColor.hex(0xFE8B26).cgColor]
        layer3.startPoint = CGPoint(x: 1, y: 1)
        layer3.endPoint   = CGPoint(x: 0, y: 0)
        gradientLayer.addSublayer(layer3)

        let layer4    = CAGradientLayer()
        layer4.frame  = CGRect(x: 0, y: width/4, width: width/2, height: width/2)
        layer4.colors = [UIColor.hex(0xFE8B26).cgColor, UIColor.hex(0xFD682D).cgColor]
        layer4.startPoint = CGPoint(x: 0, y: 1)
        layer4.endPoint   = CGPoint(x: 0, y: 0)
        gradientLayer.addSublayer(layer4)

        let layer5    = CAGradientLayer()
        layer5.frame  = CGRect(x: 0, y: -offset, width: width/2, height: width/4 + offset)
        layer5.colors = [UIColor.hex(0xFD682D).cgColor, UIColor.hex(0xFD5830).cgColor]
        layer5.startPoint = CGPoint(x: 0, y: 1)
        layer5.endPoint   = CGPoint(x: 0.9, y: 0)
        gradientLayer.addSublayer(layer5)
        return gradientLayer
    }

    // MARK: Event

    @objc private func clickEvent(_ tap: UITapGestureRecognizer) {
        self.delegate?.clickSexangleView(self)
    }

    // MARK: Tools
    /// 获取外边框填充颜色
    func getOutSideColor() -> UIColor {
        switch self.model.status {
        case .uniteUnstart, .uniteIngProgressZero:
            return self.isExtension ? UIColor.hex(0xE5DDD7) : UIColor.hex(0xE5DDD7)
        case .uniteIng:
            return self.isExtension ? UIColor.hex(0xF5F5F5) : UIColor.hex(0xF5F5F5)
        case .uniteEnd:
            return self.isExtension ? UIColor.hex(0xFFE1B3) : UIColor.hex(0xFFE1B3)
        }
    }

    /// 获取内部填充颜色
    func getInSideFillColor() -> UIColor {
        switch self.model.status {
        case .uniteUnstart, .uniteIngProgressZero:
            return self.isExtension ? UIColor.hex(0xE5DDD7) : UIColor.hex(0xE5DDD7)
        case .uniteIng:
            return self.isExtension ? UIColor.hex(0xFFE9C7) : UIColor.hex(0xFFE9C7)
        case .uniteEnd:
            return self.isExtension ? UIColor.hex(0xFFE1B3) : UIColor.hex(0xFFE9C7)
        }
    }

    /// 获取文字颜色
    func getTitleColor() -> UIColor {
        switch self.model.status {
        case .uniteUnstart, .uniteIngProgressZero:
            return self.isExtension ? UIColor.hex(0xB78F58) : UIColor.hex(0xB78F58)
        case .uniteIng:
            return self.isExtension ? UIColor.hex(0xE38B03) : UIColor.hex(0xFB6617)
        case .uniteEnd:
            return self.isExtension ? UIColor.hex(0xE38B03) : UIColor.hex(0xB78F58)
        }
    }

}
