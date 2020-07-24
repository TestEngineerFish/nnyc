//
//  YXMyClassViewController.swift
//  YXEDU
//
//  Created by 沙庭宇 on 2020/6/16.
//  Copyright © 2020 shiji. All rights reserved.
//

import Foundation

class YXMyClassViewController: YXViewController, UITableViewDelegate, UITableViewDataSource {

    var moreButton = UIButton()

    var backgroundView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.orange1
        return view
    }()
    
    var workTableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .grouped)
        tableView.separatorColor = .clear
        tableView.showsVerticalScrollIndicator = false
        tableView.estimatedRowHeight = AdaptSize(125)
        return tableView
    }()

    var classModelList = [YXMyClassModel]()
    var workListModel: YXMyWorkListModel?

    override func viewDidLoad() {
        super.viewDidLoad()
        self.bindProperty()
        self.createSubviews()
        self.reloadData()
        
        self.addMoreButton()
    }
    
    private func addMoreButton() {
        moreButton.setImage(UIImage(named: "more"), for: .normal)
        
        self.customNavigationBar?.addSubview(moreButton)
        moreButton.snp.makeConstraints { (make) in
            make.centerY.equalToSuperview()
            make.right.equalTo(-15)
            make.size.equalTo(CGSize(width: 20, height: 22))
        }
        
        moreButton.addTarget(self, action: #selector(showMoreOption), for: .touchUpInside)
    }
    
    @objc
    private func showMoreOption() {
        if classModelList.count == 1 {
            let editView = YXReviewPlanEditView(point: CGPoint(x: 0, y: 0))
            
            editView.showClassDetailclosure = {
                let classDetailViewController = YXMyClassDetailViewController()
                classDetailViewController.classId = self.classModelList[0].id
                
                self.navigationController?.pushViewController(classDetailViewController, animated: true)
            }
            
            editView.addClassDetailclosure = {
                let alertView = YXAlertView(type: .inputable, placeholder: "输入班级号或作业提取码")
                alertView.titleLabel.text = "请输入班级号或作业提取码"
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
            
            editView.show()
            
        } else {
            let classListViewController = YXMyClassListViewController()
            classListViewController.classList = self.classModelList
            
            navigationController?.pushViewController(classListViewController, animated: true)
        }
    }

    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }

    private func bindProperty() {
        self.customNavigationBar?.title           = "班级"
        self.customNavigationBar?.titleColor      = UIColor.white
        self.customNavigationBar?.backgroundColor = .orange1
        self.customNavigationBar?.leftButtonTitleColor = .white
        self.workTableView.delegate        = self
        self.workTableView.dataSource      = self
        self.workTableView.register(YXWorkWithMyClassCell.classForCoder(), forCellReuseIdentifier: "kYXWorkWithMyClassCell")
        self.workTableView.backgroundColor = .clear
        NotificationCenter.default.addObserver(self, selector: #selector(reloadData), name: YXNotification.kReloadClassList, object: nil)
    }

    private func createSubviews() {
        self.view.addSubview(backgroundView)
        self.view.addSubview(workTableView)
        backgroundView.snp.makeConstraints { (make) in
            make.left.right.equalToSuperview()
            make.top.equalToSuperview()
            make.height.equalTo(kNavHeight)
        }
        workTableView.snp.makeConstraints { (make) in
            make.top.equalToSuperview().offset(kNavHeight)
            make.left.right.bottom.equalToSuperview()
        }

        if let navBar = self.customNavigationBar {
            self.view.bringSubviewToFront(navBar)
        }
    }

    // MARK: ==== Request ====
    private func requestClassList() {
        let request = YXMyClassRequestManager.classList
        YYNetworkService.default.request(YYStructDataArrayResponse<YXMyClassModel>.self, request: request, success: { [weak self] (response) in
            guard let self = self, let modelList = response.dataArray else { return }
            
            if modelList.count == 1 {
                self.customNavigationBar?.title = modelList[0].name
            } else if modelList.count > 1 {
                self.customNavigationBar?.title = "\(modelList.count)个班级"
            }
            
            self.classModelList = modelList
        }) { (error) in
            YXUtils.showHUD(kWindow, title: error.message)
        }
    }

    private func requestWorkList() {
        let request = YXMyClassRequestManager.workList
        YYNetworkService.default.request(YYStructResponse<YXMyWorkListModel>.self, request: request, success: { [weak self] (response) in
            guard let self = self, let listModel = response.data else {
                return
            }
            self.workListModel = listModel
            self.workTableView.reloadData()
        }) { (error) in
            YXUtils.showHUD(kWindow, title: error.message)
        }
    }

    // MARK: ==== Event ====
    @objc private func reloadData() {
        self.requestClassList()
        self.requestWorkList()
    }

    // MARK: ==== UITableViewDateSource && UITableViewDelegate ====
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.workListModel?.workModelList.count ?? 0
    }

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = YXMyWorkTableViewHeaderView()
//        headerView.setDate(class: self.classModelList)
        return headerView
//
//        let view = UIView(frame: CGRect(x: 0, y: 0, width: screenWidth, height: 44))
//
//        let label = UILabel(frame: CGRect(x: 20, y: 0, width: screenWidth - 40, height: 44))
//        label.text = "班级作业"
//
//        view.addSubview(label)
//
//        return view
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "kYXWorkWithMyClassCell", for: indexPath) as? YXWorkWithMyClassCell, let listModel = self.workListModel else {
            return UITableViewCell()
        }
        let model = listModel.workModelList[indexPath.row]
        cell.setData(work: model, hashDic: listModel.bookHash)
        return cell
    }

    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
//        let count  = self.classModelList.count > 3 ? 3 : self.classModelList.count
//        let amount = CGFloat(96 + count * 50)
//        return AdaptSize(amount)
        
        return 44
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        guard let workModelList = self.workListModel?.workModelList, !workModelList.isEmpty else {
            return AdaptSize(232)
        }
        return .zero
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let footerView = YXMyClassTableViewFooterView()
        return footerView
    }
}
