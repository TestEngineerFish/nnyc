//
//  YXStepConfigManager.swift
//  YXEDU
//
//  Created by 沙庭宇 on 2020/5/21.
//  Copyright © 2020 shiji. All rights reserved.
//

import Foundation

class YXStepConfigManager {

    static let share = YXStepConfigManager()

    var hash: String {
        get {
            return (YYCache.object(forKey: "kStepConfig") as? String) ?? ""
        }

        set {
            YYCache.set(newValue, forKey: "kStepConfig")
        }
    }

    func contrastStepConfig() {
        self.requestConfig()
    }

    // MARK ==== Request ====
    private func requestConfig() {
        let request = YXExerciseRequest.stepConfig
        YYNetworkService.default.request(YYStructResponse<YXStepConfigModel>.self, request: request, success: { (response) in
            guard let model = response.data else { return }
            if model.hash != self.hash {
                YXLog("本地学习步骤混淆配置需要更新，本地Hash：", self.hash, "新Hash：", model.hash)
                YXStepConfigDaoImpl.share.updateTable(model) { (success) in
                    if success {
                        YXLog("更新本地学习步骤混淆配置成功，新Hash：", model.hash)
                        self.hash = model.hash
                    }
                }
            } else {
                YXLog("本地学习步骤混淆配置不需要更新")
            }
        }) { (error) in
            YXUtils.showHUD(kWindow, title: error.message)
        }
    }

    // MARK: ==== Tools ====

    /// 混淆单词是否在当前单词的黑名单中
    /// - Parameters:
    ///   - step: 题目步骤
    ///   - wordId: 单词ID
    ///   - otherWordId: 对比单词ID
    /// - Returns: 是否在当前单词的黑名单中
    func onBlockList(exercise step: String, wordId: Int?, otherWordId: Int?) -> Bool {
        guard let stepRange = step.textRegex(pattern: "(?<=-).*(?=-)").first else {
            return false
        }
        let _stepStr = step.substring(fromIndex: stepRange.location, length: stepRange.length)
        let _stepInt = Int(_stepStr) ?? 0
        guard let _wordId = wordId, let _otherWordId = otherWordId, let model = YXStepConfigDaoImpl.share.selecte(exercise: _stepInt, wordId: _wordId) else {
            return false
        }
        return model.wordIdList.contains(_otherWordId)
    }
}
