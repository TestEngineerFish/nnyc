//
//  YXSelectSchoolViewController.swift
//  YXEDU
//
//  Created by 沙庭宇 on 2020/6/22.
//  Copyright © 2020 shiji. All rights reserved.
//

import Foundation

class YXSelectSchoolViewController: YXViewController, YXSelectLocalPickerViewProtocol, YXSearchSchoolDelegate {

    var contentView = YXSelectSchoolContentView()
    var searchView  = YXSearchSchoolListView(type: .normal)
    var pickerView  = YXSelectLocalPickView(type: .normal)
    var selectSchoolModel: YXLocalModel?
    var selectLocalModel: YXLocalModel? {
        didSet {
            if selectLocalModel?.id != oldValue?.id {
                self.selectSchoolModel = nil
                self.selectSchool(school: nil)
            }
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.createSubviews()
        self.bindProperty()
    }

    deinit {
        self.pickerView.removeFromSuperview()
        self.searchView.removeFromSuperview()
    }

    private func bindProperty() {
        self.pickerView.delegate = self
        self.searchView.delegate = self
        let tapLocal  = UITapGestureRecognizer(target: self, action: #selector(clickLocal))
        let tapSchool = UITapGestureRecognizer(target: self, action: #selector(clickSchool))
        self.contentView.localLabel.addGestureRecognizer(tapLocal)
        self.contentView.schoolLabel.addGestureRecognizer(tapSchool)
        self.contentView.submitButton.addTarget(self, action: #selector(submitAction), for: .touchUpInside)
    }

    private func createSubviews() {
        self.view.addSubview(contentView)
        self.view.addSubview(searchView)
        self.view.addSubview(pickerView)
        contentView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
    }

    // MARK: ==== Event ====
    @objc private func clickLocal() {
        self.pickerView.show()
    }

    @objc private func clickSchool() {
        guard let model = self.selectLocalModel else {
            YXUtils.showHUD(kWindow, title: "请先选择学校地址")
            return
        }
        self.searchView.show(selectLocal: model)
    }

    @objc private func submitAction() {
        guard let localModel = self.selectLocalModel, let schoolModel = self.selectSchoolModel else {
            return
        }
        self.submit(schoolId: schoolModel.id, areaId: localModel.id)
    }

    func toNextView() {
        YYCache.set(false, forKey: .isShowSelectSchool)
        if (YYCache.object(forKey: .isShowSelectBool) as? Bool) == .some(true) {
            let storyboard = UIStoryboard(name:"Home", bundle: nil)
            let vc = storyboard.instantiateViewController(withIdentifier: "kYXAddBookGuideViewController")
            self.navigationController?.pushViewController(vc, animated: true)
        } else {
            self.navigationController?.popToRootViewController(animated: true)
        }
    }

    // MARK: ==== Request ====

    @objc private func submit(schoolId: Int, areaId: Int) {
        let request = YXSelectSchoolRequestManager.submit(schoolId: schoolId, areaId: areaId)
        YYNetworkService.default.request(YYStructResponse<YXResultModel>.self, request: request, success: { (response) in
            self.toNextView()
        }) { (error) in
            YXUtils.showHUD(kWindow, title: error.message)
        }
    }

    // MARK: ==== YXSelectLocalPickerViewProtocol ====
    func selectedLocal(local model: YXLocalModel, name: String) {
        self.contentView.setSelectLocal(local: name)
        self.selectLocalModel = model
    }

    // MARK: ==== YXSearchSchoolDelegate ====
    func selectSchool(school model: YXLocalModel?) {
        self.contentView.setSelectSchool(school: model?.name)
        self.selectSchoolModel = model
    }
}
