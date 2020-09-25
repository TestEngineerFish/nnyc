//
//  YXMyClassEditNameViewController.swift
//  YXEDU
//
//  Created by 沙庭宇 on 2020/8/26.
//  Copyright © 2020 shiji. All rights reserved.
//

import Foundation

class YXMyClassEditNameViewController: YXViewController, YXMyClassEditNameViewProtocol {

    var classModel: YXMyClassSummaryModel?
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
        guard let classModel = self.classModel else { return }
        self.customNavigationBar?.isHidden = true
        self.contentView.delegate          = self
        self.contentView.setData(model: classModel)
    }

    // MARK: ==== Request ====
    private func requestEditName(name: String) {
        let request = YXOCRequest.changeName(name: name)
        YYNetworkService.default.request(YYStructResponse<YXResultModel>.self, request: request, success: { [weak self] (response) in
            guard let self = self else { return }
            self.navigationController?.popViewController(animated: true)
            self.submitBlock?(true)
        }) { (error) in
            YXUtils.showHUD(nil, title: error.message)
        }
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
        self.contentView.endEditing(true)
        self.requestEditName(name: name)
    }
}
