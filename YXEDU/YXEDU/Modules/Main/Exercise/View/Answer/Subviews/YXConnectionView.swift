//
//  YXConnectionView.swift
//  YXEDU
//
//  Created by sunwu on 2019/11/4.
//  Copyright © 2019 shiji. All rights reserved.
//

import UIKit


class YXConnectionView: UIView {
    
    var connectionCompletion: (() -> ())?
    
    struct Config {
        static let itemLeft: CGFloat = 24
        static let interval: CGFloat = 34
        
        static let itemWidth: CGFloat = 120
        static let itemHeight: CGFloat = 30
        
    }
    
    var exerciseModel: YXWordExerciseModel? {
        didSet {
            bindData()
        }
    }

    
    var questionArray: [String] = []
    var answerArray: [String] = []
    
    private var leftItemArray: [YXConnectionItemView] = []
    private var rightItemArray: [YXConnectionItemView] = []
    
    private var rightLayerArray: [CAShapeLayer] = []
    private var wrongLayerArray: [CAShapeLayer] = []
    
    private var startItemView: YXConnectionItemView?
    
    private var path: UIBezierPath = UIBezierPath()
    private var movingPoint: CGPoint?
    private var shapeLayer: CAShapeLayer?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = UIColor.black5.withAlphaComponent(0.2)
        self.addGesture()
        self.clipsToBounds = true
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }


    func createSubview() {
            
        for (index, title) in questionArray.enumerated() {
            
            let y = (Config.itemHeight + Config.interval) * CGFloat(index)
            let ivFrame = CGRect(x: left, y: y, width: Config.itemWidth, height: Config.itemHeight)
            
            let itemView = YXConnectionItemView(frame: ivFrame)
            itemView.itemTitle = title
            itemView.index = index
            itemView.itemType = .left
            itemView.itemStatus = .normal
            itemView.clickEvent = {[weak self] (index, type) in
                self?.itemEvent(index: index, type: type)
            }

            leftItemArray.append(itemView)
            self.addSubview(itemView)
        }
                
        for (index, title) in answerArray.enumerated() {
            
            let x = self.width - Config.itemWidth
            let y = (Config.itemHeight + Config.interval) * CGFloat(index)
            let ivFrame = CGRect(x: x , y: y, width: Config.itemWidth, height: Config.itemHeight)
            
            let itemView = YXConnectionItemView(frame: ivFrame)
            itemView.itemTitle = title
            itemView.index = index
            itemView.itemType = .right
            itemView.itemStatus = .normal
            itemView.clickEvent = {[weak self] (index, type) in
                self?.itemEvent(index: index, type: type)
            }
            
            rightItemArray.append(itemView)
            self.addSubview(itemView)
        }
        
    }
    
    func bindData() {
        self.processData()
        self.createSubview()
    }

    
    func processData() {
        if let items = exerciseModel?.option?.firstItems {
            for item in items {
                questionArray.append(item.content ?? "")
            }
        }
        
        if let items = exerciseModel?.option?.secondItems {
            for item in items {
                answerArray.append(item.content ?? "")
            }
        }
    }
}


//MARK: - 处理点击事件相关的
extension YXConnectionView {
    private func itemEvent(index: Int, type: YXConnectionItemType) {
        if type == .left {
            self.leftItemEvent(index: index )
        } else {
            self.rightItemEvent(index: index)
        }
    }
    
    
    private func leftItemEvent(index: Int) {
        if isSelected(type: .right) { // 连线
            self.selectItem(index: index, type: .left)
            self.drawLineProcess()
        } else {
            self.selectItem(index: index, type: .left)
            self.startItemView = self.leftItemArray[index]
        }
    }
    
