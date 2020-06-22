//
//  YXSelectSchoolViewController.swift
//  YXEDU
//
//  Created by 沙庭宇 on 2020/6/22.
//  Copyright © 2020 shiji. All rights reserved.
//

import Foundation

class YXSelectSchoolViewController: YXViewController {

    var contentView = YXSelectSchoolContentView()
    var searchView  = YXSearchSchoolListView()
    var pickerView  = YXSelectLocalPickView()
    var backgroundView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.black.withAlphaComponent(0.7)
        view.layer.opacity   = 0.0
        return view
    }()

    let searchViewH = screenHeight * 0.92
    let pickerViewH = AdaptSize(318)

    override func viewDidLoad() {
        super.viewDidLoad()
        self.createSubviews()
        self.bindProperty()
    }

    private func bindProperty() {
        let tapLocal  = UITapGestureRecognizer(target: self, action: #selector(clickLocal))
        let tapSchool = UITapGestureRecognizer(target: self, action: #selector(clickSchool))
        self.contentView.localLabel.addGestureRecognizer(tapLocal)
        self.contentView.schoolLabel.addGestureRecognizer(tapSchool)
        self.searchView.cancelButton.addTarget(self, action: #selector(hideSelectSchoolView), for: .touchUpInside)
        self.searchView.downButton.addTarget(self, action: #selector(hideSelectSchoolView), for: .touchUpInside)
        self.pickerView.cancelButton.addTarget(self, action: #selector(hideSelectLocalView), for: .touchUpInside)
        self.pickerView.downButton.addTarget(self, action: #selector(hideSelectLocalView), for: .touchUpInside)
        self.searchView.clipRectCorner(directionList: [.topLeft, .topRight], cornerRadius: AdaptSize(5))
        self.pickerView.clipRectCorner(directionList: [.topLeft, .topRight], cornerRadius: AdaptSize(5))
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
        YXLog("clickLocal")
        UIView.animate(withDuration: 0.25) {
            self.backgroundView.layer.opacity = 1.0
            self.pickerView.transform         = CGAffineTransform(translationX: 0, y: -self.pickerViewH)
        }
    }

    @objc private func clickSchool() {
        YXLog("clickSchool")
        UIView.animate(withDuration: 0.25) {
            self.backgroundView.layer.opacity = 1.0
            self.searchView.transform         = CGAffineTransform(translationX: 0, y: -self.searchViewH)
        }
    }

    @objc private func hideSelectSchoolView() {
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
}
