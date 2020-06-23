//
//  YXSelectLocalPickView.swift
//  YXEDU
//
//  Created by 沙庭宇 on 2020/6/22.
//  Copyright © 2020 shiji. All rights reserved.
//

import Foundation

class YXSelectLocalPickView: YXView, UIPickerViewDelegate, UIPickerViewDataSource {
    var cancelButton: UIButton = {
        let button = UIButton()
        button.setTitle("取消", for: .normal)
        button.setTitleColor(UIColor.hex(0x999999), for: .normal)
        button.titleLabel?.font = UIFont.regularFont(ofSize: AdaptFontSize(15))
        return button
    }()
    var titleLabel: UILabel = {
        let label = UILabel()
        label.text          = "选择地址"
        label.textColor     = UIColor.black1
        label.font          = UIFont.mediumFont(ofSize: AdaptFontSize(16))
        label.textAlignment = .center
        return label
    }()
    var downButton: UIButton = {
        let button = UIButton()
        button.setTitle("确认", for: .normal)
        button.setTitleColor(UIColor.blue2, for: .normal)
        button.titleLabel?.font = UIFont.regularFont(ofSize: AdaptFontSize(15))
        return button
    }()
    var lineView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.black4
        return view
    }()
    var pickerView: UIPickerView = {
        let pickerView = UIPickerView()
        return pickerView
    }()

    var cityList = [YXCityModel]()

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.bindProperty()
        self.createSubviews()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func bindProperty() {
        super.bindProperty()
        self.backgroundColor     = .white
        self.pickerView.delegate = self
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

    override func createSubviews() {
        super.createSubviews()
        self.addSubview(cancelButton)
        self.addSubview(titleLabel)
        self.addSubview(downButton)
        self.addSubview(lineView)
        self.addSubview(pickerView)
        titleLabel.sizeToFit()
        titleLabel.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.top.equalToSuperview().offset(AdaptSize(13))
            make.size.equalTo(titleLabel.size)
        }
        cancelButton.snp.makeConstraints { (make) in
            make.left.equalToSuperview().offset(AdaptSize(15))
            make.centerY.equalTo(titleLabel)
            make.size.equalTo(CGSize(width: AdaptSize(40), height: AdaptSize(30)))
        }
        downButton.snp.makeConstraints { (make) in
            make.centerY.equalTo(titleLabel)
            make.right.equalToSuperview().offset(-15)
            make.size.equalTo(CGSize(width: AdaptSize(40), height: AdaptSize(30)))
        }
        lineView.snp.makeConstraints { (make) in
            make.left.right.equalToSuperview()
            make.height.equalTo(AdaptSize(0.5))
            make.top.equalToSuperview().offset(AdaptSize(48))
        }
        pickerView.snp.makeConstraints { (make) in
            make.left.bottom.right.equalToSuperview()
            make.top.equalTo(lineView.snp.bottom)
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
            self.pickerView.reloadComponent(1)
            self.pickerView.reloadComponent(2)
        } else if component == 1 {
            self.pickerView.reloadComponent(2)
        }
        YXLog(row)
    }
}
