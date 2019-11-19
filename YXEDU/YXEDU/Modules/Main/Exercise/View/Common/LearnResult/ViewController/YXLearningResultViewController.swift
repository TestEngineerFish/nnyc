//
//  YXLearningResultViewController.swift
//  BaseProject
//
//  Created by 沙庭宇 on 2019/11/9.
//  Copyright © 2019 沙庭宇. All rights reserved.
//

import UIKit


class YXLearningResultViewController: UIViewController {

    var backButton = UIButton()
    var punchButton = YXButton()
    var mapModelList: [YXLearnMapUnitModel]? // 总单元
    var currentModel: YXLearnMapUnitModel? // 当前单元
    var homeModel:YXHomeModel?
    var requestCount = 0

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.isNavigationBarHidden = true
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.white
        self.bindData()
    }

    private func createSubviews() {
        // 返回按钮
        backButton.setImage(UIImage(named: "back"), for: .normal)
        self.view.addSubview(backButton)
        backButton.snp.makeConstraints { (make) in
            make.left.equalToSuperview().offset(AdaptSize(16))
            make.top.equalToSuperview().offset(AdaptSize(32))
            make.width.height.equalTo(AdaptSize(22))
        }
        backButton.addTarget(self, action: #selector(backClick), for: .touchUpInside)

        guard let _currentModel = self.currentModel, let _homeModel = self.homeModel else {
            return
        }

        // 结果视图
        let headerView = YXLearningResultHeaderView(_currentModel, homdModel: _homeModel)
        self.view.addSubview(headerView)
        headerView.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.height.equalTo(AdaptSize(244))
            make.width.equalToSuperview()
            make.top.equalToSuperview().offset(kNavHeight)
        }

        // 打卡按钮
        let punchSize = CGSize(width: screenWidth - AdaptSize(100), height: AdaptSize(42))
        punchButton.setTitle("打卡", for: .normal)
        punchButton.setTitleColor(UIColor.white, for: .normal)
        punchButton.size = punchSize
        punchButton.cornerRadius = punchButton.size.height/2
        punchButton.layer.setGradient(colors: [UIColor.hex(0xFDBA33), UIColor.hex(0xFB8417)], direction: .vertical)
        punchButton.addTarget(self, action: #selector(punchEvent), for: .touchUpInside)
        self.view.addSubview(punchButton)
        punchButton.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.bottom.equalToSuperview().offset(-30 - kSafeBottomMargin)
            make.size.equalTo(punchSize)
        }
    }

    /// 设置任务地图
    private func createTaskMap() {
        guard let modelArray = self.mapModelList else {
            return
        }
        // 任务地图视图
        let taskMapViewSize = CGSize(width: AdaptSize(307), height: AdaptSize(245))
        let taskMapFrame    = CGRect(origin: CGPoint.zero, size: taskMapViewSize)
        let taskMapView     = YXTaskMapView(modelArray, frame: taskMapFrame, currentModel: currentModel)
        taskMapView.learnNewUnit = { (unitId: Int?) -> Void in
            guard let id = unitId else {
                return
            }
            self.learnUnit(id)
        }
        taskMapView.backgroundColor    = UIColor.white
        taskMapView.layer.cornerRadius = 6
        self.view.addSubview(taskMapView)
        taskMapView.snp.makeConstraints { (make) in
            make.top.equalToSuperview().offset(kNavHeight + AdaptSize(300))
            make.size.equalTo(taskMapViewSize)
            make.centerX.equalToSuperview()
        }
        taskMapView.layer.setDefaultShadow()

        let taskMapLabel = UILabel()
        taskMapLabel.text = "任务地图"
        taskMapLabel.font = UIFont.regularFont(ofSize: 12)
        taskMapLabel.textColor = UIColor.hex(0xFBA217)
        self.view.addSubview(taskMapLabel)
        taskMapLabel.snp.makeConstraints { (make) in
            make.bottom.equalTo(taskMapView.snp.top).offset(-7)
            make.left.equalTo(taskMapView)
            make.width.equalTo(48)
            make.height.equalTo(12)
        }
    }

    private func bindData() {
        guard let model = self.homeModel, let bookId = model.bookId, let unitId = model.unitId else {
            return
        }
        let request = YXExerciseRequest.learnResult(bookId: bookId, unitId: unitId)
        YYNetworkService.default.httpRequestTask(YYStructResponse<YXLearnResultModel>.self, request: request, success: { (response) in
            // 如果后台还在计算,则重新请求
            if response.data?.countStatus == .some(.ing) {
                // 如果请求次数超过五次,则退出
                if self.requestCount >= 5 {
                    YXUtils.showHUD(self.view, title: "后台繁忙,请稍后重试")
                } else {
                    self.requestCount += 1
                    self.bindData()
                }
            } else {
                self.mapModelList = response.data?.unitList
                self.currentModel = self.mapModelList?.filter({ (model) -> Bool in
                    return model.unitID == unitId
                    }).first
                self.createSubviews()
                self.createTaskMap()
            }
        }) { (error) in
            YXUtils.showHUD(self.view, title: "\(error)")
        }
    }

    /// 学习新单元
    private func learnUnit(_ unitId: Int) {
        guard let model = self.homeModel, let bookId = model.bookId, let unitId = model.unitId else {
            return
        }
        let request = YXExerciseRequest.addUserBook(userId: 0, bookId: bookId, unitId: unitId)
        YYNetworkService.default.httpRequestTask(YYStructResponse<YXLearnResultModel>.self, request: request, success: { (response) in
            print("学习新单元成功")
        }) { (error) in
            YXUtils.showHUD(self.view, title: "\(error)")
        }
    }

    // MARK: Event

    @objc private func backClick() {
        self.navigationController?.popViewController(animated: true)
    }

    @objc private func punchEvent() {
        //        let vc = YXLearnMapViewController()
        //        self.navigationController?.pushViewController(vc, animated: true)
        //        self.hidesBottomBarWhenPushed = false
    }
}
