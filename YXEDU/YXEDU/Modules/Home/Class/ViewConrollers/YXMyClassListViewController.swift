//
//  YXMyClassListViewController.swift
//  YXEDU
//
//  Created by Jake To on 2020/7/17.
//  Copyright © 2020 shiji. All rights reserved.
//

import UIKit

class YXMyClassListViewController: YXViewController, UITableViewDelegate, UITableViewDataSource {

    var classModelList = [YXMyClassModel]()

    var addClassButton = UIButton()

    var tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .plain)
        tableView.backgroundColor = .white
        tableView.separatorStyle  = .none
        return tableView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.createSubviews()
        self.bindProperty()
    }

    deinit {
        NotificationCenter.default.removeObserver(self)
    }

    private func createSubviews() {
        self.customNavigationBar?.title = "我的班级"
        tableView.register(YXMyClassTableViewClassCell.classForCoder(), forCellReuseIdentifier: "kYXMyClassTableViewClassCell")

        addClassButton.setTitle("加入班级", for: .normal)
        addClassButton.titleLabel?.font = .regularFont(ofSize: 14)
        addClassButton.setTitleColor(UIColor.gray3, for: .normal)

        self.customNavigationBar?.addSubview(addClassButton)
        self.view.addSubview(tableView)
        tableView.snp.makeConstraints { (make) in
            make.left.right.bottom.equalToSuperview()
            make.top.equalToSuperview().offset(kNavHeight)
        }
        addClassButton.snp.makeConstraints { (make) in
            make.centerY.equalToSuperview()
            make.right.equalTo(-15)
            make.size.equalTo(CGSize(width: 60, height: 22))
        }
    }

    private func bindProperty() {
        tableView.delegate = self
        tableView.dataSource = self
        addClassButton.addTarget(self, action: #selector(addClass), for: .touchUpInside)
        NotificationCenter.default.addObserver(self, selector: #selector(requestClassList), name: YXNotification.kReloadClassList, object: nil)
    }

    @objc
    private func addClass() {
        let alertView = YXAlertView(type: .inputable, placeholder: "输入班级号")
        alertView.titleLabel.text = "请输入班级号"
        alertView.shouldOnlyShowOneButton = false
        alertView.shouldClose = false
        alertView.doneClosure = {(classNumber: String?) in
            YXUserDataManager.share.joinClass(code: classNumber) { (result) in
                alertView.removeFromSuperview()
            }
            YXLog("班级号：\(classNumber ?? "")")
        }
        alertView.clearButton.isHidden    = true
        alertView.textCountLabel.isHidden = true
        alertView.textMaxLabel.isHidden   = true
        alertView.alertHeight.constant    = 222
        alertView.show()
    }

    // MARK: ==== Request ====
    @objc private func requestClassList() {
        let request = YXMyClassRequestManager.classList
        YYNetworkService.default.request(YYStructDataArrayResponse<YXMyClassModel>.self, request: request, success: { [weak self] (response) in
            guard let self = self, let modelList = response.dataArray else { return }
            self.classModelList = modelList
            self.tableView.reloadData()
        }) { (error) in
            YXUtils.showHUD(nil, title: error.message)
        }
    }

    // MARK: ==== UITableViewDataSource && UITableViewDelegate ====
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.classModelList.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "kYXMyClassTableViewClassCell") as? YXMyClassTableViewClassCell else {
            return UITableViewCell()
        }
        cell.setData(model: classModelList[indexPath.row])
        return cell
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return AdaptSize(60)
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = YXMyClassDetailViewController()
        vc.classId = self.classModelList[indexPath.row].id
        YRRouter.sharedInstance().currentNavigationController()?.pushViewController(vc, animated: true)
    }

}
