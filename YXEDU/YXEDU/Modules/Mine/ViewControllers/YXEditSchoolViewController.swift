//
//  YXEditSchoolViewController.swift
//  YXEDU
//
//  Created by 沙庭宇 on 2020/8/25.
//  Copyright © 2020 shiji. All rights reserved.
//

import Foundation

class YXEditSchoolViewController: YXViewController, YXEditSchoolViewProtocol, YXSearchSchoolDelegate, YXSelectLocalPickerViewProtocol {

    var contentView      = YXEditSchoolView()
    let selectLocalView  = YXSelectLocalPickView()
    let selectSchollView = YXSearchSchoolListView()
    var isEdit: Bool = true

    override func viewDidLoad() {
        super.viewDidLoad()
        self.createSubviews()
        self.bindProperty()
    }

    private func createSubviews() {
        self.view.addSubview(contentView)
        contentView.snp.makeConstraints { (make) in
            make.left.right.bottom.equalToSuperview()
            make.top.equalToSuperview().offset(kNavHeight)
        }
    }

    private func bindProperty() {
        self.customNavigationBar?.title = isEdit ? "修改学校信息" : "补充学校信息"
        self.contentView.delegate      = self
        self.selectLocalView.delegate  = self
        self.selectSchollView.delegate = self
    }

    // MARK: ==== YXEditSchoolViewProtocol ====
    func selectSchoolLocal() {
        self.selectLocalView.show()
    }

    func selectShcoolName() {
        guard let localModel = self.contentView.localModel else {
            return
        }
        self.selectSchollView.show(selectLocal: localModel)
    }

    // MARK: ==== YXSelectLocalPickerViewProtocol ====
    func selectedLocal(local model:YXLocalModel, name: String) {
        if self.contentView.localModel?.id != .some(model.id) {
            self.selectSchool(school: nil)
        }
        self.contentView.localModel           = model
        self.contentView.localLabel.text      = name
        self.contentView.localLabel.textColor = .black1
    }

    // MARK: ==== YXSearchSchoolDelegate ====
    func selectSchool(school model: YXLocalModel?) {
        if model == nil {
            self.contentView.nameLabel.text      = "请选择学校名称"
            self.contentView.nameLabel.textColor = UIColor.black6
            self.contentView.doneButton.setStatus(.disable)
        } else {
            self.contentView.nameLabel.text      = model?.name
            self.contentView.nameLabel.textColor = UIColor.black1
            self.contentView.doneButton.setStatus(.normal)
        }
    }
}
