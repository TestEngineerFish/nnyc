//
//  YXNewLearningResultViewController.swift
//  YXEDU
//
//  Created by 沙庭宇 on 2020/8/26.
//  Copyright © 2020 shiji. All rights reserved.
//

import Foundation

class YXNewLearningResultViewController: YXViewController, YXNewLearningResultViewProtocol {

    var model = YXExerciseResultDisplayModel()

    var contentView = YXNewLearningResultView()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.createSubviews()
        self.bindProperty()
        self.setData()
    }

    private func createSubviews() {
        self.view.addSubview(contentView)
        contentView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
    }

    private func bindProperty() {
        self.customNavigationBar?.isHidden = true
        self.contentView.delegate          = self
    }

    private func setData() {
        self.contentView.setData(model: model)
    }

    // MARK: ==== YXNewLearningResultViewProtocol ====
    func closedAction() {
        self.navigationController?.popViewController(animated: true)
    }

    func punchAction() {
        let vc = YXShareViewController()
        self.navigationController?.pushViewController(vc, animated: true)
    }
}
