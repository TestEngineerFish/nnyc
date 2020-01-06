//
//  YXConnectionView.swift
//  YXEDU
//
//  Created by sunwu on 2019/11/4.
//  Copyright © 2019 shiji. All rights reserved.
//

import UIKit

/// 连线题，选项size大小
protocol YXConnectionItemConfigProtocol {
    var leftItemWidth: CGFloat {get}
    var leftItemHeight: CGFloat {get}
    var leftInterval: CGFloat {get}
    
    var rightItemWidth: CGFloat {get}
    var rightItemHeight: CGFloat {get}
    var rightInterval: CGFloat {get}
    
    var leftPardding: CGFloat {get}
}
extension YXConnectionItemConfigProtocol {
    var leftPardding: CGFloat {return AdaptSize(22)}
}

/// 单词 + 中文
struct YXConnectionWordAndChineseConfig: YXConnectionItemConfigProtocol {
    var leftItemWidth: CGFloat { return AdaptSize(104)}
    var leftItemHeight: CGFloat { return AdaptSize(30)}
    var leftInterval: CGFloat { return AdaptSize(34)}

    var rightItemWidth: CGFloat { return leftItemWidth}
    var rightItemHeight: CGFloat { return leftItemHeight}
    var rightInterval: CGFloat { return leftInterval}
}
/// 单词 + 图片
struct YXConnectionWordAndImageConfig: YXConnectionItemConfigProtocol {
    var leftItemWidth: CGFloat { return AdaptSize(102)}
    var leftItemHeight: CGFloat { return AdaptSize(30)}
    var leftInterval: CGFloat { return AdaptSize(54)}

    var rightItemWidth: CGFloat { return AdaptSize(89)}
    var rightItemHeight: CGFloat { return AdaptSize(59)}
    var rightInterval: CGFloat { return AdaptSize(24)}
}


class YXConnectionView: UIView {
    
    var connectionCompletion: (() -> ())?
    var selectedLeftItemEvent: ((_ status: YXConnectionItemStatus, _ wordId: Int) -> ())?
    var remindEvent: ((_ wordId: Int) -> ())?
    var connectionEvent: ((_ wordId: Int, _ right: Bool, _ finish: Bool) -> ())?
    
    
    var itemConfig: YXConnectionItemConfigProtocol {
        if exerciseModel?.type == .connectionWordAndChinese {
            return YXConnectionWordAndChineseConfig()
        } else {
            return YXConnectionWordAndImageConfig()
        }
    }
    
    
    var exerciseModel: YXWordExerciseModel? {
        didSet { bindData() }
    }

    private var audioPlayerView = YXAudioPlayerView()
    
    private var questionArray: [String] = []
    private var answerArray: [String] = []
    
    private var leftItemArray: [YXConnectionItemView] = []
    private var rightItemArray: [YXConnectionItemView] = []
    
    private var rightLayerArray: [CAShapeLayer] = []
    private var wrongLayerArray: [CAShapeLayer] = []
    
    private var startItemView: YXConnectionItemView?
    
    private var path: UIBezierPath = UIBezierPath()
    private var movingPoint: CGPoint?
    private var shapeLayer: CAShapeLayer?
    
    
    /// 点击后连线状态， 用于防止快速点击时出错, true 连线完毕，false连线中
    private var connectionStatus: Bool = true
    
