//
//  YXLearningPathViewController.swift
//  BaseProject
//
//  Created by 沙庭宇 on 2019/11/7.
//  Copyright © 2019 沙庭宇. All rights reserved.
//

import UIKit

class YXLearnMapViewController: UIViewController {

    var mapModelList: [YXLearnMapUnitModel]?

    var backButton = UIButton()
    var leftCloud  = UIImageView()
    var rightCloud = UIImageView()
    var bookId: Int?
    var unitId: Int?

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.isNavigationBarHidden = true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.white
        self.bindData()
        self.createSubviews()
        self.startAnimation()
    }

    private func createSubviews() {
        // 打底背景
        let bgImageView = UIImageView(image: UIImage(named: "pathBg"))
        self.view.addSubview(bgImageView)
        bgImageView.snp.makeConstraints { (make) in
            make.height.equalTo(AdaptSize(358))
            make.left.right.equalToSuperview()
            make.centerY.equalToSuperview()
        }
        // 返回按钮
        backButton.setImage(UIImage(named: "back"), for: .normal)
        self.view.addSubview(backButton)
        backButton.snp.makeConstraints { (make) in
            make.left.equalToSuperview().offset(AdaptSize(16))
            make.top.equalToSuperview().offset(AdaptSize(40))
            make.width.height.equalTo(AdaptSize(22))
        }
        backButton.addTarget(self, action: #selector(backClick), for: .touchUpInside)
        // 左边的云
        leftCloud = UIImageView(image: UIImage(named: "cloudLeft"))
        self.view.addSubview(leftCloud)
        leftCloud.snp.makeConstraints { (make) in
            make.left.equalToSuperview()
            make.top.equalToSuperview().offset(AdaptSize(76))
            make.width.equalTo(AdaptSize(54))
            make.height.equalTo(AdaptSize(35))
        }
        // 右边的云
        rightCloud = UIImageView(image: UIImage(named: "cloudRight"))
        self.view.addSubview(rightCloud)
        rightCloud.snp.makeConstraints { (make) in
            make.right.equalToSuperview()
            make.centerY.equalToSuperview().offset(AdaptSize(96))
            make.width.equalTo(AdaptSize(36))
            make.height.equalTo(AdaptSize(24))
        }
        // 底部的树
        let treeImageView = UIImageView(image: UIImage(named: "pathTree"))
        self.view.addSubview(treeImageView)
        treeImageView.snp.makeConstraints { (make) in
            make.bottom.left.right.equalToSuperview()
            make.height.equalTo(AdaptSize(103))
        }
    }

    /// 设置学习地图
    private func createMapView() {
        guard let modelList = self.mapModelList else {
            return
        }
        // 学习路径
        let learningPath = LearningMapView(units: modelList, frame: self.view.bounds, unitId: unitId)
        learningPath.learnNewUnit = { (unitId: Int?) -> Void in
            guard let id = unitId else {
                return
            }
            self.learnUnit(id)
        }
        self.view.addSubview(learningPath)
        self.view.bringSubviewToFront(backButton)
        learningPath.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
    }

    @objc private func backClick() {
        self.navigationController?.popViewController(animated: true)
    }


    private func bindData() {
        guard let _bookId = self.bookId else {
            return
        }
        let request = YXExerciseRequest.learnMap(bookId: _bookId)
        YYNetworkService.default.httpRequestTask(YYStructDataArrayResponse<YXLearnMapUnitModel>.self, request: request, success: { (response) in
            self.mapModelList = response.dataArray
            self.createMapView()
        }) { (error) in
            YXUtils.showHUD(self.view, title: "\(error)")
        }
    }

    /// 学习新单元
    private func learnUnit(_ unitId: Int) {
        guard let uuidStr = YXUserModel.default.uuid, let bookId = self.bookId else {
            return
        }
        let request = YXExerciseRequest.addUserBook(userId: uuidStr, bookId: bookId, unitId: unitId)
        YYNetworkService.default.httpRequestTask(YYStructResponse<YXLearnResultModel>.self, request: request, success: { (response) in
            print("学习新单元成功")
        }) { (error) in
            YXUtils.showHUD(self.view, title: "\(error)")
        }
    }

    // TODO: Animation

    private func startAnimation() {
        let leftAnimation = CABasicAnimation(keyPath: "position.x")
        leftAnimation.fromValue      = leftCloud.frame.origin.x
        leftAnimation.toValue        = leftCloud.frame.origin.x + 90
        leftAnimation.duration       = 8
        leftAnimation.timingFunction = CAMediaTimingFunction(name: .linear)
        leftAnimation.repeatCount    = MAXFLOAT
        leftAnimation.autoreverses   = true
        leftCloud.layer.add(leftAnimation, forKey: "leftAnimation")

        let rightAnimation = CABasicAnimation(keyPath: "position.x")
        rightAnimation.fromValue      = screenWidth - AdaptSize(26)
        rightAnimation.toValue        = screenWidth - AdaptSize(26) - AdaptSize(90)
        rightAnimation.duration       = 8
        rightAnimation.timingFunction = CAMediaTimingFunction(name: .linear)
        rightAnimation.repeatCount    = MAXFLOAT
        rightAnimation.autoreverses   = true
        rightCloud.layer.add(rightAnimation, forKey: "rightAnimation")
    }
}
