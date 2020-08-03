//
//  YXWebViewSelectSchool.swift
//  YXEDU
//
//  Created by 沙庭宇 on 2020/7/7.
//  Copyright © 2020 shiji. All rights reserved.
//

import Foundation

class YXWebViewSelectSchool: YRWebViewJSAction, YXSearchSchoolDelegate {

    let selectView = YXSearchSchoolListView()

    override func action() {
        super.action()
        if let addressId = self.params["address_id"] as? Int {
            self.showSelectSchoolView(local: addressId)
        }
    }

    deinit {
        self.selectView.delegate = nil
        self.selectView.removeFromSuperview()
    }

    // MARK: ==== Event ====
    private func showSelectSchoolView(local id: Int) {
        var localModel = YXLocalModel()
        localModel.id  = id
        selectView.delegate = self
        selectView.show(selectLocal: localModel)
    }

    // MARK: ==== YXSearchSchoolDelegate ====
    func selectSchool(school model: YXLocalModel?) {
        guard let _model = model, let callBackStr = self.callback else { return }
        let resultDic: [String : Any] = ["school" : _model.name, "school_id" : _model.id]
        let funcStr = String(format: "%@('%@')", callBackStr, resultDic.toJson())
        DispatchQueue.main.async { [weak self] in
            self?.jsBridge.webView?.evaluateJavaScript(funcStr, completionHandler: nil)
        }
    }
}