    private func rightItemEvent(index: Int) {
        if isSelected(type: .left) { // 连线
            self.selectItem(index: index, type: .right)
            self.drawLineProcess()
        } else {
            self.selectItem(index: index, type: .right)
            self.startItemView = self.rightItemArray[index]
        }
    }
    
    
    /// 是否有选中的
    /// - Parameter type: 类型
    private func isSelected(type: YXConnectionItemType) -> Bool {
        return selectedIndex(type: type) > -1
    }
    
    /// 选中的下标
    private func selectedIndex(type: YXConnectionItemType) -> Int {
        let itemArray = (type == .left) ? leftItemArray : rightItemArray
        for (index, itemView) in itemArray.enumerated() {
            if itemView.itemStatus == .selected {
                return index
            }
        }
        return -1
    }
    
    
    /// 选中一个 Item
    /// - Parameter index: 下标
    /// - Parameter type: 类型
    private func selectItem(index: Int, type: YXConnectionItemType) {
        let itemArray = (type == .left) ? leftItemArray : rightItemArray
        for itemView in itemArray {
            if itemView.itemStatus != .end {
                itemView.itemStatus = .normal
            }
        }
        itemArray[index].itemStatus = .selected
    }
    
    
    /// 选中的左右项
    private func leftAndRightItems() -> (YXConnectionItemView, YXConnectionItemView) {
        let leftItem = self.leftItemArray[selectedIndex(type: .left)]
        let rightItem = self.rightItemArray[selectedIndex(type: .right)]
        return (leftItem, rightItem)
    }
    
    
    
    /// 连接是否正确
    private func isConnectionRight() -> Bool {
        return false
    }
    
    
    private func processConnectionCompletion() {
        var count = 0
        let itemArray = leftItemArray + rightItemArray
        for itemView in itemArray {
            if itemView.itemStatus == .end {
                count += 1
            }
        }
        
        if itemArray.count == count {
            self.connectionCompletion?()
            print("全部连接完毕")
        }
        
    }
}


//MARK: - 处理手势滑动事件相关
extension YXConnectionView {
    private func addGesture() {
        let pan = UIPanGestureRecognizer()
        pan.addTarget(self, action: #selector(gestureEvent(gesture:)))
        self.addGestureRecognizer(pan)
    }

    
    /// 手势事件
    /// - Parameter gesture:
    @objc private func gestureEvent(gesture: UIPanGestureRecognizer) {
        let point = gesture.location(in: self)
        if gesture.state == .began {
            self.gestureBegan(point: point)
        } else if gesture.state == .changed {
            self.gestureMoved(point: point)
        } else if gesture.state == .ended {
            self.gestureEnd(point: point)
        }
    }
    
    
    /// 手势开始
    /// - Parameter point: 位置
    private func gestureBegan(point: CGPoint) {
        if !self.bounds.contains(point) {
            print("跑到画板外面去啦————开始")
            return
        }
        print(point)
        self.selecteGestureStartItemView(point: point)
    }
    
    /// 手势移动，在屏幕上滑动
    /// - Parameter point: 位置
    private func gestureMoved(point: CGPoint) {
//        if !self.bounds.contains(point) {
//            print("跑到画板外面去啦————移动中")
//            return
//        }

        if let itemView = startItemView, let startPoint = self.startItemView?.locationPoint {// 动态画线
            self.shapeLayer?.removeFromSuperlayer()
            if itemView.frame.contains(point) == false {// 起始item 内不用画线
                self.shapeLayer = self.drawLine(status: .selected, start: startPoint, end: point)
            }
        } else {// 没有开始位置，设置一个
            self.selecteGestureStartItemView(point: point)
        }
    }
        
    /// 手势结束，松开手指
    /// - Parameter point: 位置
    private func gestureEnd(point: CGPoint) {
//        if !self.bounds.contains(point) {
//            print("跑到画板外面去啦————结束")
//            return
//        }
        
        if let _startItemView = self.startItemView,
            let itemView = gestureItemView(point: point),
            itemView.itemType != _startItemView.itemType,
            itemView.itemStatus != .end {
            
            self.shapeLayer?.removeFromSuperlayer()
            self.startItemView = nil
            
            itemView.itemStatus = .selected
            self.drawLineProcess()
        } else {// 清除掉
//            self.startItemView?.itemStatus = .normal
//            self.startItemView = nil
            self.shapeLayer?.removeFromSuperlayer()
        }

    }
    
    
    /// 手势滑动时，选中起始 Item
    /// - Parameter point: 位置
    private func selecteGestureStartItemView(point: CGPoint) {
        guard let itemView = gestureItemView(point: point) else {
            return
        }
        if itemView.itemStatus == .end {
            return
        }
        self.startItemView = itemView
        selectItem(index: itemView.index, type: itemView.itemType)
    }
    
    private func gestureItemView(point: CGPoint) -> YXConnectionItemView? {
        let itemArray = leftItemArray + rightItemArray
        for itemView in itemArray {
            
            if itemView.frame.contains(point) {
                return itemView
            }
        }
        
        return nil
    }
}



//MARK: - 处理连线画图相关
extension YXConnectionView {

