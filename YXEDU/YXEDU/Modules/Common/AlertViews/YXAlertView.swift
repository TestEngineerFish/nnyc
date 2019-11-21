//
//  YXAlertView.swift
//  YXEDU
//
//  Created by Jake To on 11/6/19.
//  Copyright © 2019 shiji. All rights reserved.
//

import UIKit

enum YXAlertViewType {
    case normal
    case inputable
}

class YXAlertView: UIView, UITextFieldDelegate {

    var cancleClosure: (() -> Void)?
    var doneClosure: ((_ string: String?) -> Void)?

    private var type: YXAlertViewType = .normal
    
    @IBOutlet var contentView: UIView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var textFieldView: UIView!
    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var clearButton: UIButton!
    @IBOutlet weak var textCountLabel: UILabel!
    @IBOutlet weak var cancelButtonRightDistance: NSLayoutConstraint!
    @IBOutlet weak var doneButtonLeftDistance: NSLayoutConstraint!
    @IBOutlet weak var alertHeight: NSLayoutConstraint!
    
    @IBAction func cancle(_ sender: UIButton) {
        cancleClosure?()
        self.removeFromSuperview()
    }
    
    @IBAction func done(_ sender: UIButton) {
        doneClosure?(textField.text)
        self.removeFromSuperview()
    }
    
    @IBAction func clearTextField(_ sender: UIButton) {
        textField.text = ""
    }
    
    init(type: YXAlertViewType = .normal) {
        super.init(frame: CGRect(x: 0, y: 0, width: screenWidth, height: screenHeight))
        self.type = type
        
        initializationFromNib()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        initializationFromNib()
    }
    
    private func initializationFromNib() {
        Bundle.main.loadNibNamed("YXAlertView", owner: self, options: nil)
        addSubview(contentView)
        contentView.frame = self.bounds
        
        switch type {
        case .normal:
            textFieldView.isHidden = true
            cancelButtonRightDistance.constant = ((screenWidth - 128) / 2) + 10
            doneButtonLeftDistance.constant = ((screenWidth - 128) / 2) + 10
            alertHeight.constant = 184
            
        case .inputable:
            textFieldView.isHidden = false
            textField.delegate = self
            textField.addTarget(self, action: #selector(changeTextField), for: UIControl.Event.editingChanged)
            alertHeight.constant = 204
        }
    }
    
    @objc
    private func changeTextField() {
        if var text = textField.text, text.count >= 20 {
            textField.text = text.substring(maxIndex: 20)
            text = textField.text!
        }
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        guard let text = textField.text, text.isEmpty == false else { return }
        clearButton.isHidden = false
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        clearButton.isHidden = true
    }
    
    func show() {
        kWindow.addSubview(self)
    }
}
