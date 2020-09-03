//
//  YXWebActionManager.swift
//  YXEDU
//
//  Created by 沙庭宇 on 2020/7/13.
//  Copyright © 2020 shiji. All rights reserved.
//

import Foundation

@objc
class YXWebActionManager: NSObject {
    @objc static let share = YXWebActionManager()

    @objc
    func progressWXReq(extion info: String) {
        guard let model = YXWXWebModel(JSONString: info) else {
            return
        }
        // 状态拦截
        guard YXUserModel.default.didLogin, (YYCache.object(forKey: .isShowSelectSchool) as? Bool) == .some(false), (YYCache.object(forKey: .isShowSelectBool) as? Bool) == .some(false) else {
            YXLog("状态拦截")
            return
        }
        // 页面拦截
        guard let currentVC = YRRouter.sharedInstance().currentViewController(), !currentVC.isKind(of: YXBindPhoneViewController.classForCoder()), !currentVC.isKind(of: YXExerciseViewController.classForCoder()) else {
            YXLog("页面拦截")
            return
        }
        switch model.action {
        case "join_class":
            let classNumber = model.params
            let descriptionStr: String = {
                if model.teacherName.isEmpty {
                    return "是否确认加入班级"
                } else {
                    return "是否加入\(model.teacherName)老师创建的班级：\(model.name)"
                }
            }()
            self.showAlert(title: "加入班级", description: descriptionStr, downTitle: "加入") {
                // 加入班级
                YXUserDataManager.share.joinClass(code: classNumber) { [weak self] (workModel) in
                    self?.toVC(scheme: model.scheme)
                }
            }
            break
        case "add_work":
            let descriptionStr: String = {
                if model.teacherName.isEmpty {
                    return "是否确认提取作业"
                } else {
                    return "\(model.teacherName)老师布置了作业：\(model.name)，赶紧去完成吧"
                }
            }()
            self.showAlert(title: "提取作业", description: descriptionStr, downTitle: "去做作业") { [weak self] in
                guard let self = self else { return }
                let workCode = model.params
                let request = YXHomeRequest.pickUpWork(code: workCode)
                // 添加作业
                YYNetworkService.default.request(YYStructResponse<YXMyWorkModel>.self, request: request, success: { [weak self] (response) in
                    guard let self = self, let _workModel = response.data else { return }
                    YXLog(String(format: "==== 提取作业 开始做%@，作业ID：%ld ====", _workModel.type.learnType().desc, _workModel.workId ?? 0))
                    if _workModel.isFirstJoin {
                        let vc = YXMyClassEditNameViewController()
                        vc.submitBlock = { [weak self] result in
                            self?.toExerciseVC(model: _workModel)
                        }
                        vc.classModel  = self.transformToSummaryModel(model: _workModel)
                        YRRouter.sharedInstance().currentNavigationController()?.pushViewController(vc, animated: true)
                    } else {
                        self.toExerciseVC(model: _workModel)
                    }
                }) { (error) in
                    YXUtils.showHUD(nil, title: error.message)
                }
            }
        case "make_team":
            self.addFriend(user: model.params, channel: model.channel, complete: nil)
            break
            
        default:
            break
        }
    }

    // MARK: ==== Event ====
    private func toVC(scheme: String) {
        switch scheme {
        case "/class/list":
            if YRRouter.sharedInstance().currentViewController()?.isKind(of: YXMyClassViewController.classForCoder()) == .some(false) {
                let vc = YXMyClassViewController()
                YRRouter.sharedInstance().currentNavigationController()?.pushViewController(vc, animated: true)
            }
        case "/activity/detail":
            if YRRouter.sharedInstance().currentViewController()?.isKind(of: YXWebViewController.classForCoder()) == .some(false) {
                let vc = YXWebViewController()
                YRRouter.sharedInstance().currentNavigationController()?.pushViewController(vc, animated: true)
            }
        default:
            break
        }
    }

    private func toExerciseVC(model: YXMyWorkModel) {
        if model.type == .punch {
            let dataList = self.getBookHashDic(model)
            YXWordBookResourceManager.shared.saveReviewPlan(dataList: dataList, type: .homework)
        }
        // 跳转学习
        let vc         = YXExerciseViewController()
        let bookId     = (model.type == .punch) ? (model.bookIdList.first ?? 0) : 0
        let unitId     = model.type == .punch ? model.unitId : 0
        let learnType  = model.type.learnType()
        vc.learnConfig = YXLearnConfigImpl(bookId: bookId, unitId: unitId, planId: 0, learnType: learnType, homeworkId: model.workId ?? 0)
        YRRouter.sharedInstance().currentNavigationController()?.pushViewController(vc, animated: true)
    }

    private func addFriend(user id: String, channel: Int, complete block: (()->Void)?) {
        guard let userId = Int(id) else {
            return
        }
        let request = YXHomeRequest.addFriend(id: userId, channel: channel)
        YYNetworkService.default.request(YYStructResponse<YXResultModel>.self, request: request, success: { (response) in
            YXLog("添加好友成功")
            block?()
        }) { (error) in
            YXUtils.showHUD(nil, title: error.message)
        }
    }

    private func showAlert(title: String, description: String, downTitle: String, finished: (()->Void)?) {
        let alertView = YXAlertView()
        alertView.titleLabel.text       = title
        alertView.descriptionLabel.text = description
        alertView.rightOrCenterButton.setTitle(downTitle, for: .normal)
        alertView.doneClosure = { _ in
            finished?()
        }
        YXAlertQueueManager.default.addAlert(alertView: alertView)
    }

    // MARK: ==== Tools ====
    private func getBookHashDic(_ model: YXMyWorkModel) -> [(Int, String)] {
        var bookHash = [(Int, String)]()
        model.bookIdList.forEach { (bookId) in
            if let hash = model.bookHash["\(bookId)"] {
                bookHash.append((bookId,hash))
            }
        }
        return bookHash
    }

    private func transformToSummaryModel(model: YXMyWorkModel) -> YXMyClassSummaryModel {
        var summaryModel = YXMyClassSummaryModel()
        summaryModel.classId     = model.classId ?? 0
        summaryModel.className   = model.className
        summaryModel.teacherName = model.teacherName ?? ""
        summaryModel.isFirstJoin = model.isFirstJoin
        return summaryModel
    }
}
