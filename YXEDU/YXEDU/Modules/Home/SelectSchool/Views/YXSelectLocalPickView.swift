//
//  YXSelectLocalPickView.swift
//  YXEDU
//
//  Created by 沙庭宇 on 2020/6/22.
//  Copyright © 2020 shiji. All rights reserved.
//

import Foundation

protocol YXSelectLocalPickerViewProtocol: NSObjectProtocol {
    func selectedLocal(local model:YXLocalModel, name: String)
}

class YXSelectLocalPickView: YXView, UIPickerViewDelegate, UIPickerViewDataSource {
    var citiesArray = [YXCityModel]()  // 省
    var areasArray  = [YXAreaModel]()  // 市
    var localsArray = [YXLocalModel]() // 区
    weak var delegate: YXSelectLocalPickerViewProtocol?

    var localName: String {
        get {
            let cityIndex  = self.pickerView.selectedRow(inComponent: 0)
            let cityModel  = self.citiesArray[cityIndex]
            let areaIndex  = self.pickerView.selectedRow(inComponent: 1)
            let areaModel  = self.areasArray[areaIndex]
            let localIndex = self.pickerView.selectedRow(inComponent: 2)
            let localModel = self.localsArray[localIndex]
            return String(format: "%@%@%@", cityModel.name, areaModel.name, localModel.name)
        }
    }

    var backgroundView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.black.withAlphaComponent(0.7)
        view.layer.opacity   = 0.0
        return view
    }()
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
        pickerView.isMultipleTouchEnabled = false
        return pickerView
    }()

    init() {
        let _frame = CGRect(x: 0, y: screenHeight, width: screenWidth, height: AdaptSize(318))
        super.init(frame: _frame)
        self.bindProperty()
        self.createSubviews()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func bindProperty() {
        super.bindProperty()
        self.backgroundColor       = .white
        self.pickerView.delegate   = self
        self.pickerView.dataSource = self
        self.citiesArray.removeAll()
        do {
            let path = Bundle.main.path(forResource: "city", ofType: "json") ?? ""
            let data = try Data(contentsOf: URL(fileURLWithPath: path))
            let jsonArray = try JSONSerialization.jsonObject(with: data, options: .mutableContainers) as? Array<[String:Any]>
            jsonArray?.forEach({ (dict:[String:Any]) in
                if let cityModel = YXCityModel(JSON: dict) {
                    self.citiesArray.append(cityModel)
                }
            })
        } catch {
            self.citiesArray = []
        }
        self.areasArray  = self.citiesArray.first?.areaList ?? []
        self.localsArray = self.areasArray.first?.localList ?? []
        self.cancelButton.addTarget(self, action: #selector(hide), for: .touchUpInside)
        self.downButton.addTarget(self, action: #selector(downSelectLocal), for: .touchUpInside)
        self.clipRectCorner(directionList: [.topLeft, .topRight], cornerRadius: AdaptSize(5))
    }

    override func createSubviews() {
        super.createSubviews()
        kWindow.addSubview(self.backgroundView)
        kWindow.addSubview(self)
        self.addSubview(cancelButton)
        self.addSubview(titleLabel)
        self.addSubview(downButton)
        self.addSubview(lineView)
        self.addSubview(pickerView)
        self.backgroundView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
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

    // MARK: ==== Event ====
    func show() {
        UIView.animate(withDuration: 0.25) { [weak self] in
            guard let self = self else { return }
            self.backgroundView.layer.opacity = 1.0
            self.transform = CGAffineTransform(translationX: 0, y: -self.height)
        }
    }

    @objc func hide() {
        UIView.animate(withDuration: 0.25) { [weak self] in
            guard let self = self else { return }
            self.backgroundView.layer.opacity = 0.0
            self.transform = .identity
        }
    }

    @objc private func downSelectLocal() {
        let localIndex = self.pickerView.selectedRow(inComponent: 2)
        let localModel = self.localsArray[localIndex]
        self.delegate?.selectedLocal(local: localModel, name: self.localName)
        self.hide()
    }

    // MARK: ==== UIPickerViewDelegate && UIPickerViewDataSource ====
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 3
    }

    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if self.citiesArray.isEmpty {
            return 0
        }
        switch component {
        case 0:
            return self.citiesArray.count
        case 1:
            return self.areasArray.count
        case 2:
            return self.localsArray.count
        default:
            return 0
        }
    }

    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        switch component {
        case 0:
            let cityModel = self.citiesArray[row]
            return cityModel.name
        case 1:
            let areaModel = self.areasArray[row]
            return areaModel.name
        case 2:
            let localModel = self.localsArray[row]
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
            if row < self.citiesArray.count {
                self.areasArray = self.citiesArray[row].areaList
                pickerView.reloadComponent(1)
                if self.areasArray.isEmpty {
                    self.localsArray = []
                    pickerView.reloadComponent(2)
                } else {
                    var areaIndex = pickerView.selectedRow(inComponent: 1)
                    areaIndex = areaIndex >= self.areasArray.count ? self.areasArray.count - 1 : areaIndex
                    if areaIndex >= 0 {
                        self.localsArray = self.areasArray[areaIndex].localList
                        pickerView.reloadComponent(2)
                    }
                }
            }
        } else if component == 1 {
            if row < self.areasArray.count && !self.areasArray.isEmpty {
                self.localsArray = self.areasArray[row].localList
                pickerView.reloadComponent(2)
            }
        }
    }
}
