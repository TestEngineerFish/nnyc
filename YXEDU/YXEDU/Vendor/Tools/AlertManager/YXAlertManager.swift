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

    func showAddClassOrHomeworkAlert(onlyClass:Bool = false, onlyHomework: Bool = false, _ block:((String?)->Void)?) {
        var titleText  = "请输入班级号或作业提取码"
        var placeholder = "输入班级号或作业提取码"
        if onlyClass {
            titleText = "请输入班级号"
            placeholder = "输入班级号"
        }
        if onlyHomework {
            titleText = "请输入作业提取码"
            placeholder = "输入作业提取码"
        }
        let alertView = YXAlertView(type: .inputable, placeholder: placeholder)
        alertView.titleLabel.text = titleText
        alertView.shouldOnlyShowOneButton = false
        alertView.shouldClose             = false
        alertView.clearButton.isHidden    = true
        alertView.textCountLabel.isHidden = true
        alertView.textMaxLabel.isHidden   = true
        alertView.alertHeight.constant    = 222
        alertView.doneClosure             = { (text: String?) in
            block?(text)
            alertView.removeFromSuperview()
        }
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
