//
//  YXEditSchoolView.swift
//  YXEDU
//
//  Created by 沙庭宇 on 2020/8/25.
//  Copyright © 2020 shiji. All rights reserved.
//

import Foundation

protocol YXEditSchoolViewProtocol: NSObjectProtocol {
    func selectSchoolLocal()
    func selectShcoolName()
    func submitAction()
}

class YXEditSchoolView: YXView {

    var delegate: YXEditSchoolViewProtocol?

    var localModel: YXLocalModel?

    var titleLabel: UILabel = {
        let label = UILabel()
        label.text          = "请选择您孩子的就读学校"
        label.textColor     = UIColor.black1
        label.font          = UIFont.mediumFont(ofSize: AdaptFontSize(20))
        label.textAlignment = .left
        return label
    }()
    var localLabel: UILabel = {
        let label = UILabel()
        label.text          = "请选择学校地址"
        label.textColor     = UIColor.black6
        label.font          = UIFont.regularFont(ofSize: AdaptFontSize(14))
        label.textAlignment = .left
        label.isUserInteractionEnabled = true
        return label
    }()
    var localLineView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.black4
        return view
    }()
    var nameLabel: UILabel = {
        let label = UILabel()
        label.text          = "请选择学校名称"
        label.textColor     = UIColor.black6
        label.font          = UIFont.regularFont(ofSize: AdaptFontSize(14))
        label.textAlignment = .left
        label.isUserInteractionEnabled = true
        return label
    }()
    var nameLineView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.black4
        return view
    }()
    var doneButton: YXButton = {
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
        self.addSubview(titleLabel)
        self.addSubview(localLabel)
        self.addSubview(localLineView)
        self.addSubview(nameLabel)
        self.addSubview(nameLineView)
        self.addSubview(doneButton)
        titleLabel.snp.makeConstraints { (make) in
            make.left.equalToSuperview().offset(AdaptSize(20))
            make.top.equalToSuperview().offset(AdaptSize(30))
            make.right.equalToSuperview().offset(AdaptSize(-20))
        }
        localLabel.snp.makeConstraints { (make) in
            make.left.right.equalTo(titleLabel)
            make.top.equalTo(titleLabel.snp.bottom).offset(AdaptSize(25))
        }
        localLineView.snp.makeConstraints { (make) in
            make.left.right.equalTo(titleLabel)
            make.top.equalTo(localLabel.snp.bottom).offset(AdaptSize(10))
            make.height.equalTo(0.6)
        }
        nameLabel.snp.makeConstraints { (make) in
            make.left.right.equalTo(titleLabel)
            make.top.equalTo(localLineView.snp.bottom).offset(AdaptSize(25))
        }
        nameLineView.snp.makeConstraints { (make) in
            make.left.right.equalTo(titleLabel)
            make.top.equalTo(nameLabel.snp.bottom).offset(AdaptSize(10))
            make.height.equalTo(0.6)
        }
        doneButton.size = CGSize(width: AdaptSize(273), height: AdaptSize(42))
        doneButton.snp.makeConstraints { (make) in
            make.size.equalTo(doneButton.size)
            make.centerX.equalToSuperview()
            make.top.equalTo(nameLineView.snp.bottom).offset(AdaptSize(30))
        }
    }

    override func bindProperty() {
        super.bindProperty()
        let tapLocal = UITapGestureRecognizer(target: self, action: #selector(self.tapLocalAction))
        let tapName  = UITapGestureRecognizer(target: self, action: #selector(self.tapNameAction))
        self.localLabel.addGestureRecognizer(tapLocal)
        self.nameLabel.addGestureRecognizer(tapName)
        self.doneButton.setStatus(.disable)
        self.doneButton.addTarget(self, action: #selector(self.submitAction), for: .touchUpInside)
    }

    // MARK: ==== Event ====
    @objc
    private func tapLocalAction() {
        self.delegate?.selectSchoolLocal()
    }

    @objc
    private func tapNameAction() {
        self.delegate?.selectShcoolName()
    }

    @objc
    private func submitAction() {
        self.delegate?.submitAction()
    }
}
