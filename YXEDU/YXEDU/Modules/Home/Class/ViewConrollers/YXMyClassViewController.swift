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

    let redDotView = YXRedDotView()
    var noticeButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "class_notice"), for: .normal)
        return button
    }()
    
    var workTableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .grouped)
        tableView.separatorColor = .clear
        tableView.showsVerticalScrollIndicator = false
        return tableView
    }()

    var classModelList = [YXMyClassModel]()
    var workListModel: YXMyWorkListModel? {
        didSet {
            self.redDotView.isHidden = workListModel?.hadNewNotification != .some(true)
        }
    }

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
                YXAlertManager().showAddClassOrHomeworkAlert { (classNumber: String?) in
                    YXUserDataManager.share.joinClass(code: classNumber) { (result) in
                    }
                    YXUserDataManager.share.joinClass(code: classNumber, complate: nil)
                }
            }
            YXAlertQueueManager.default.addAlert(alertView: editView)
        } else {
            let classListViewController = YXMyClassListViewController()
            classListViewController.classModelList = self.classModelList
            
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
        self.workTableView.backgroundColor    = .clear
        self.workTableView.estimatedRowHeight = AdaptSize(50)
        self.redDotView.isHidden              = true
        NotificationCenter.default.addObserver(self, selector: #selector(reloadData), name: YXNotification.kReloadClassList, object: nil)
        self.noticeButton.addTarget(self, action: #selector(showNoticeList), for: .touchUpInside)
    }

    private func createSubviews() {
        self.view.addSubview(backgroundView)
        self.view.addSubview(workTableView)
        self.customNavigationBar?.addSubview(noticeButton)
        noticeButton.addSubview(redDotView)
        if self.customNavigationBar != nil {
            self.noticeButton.snp.makeConstraints { (make) in
                make.centerY.equalToSuperview()
                make.right.equalTo(self.customNavigationBar!.rightButton.snp.left).offset(AdaptSize(-10))
                make.size.equalTo(CGSize(width: AdaptSize(22), height: AdaptSize(22)))
            }
        }
        self.redDotView.snp.makeConstraints { (make) in
            make.size.equalTo(redDotView.size)
            make.top.right.equalToSuperview()
        }
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
            YXUtils.showHUD(nil, title: error.message)
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
            YXUtils.showHUD(nil, title: error.message)
        }
    }

    // MARK: ==== Event ====
    @objc
    private func reloadData() {
        self.requestClassList()
        self.requestWorkList()
    }

    @objc
    private func showNoticeList() {
        self.redDotView.isHidden = true
        let vc = YXMyClassNoticeViewController()
        self.navigationController?.pushViewController(vc, animated: true)
    }

    private func pushDetailView(work model: YXMyWorkModel, hashDic: [String:String]) {
        let vc = YXHomeworkDetailViewController()
        vc.workModel = model
        vc.hashDic   = hashDic
        self.navigationController?.pushViewController(vc, animated: true)
    }

    // MARK: ==== UITableViewDateSource && UITableViewDelegate ====
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.workListModel?.workModelList.count ?? 0
    }

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = YXMyWorkTableViewHeaderView()
        return headerView
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
        return AdaptSize(44)
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

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let model = self.workListModel?.workModelList[indexPath.row], let hashDic = self.workListModel?.bookHash else {
            return
        }
        YXLog("查看作业\(model.workName)详情")
        self.pushDetailView(work: model, hashDic: hashDic)
    }
}
