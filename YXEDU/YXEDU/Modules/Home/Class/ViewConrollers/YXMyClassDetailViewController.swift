//
//  YXMyClassDetailViewController.swift
//  YXEDU
//
//  Created by 沙庭宇 on 2020/6/17.
//  Copyright © 2020 shiji. All rights reserved.
//

import Foundation

class YXMyClassDetailViewController: YXViewController, UITableViewDelegate, UITableViewDataSource {

    var tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .grouped)
        tableView.backgroundColor = .white
        tableView.separatorColor = .clear
        return tableView
    }()

    var backgroundView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.black5.withAlphaComponent(0.7)
        view.layer.opacity   = 0.0
        return view
    }()

    var sheetView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        return view
    }()

    var leaveButton: UIButton = {
        let button = UIButton()
        button.setTitle("退出班级", for: .normal)
        button.setTitleColor(UIColor.red1, for: .normal)
        button.titleLabel?.font = .regularFont(ofSize: AdaptFontSize(15))
        return button
    }()

    var lineView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.black4
        return view
    }()

    var cancelButton: UIButton = {
        let button = UIButton()
        button.setTitle("取消", for: .normal)
        button.setTitleColor(UIColor.gray3, for: .normal)
        button.titleLabel?.font = .regularFont(ofSize: AdaptFontSize(15))
        return button
    }()

    var classId: Int?
    var classDetailModel: YXMyClassDetailModel?

    override func viewDidLoad() {
        super.viewDidLoad()
        self.createSubviews()
        self.bindProprety()
        self.requestData()
    }

    private func createSubviews() {
        self.view.addSubview(tableView)
        self.sheetView.addSubview(leaveButton)
        self.sheetView.addSubview(lineView)
        self.sheetView.addSubview(cancelButton)

        self.tableView.snp.makeConstraints { (make) in
            make.left.bottom.right.equalToSuperview()
            make.top.equalToSuperview().offset(AdaptSize(kNavHeight))
        }
        self.leaveButton.snp.makeConstraints { (make) in
            make.left.right.top.equalToSuperview()
            make.height.equalTo(AdaptSize(50))
        }
        self.lineView.snp.makeConstraints { (make) in
            make.left.right.bottom.equalTo(leaveButton)
            make.height.equalTo(AdaptSize(0.5))
        }
        self.cancelButton.snp.makeConstraints { (make) in
            make.left.right.equalToSuperview()
            make.top.equalTo(leaveButton.snp.bottom)
            make.height.equalTo(AdaptSize(50))
        }
    }

    private func bindProprety() {
        self.tableView.delegate   = self
        self.tableView.dataSource = self
        self.tableView.register(YXMyClassStudentCell.classForCoder(), forCellReuseIdentifier: "kYXMyClassStudentCell")
        self.customNavigationBar?.title = "班级详情"
        self.customNavigationBar?.rightButton.setImage(UIImage(named: "more_black"), for: .normal)
        self.customNavigationBar?.rightButton.addTarget(self, action: #selector(showSheetView), for: .touchUpInside)
        let hideTap = UITapGestureRecognizer(target: self, action: #selector(hideSheepView))
        self.backgroundView.addGestureRecognizer(hideTap)
        self.leaveButton.addTarget(self, action: #selector(leaveAction), for: .touchUpInside)
        self.cancelButton.addTarget(self, action: #selector(cancelAction), for: .touchUpInside)
    }

    // MARK: ==== Request ====
    private func requestData() {
        guard let id = self.classId else { return }
        let request = YXMyClassRequestManager.classDetail(id: id)
        YYNetworkService.default.request(YYStructResponse<YXMyClassDetailModel>.self, request: request, success: { (response) in
            self.classDetailModel = response.data
            self.tableView.reloadData()
        }) { (error) in
            YXUtils.showHUD(kWindow, title: error.message)
        }
    }

    private func leaveClass() {
        guard let id = self.classId else { return }
        let request = YXMyClassRequestManager.leaveClass(id: id)
        YYNetworkService.default.request(YYStructResponse<YXResultModel>.self, request: request, success: { (response) in
            self.navigationController?.popViewController(animated: true)
            // 刷新列表
            NotificationCenter.default.post(name: YXNotification.kJoinClass, object: nil)
        }) { (error) in
            YXUtils.showHUD(kWindow, title: error.message)
        }
    }

    // TODO: ==== Event ====
    @objc private func showSheetView() {
        kWindow.addSubview(self.backgroundView)
        kWindow.addSubview(self.sheetView)
        self.backgroundView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        self.sheetView.frame = CGRect(x: 0, y: screenHeight, width: screenWidth, height: AdaptSize(100) + kSafeBottomMargin)
        UIView.animate(withDuration: 0.25) {
            self.backgroundView.layer.opacity = 1.0
            self.sheetView.transform = CGAffineTransform(translationX: 0, y: AdaptSize(-100))
        }
    }

    @objc private func hideSheepView() {
        UIView.animate(withDuration: 0.25, animations: {
            self.backgroundView.layer.opacity = 0.0
            self.sheetView.transform = .identity
        }) { (finished) in
            if finished {
                self.backgroundView.removeFromSuperview()
                self.sheetView.removeFromSuperview()
            }
        }
    }

    @objc private func leaveAction() {
        self.hideSheepView()
        let alertView = YXAlertView(type: .normal)
        alertView.descriptionLabel.text = "是否确认退出班级？"
        alertView.leftButton.setTitle("退出", for: .normal)
        alertView.leftButton.layer.borderColor = UIColor.red1.cgColor
        alertView.leftButton.setTitleColor(UIColor.red1, for: .normal)
        alertView.rightOrCenterButton.setTitle("点错了", for: .normal)
        alertView.rightOrCenterButton.setTitleColor(UIColor.black1, for: .normal)
        alertView.rightOrCenterButton.backgroundColor   = UIColor.clear
        alertView.rightOrCenterButton.layer.borderColor = UIColor.black6.cgColor
        alertView.rightOrCenterButton.layer.borderWidth = AdaptSize(0.5)
        alertView.cancleClosure = {
            self.leaveClass()
            YXLog("退出班级")
        }
        alertView.show()
    }

    @objc private func cancelAction() {
        self.hideSheepView()
    }

    // MARK: ==== UITableViewDelegate && UITableViewDataSource ====

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.classDetailModel?.studentModelList.count ?? 0
    }

    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return tableView.estimatedSectionHeaderHeight
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return AdaptSize(80)
    }

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = YXMyClassDetailHeaderView()
        headerView.setData(class: self.classDetailModel)
        return headerView
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "kYXMyClassStudentCell", for: indexPath) as? YXMyClassStudentCell, let detailModel = self.classDetailModel else {
            return UITableViewCell()
        }
        let model = detailModel.studentModelList[indexPath.row]
        cell.setData(student: model)
        return cell
    }
}