    init(exerciseModel: YXWordExerciseModel) {
        self.exerciseModel = exerciseModel
        super.init(frame: CGRect.zero)
        self.addGesture()
        self.clipsToBounds = true
        self.backgroundColor = UIColor.clear
        
        self.audioPlayerView.isHidden = true
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func createSubview() {
        self.addSubview(audioPlayerView)
        
        self.createLeftItems()
        self.createRightItems()
    }
    
    func createLeftItems() {
        var y = (itemConfig.rightItemHeight - itemConfig.leftItemHeight)/2
        for (index, title) in questionArray.enumerated() {
            
            let itemView = YXConnectionItemView()
            itemView.index         = index
            itemView.itemType      = .left
            itemView.rightItemType = .text
            itemView.itemStatus    = .normal
            itemView.itemTitle     = title
            itemView.itemModel     = exerciseModel?.option?.firstItems?[index]
            itemView.clickEvent    = {[weak self] (index, type) in
                self?.itemEvent(index: index, type: type)
            }
            itemView.layer.masksToBounds = true
            itemView.layer.cornerRadius = itemConfig.leftItemHeight/2
            leftItemArray.append(itemView)
            self.addSubview(itemView)
            itemView.snp.makeConstraints { (make) in
                make.left.equalTo(AdaptSize(itemConfig.leftPardding))
                make.top.equalToSuperview().offset(y)
                make.width.equalTo(itemConfig.leftItemWidth)
                make.height.equalTo(itemConfig.leftItemHeight)
            }
            y += itemConfig.leftItemHeight + itemConfig.leftInterval
        }
    }
    
    func createRightItems() {
        var y = CGFloat.zero
        for (index, title) in answerArray.enumerated() {
            let itemView = YXConnectionItemView()
            itemView.index         = index
            itemView.itemType      = .right
            itemView.rightItemType = (exerciseModel?.type == .connectionWordAndChinese) ? .text : .image
            itemView.itemStatus    = .normal
            itemView.itemTitle     = title
            itemView.itemModel     = exerciseModel?.option?.secondItems?[index]
            itemView.clickEvent    = {[weak self] (index, type) in
                self?.itemEvent(index: index, type: type)
            }
            itemView.layer.masksToBounds = true
            itemView.layer.cornerRadius = itemView.rightItemType == .text ? itemConfig.rightItemHeight/2 : 4
            
            rightItemArray.append(itemView)
            self.addSubview(itemView)

            itemView.snp.makeConstraints { (make) in
                make.right.equalTo(AdaptSize(-itemConfig.leftPardding))
                make.top.equalToSuperview().offset(y)
                make.width.equalTo(itemConfig.rightItemWidth)
                make.height.equalTo(itemConfig.rightItemHeight)
            }
            y += itemConfig.rightItemHeight + itemConfig.rightInterval
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
        
        if connectionStatus == false {
            return
        }
        connectionStatus = false
        
        if type == .left {
            if (leftItemArray[index].itemStatus == .selected) {// 取消左边的选中
                leftItemArray[index].itemStatus = .normal
                self.selectedLeftItemEvent?(.normal, leftItemArray[index].itemModel?.optionId ?? 0)
                self.audioPlayerView.isHidden = true
                self.startItemView = nil
                connectionStatus = true
                return
            }
            self.selectedLeftItemEvent?(.selected, leftItemArray[index].itemModel?.optionId ?? 0)
            
            self.leftItemEvent(index: index )
            self.playAudio(index: index)
        } else {
            
            if (rightItemArray[index].itemStatus == .selected) {// 取消右边的选中
                rightItemArray[index].itemStatus = .normal
                self.startItemView = nil
                connectionStatus = true
                return
            }
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
            connectionStatus = true
        }
    }
    
    private func rightItemEvent(index: Int) {
        if isSelected(type: .left) { // 连线
            self.selectItem(index: index, type: .right)
            self.drawLineProcess()
        } else {
            self.selectItem(index: index, type: .right)
            self.startItemView = self.rightItemArray[index]
            connectionStatus = true
        }
    }
    
    private func playAudio(index: Int) {
        let item = leftItemArray[index]
        self.audioPlayerView.snp.remakeConstraints { (make) in
            make.top.equalTo(item.snp.bottom)
            make.left.equalTo(item.snp.left)
            make.width.equalTo(22)
            make.height.equalTo(22)
        }
        
        let word = YXWordBookDaoImpl().selectWord(wordId: leftItemArray[index].itemModel?.optionId ?? 0)
        self.audioPlayerView.isHidden = false
        self.audioPlayerView.urlStr = word?.voice
        self.audioPlayerView.play()
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
        let selectedItems = self.leftAndRightItems()
        guard let leftId = selectedItems.0.itemModel?.optionId, let rightId = selectedItems.1.itemModel?.optionId, leftId == rightId else {
            return false
        }
        return true
    }
    
    
    private func processConnectionCompletion() -> Bool {
        var count = 0
        let itemArray = leftItemArray + rightItemArray
        for itemView in itemArray {
            if itemView.itemStatus == .end {
                count += 1
            }
        }
        
        if itemArray.count == count {
//            self.connectionCompletion?()
            print("全部连接完毕")
            return true
        }
        return false
        
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
        // 结束时，其实
        if let _startItemView = self.startItemView,
            let itemView = gestureItemView(point: point),
            itemView.itemType != _startItemView.itemType,
            itemView.itemStatus != .end {
            
            // 如果结束时，是左边项，发送左边项选中事件
            if itemView.itemType == .left {
                selectedLeftItemEvent?(.selected, itemView.itemModel?.optionId ?? 0)
            }
            
            self.shapeLayer?.removeFromSuperlayer()
            self.startItemView = nil
            
            itemView.itemStatus = .selected
            self.drawLineProcess()
        } else {// 清除掉
            self.startItemView?.itemStatus = .normal
            self.startItemView = nil
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
        
        // 如果开始是左边项，发送左边项选中事件
        if itemView.itemType == .left {
            selectedLeftItemEvent?(.selected, itemView.itemModel?.optionId ?? 0)
        }
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
        
        self.audioPlayerView.isHidden = true
        
        let selectedItems = self.leftAndRightItems()
        let start = selectedItems.0.locationPoint
        let end = selectedItems.1.locationPoint
        
        // 第一次画黑线
        var shapeLayer = self.drawLine(status: .selected, start: start, end: end)
        
        let right = isConnectionRight()
    
//        self.connectionEvent?(selectedItems.0.itemModel?.optionId ?? 0, right)
        selectedLeftItemEvent?(.normal, selectedItems.0.itemModel?.optionId ?? 0)
        
        if right {
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.25) { [weak self] in
                guard let self = self else { return }
                shapeLayer.removeFromSuperlayer()
                
                selectedItems.0.itemStatus = .right
                selectedItems.1.itemStatus = .right
                
                // 第二次画绿线
                shapeLayer = self.drawLine(status: .right, start: start, end: end)
                
//                let CABasicAnimation
                                                                                
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.4) {
                    shapeLayer.removeFromSuperlayer()
                    
                    selectedItems.0.itemStatus = .end
                    selectedItems.1.itemStatus = .end
                    
                    // 第三次画完成线
                    shapeLayer = self.drawLine(status: .end, start: start, end: end)
                    
                    self.connectionStatus = true
                    
                    // 做题完成
                    let result = self.processConnectionCompletion()
                    self.connectionEvent?(selectedItems.0.itemModel?.optionId ?? 0, true, result)
                }
                
            }
            
            
        } else {
            remindEvent?(selectedItems.0.itemModel?.optionId ?? 0)
            
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
                    
                    self.connectionStatus = true
                    
                    self.connectionEvent?(selectedItems.0.itemModel?.optionId ?? 0, false, false)
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
            lineColor = UIColor.green1
        case .wrong:
            lineColor = UIColor.red1
        case .end:
            lineColor = UIColor.black8
        default:
            lineColor = UIColor.black1
        }
        return lineColor
    }
    
    
}
