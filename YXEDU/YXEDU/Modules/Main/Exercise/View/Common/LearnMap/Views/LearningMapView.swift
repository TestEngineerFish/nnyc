//
//  LearningPathView.swift
//  BaseProject
//
//  Created by 沙庭宇 on 2019/10/30.
//  Copyright © 2019 沙庭宇. All rights reserved.
//

import UIKit

class LearningMapView: UIScrollView, YXSexangleViewClickProcotol {

    var modelArray: [YXLearnMapUnitModel]
    var avatarPinView: YXAvatarPinView?
    var learnButton: UIButton = {
        let button = UIButton()
        button.setTitle("开始复习", for: .normal)
        button.setTitleColor(UIColor.white, for: .normal)
        button.layer.cornerRadius = AdaptIconSize(14)
        button.titleLabel?.font = UIFont.mediumFont(ofSize: AdaptFontSize(13))
        button.size = CGSize(width: AdaptIconSize(89), height: AdaptIconSize(28))
        button.backgroundColor = UIColor.gradientColor(with: button.size, colors: [UIColor.hex(0xFFBE34), UIColor.hex(0xFF790C)], direction: .vertical)
        button.isHidden = true
        return button
    }()
//    var learnNewUnit:((Int?)->Void)?
    var currentUnitId: Int?
    // 间距
    let margin = AdaptIconSize(130)
    // 弧线数量
    var sectorAmount: Int
    // 单元格数量
    var unitAmount: Int
    // 一个扇形上默认显示4个单元
    let sectorUnits = CGFloat(3)
    // 路径底部开始坐标
    var startPoint = CGPoint.zero
    // 控制点偏移量
    let centerOffset = AdaptIconSize(60)
    // 单元坐标数组,从低到高
    var unitPointArray = [CGPoint]()
    // 单元视图数组,从低到高
    var unitViewArray = [YXSexangleView]()
    var currentUnitView: YXSexangleView?
    // 路径
    let proShapeLayer = CAShapeLayer()

    init(units modelArray: [YXLearnMapUnitModel], frame: CGRect, unitId: Int?) {
        self.modelArray    = modelArray
        self.currentUnitId = unitId
        let tmpAmount      = modelArray.count - 1
        sectorAmount       = tmpAmount / Int(sectorUnits)
        if tmpAmount % Int(sectorUnits) > 0 {
            sectorAmount += 1
        }
        unitAmount = modelArray.count
        super.init(frame: frame)
        let h = margin * CGFloat(unitAmount) + kNavHeight + kSafeBottomMargin
        self.contentSize          = CGSize(width: frame.width, height: h)
        self.alwaysBounceVertical = true
        self.backgroundColor      = UIColor.clear
        self.scrollsToTop         = false
        self.showsVerticalScrollIndicator   = false
        self.showsHorizontalScrollIndicator = false
        self.createSubview()
        // 获得当前学习单元对象
        for (index, model) in self.modelArray.enumerated() {
            // 默认获取第一个学习中的单元
            if model.unitID == unitId && index < self.unitViewArray.count {
                let unitView = self.unitViewArray[index]
                self.currentUnitView = unitView
                // 创建用户头像
                self.avatarPinView = YXAvatarPinView(frame: CGRect.zero)
                self.movePinView(to: unitView, animation: false)
                self.addSubview(avatarPinView!)
            }
        }
        if self.contentSize.height > self.frame.height {
            var offsetY = (self.currentUnitView?.frame.midY ?? 0) - self.frame.height/2
            offsetY = offsetY < 0 ? 0 : offsetY
            offsetY = offsetY + self.frame.height > self.contentSize.height ? self.contentSize.height - self.frame.height : offsetY
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.5) {
                self.setContentOffset(CGPoint(x: 0, y: offsetY), animated: true)
            }
        }
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func createSubview() {
        self.setLayerPath()
        self.setUnitView()
        self.addSubview(learnButton)
    }

