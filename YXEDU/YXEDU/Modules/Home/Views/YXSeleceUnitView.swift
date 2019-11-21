//
//  YXSeleceUnitView.swift
//  YXEDU
//
//  Created by Jake To on 11/1/19.
//  Copyright © 2019 shiji. All rights reserved.
//

import UIKit

class YXSeleceUnitView: UIView, UIPickerViewDelegate, UIPickerViewDataSource {
    private var units: [YXWordBookUnitModel] = []
    private var doneClosure: ((_ id: Int?) -> Void)?

    @IBOutlet var contentView: UIView!
    @IBOutlet weak var pickerView: UIPickerView!

    init(units: [YXWordBookUnitModel], doneClosure: ((_ id: Int?) -> Void)?) {
        super.init(frame: CGRect(x: 0, y: 0, width: screenWidth, height: screenHeight))
        self.units = units
        self.doneClosure = doneClosure

        initializationFromNib()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        initializationFromNib()
    }
    
    func initializationFromNib() {
        Bundle.main.loadNibNamed("YXSeleceUnitView", owner: self, options: nil)
        addSubview(contentView)
        contentView.frame = self.bounds
    }
    
    @IBAction func done(_ sender: UIButton) {
        let row = pickerView.selectedRow(inComponent: 0)
        let unit = units[row]
        doneClosure?(unit.unitId)
        self.removeFromSuperview()
    }
    
    @IBAction func dismiss(_ sender: UITapGestureRecognizer) {
        self.removeFromSuperview()
    }
    
    func show() {
        kWindow.addSubview(self)
//        kWindow.isHidden = false
    }
    
    
    
    // MARK: - PickerView
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return units.count
    }

    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return units[row].unitName
    }
}