    private func drawLineProcess() {
        
        
        let selectedItems = self.leftAndRightItems()
        let start = selectedItems.0.locationPoint
        let end = selectedItems.1.locationPoint
        
        // 第一次画黑线
        var shapeLayer = self.drawLine(status: .selected, start: start, end: end)
        
        if isConnectionRight() {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.25) { [weak self] in
                guard let self = self else { return }
                shapeLayer.removeFromSuperlayer()
                
                selectedItems.0.itemStatus = .right
                selectedItems.1.itemStatus = .right
                
                // 第二次画绿线
                shapeLayer = self.drawLine(status: .right, start: start, end: end)
                
//                let CABasicAnimation
                
                
                
                
                
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.6) {
                    shapeLayer.removeFromSuperlayer()
                    
                    selectedItems.0.itemStatus = .end
                    selectedItems.1.itemStatus = .end
                    
                    // 第三次画完成线
                    shapeLayer = self.drawLine(status: .end, start: start, end: end)
                    
                    // 做题完成
                    self.processConnectionCompletion()
                }
                
            }
            
            
        } else {

            DispatchQueue.main.asyncAfter(deadline: .now() + 0.35) { [weak self] in
                guard let self = self else { return }
                shapeLayer.removeFromSuperlayer()
                
                selectedItems.0.itemStatus = .wrong
                selectedItems.1.itemStatus = .wrong
                
                // 第二次画红线
                shapeLayer = self.drawLine(status: .wrong, start: start, end: end)
                
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                    shapeLayer.removeFromSuperlayer()
                    selectedItems.0.itemStatus = .normal
                    selectedItems.1.itemStatus = .normal
                }
            }
        }
        
        
    }
    private func drawLine(status: YXConnectionItemStatus, start: CGPoint, end: CGPoint) -> CAShapeLayer{
        let path = UIBezierPath()
        path.move(to: start)
        path.addLine(to: end)
        
        let shapeLayer = CAShapeLayer()
        shapeLayer.lineWidth = 2
        shapeLayer.lineCap = .round
        shapeLayer.strokeColor = lineColor(status: status).cgColor
        shapeLayer.lineDashPattern = [4, 6]
                
        shapeLayer.path = path.cgPath
        shapeLayer.frame = self.bounds
        
        self.layer.addSublayer(shapeLayer)
        return shapeLayer
    }

    
    private func lineColor(status: YXConnectionItemStatus) -> UIColor {
        var lineColor = UIColor.black1
        switch status {
        case .selected:
            lineColor = UIColor.black1
        case .right:
            lineColor = UIColor.green
        case .wrong:
            lineColor = UIColor.red1
        case .end:
            lineColor = UIColor.black3
        default:
            lineColor = UIColor.black1
        }
        return lineColor
    }
    
    
}
