//
//  YXHomeworkDetailViewController.swift
//  YXEDU
//
//  Created by 沙庭宇 on 2020/8/18.
//  Copyright © 2020 shiji. All rights reserved.
//

import Foundation

class YXHomeworkDetailViewController: YXViewController, YXHomeworkDetailViewProperty {

    var workModel: YXMyWorkModel?
    var hashDic: [String:String] = [:]
    var detailModel: YXHomeworkDetailModel? {
        didSet {
            guard let model = detailModel else {
                return
            }
            self.contentView.setDate(model: model)
        }
    }

    var contentView = YXHomeworkDetailView()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.createSubviews()
        self.bindProperty()
        self.requestData()
    }

    private func createSubviews() {
        self.view.addSubview(contentView)
        contentView.snp.makeConstraints { (make) in
            make.left.right.bottom.equalToSuperview()
            make.top.equalToSuperview().offset(kNavHeight)
        }
    }

    private func bindProperty() {
        self.customNavigationBar?.title = "作业详情"
        self.contentView.delegate = self
    }

    private func requestData() {
        guard let id = self.workModel?.workId else { return }
        let request = YXMyClassRequestManager.workDetail(id: id)
        YXUtils.showHUD(self.view)
        YYNetworkService.default.request(YYStructResponse<YXHomeworkDetailModel>.self, request: request, success: { [weak self] (response) in
            guard let self = self else { return }
            YXUtils.hideHUD(self.view)
            self.detailModel = response.data
        }) { [weak self] (error) in
            guard let self = self else { return }
            YXUtils.hideHUD(self.view)
        }
    }

    // MARK: ==== YXHomeworkDetailViewProperty ====

    func showWordList() {
        let vc = YXHomeworkWordListViewController()
        vc.wordModelList = self.detailModel?.wordModelList ?? []
        vc.bookName      = self.detailModel?.bookName ?? ""
        self.navigationController?.present(vc, animated: true, completion: nil)
    }

    func downAction() {
        guard let model = self.detailModel else {
            return
        }
        let exerciseStatusList: [YXExerciseWorkStatusTypes] = [.unexpiredUnfinished,
                                                               .beExpiredUnfinished]
        let checkReport: [YXExerciseWorkStatusTypes] = [.unexpiredFinished, .beExpiredFinished]
        // 已完成
        if model.type == .punch {
            if model.punchStatus == .unexpiredLearnedUnshare {
                self.punch()
            } else {
                self.startExercise(learn: .homeworkPunch)
            }
        } else {
            if checkReport.contains(model.otherStatus) {
                // 查看报告
                let vc = YXMyClassWorkReportViewController()
                vc.workId = self.workModel?.workId
                YRRouter.sharedInstance().currentNavigationController()?.pushViewController(vc, animated: true)
            } else if exerciseStatusList.contains(model.otherStatus) {
                // 做、补作业
                if model.type == .listen {
                    self.startExercise(learn: .homeworkListen)
                } else {
                    self.startExercise(learn: .homeworkWord)
                }

            }
        }
    }

    // MARK: ==== Event ====
    /// 去打卡
    private func punch() {
        guard let model = self.workModel else {
            return
        }
        // 打卡分享
        let shareVC = YXShareViewController()
        shareVC.bookId      = model.bookIdList.first ?? 0
        shareVC.learnType   = model.type.learnType()
        shareVC.shareType   = .learnResult
        shareVC.wordsAmount = model.studyWordCount
        shareVC.daysAmount  = model.studyDayCount
        YRRouter.sharedInstance().currentNavigationController()?.pushViewController(shareVC, animated: true)
    }

    /// 开始学习
    private func startExercise(learn type: YXLearnType) {
        guard let model = self.workModel, let workId = model.workId else {
            return
        }
        YXLog(String(format: "==== 开始做%@，作业ID：%ld ====", type.desc, workId))
        let dataList = self.getBookHashDic()
        YXWordBookResourceManager.shared.saveReviewPlan(dataList: dataList, type: .homework)

        // 跳转学习
        let vc = YXExerciseViewController()
        let bookId = type == .homeworkPunch ? (model.bookIdList.first ?? 0) : 0
        let unitId = type == .homeworkPunch ? model.unitId : 0
        vc.learnConfig = YXLearnConfigImpl(bookId: bookId, unitId: unitId, planId: 0, learnType: type, homeworkId: workId)
        YRRouter.sharedInstance().currentNavigationController()?.pushViewController(vc, animated: true)
    }

    private func getBookHashDic() -> [(Int, String)] {
        var bookHash = [(Int, String)]()
        guard let model = self.workModel else {
            return bookHash
        }
        model.bookIdList.forEach { (bookId) in
            if let hash = self.hashDic["\(bookId)"] {
                bookHash.append((bookId,hash))
            }
        }
        return bookHash
    }

}
