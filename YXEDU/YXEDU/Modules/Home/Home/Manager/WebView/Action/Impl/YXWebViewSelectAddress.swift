//
//  YXWebViewSelectAddress.swift
//  YXEDU
//
//  Created by 沙庭宇 on 2020/7/7.
//  Copyright © 2020 shiji. All rights reserved.
//

import Foundation

class YXWebViewSelectAddress: YRWebViewJSAction, YXSelectLocalPickerViewProtocol {

    let selectView = YXSelectLocalPickView()

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
        selectView.show()
    }

    // MARK: ==== YXSelectLocalPickerViewProtocol ====
    func selectedLocal(local model:YXLocalModel, name: String) {
        guard let callBackStr = self.callback else {
            return
        }
        let resultDic: [String : Any] = ["address" : name, "address_id" : model.id]
        let funcStr = String(format: "%@('%@')", callBackStr, resultDic.toJson())
        DispatchQueue.main.async {
            self.jsBridge.webView?.evaluateJavaScript(funcStr, completionHandler: nil)
        }
    }
}
