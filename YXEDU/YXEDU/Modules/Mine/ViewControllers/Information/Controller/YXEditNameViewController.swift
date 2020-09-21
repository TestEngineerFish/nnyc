//
//  YXEditNameViewController.swift
//  YXEDU
//
//  Created by 沙庭宇 on 2020/7/31.
//  Copyright © 2020 shiji. All rights reserved.
//

import Foundation

class YXEditNameViewController: YXViewController, UITextFieldDelegate {

    var name: String   = ""
    let maxLength: Int = 10
    var blackAction: ((String)->Void)?

    var saveButton: UIButton = {
        let button = UIButton()
        button.setTitle("完成", for: .normal)
        button.setTitleColor(UIColor.black1, for: .normal)
        button.titleLabel?.textAlignment = .right
        button.titleLabel?.font = UIFont.regularFont(ofSize: AdaptFontSize(16))
        return button
    }()
    var backgroundView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.white
        return view
    }()
    let nameTextField: UITextField = {
        let textField = UITextField()
        textField.font = UIFont.regularFont(ofSize: AdaptFontSize(16))
        textField.textColor = UIColor.hex(0x485461)
        return textField
    }()
    var lengthLabel: UILabel = {
        let label = UILabel()
        label.text          = ""
        label.textColor     = UIColor.hex(0x8095AB)
        label.font          = UIFont.regularFont(ofSize: AdaptFontSize(14))
        label.textAlignment = .right
        return label
    }()
    var bottomView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.hex(0xedf2f6)
        return view
    }()

    deinit {
        self.nameTextField.removeTarget(self, action: #selector(editName), for: .editingChanged)
        self.nameTextField.delegate = nil

    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.createSubviews()
        self.bindProperty()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.nameTextField.becomeFirstResponder()
    }

    private func createSubviews() {
        self.view.addSubview(backgroundView)
        self.view.addSubview(bottomView)
        self.customNavigationBar?.addSubview(saveButton)
        backgroundView.addSubview(nameTextField)
        backgroundView.addSubview(lengthLabel)
        backgroundView.snp.makeConstraints { (make) in
            make.left.right.equalToSuperview()
            make.top.equalToSuperview().offset(kNavHeight)
            make.height.equalTo(AdaptSize(60))
        }
        nameTextField.snp.makeConstraints { (make) in
            make.bottom.height.equalToSuperview()
            make.left.equalToSuperview().offset(AdaptSize(15))
            make.right.equalTo(lengthLabel.snp.left).offset(AdaptSize(-15))
        }
        lengthLabel.snp.makeConstraints { (make) in
            make.centerY.height.equalToSuperview()
            make.width.equalTo(AdaptSize(60))
            make.right.equalToSuperview().offset(AdaptSize(-15))
        }
        bottomView.snp.makeConstraints { (make) in
            make.left.right.bottom.equalToSuperview()
            make.top.equalTo(backgroundView.snp.bottom)
        }
        saveButton.snp.makeConstraints { (make) in
            make.right.equalToSuperview()
            make.centerY.height.equalToSuperview()
            make.width.equalTo(AdaptSize(60))
        }
    }

    private func bindProperty() {
        self.customNavigationBar?.title = "修改姓名"
        let _name = name.count > maxLength ? name.substring(maxIndex: maxLength) : name
        self.nameTextField.text     = _name
        self.nameTextField.delegate = self
        self.view.backgroundColor   = UIColor.white
        self.updateLength(_name)
        self.saveButton.addTarget(self, action: #selector(saveAction), for: .touchUpInside)
        self.nameTextField.addTarget(self, action: #selector(editName), for: .editingChanged)
    }

    // MARK: ==== Request ====
    private func requestEdit() {
        let name = (self.nameTextField.text ?? "").substring(maxIndex: 10)
        DispatchQueue.main.async {
            YXUtils.showProgress(kWindow)
        }
        let request = YXOCRequest.changeName(name: name)
        YYNetworkService.default.request(YYStructResponse<YXResultModel>.self, request: request, success: { [weak self] (response) in
            DispatchQueue.main.async {
                YXUtils.hidenProgress(kWindow)
            }
            guard let self = self else { return }
            self.blackAction?(name)
            self.navigationController?.popViewController(animated: true)
        }) { (error) in
            DispatchQueue.main.async {
                YXUtils.hidenProgress(kWindow)
            }
            YXUtils.showHUD(nil, title: error.message)
        }
    }

    // MARK: ==== Event ====
    @objc private func editName() {
        guard let name = self.nameTextField.text else {
            return
        }
        self.updateLength(name)
    }

    @objc private func saveAction() {
        self.requestEdit()
    }

    private func updateLength(_ name: String) {
        self.lengthLabel.text = "\(name.count)/\(maxLength)"
    }

    // MARK: ==== UITextFieldDelegate =====
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if range.length <= 0 {
            YXLog(string)
            guard let name = textField.text, (name.count + string.count) <= self.maxLength else {
                return false
            }
        }
        return true
    }
    override func canPerformAction(_ action: Selector, withSender sender: Any?) -> Bool {
        return false
    }
}
