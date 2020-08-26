//
//  YXMyClassEditNameView.swift
//  YXEDU
//
//  Created by 沙庭宇 on 2020/8/26.
//  Copyright © 2020 shiji. All rights reserved.
//

import Foundation

protocol YXMyClassEditNameViewProtocol: NSObjectProtocol {
    func closedAction()
    func editName(name: String)
}

class YXMyClassEditNameView: YXView, UITextFieldDelegate {

    weak var delegate: YXMyClassEditNameViewProtocol?
    var maxNameLength = 10

    var closeButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "close_white"), for: .normal)
        return button
    }()
    var successImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "success")
        return imageView
    }()
    var backgroundView: UIView = {
        let view = UIView()
        return view
    }()
    var titleLabel: UILabel = {
        let label = UILabel()
        label.text          = ""
        label.textColor     = UIColor.white
        label.font          = UIFont.mediumFont(ofSize: AdaptFontSize(20))
        label.textAlignment = .center
        label.numberOfLines = 0
        return label
    }()
    var teacherLabel: UILabel = {
        let label = UILabel()
        label.text          = ""
        label.textColor     = UIColor.white
        label.font          = UIFont.regularFont(ofSize: AdaptSize(14))
        label.textAlignment = .center
        return label
    }()
    var contentView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.white
        return view
    }()
    var descriptionLabel: UILabel = {
        let label = UILabel()
        label.text          = "为了帮助老师认识你，建议在班级里使用自己的姓名作为昵称哦!"
        label.textColor     = UIColor.hex(0x666666)
        label.font          = UIFont.regularFont(ofSize: AdaptFontSize(13))
        label.textAlignment = .left
        label.numberOfLines = 0
        return label
    }()
    var nameTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder     = "请输入你的昵称"
        textField.textColor       = UIColor.black1
        textField.font            = UIFont.regularFont(ofSize: AdaptFontSize(15))
        textField.backgroundColor = UIColor.hex(0xF2F2F2)
        let leftPaddingView       = UIView(frame: CGRect(x: 0, y: 0, width: AdaptSize(20), height: AdaptSize(20)))
        textField.leftView        = leftPaddingView
        textField.leftViewMode    = .always
        return textField
    }()
    var submitButton: YXButton = {
        let button = YXButton(.theme, frame: .zero)
        button.setTitle("确认", for: .normal)
        button.titleLabel?.font = UIFont.regularFont(ofSize: AdaptFontSize(17))
        return button
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.createSubviews()
        self.bindProperty()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func createSubviews() {
        super.createSubviews()
        self.addSubview(backgroundView)
        self.addSubview(closeButton)
        self.addSubview(successImageView)
        self.addSubview(titleLabel)
        self.addSubview(teacherLabel)
        self.addSubview(contentView)
        contentView.addSubview(descriptionLabel)
        contentView.addSubview(nameTextField)
        contentView.addSubview(submitButton)
        backgroundView.size = CGSize(width: screenWidth, height: AdaptSize(303))
        backgroundView.snp.makeConstraints { (make) in
            make.centerX.top.equalToSuperview()
            make.size.equalTo(backgroundView.size)
        }
        closeButton.snp.makeConstraints { (make) in
            make.left.equalToSuperview().offset(AdaptSize(20))
            make.top.equalTo(kStatusBarHeight + AdaptSize(10))
            make.size.equalTo(CGSize(width: AdaptSize(22), height: AdaptSize(22)))
        }
        successImageView.snp.makeConstraints { (make) in
            make.top.equalTo(closeButton.snp.bottom).offset(AdaptSize(10))
            make.centerX.equalToSuperview()
            make.size.equalTo(CGSize(width: AdaptSize(50), height: AdaptSize(50)))
        }
        titleLabel.snp.makeConstraints { (make) in
            make.left.equalToSuperview().offset(AdaptSize(15))
            make.right.equalToSuperview().offset(AdaptSize(-15))
            make.top.equalTo(successImageView.snp.bottom).offset(AdaptSize(15))
        }
        teacherLabel.snp.makeConstraints { (make) in
            make.left.right.equalTo(titleLabel)
            make.top.equalTo(titleLabel.snp.bottom).offset(AdaptSize(5))
        }
        contentView.snp.makeConstraints { (make) in
            make.left.equalToSuperview().offset(AdaptSize(20))
            make.right.equalToSuperview().offset(AdaptSize(-20))
            make.top.equalTo(teacherLabel.snp.bottom).offset(35)
            make.height.equalTo(AdaptSize(238))
        }
        descriptionLabel.snp.makeConstraints { (make) in
            make.left.equalToSuperview().offset(AdaptSize(15))
            make.right.equalToSuperview().offset(AdaptSize(-15))
            make.top.equalToSuperview().offset(AdaptSize(25))
        }
        nameTextField.snp.makeConstraints { (make) in
            make.left.right.equalTo(descriptionLabel)
            make.top.equalTo(descriptionLabel.snp.bottom).offset(AdaptSize(25))
            make.height.equalTo(AdaptSize(45))
        }
        submitButton.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.bottom.equalToSuperview().offset(AdaptSize(-30))
            make.size.equalTo(CGSize(width: AdaptSize(273), height: AdaptFontSize(42)))
        }
    }

    override func bindProperty() {
        super.bindProperty()
        self.backgroundView.backgroundColor = UIColor.gradientColor(with: self.backgroundView.size, colors: [UIColor.hex(0xFDBA22), UIColor.hex(0xFB8417)], direction: .horizontal)
        self.backgroundView.clipRectCorner(directionList: [.bottomLeft, .bottomRight], cornerRadius: AdaptSize(25))
        self.contentView.layer.setDefaultShadow()
        self.nameTextField.layer.cornerRadius = AdaptSize(22.5)
        self.nameTextField.delegate = self
        self.submitButton.setStatus(.disable)
        self.closeButton.addTarget(self, action: #selector(self.closedAction), for: .touchUpInside)
        self.nameTextField.addTarget(self, action: #selector(self.editName(textField:)), for: .editingChanged)
        self.submitButton.addTarget(self, action: #selector(self.submitAction), for: .touchUpInside)
    }

    // MARK: ==== Event ====

    @objc
    private func closedAction() {
        self.delegate?.closedAction()
    }

    @objc
    private func editName(textField: UITextField) {
        guard let name = textField.text, !name.isEmpty else {
            self.submitButton.setStatus(.disable)
            return
        }
        self.submitButton.setStatus(.normal)
    }

    @objc
    private func submitAction() {
        guard let name = self.nameTextField.text else { return }
        self.delegate?.editName(name: name)
    }

    func setData(className: String, teacherName: String) {
        self.titleLabel.text   = "你已成功加入 " + className
        self.teacherLabel.text = "老师：" + teacherName
    }

    // MARK: ==== UITextFieldDelegate ====
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if range.length <= 0 {
            YXLog(string)
            guard let name = textField.text, (name.count + string.count) <= self.maxNameLength else {
                return false
            }
        }
        return true
    }

}
