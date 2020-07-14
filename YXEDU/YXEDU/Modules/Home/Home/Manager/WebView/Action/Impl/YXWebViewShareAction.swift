//
//  YXWebViewShareAction.swift
//  YXEDU
//
//  Created by 沙庭宇 on 2020/7/7.
//  Copyright © 2020 shiji. All rights reserved.
//

import Foundation

class YXWebViewShareAction: YRWebViewJSAction {

    override func action() {
        super.action()

        if let json = self.params as? [String: Any], let actionModel = ShareActionModel(JSON: json) {
            let shareView = YXShareDefaultView()
            // 分享完成后的回调
            shareView.completeBlock = { (channel: YXShareChannel, result: Bool) in
                guard let callBackStr = self.callback else {
                    return
                }
                let resultDic = ["result":result]
                let funcStr = String(format: "%@('%@')", callBackStr, resultDic.toJson())
                DispatchQueue.main.async {
                    self.jsBridge.webView?.evaluateJavaScript(funcStr, completionHandler: nil)
                }
            }
            self.getShareImage { (shareImage) in
                guard let _shareImage = shareImage else {
                    return
                }
                shareView.shareImage(to: actionModel.type.getShareChannel(), with: _shareImage, finishedBlock: nil)
            }
        }
    }

    // MARK: ==== Event ====
    /// 获取分享图片
    private func getShareImage(complete block: ((UIImage?)->Void)?) {
        let request = YXShareRequest.getActivityShareImage
        YXUtils.showLoadingInfo("加载中", to: kWindow)
        YYNetworkService.default.request(YYStructResponse<YXResultModel>.self, request: request, success: { response in
            guard let model = response.data else { return }
            SDWebImageManager.shared().imageDownloader?.downloadImage(with: URL(string: model.imageUrlStr), completed: { (image, data, error, result) in
                block?(image)
            })
        }) { (error) in
            YXUtils.showHUD(kWindow, title: error.message)
        }
    }
}
