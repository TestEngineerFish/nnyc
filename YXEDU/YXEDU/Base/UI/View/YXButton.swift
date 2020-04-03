//
//  YXButton.swift
//  YXEDU
//
//  Created by 沙庭宇 on 2019/11/14.
//  Copyright © 2019 shiji. All rights reserved.
//

import UIKit

enum YXButtonStatusEnum: Int {
    case normal
    case touchDown
    case disable
}

@IBDesignable
class YXButton: UIButton {

    var status = YXButtonStatusEnum.normal

    override var isEnabled: Bool {
        didSet {
            self.layoutIfNeeded()
        }
    }

    // MARK: ---- Init ----
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.addTarget(self, action: #selector(touchDown(sender:)), for: .touchDown)
        self.addTarget(self, action: #selector(touchUp(sender:)), for: .touchUpInside)
        self.addTarget(self, action: #selector(touchUp(sender:)), for: .touchUpOutside)
        self.addTarget(self, action: #selector(touchUp(sender:)), for: .touchCancel)
        self.bindProperty()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    deinit {
        self.removeTarget(self, action: #selector(touchDown(sender:)), for: .touchDown)
        self.removeTarget(self, action: #selector(touchUp(sender:)), for: .touchUpInside)
        self.removeTarget(self, action: #selector(touchUp(sender:)), for: .touchUpOutside)
        self.removeTarget(self, action: #selector(touchUp(sender:)), for: .touchCancel)
    }

    // MARK: ---- Layout ----

    override func layoutSubviews() {
        super.layoutSubviews()
        self.layer.cornerRadius  = self.size.height / 2
        self.layer.masksToBounds = true
    }

    /// 设置按钮状态，根据状态来更新UI
    private func setStatus(_ status: YXButtonStatusEnum?) {
        if let _status = status {
          self.status = _status
        }
        switch self.status {
        case .normal:
            self.backgroundColor = UIColor.gradientColor(with: self.size, colors: [UIColor.hex(0xFDBA33), UIColor.orange1], direction: .vertical)
        case .touchDown:
            self.backgroundColor = UIColor.hex(0x0F0F0F).withAlphaComponent(0.22)
        case .disable:
            self.backgroundColor = UIColor.hex(0xFFF4E9)
        }
    }

    // MARK: ---- Event ----

    private func bindProperty() {
        self.setTitleColor(UIColor.white, for: .normal)
        self.setTitleColor(UIColor.white, for: .highlighted)
        self.addObserver(self, forKeyPath: "size", options: .new, context: nil)
    }

    @objc func touchDown(sender: UIButton) {
        sender.transform = CGAffineTransform(scaleX: 0.93, y: 0.93)

    }

    @objc func touchUp(sender: UIButton) {
        sender.transform = CGAffineTransform.identity
    }

    //TODO: 自定义Storyboard编辑器
    @IBInspectable
    var cornerRadius: CGFloat = 0.0 {
        didSet {
            layer.cornerRadius  = cornerRadius
            layer.masksToBounds = cornerRadius > 0
        }
    }

    @IBInspectable
    var borderWidth: CGFloat = 0.0 {
        didSet {
            layer.borderWidth = borderWidth
        }
    }

    @IBInspectable
    var borderColor: UIColor = .black {
        didSet {
            layer.borderColor = borderColor.cgColor
        }
    }

    // MARK: ---- KVO ----
    override class func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if keyPath == "size" {
            
        }
    }
}

