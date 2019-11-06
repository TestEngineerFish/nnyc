//
//  YXConnectionLeftView.swift
//  YXEDU
//
//  Created by sunwu on 2019/11/4.
//  Copyright © 2019 shiji. All rights reserved.
//

import UIKit




class YXConnectionLeftView: UIView {

    

}


/// 选择状态枚举
enum YXConnectionItemStatus {
    case normal
    case selected
    case right
    case wrong
    case end
}

/// 选择类型枚举
enum YXConnectionItemType {
    case left
    case right
}

class YXConnectionItemView: UIButton {
    
    public var clickEvent: ((_ index: Int, _ itemType: YXConnectionItemType) -> Void)?
    
    public var index: Int = 0
    public var itemType: YXConnectionItemType = .left
    public var itemStatus: YXConnectionItemStatus = .normal {
        didSet { self.setItemStatus() }
    }
    
    public var itemTitle: String? {
        didSet { self.setTitle(self.itemTitle, for: .normal) }
    }
    
    public var itemImageUrl: String? {
        didSet { self.setBackgroundImage(UIImage.imageWithColor(UIColor.gray), for: .normal) }
    }
    
    public var locationPoint: CGPoint { return self._locationPoint() }
    

    override init(frame: CGRect) {
        super.init(frame: frame)
//        self.addGesture()
        self.bindProperty()
    }
        
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    //MARK: --------- private ---------

    
    private func bindProperty() {
        self.addTarget(self, action: #selector(clickButton), for: .touchUpInside)
        self.layer.masksToBounds = true
        self.layer.cornerRadius = self.height / 2
    }
    
    private func setItemStatus() {
        self.layer.borderColor = UIColor.clear.cgColor
        self.layer.borderWidth = 1.02
        
        if itemStatus == .normal {
            self.setTitleColor(UIColor.black1, for: .normal)
            self.backgroundColor = UIColor.orange3
        } else if itemStatus == .selected {
            self.setTitleColor(UIColor.white, for: .normal)
            self.backgroundColor = UIColor.orange1
        } else if itemStatus == .right {
            self.setTitleColor(UIColor.green1, for: .normal)
            self.backgroundColor = UIColor.orange3
            self.layer.borderColor = UIColor.green1.cgColor
        } else if itemStatus == .wrong {
            self.setTitleColor(UIColor.red1, for: .normal)
            self.backgroundColor = UIColor.red2
            self.layer.borderColor = UIColor.red1.cgColor
        } else {
            self.setTitleColor(UIColor.black3, for: .normal)
            self.backgroundColor = UIColor.orange3.withAlphaComponent(0.4)
        }
    }

    
    private func _locationPoint() -> CGPoint {
        let offset: CGFloat = 5
        var x: CGFloat = self.width + offset
        if self.itemType == .right {
            x = 0 - offset
        }
        let point = CGPoint(x: x, y: self.height / 2)
        // 返回 item 在父类中的位置
        return self.convert(point, to: self.superview)
    }
    
    @objc private func clickButton() {
        if itemStatus == .selected {
            self.itemStatus = .normal
        } else if itemStatus == .normal {
            self.clickEvent?(self.index, self.itemType)
        }
    }
    
    
}





