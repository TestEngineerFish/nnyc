//
//  YXCharacterTextField.swift
//  YXEDU
//
//  Created by 沙庭宇 on 2019/10/25.
//  Copyright © 2019 shiji. All rights reserved.
//

import UIKit

protocol YXCharacterTextFieldProtocol: NSObjectProtocol {
    func yxDeleteBackward()
}

class YXCharacterTextField: UITextField, UIGestureRecognizerDelegate {

    typealias ClickAction = ((UIButton)->Void)
    var isBlank = false
    var clickLeftButtonAction:ClickAction?
    weak var customDelegate: YXCharacterTextFieldProtocol?

    init(frame: CGRect, isTitle: Bool) {
        super.init(frame: frame)
        self.tag                    = 999// 用户响应底部答题事件
        self.font                   = isTitle ? UIFont.boldSystemFont(ofSize: AdaptFontSize(26)) : UIFont.pfSCRegularFont(withSize: AdaptFontSize(17))
        self.textColor              = isTitle ? UIColor.black1 : UIColor.black2
//        self.minimumFontSize        = 0.3
        self.borderStyle            = .none
        self.returnKeyType          = .done
        self.textAlignment          = .center
        self.backgroundColor        = .clear
        self.inputAccessoryView     = UIView()
        self.autocorrectionType     = .no
        self.autocapitalizationType = .none
    }
    
    init() {
        super.init(frame: CGRect.zero)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func canPerformAction(_ action: Selector, withSender sender: Any?) -> Bool {
        return false
    }

    // 删除事件
    override func deleteBackward() {
        super.deleteBackward()
        self.customDelegate?.yxDeleteBackward()
    }
    
    // MARK: ---- Event ----
    func showRemindButton(_ clickBlock: ClickAction?) {
        let tipsButton: UIButton = {
            let button = UIButton()
            button.setTitle("提示一下", for: .normal)
            button.titleLabel?.contentMode = .left
            button.setImage(UIImage(named: "exercise_tips"), for: .normal)
            button.setTitleColor(UIColor.black3, for: .normal)
            button.setTitleColor(UIColor.black2, for: .highlighted)
            button.titleLabel?.font = UIFont.pfSCRegularFont(withSize: AdaptFontSize(12))
            return button
        }()
        self.clickLeftButtonAction = clickBlock
        tipsButton.addTarget(self, action: #selector(clickLeftButton(_:)), for: .touchUpInside)
        self.keyboardToolbar.addSubview(tipsButton)
        // 因为IQKeyboard会添加一个contentView到Toolbar中，导致遮盖自定义按钮
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) { [weak self] in
            self?.keyboardToolbar.bringSubviewToFront(tipsButton)
        }
        tipsButton.sizeToFit()
        tipsButton.snp.makeConstraints { (make) in
            make.left.equalToSuperview().offset(AdaptIconSize(15))
            make.centerY.equalToSuperview()
            make.height.equalToSuperview()
            make.width.equalTo(tipsButton.width)
        }
    }
    
    /// 点击工具栏左边按钮事件
    @objc private func clickLeftButton(_ button: UIButton) {
        self.clickLeftButtonAction?(button)
    }

    // MARK: UIGestureRecognizerDelegate
    override func addGestureRecognizer(_ gestureRecognizer: UIGestureRecognizer) {
        return
    }

    override func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        return false
    }

}
