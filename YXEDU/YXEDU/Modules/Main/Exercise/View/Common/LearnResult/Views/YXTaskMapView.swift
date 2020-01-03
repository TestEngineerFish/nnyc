//
//  YXTaskMapView.swift
//  BaseProject
//
//  Created by 沙庭宇 on 2019/11/9.
//  Copyright © 2019 沙庭宇. All rights reserved.
//

import UIKit

class YXTaskMapView: UIView, YXSexangleViewClickProcotol {

    let modelArray: [YXLearnMapUnitModel]
    var unitViewArray = [UIView]()
    var unitPointArray = [CGPoint]()
    var avatarPinView: YXAvatarPinView?
    var currentModel: YXLearnMapUnitModel?

    var learnNewUnit:((Int?)->Void)?

    init(_ modelArray: [YXLearnMapUnitModel], frame: CGRect, currentModel: YXLearnMapUnitModel?) {
        self.modelArray = modelArray
        self.currentModel = currentModel
        super.init(frame: frame)
        self.createSubviews()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func createSubviews() {

        let startPoint   = CGPoint(x: self.width*0.5, y: self.height)
        let endPoint     = CGPoint(x: self.width*0.45, y: 0)
        let controlPoint = CGPoint(x: self.width*0.6, y: self.height*0.6)
        
        // 路径
        let path = UIBezierPath()
        path.move(to: startPoint)
        path.addQuadCurve(to: endPoint, controlPoint: controlPoint)
        let shapLayer = CAShapeLayer()
        shapLayer.path        = path.cgPath
        shapLayer.lineWidth   = 10
        shapLayer.strokeColor = UIColor.hex(0xE5DDD7).cgColor
        shapLayer.fillColor   = nil
        shapLayer.strokeEnd   = CGFloat(self.modelArray.count)/3
        self.layer.addSublayer(shapLayer)

        // 设置点
        let currentX = YXTools.getAngleX(t: 3/4, p0: startPoint, c: controlPoint, p1: endPoint)
        let currentY = self.height/4*3
        let nextX    = YXTools.getAngleX(t: 1/4, p0: startPoint, c: controlPoint, p1: endPoint)
        let nextY    = self.height/4*1
        self.unitPointArray.append(CGPoint(x: currentX, y: currentY))
        self.unitPointArray.append(CGPoint(x: nextX, y: nextY))

        self.setUnitView()
        self.addHillView()
        self.addTipsView()
    }

    /// 添加单元图形
    private func setUnitView() {
        for (index, point) in self.unitPointArray.enumerated() {
            if index < self.modelArray.count {
                let model = self.modelArray[index]
                let isShowProgress = model.unitID == self.currentModel?.unitID
                let sexangleView = YXSexangleView(model, isExtension: false, isShowProgress: isShowProgress)
                sexangleView.tag = index
                sexangleView.center = point
                sexangleView.delegate = self
                self.insertSubview(sexangleView, at: 1)
                self.unitViewArray.append(sexangleView)
                // 如果是当前学习的单元,则添加小图钉头像
                if model.unitID == self.currentModel?.unitID {
                    self.addAvatarPinView(sexangleView)
                }
            }
        }
        guard let currentModel = self.currentModel, let nextView = self.unitViewArray.last else {
            return
        }
        if currentModel.stars > 1 {
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 1.5) {
                self.movePinView(to: nextView)
            }
        }
    }

    /// 添加小山
    private func addHillView() {
        let hillLeft = UIImageView(image: UIImage(named: "learnResultCardBackground"))
        self.addSubview(hillLeft)
        hillLeft.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
    }
    
    /// 添加提示气泡
    private func addTipsView() {
        guard let currentModel = self.currentModel else {
            return
        }
        let bubbleImageView = UIImageView(image: UIImage(named: "bubble"))
        let bubbleSize = CGSize(width: AdaptSize(170), height: AdaptSize(60))
        bubbleImageView.size = bubbleSize
        let label = UILabel()
        label.text = {
            if currentModel.stars > 0 {
                return "有些单词还掌握的不太好呢,再练习一下吧～"
            } else if currentModel.stars > 1 {
                return "厉害~再巩固一下就冲向三星了哦！"
            } else if currentModel.stars > 2 {
                if currentModel.ext == nil {
                    return "您可以进入下一个单元进行学习哦！"
                } else {
                    return "来试试拓展单元吧，可以学到更多有用的词汇哦~"
                }
            } else {
                return "学得不错，继续学习就 可以推进这个单元的进度哦~"
            }
        }()
        label.textColor = UIColor.white
        label.font = UIFont.semiboldFont(ofSize: AdaptSize(12))
        label.numberOfLines = 2
        label.textAlignment = .center
        bubbleImageView.addSubview(label)
        label.snp.makeConstraints { (make) in
            make.left.equalToSuperview().offset(AdaptSize(15))
            make.right.equalToSuperview().offset(AdaptSize(-15))
            make.height.equalTo(AdaptSize(36))
            make.top.equalToSuperview().offset(AdaptSize(8))
        }
        self.addSubview(bubbleImageView)
        bubbleImageView.snp.makeConstraints { (make) in
            make.top.equalToSuperview().offset(AdaptSize(-40))
            make.right.equalToSuperview().offset(AdaptSize(20))
            make.size.equalTo(bubbleSize)
        }
    }

    /// 添加图钉头像
    private func addAvatarPinView(_ view: UIView) {
        // 创建用户头像
        self.avatarPinView = YXAvatarPinView()
        self.movePinView(to: view, animation: false)
        self.addSubview(avatarPinView!)
    }

    /// 移动到对应单元视图
    private func movePinView(to unitView: UIView, animation: Bool = true) {
        let targetFrame = CGRect(x: unitView.frame.midX - AdaptSize(15), y: unitView.frame.minY - AdaptSize(5), width: AdaptSize(30), height: AdaptSize(30))
        if animation {
            UIView.animate(withDuration: 0.5) {
                self.avatarPinView?.frame = targetFrame
            }
        } else {
            avatarPinView?.frame = targetFrame
        }
        if unitView.tag < self.modelArray.count {
            let model = self.modelArray[unitView.tag]
            self.currentModel = model
            self.learnNewUnit?(model.unitID)
        }

    }

    // MARK: YXSexangleViewClickProcotol
    func clickSexangleView(_ view: YXSexangleView) {
        if view.model.unitID == self.currentModel?.unitID {
            return
        }
        if self.currentModel?.status == .some(.uniteIng) {
            let currentUnitName = self.currentModel?.unitName ?? ""
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
