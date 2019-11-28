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
    var learnNewUnit:((Int?)->Void)?
    var currentUnitId: Int?
    // 间距
    let margin = CGFloat(130)
    // 弧线数量
    var sectorAmount: Int
    // 单元格数量
    var unitAmount: Int
    // 一个扇形上默认显示4个单元
    let sectorUnits = CGFloat(3)
    // 路径底部开始坐标
    var startPoint = CGPoint.zero
    // 控制点偏移量
    let centerOffset = CGFloat(60)
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
                self.avatarPinView = YXAvatarPinView()
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
    }

    /// 设置路径
    private func setLayerPath() {
        let arcHeight  = sectorUnits * margin
        let stepShort  = margin * 1.5
        let stepLong   = arcHeight - stepShort
        let bezierPath = UIBezierPath()
        startPoint = CGPoint(x: self.contentSize.width/2, y: self.contentSize.height - 100)
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
        proShapeLayer.lineWidth   = 10
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
        let targetFrame = CGRect(x: unitView.frame.midX - AdaptSize(15), y: unitView.frame.minY - AdaptSize(5), width: AdaptSize(30), height: AdaptSize(30))
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
            if unitView.tag < self.modelArray.count {
                let model = self.modelArray[unitView.tag]
                self.learnNewUnit?(model.unitID)
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
        if self.currentUnitView?.model.status == .some(.uniteIng) || self.currentUnitView?.model.status == .some(.uniteStop) {
            let currentUnitName = self.currentUnitView?.model.unitName ?? ""
            let toUnitName = view.model.unitName ?? ""
            let content = String(format: "当前正在学习 %@,是否切换到 %@?", currentUnitName, toUnitName)
            
            let alertView = YXAlertView()
            alertView.descriptionLabel.text = content
            alertView.doneClosure = { _ in
                self.movePinView(to: view)
            }
            
            alertView.show()
            
        } else {
            self.movePinView(to: view)
        }
    }

}
