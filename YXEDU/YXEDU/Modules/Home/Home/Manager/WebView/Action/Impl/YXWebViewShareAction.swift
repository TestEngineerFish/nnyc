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
                let resultDic = ["result":result]
                self.jsBridge.webView?.evaluateJavaScript(resultDic.toJson(), completionHandler: nil)
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
        let request = YXShareRequest.changeBackgroundImage(type: YXShareChannel.timeLine.rawValue)
        YYNetworkService.default.request(YYStructResponse<YXResultModel>.self, request: request, success: { response in
            guard let result = response.data, let imageStr = result.imageUrls?.first else { return }
            YXKVOImageView().sd_setImage(with: URL(string: imageStr)) { (shareImage, error, type, url) in
                block?(shareImage)
            }
        }) { (error) in
            YXUtils.showHUD(kWindow, title: error.message)
        }
    }
}
