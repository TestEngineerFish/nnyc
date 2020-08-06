//
//  YXAlertManager.swift
//  YXEDU
//
//  Created by 沙庭宇 on 2020/7/7.
//  Copyright © 2020 shiji. All rights reserved.
//

import Foundation

struct YXAlertManager {
    func showNoLearningContent(book model: YXWordBookModel) {
        let alertView = YXAlertView(type: .normal)
        alertView.descriptionLabel.text   = "您当前\(model.bookName ?? "") 暂时没有需要学习的单词，请明天再来看看吧~"
        alertView.shouldOnlyShowOneButton = true
        alertView.rightOrCenterButton.setTitle("跳过今日学习", for: .normal)
        alertView.doneClosure = { _ in
            YXLog("跳过今日打卡学习")
            self.skipPunchLearn(book: model.bookId ?? 0)
        }
        alertView.adjustAlertHeight()
        YXAlertQueueManager.default.addAlert(alertView: alertView)
    }

    // MARK: ==== Tools ====
    private func skipPunchLearn(book id: Int) {
        let request = YXShareRequest.punch(type: YXShareChannel.qq.rawValue, bookId: id, learnType: YXLearnType.homeworkPunch.rawValue)
        YYNetworkService.default.request(YYStructResponse<YXShareModel>.self, request: request, success: { (response) in
            guard let model = response.data else { return }
            if model.state {
                if let count = YYCache.object(forKey: YXLocalKey.punchCount) as? Int {
                    YXLog("用户 \(YXUserModel.default.uuid ?? "") 打卡次数： \(count + 1)")
                    YYCache.set(count + 1, forKey: YXLocalKey.punchCount)
                } else {
                    YXLog("用户 \(YXUserModel.default.uuid ?? "") 打卡次数： 1")
                    YYCache.set(1, forKey: YXLocalKey.punchCount)
                }
                NotificationCenter.default.post(name: YXNotification.kReloadClassList, object: nil)
            } else {
                YXLog("打卡分享失败")
            }
        }) { (error) in
            YXUtils.showHUD(nil, title: error.message)
        }
    }
}