    /// 设置路径
    private func setLayerPath() {
        let arcHeight  = sectorUnits * margin
        let stepShort  = margin * 1.5
        let stepLong   = arcHeight - stepShort
        let bezierPath = UIBezierPath()
        startPoint = CGPoint(x: self.contentSize.width/2, y: self.contentSize.height - AdaptIconSize(100))
        bezierPath.move(to: startPoint)
        var p0 = startPoint
        var c  = CGPoint(x: self.contentSize.width/2 + centerOffset, y: startPoint.y - stepShort)
        var p1 = CGPoint(x: startPoint.x, y: startPoint.y - sectorUnits * margin)
        // 默认添加初始坐标
        self.unitPointArray = [startPoint]
        for index in 0..<sectorAmount {
            self.appendPoints(p0: p0, c: c, p1: p1)
            bezierPath.addQuadCurve(to: p1, controlPoint: c)
            p0 = p1
            c.y -= index % 2 > 0 ? stepShort * 2 : stepLong * 2
            c.x = index % 2 > 0 ? self.contentSize.width/2 + centerOffset : self.contentSize.width/2 - centerOffset
            p1.y -= arcHeight
        }
        let totalLength = CGFloat(sectorAmount) * sectorUnits + 1
        let scaleValue  = CGFloat(self.unitAmount) / totalLength
        proShapeLayer.path        = bezierPath.cgPath
        proShapeLayer.lineWidth   = AdaptIconSize(10)
        proShapeLayer.strokeColor = UIColor.hex(0xE5DDD7).cgColor
        proShapeLayer.strokeStart = 0.0
        proShapeLayer.strokeEnd   = scaleValue
        proShapeLayer.fillColor   = nil
        self.layer.addSublayer(proShapeLayer)
    }

    /// 添加单元在路径上的坐标
    private func appendPoints(p0: CGPoint, c: CGPoint, p1: CGPoint) {
        for index in 1...3 {
            if self.unitPointArray.count >= self.unitAmount {
                return
            }
            let scale = 1/3 * Float(index)
            let x = YXTools.getAngleX(t: scale, p0: p0, c: c, p1: p1)
            let y = self.startPoint.y - CGFloat(self.unitPointArray.count) * margin
            self.unitPointArray.append(CGPoint(x: x, y: y))
        }
    }

    /// 添加单元图形
    private func setUnitView() {
        for (index, point) in self.unitPointArray.enumerated() {
            if index < self.modelArray.count {
                let model = self.modelArray[index]
                let isShowProgress = model.unitID == self.currentUnitId
                let sexangleView = YXSexangleView(model, isExtension: false, isShowProgress: isShowProgress)
                sexangleView.center   = point
                sexangleView.delegate = self
                sexangleView.tag      = index
                self.addSubview(sexangleView)
                self.unitViewArray.append(sexangleView)
            }
        }
    }

    /// 移动到对应单元视图
    private func movePinView(to unitView: YXSexangleView, animation: Bool = true) {
        let targetFrame = CGRect(x: unitView.frame.midX - AdaptIconSize(15), y: unitView.frame.minY - AdaptIconSize(5), width: AdaptIconSize(30), height: AdaptIconSize(30))
        if animation {
            UIView.animate(withDuration: 1) {
                self.avatarPinView?.frame = targetFrame
                // 隐藏进度条
                self.currentUnitView?.hideProgressAnimtion()
                // 替换当前视图
                self.currentUnitView = unitView
                // 显示选中视图的进度条
                unitView.showProgressAnimation()
            }
        } else {
            avatarPinView?.frame = targetFrame
        }
    }

    // MARK: YXSexangleViewClickProcotol

    func clickSexangleView(_ view: YXSexangleView) {
        if view == self.currentUnitView {
            return
        }
        self.showLearnButton(to: view)
    }

    // MARK: ==== Event ====

    private func showLearnButton(to view: YXSexangleView) {
        if learnButton.isHidden {
            self.hideLearnButton()
        }
        learnButton.tag = view.model.unitID ?? 0
        switch view.model.status {
        case .uniteUnstart, .uniteIngProgressZero:
            self.learnButton.setTitle("开始学习", for: .normal)
        case .uniteIng:
            self.learnButton.setTitle("继续学习", for: .normal)
        case .uniteEnd:
            self.learnButton.setTitle("开始复习", for: .normal)
        }
        let center = CGPoint(x: view.frame.midX, y: view.frame.maxY)
        self.learnButton.center = center
        self.learnButton.isHidden = false
        self.learnButton.layer.addJellyAnimation()
    }

    private func hideLearnButton() {
        self.learnButton.isHidden = true
    }

}
