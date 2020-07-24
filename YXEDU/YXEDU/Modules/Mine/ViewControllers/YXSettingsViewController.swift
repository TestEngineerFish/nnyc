//
//  YXSettingsViewController.swift
//  YXEDU
//
//  Created by Jake To on 12/20/19.
//  Copyright © 2019 shiji. All rights reserved.
//

import UIKit
import MBProgressHUD

class YXSettingsViewController: YXViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var viewTopConstraint: NSLayoutConstraint!

    @IBAction func logout(_ sender: Any) {
        let alertView = YXAlertView()
        alertView.descriptionLabel.text = "您确定要退出登录吗？"
        alertView.doneClosure = { _ in
            YXUserModel.default.logout()
        }
        alertView.show()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.customNavigationBar?.title = "设置"
        self.viewTopConstraint.constant = kNavBarHeight
    }

    // MARK: - TableView
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 6
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.row {
        case 0:
            return tableView.dequeueReusableCell(withIdentifier: "CellTwo") ?? UITableViewCell()
            
        case 1:
            return tableView.dequeueReusableCell(withIdentifier: "CellThree") ?? UITableViewCell()
            
        case 2:
            return tableView.dequeueReusableCell(withIdentifier: "CellFour") ?? UITableViewCell()
            
        case 3:
            return tableView.dequeueReusableCell(withIdentifier: "CellFive") ?? UITableViewCell()
          
        case 4:
            return tableView.dequeueReusableCell(withIdentifier: "CellSix") ?? UITableViewCell()
            
        default:
            return tableView.dequeueReusableCell(withIdentifier: "CellSeven") ?? UITableViewCell()
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
    
        switch indexPath.row {
//        case 0:
//            self.performSegue(withIdentifier: "ManageMaterial", sender: self)
//            break
            
        case 0:
            performSegue(withIdentifier: "AboutUs", sender: self)
            break
            
        case 1:
            YXSettingDataManager().checkVersion { (version, error) in
                if version?.state == .recommend || version?.state == .force, let url = URL(string: "https://apps.apple.com/cn/app/id1379948642") {
                    UIApplication.shared.open(url, options: [:], completionHandler: nil)
                } else {
                    YXUtils.showHUD(self.view, title: "当前已经是最新版本")
                }
            }
            break
            
        case 2:
            performSegue(withIdentifier: "UserAgreement", sender: nil)
            break
            
        case 3:
            performSegue(withIdentifier: "PrivacyPolicy", sender: nil)
            break
            
        case 4:
            YXLogManager.share.report(true)
            break
            
        case 5:
            resetCache()
            break
            
        default:
            break
        }
    }
    
    private func resetCache() {
        let alertView = YXAlertView()
        alertView.descriptionLabel.text = "清除后将删除当前尚未学完的学习记录，是否确定？"
        alertView.doneClosure = { _ in
            let service: YXExerciseService = YXExerciseServiceImpl()
            service.cleanAllStudyRecord()
            self.view.makeToast("清除成功")
        }
        alertView.show()
    }
}
