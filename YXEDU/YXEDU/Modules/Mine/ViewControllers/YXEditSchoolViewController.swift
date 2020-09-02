//
//  YXEditSchoolViewController.swift
//  YXEDU
//
//  Created by 沙庭宇 on 2020/8/25.
//  Copyright © 2020 shiji. All rights reserved.
//

import Foundation

class YXEditSchoolViewController: YXViewController, YXEditSchoolViewProtocol, YXSearchSchoolDelegate, YXSelectLocalPickerViewProtocol {

    var schoolInfoModel: YXSchoolInfoModel?
    
    var contentView      = YXEditSchoolView()
    let selectLocalView  = YXSelectLocalPickView()
    let selectSchollView = YXSearchSchoolListView()


    override func viewDidLoad() {
        super.viewDidLoad()
        self.createSubviews()
        self.bindProperty()
    }

    private func createSubviews() {
        self.view.addSubview(contentView)
        contentView.snp.makeConstraints { (make) in
            make.left.right.bottom.equalToSuperview()
            make.top.equalToSuperview().offset(kNavHeight)
        }
    }

    private func bindProperty() {
        self.contentView.delegate       = self
        self.selectLocalView.delegate   = self
        self.selectSchollView.delegate  = self
        let cityName = self.getCityName()
        if let model = self.schoolInfoModel, !model.schoolName.isEmpty, !cityName.isEmpty, let localModel = YXLocalModel(JSON: ["id" : model.cityId]), let schoolModel = YXLocalModel(JSON: ["id" : model.schoolId, "name" : model.schoolName]) {
            self.customNavigationBar?.title = "修改学校信息"
            self.selectedLocal(local: localModel, name: cityName)
            self.selectSchool(school: schoolModel)
        } else {
            self.customNavigationBar?.title = "补充学校信息"
        }
    }

    // MARK: ==== Request ====
    private func requestUploadSchoolInfo() {
        guard let model = self.schoolInfoModel else { return }
        let request = YXMineRequest.updateSchoolInfo(schoolId: model.schoolId, cityId: model.cityId, schoolName: model.schoolName)
        YYNetworkService.default.request(YYStructResponse<YXResultModel>.self, request: request, success: { [weak self] (response) in
            guard let self = self else { return }
            YXUtils.showHUD(kWindow, title: "学校信息更新成功")
            self.navigationController?.popViewController(animated: true)
        }) { (error) in
            YXUtils.showHUD(nil, title: error.message)
        }
    }

    // MARK: ==== Tools ====
    private func getCityName() -> String {
        var cityName = ""
        if let localId = self.schoolInfoModel?.cityId, let cityPath = Bundle.main.path(forResource: "city", ofType: "json") {
            do {
                let data = try Data(contentsOf: URL(fileURLWithPath: cityPath))
                let jsonArray = try JSONSerialization.jsonObject(with: data, options: .mutableContainers) as? Array<[String:Any]>
                jsonArray?.forEach({ (dict:[String:Any]) in
                    if let cityModel = YXCityModel(JSON: dict) {
                        cityModel.areaList.forEach { (areaModel) in
                            areaModel.localList.forEach { (localModel) in
                                if localModel.id == localId {
                                    cityName = cityModel.name + areaModel.name + localModel.name
                                }
                            }
                        }
                    }
                })
            } catch {}
        }
        return cityName
    }

    // MARK: ==== YXEditSchoolViewProtocol ====
    func selectSchoolLocal() {
        self.selectLocalView.show()
    }

    func selectShcoolName() {
        guard let localModel = self.contentView.localModel else {
            YXUtils.showHUD(self.view, title: "请先选择地区")
            return
        }
        self.selectSchollView.show(selectLocal: localModel)
    }

    func submitAction() {
        self.requestUploadSchoolInfo()
    }

    // MARK: ==== YXSelectLocalPickerViewProtocol ====
    func selectedLocal(local model:YXLocalModel, name: String) {
        if self.contentView.localModel?.id != .some(model.id) {
            self.selectSchool(school: nil)
        }
        self.contentView.localModel           = model
        self.contentView.localLabel.text      = name
        self.contentView.localLabel.textColor = .black1
        self.schoolInfoModel?.cityId          = model.id
    }

    // MARK: ==== YXSearchSchoolDelegate ====
    func selectSchool(school model: YXLocalModel?) {
        if model == nil {
            self.contentView.nameLabel.text      = "请选择学校名称"
            self.contentView.nameLabel.textColor = UIColor.black6
            self.contentView.doneButton.setStatus(.disable)
        } else {
            self.contentView.nameLabel.text      = model?.name
            self.contentView.nameLabel.textColor = UIColor.black1
            self.contentView.doneButton.setStatus(.normal)
            self.schoolInfoModel?.schoolName     = model?.name ?? ""
            self.schoolInfoModel?.schoolId       = model?.id ?? 0
        }
    }
}
