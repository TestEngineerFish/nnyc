//
//  YXUnitMapView.swift
//  YXEDU
//
//  Created by 沙庭宇 on 2020/3/27.
//  Copyright © 2020 shiji. All rights reserved.
//

import UIKit

class YXUnitMapView: UIView {
    
    var unitModelList  = [YXLearnMapUnitModel]()
    var unitPointList  = [CGPoint]()
    var offsetUnit     = 0 /// 偏移的单元数量
    var showUnitNumber = 0 /// 需要显示的单元数量
    var currentUnitIndex: Int /// 当前单元下标
    
    var avatarPinView: YXAvatarPinView?

    init(unitModelList: [YXLearnMapUnitModel], currentUnitIndex: Int, moveNext: Bool, frame: CGRect) {
        self.unitModelList    = unitModelList
        self.currentUnitIndex = currentUnitIndex
        super.init(frame: frame)
        self.createSubviews()
        self.bindProperty()
        if moveNext {
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) { [weak self] in
                guard let self = self else { return }
                if (self.currentUnitIndex - self.offsetUnit) < self.showUnitNumber {
                    self.moveToNextUnit()
                    if currentUnitIndex < unitModelList.count {
                        let model = unitModelList[currentUnitIndex]
                        self.learnUnit(model.unitID, bookId: model.bookID)
                    }
                }
            }
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func bindProperty() {
        self.backgroundColor = UIColor.white
        self.layer.cornerRadius = AdaptSize(6)
        self.layer.setDefaultShadow()
    }
    
    private func createSubviews() {
        self.setUnitPointList()
        self.drawLine()
        self.addUnitView()
        if self.offsetUnit > 0 {
            self.setStartShadow()
        }
        if self.unitModelList.count - self.offsetUnit - self.showUnitNumber > 0 {
            self.setEndShadow()
        }
        self.setPinView()
    }
    
    /// 设置单元位置
    private func setUnitPointList() {
        self.unitPointList.removeAll()
        let startPoint    = CGPoint(x: self.width - AdaptSize(55), y: self.height)
        let firstPoint    = CGPoint(x: self.width - AdaptSize(94), y: self.height - AdaptSize(36))
        let secondPoint   = CGPoint(x: firstPoint.x - AdaptSize(70), y: firstPoint.y)
        let thirdPoint    = CGPoint(x: secondPoint.x - AdaptSize(70), y: firstPoint.y)
        let fourthlyPoint = CGPoint(x: thirdPoint.x, y: AdaptSize(66))
        let fifthlyPoint  = CGPoint(x: secondPoint.x, y: fourthlyPoint.y)
        let sixthPoint    = CGPoint(x: firstPoint.x, y: fourthlyPoint.y)
        let endPoint      = CGPoint(x: startPoint.x, y: 0)
        self.unitPointList.append(startPoint)
        self.unitPointList.append(firstPoint)
        self.unitPointList.append(secondPoint)
        self.unitPointList.append(thirdPoint)
        self.unitPointList.append(fourthlyPoint)
        self.unitPointList.append(fifthlyPoint)
        self.unitPointList.append(sixthPoint)
        self.unitPointList.append(endPoint)
    }
    
    /// 绘制线路
    private func drawLine() {
        let path = UIBezierPath()
        path.move(to: unitPointList[0])
        path.addQuadCurve(to: unitPointList[1], controlPoint: CGPoint(x: unitPointList[0].x, y: self.unitPointList[1].y))
        path.addLine(to: unitPointList[3])
        path.addCurve(to: unitPointList[4], controlPoint1: CGPoint(x: unitPointList[3].x - AdaptSize(61), y: unitPointList[3].y), controlPoint2: CGPoint(x: unitPointList[4].x - AdaptSize(61), y: unitPointList[4].y))
        path.addLine(to: unitPointList[6])
        path.addQuadCurve(to: CGPoint(x: unitPointList[7].x, y: unitPointList[7].y + AdaptSize(15)), controlPoint: CGPoint(x: unitPointList[7].x, y: unitPointList[6].y))
        path.addLine(to: unitPointList[7])
        
        let mapLayer = CAShapeLayer()
        mapLayer.frame       = self.bounds
        mapLayer.path        = path.cgPath
        mapLayer.lineWidth   = AdaptSize(10)
        mapLayer.fillColor   = nil
        mapLayer.strokeColor = UIColor.hex(0xE8DACC).cgColor
        self.layer.addSublayer(mapLayer)
    }
    
    /// 添加单元站点
    private func addUnitView() {
        self.offsetUnit = {
            if self.currentUnitIndex >= 6 && self.unitModelList.count > 6 {
                return ((self.currentUnitIndex / 3) - 1) * 3
            } else {
                return 0
            }
        }()
        
        self.showUnitNumber = {
            if offsetUnit > 0 {
                if ((self.currentUnitIndex / 3) + 1) * 3 > self.unitModelList.count {
                    return self.unitModelList.count % 3 + 3
                } else {
                    return 6
                }
            } else {
                return self.unitModelList.count > 6 ? 6 : self.unitModelList.count
            }
        }()
        
        for (index, center) in self.unitPointList.enumerated() {
            if index == 0 || index == self.unitPointList.count - 1 {
                continue
            }
            if index <= showUnitNumber {
                let unitView = self.createUnitLayer(center, index: index)
                self.addSubview(unitView)
            }
        }
    }
    
    /// 创建一个单元站点视图
    private func createUnitLayer(_ center: CGPoint, index: Int) -> UIView {
        let unitView = UIView()
        let unit     = self.offsetUnit + index
        let label = UILabel()
        if unit == self.currentUnitIndex  {
            label.textColor   = UIColor.orange1
            label.font        = UIFont.semiboldFont(ofSize: AdaptFontSize(15))
        } else {
            label.textColor   = UIColor.hex(0xDBC4AD)
            label.font        = UIFont.mediumFont(ofSize: AdaptFontSize(13))
        }
        label.text  = {
            if unit <= self.unitModelList.count {
                return self.unitModelList[unit - 1].unitName ?? ""
            }
            return ""
        }()
        label.sizeToFit()
        label.frame = CGRect(x: 0, y: AdaptSize(25), width: label.width, height: label.height)
        
        unitView.addSubview(label)
        
        let outsideLayer = CALayer()
        outsideLayer.frame           = CGRect(x: (label.width / 2) - AdaptSize(11), y: 0, width: AdaptSize(22), height: AdaptSize(22))
        outsideLayer.backgroundColor = UIColor.hex(0xE8DACC).cgColor
        outsideLayer.cornerRadius    = AdaptSize(11)
        
        let insideLayer = CALayer()
        insideLayer.frame           = CGRect(x: AdaptSize(5), y: AdaptSize(5), width: AdaptSize(12), height: AdaptSize(12))
        insideLayer.backgroundColor = UIColor.white.cgColor
        insideLayer.setDefaultShadow()
        insideLayer.cornerRadius    = AdaptSize(6)
        
        outsideLayer.addSublayer(insideLayer)
        unitView.layer.addSublayer(outsideLayer)
        
        unitView.frame  = CGRect(x: center.x - (label.width / 2), y: center.y - AdaptSize(11), width: label.width, height: AdaptSize(43))
        return unitView
    }
    
     /// 添加头像图钉
    private func setPinView() {
        let pinPoint = self.unitPointList[self.currentUnitIndex - self.offsetUnit]
        let pinFrame = CGRect(x: pinPoint.x - AdaptSize(18), y: pinPoint.y - AdaptSize(10), width: AdaptSize(36), height: AdaptSize(42))
        self.avatarPinView = YXAvatarPinView(isSmallMap: true, frame: pinFrame)
        self.addSubview(avatarPinView!)
    }
    
    /// 设置入口路径阴影
    private func setStartShadow() {
        guard let startPoint = self.unitPointList.first else {
            return
        }
        let startSize = CGSize(width:  AdaptSize(76), height: AdaptSize(30))
        let startView = UIView(frame: CGRect(x: startPoint.x - startSize.width / 2, y: self.height - startSize.height, width: startSize.width, height: startSize.height))
        startView.backgroundColor = UIColor.gradientColor(with: startSize, colors: [UIColor.white.withAlphaComponent(0.0), UIColor.white], direction: .vertical)
        self.addSubview(startView)
    }
    
    /// 设置结束路径阴影
    private func setEndShadow() {
        guard let endPoint = self.unitPointList.last else {
            return
        }
        let endSize = CGSize(width: AdaptSize(76), height: AdaptSize(58))
        let endView = UIView(frame: CGRect(x: endPoint.x - endSize.width / 2, y: 0, width: endSize.width, height: endSize.height))
        endView.backgroundColor = UIColor.gradientColor(with: endSize, colors: [UIColor.white, UIColor.white.withAlphaComponent(0.0)], direction: .vertical)
        self.addSubview(endView)
    }
    
    /// 移动到下个单元
    private func moveToNextUnit() {
        let currentIndex = self.currentUnitIndex - self.offsetUnit
        guard let _pinView = self.avatarPinView else { return }
        let currentUnitPoint = self.unitPointList[currentIndex]
        let nextUnitPoint    = self.unitPointList[currentIndex + 1]
        let path = UIBezierPath()
        var duration: Double = 0
        // 往上移动
        if nextUnitPoint.y < currentUnitPoint.y {
            path.move(to: CGPoint(x: currentUnitPoint.x, y: currentUnitPoint.y + AdaptSize(21) - AdaptSize(10)))
            path.addLine(to: CGPoint(x: currentUnitPoint.x, y: currentUnitPoint.y + AdaptSize(23)))
            path.addCurve(to: CGPoint(x: unitPointList[4].x, y: unitPointList[4].y + AdaptSize(23)), controlPoint1: CGPoint(x: unitPointList[3].x - AdaptSize(61), y: unitPointList[3].y + AdaptSize(23)), controlPoint2: CGPoint(x: unitPointList[4].x - AdaptSize(61), y: unitPointList[4].y + AdaptSize(23) - AdaptSize(10)))
            path.addLine(to: CGPoint(x: unitPointList[4].x, y: unitPointList[4].y + AdaptSize(21) - AdaptSize(10)))
            duration = 1.5
        } else {
            path.move(to: CGPoint(x: currentUnitPoint.x, y: currentUnitPoint.y + AdaptSize(21) - AdaptSize(10)))
            path.addLine(to: CGPoint(x: currentUnitPoint.x, y: currentUnitPoint.y + AdaptSize(23)))
            path.addLine(to: CGPoint(x: nextUnitPoint.x, y: nextUnitPoint.y + AdaptSize(23)))
            path.addLine(to: CGPoint(x: nextUnitPoint.x, y: nextUnitPoint.y + AdaptSize(21) - AdaptSize(10)))
            duration = 0.75
        }
        let animation = CAKeyframeAnimation(keyPath: "position")
        animation.path     = path.cgPath
        animation.duration = duration
        animation.fillMode = .forwards
        animation.isRemovedOnCompletion = false
        _pinView.layer.add(animation, forKey: nil)
    }

    // MARK: ---- Request ----
    /// 学习新单元
    private func learnUnit(_ unitId: Int?, bookId: Int?) {
        guard let uuidStr = YXUserModel.default.uuid, let _unitId = unitId, let _bookId = bookId else {
            return
        }
        let request = YXExerciseRequest.addUserBook(userId: uuidStr, bookId: _bookId, unitId: _unitId)
        YYNetworkService.default.request(YYStructResponse<YXLearnResultModel>.self, request: request, success: { (response) in
            YXLog("学习新单元成功")
        }) { (error) in
            YXUtils.showHUD(kWindow, title: error.message)
        }
    }
}

