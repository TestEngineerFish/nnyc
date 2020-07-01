//
//  YXSelectSchoolViewController.swift
//  YXEDU
//
//  Created by 沙庭宇 on 2020/6/22.
//  Copyright © 2020 shiji. All rights reserved.
//

import Foundation

class YXSelectSchoolViewController: YXViewController, UIPickerViewDelegate, UIPickerViewDataSource, UITableViewDelegate, UITableViewDataSource {

    var contentView = YXSelectSchoolContentView()
    var searchView  = YXSearchSchoolListView()
    var pickerView  = YXSelectLocalPickView()
    var backgroundView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.black.withAlphaComponent(0.7)
        view.layer.opacity   = 0.0
        return view
    }()

    let searchViewH     = screenHeight * 0.92
    let pickerViewH     = AdaptSize(318)
    var cityList        = [YXCityModel]()
    var schoolModelList = [YXLocalModel]()
    var willSchoolModel: YXLocalModel?
    var selectSchoolModel: YXLocalModel? {
        willSet {
            self.contentView.setSelectSchool(school: newValue?.name)
        }
    }
    var selectLocalModel: YXLocalModel? {
        willSet {
            let cityIndex  = self.pickerView.pickerView.selectedRow(inComponent: 0)
            let cityModel  = self.cityList[cityIndex]
            let areaIndex  = self.pickerView.pickerView.selectedRow(inComponent: 1)
            let areaModel  = cityModel.areaList[areaIndex]
            let localIndex = self.pickerView.pickerView.selectedRow(inComponent: 2)
            let localModel = areaModel.localList[localIndex]
            let localStr   = String(format: "%@%@%@", cityModel.name, areaModel.name, localModel.name)
            self.contentView.setSelectLocal(local: localStr)
        }
        didSet {
            if selectLocalModel?.id != oldValue?.id {
                self.selectSchoolModel = nil
            }
        }
    }
    var localName: String {
        get {
            let cityIndex  = self.pickerView.pickerView.selectedRow(inComponent: 0)
            let cityModel  = self.cityList[cityIndex]
            let areaIndex  = self.pickerView.pickerView.selectedRow(inComponent: 1)
            let areaModel  = cityModel.areaList[areaIndex]
            let localIndex = self.pickerView.pickerView.selectedRow(inComponent: 2)
            let localModel = areaModel.localList[localIndex]
            return String(format: "%@%@%@", cityModel.name, areaModel.name, localModel.name)
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.createSubviews()
        self.bindProperty()
    }

    private func bindProperty() {
        self.pickerView.pickerView.delegate  = self
        self.searchView.tableView.delegate   = self
        self.searchView.tableView.dataSource = self
        let tapLocal  = UITapGestureRecognizer(target: self, action: #selector(clickLocal))
        let tapSchool = UITapGestureRecognizer(target: self, action: #selector(clickSchool))
        self.contentView.localLabel.addGestureRecognizer(tapLocal)
        self.contentView.schoolLabel.addGestureRecognizer(tapSchool)
        self.contentView.submitButton.addTarget(self, action: #selector(submitAction), for: .touchUpInside)
        self.searchView.cancelButton.addTarget(self, action: #selector(hideSelectSchoolView), for: .touchUpInside)
        self.searchView.downButton.addTarget(self, action: #selector(downSelectSchool), for: .touchUpInside)
        self.pickerView.cancelButton.addTarget(self, action: #selector(hideSelectLocalView), for: .touchUpInside)
        self.pickerView.downButton.addTarget(self, action: #selector(downSelectLocal), for: .touchUpInside)
        self.searchView.clipRectCorner(directionList: [.topLeft, .topRight], cornerRadius: AdaptSize(5))
        self.pickerView.clipRectCorner(directionList: [.topLeft, .topRight], cornerRadius: AdaptSize(5))
        self.searchView.textField.addTarget(self, action: #selector(seachSchool(_:)), for: .editingChanged)
        self.cityList.removeAll()
        do {
            let path = Bundle.main.path(forResource: "city", ofType: "json") ?? ""
            let data = try Data(contentsOf: URL(fileURLWithPath: path))
            let jsonArray = try JSONSerialization.jsonObject(with: data, options: .mutableContainers) as? Array<[String:Any]>
            jsonArray?.forEach({ (dict:[String:Any]) in
                if let cityModel = YXCityModel(JSON: dict) {
                    self.cityList.append(cityModel)
                }
            })
        } catch {
            cityList = []
        }
    }

    private func createSubviews() {
        self.view.addSubview(contentView)
        self.view.addSubview(backgroundView)
        self.view.addSubview(searchView)
        self.view.addSubview(pickerView)
        contentView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        backgroundView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        self.searchView.frame = CGRect(x: 0, y: screenHeight, width: screenWidth, height: searchViewH)
        self.pickerView.frame = CGRect(x: 0, y: screenHeight, width: screenWidth, height: pickerViewH)
    }

    // MARK: ==== Event ====
    @objc private func clickLocal() {
        UIView.animate(withDuration: 0.25) {
            self.backgroundView.layer.opacity = 1.0
            self.pickerView.transform         = CGAffineTransform(translationX: 0, y: -self.pickerViewH)
        }
    }

    @objc private func clickSchool() {
        if self.selectLocalModel == nil {
            YXUtils.showHUD(kWindow, title: "请先选择学校地址")
            return
        }
        self.searchView.tableView.reloadData()
        UIView.animate(withDuration: 0.25, animations: {
            self.backgroundView.layer.opacity = 1.0
            self.searchView.transform         = CGAffineTransform(translationX: 0, y: -self.searchViewH)
        }) { (finished) in
            if finished {
                self.searchView.textField.becomeFirstResponder()
            }
        }
    }

    @objc private func downSelectSchool() {
        self.selectSchoolModel = self.willSchoolModel
        self.searchView.textField.text = nil
        self.schoolModelList.removeAll()
        self.searchView.tableView.reloadData()
        self.hideSelectSchoolView()
    }

    @objc private func downSelectLocal() {
        let cityIndex  = self.pickerView.pickerView.selectedRow(inComponent: 0)
        let cityModel  = self.cityList[cityIndex]
        let areaIndex  = self.pickerView.pickerView.selectedRow(inComponent: 1)
        let areaModel  = cityModel.areaList[areaIndex]
        let localIndex = self.pickerView.pickerView.selectedRow(inComponent: 2)
        let localModel = areaModel.localList[localIndex]
        self.selectLocalModel = localModel
        self.hideSelectLocalView()
    }

    @objc private func hideSelectSchoolView() {
        self.searchView.textField.resignFirstResponder()
        UIView.animate(withDuration: 0.25) {
            self.backgroundView.layer.opacity = 0.0
            self.searchView.transform         = .identity
        }
    }

    @objc private func hideSelectLocalView() {
        UIView.animate(withDuration: 0.25) {
            self.backgroundView.layer.opacity = 0.0
            self.pickerView.transform         = .identity
        }
    }

    @objc private func seachSchool(_ textField: UITextField) {
        guard var school = textField.text else {
            return
        }
        self.schoolModelList.removeAll()
        self.searchView.tableView.reloadData()
        school = school.trimed
        if school != "" {
            self.searchSchool(name: school)
        }
    }

    @objc private func submitAction() {
        guard let localModel = self.selectLocalModel, let schoolModel = self.selectSchoolModel else {
            return
        }
        self.submit(schoolId: schoolModel.id, areaId: localModel.id)
    }

    func toNextView() {
        YYCache.set(false, forKey: .isShowSelectSchool)
        let storyboard = UIStoryboard(name:"Home", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "kYXAddBookGuideViewController")
        self.navigationController?.pushViewController(vc, animated: true)
    }

    // MARK: ==== Request ====
    private func searchSchool(name: String) {
        guard let model = self.selectLocalModel else {
            return
        }
        let request = YXSelectSchoolRequestManager.searchSchool(name: name, areaId: model.id)
        YYNetworkService.default.request(YYStructDataArrayResponse<YXLocalModel>.self, request: request, success: { (response) in
            guard let modelList = response.dataArray else {
                return
            }
            self.schoolModelList = modelList
            self.searchView.tableView.reloadData()
        }) { (error) in
            YXUtils.showHUD(kWindow, title: error.message)
        }
    }

    @objc private func submit(schoolId: Int, areaId: Int) {
        let request = YXSelectSchoolRequestManager.submit(schoolId: schoolId, areaId: areaId)
        YYNetworkService.default.request(YYStructResponse<YXResultModel>.self, request: request, success: { (response) in
            self.toNextView()
        }) { (error) in
            YXUtils.showHUD(kWindow, title: error.message)
        }
    }

    // MARK: ==== UIPickerViewDelegate && UIPickerViewDataSource ====
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 3
    }

    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if self.cityList.isEmpty {
            return 0
        }
        switch component {
        case 0:
            return self.cityList.count
        case 1:
            let cityModel = self.cityList[pickerView.selectedRow(inComponent: 0)]
            return cityModel.areaList.count
        case 2:
            let cityModel = self.cityList[pickerView.selectedRow(inComponent: 0)]
            let areaModel = cityModel.areaList[pickerView.selectedRow(inComponent: 1)]
            return areaModel.localList.count
        default:
            return 0
        }

    }

    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        switch component {
        case 0:
            let cityModel = self.cityList[row]
            return cityModel.name
        case 1:
            let cityIndex  = pickerView.selectedRow(inComponent: 0)
            let cityModel  = self.cityList[cityIndex]
            let areaModel  = cityModel.areaList[row]
            return areaModel.name
        case 2:
            let cityIndex  = pickerView.selectedRow(inComponent: 0)
            let cityModel  = self.cityList[cityIndex]
            let areaIndex  = pickerView.selectedRow(inComponent: 1)
            let areaModel  = cityModel.areaList[areaIndex]
            let localModel = areaModel.localList[row]
            return localModel.name
        default:
            return ""
        }
    }

    func pickerView(_ pickerView: UIPickerView, widthForComponent component: Int) -> CGFloat {
        return screenWidth / 3
    }

    func pickerView(_ pickerView: UIPickerView, rowHeightForComponent component: Int) -> CGFloat {
        return AdaptSize(47)
    }

    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if component == 0 {
            pickerView.reloadComponent(1)
            pickerView.reloadComponent(2)
        } else if component == 1 {
            pickerView.reloadComponent(2)
        }
    }
    
    // MARK: ==== UITableViewDelegate && UITableViewDataSource ====
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.schoolModelList.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "kYXSelectSchoolCell", for: indexPath) as? YXSelectSchoolCell else {
            return UITableViewCell()
        }
        let schoolModel = self.schoolModelList[indexPath.row]
        cell.setData(school: schoolModel)
        if .some(schoolModel.id) == self.selectSchoolModel?.id {
            cell.setSelected(true, animated: false)
        }
        return cell
    }

    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return UIView()
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return tableView.estimatedRowHeight
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.willSchoolModel = self.schoolModelList[indexPath.row]
    }
}
