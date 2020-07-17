//
//  YXMyClassListViewController.swift
//  YXEDU
//
//  Created by Jake To on 2020/7/17.
//  Copyright © 2020 shiji. All rights reserved.
//

import UIKit

class YXMyClassListViewController: YXViewController, UITableViewDelegate, UITableViewDataSource {

    var classList = [YXMyClassModel]()

    var addClassButton = UIButton()

    var tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .plain)
        tableView.backgroundColor = .white
        tableView.separatorStyle = .none
        return tableView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.customNavigationBar?.title = "我的班级"

        // Do any additional setup after loading the view.
        tableView.register(YXMyClassTableViewClassCell.classForCoder(), forCellReuseIdentifier: "kYXMyClassTableViewClassCell")
        tableView.delegate = self
        tableView.dataSource = self
        
        addClassButton.setTitle("添加班级", for: .normal)
        addClassButton.titleLabel?.font = .regularFont(ofSize: 14)
        addClassButton.setTitleColor(UIColor.gray3, for: .normal)
        
        self.customNavigationBar?.addSubview(addClassButton)
        addClassButton.snp.makeConstraints { (make) in
            make.centerY.equalToSuperview()
            make.right.equalTo(-15)
            make.size.equalTo(CGSize(width: 60, height: 22))
        }
        
        addClassButton.addTarget(self, action: #selector(addClass), for: .touchUpInside)

    }
    
    @objc
    private func addClass() {
        let alertView = YXAlertView(type: .inputable, placeholder: "输入班级号")
        alertView.titleLabel.text = "请输入班级号"
        alertView.shouldOnlyShowOneButton = false
        alertView.shouldClose = false
        alertView.doneClosure = {(classNumber: String?) in
            YXUserDataManager.share.joinClass(code: classNumber) { (result) in
                if result != nil {
                    alertView.removeFromSuperview()
                }
            }
            YXLog("班级号：\(classNumber ?? "")")
        }
        alertView.clearButton.isHidden    = true
        alertView.textCountLabel.isHidden = true
        alertView.textMaxLabel.isHidden   = true
        alertView.alertHeight.constant    = 222
        alertView.show()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        tableView.frame = CGRect(x: 0, y: kNavHeight, width: self.view.bounds.width, height: self.view.bounds.height - kNavHeight)
        self.view.addSubview(tableView)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        tableView.reloadData()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.classList.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "kYXMyClassTableViewClassCell") as? YXMyClassTableViewClassCell else {
            return UITableViewCell()
        }
        cell.setData(model: classList[indexPath.row])
        return cell
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return AdaptSize(60)
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = YXMyClassDetailViewController()
        vc.classId = self.classList[indexPath.row].id
        YRRouter.sharedInstance().currentNavigationController()?.pushViewController(vc, animated: true)
    }

}
