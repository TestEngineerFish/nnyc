//
//  YXMyClassEditNameViewController.swift
//  YXEDU
//
//  Created by 沙庭宇 on 2020/8/26.
//  Copyright © 2020 shiji. All rights reserved.
//

import Foundation

class YXMyClassEditNameViewController: YXViewController, YXMyClassEditNameViewProtocol {

    var classId: Int        = 0
    var className: String   = ""
    var teacherName: String = ""
    var submitBlock: ((Bool)->Void)?

    var contentView = YXMyClassEditNameView()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.createSubviews()
        self.bindProperty()
    }

    private func createSubviews() {
        self.view.addSubview(contentView)
        contentView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
    }

    private func bindProperty() {
        self.customNavigationBar?.isHidden = true
        self.contentView.delegate          = self
        self.contentView.setData(className: self.className, teacherName: self.teacherName)
    }

    // MARK: ==== Request ====
    private func requestEditName(name: String) {
        self.submitBlock?(true)
    }

    // MARK: ==== YXMyClassEditNameViewProtocol ====
    func closedAction() {
        if self.submitBlock != nil {
            self.navigationController?.popViewController(animated: false)
            self.submitBlock?(true)
        } else {
            self.navigationController?.popViewController(animated: true)
        }
    }
    func editName(name: String) {
        self.requestEditName(name: name)
    }
}
