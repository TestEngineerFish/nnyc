//
//  YXSettingsViewController.swift
//  YXEDU
//
//  Created by Jake To on 12/20/19.
//  Copyright © 2019 shiji. All rights reserved.
//

import UIKit
import MBProgressHUD

class YXSettingsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var tableView: UITableView!

    @IBAction func back(_ sender: UIBarButtonItem) {
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func logout(_ sender: Any) {
        let alertView = YXAlertView()
        alertView.descriptionLabel.text = "您确定要退出登录吗？"
        alertView.doneClosure = { _ in
            let request = YXRegisterAndLoginRequest.logout
            YYNetworkService.default.request(YYStructResponse<YXResultModel>.self, request: request, success: nil) { (error) in
                YXUtils.showHUD(kWindow, title: error.message)
            }
            
            YXUserModel.default.logout()
        }
        
        alertView.show()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(false, animated: animated)
    }
    

    // MARK: - TableView
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 6
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.row {
//        case 0:
//            return tableView.dequeueReusableCell(withIdentifier: "CellOne")!
            
        case 0:
            return tableView.dequeueReusableCell(withIdentifier: "CellTwo")!
            
        case 1:
            return tableView.dequeueReusableCell(withIdentifier: "CellThree")!
            
        case 2:
            return tableView.dequeueReusableCell(withIdentifier: "CellFour")!
            
        case 3:
            return tableView.dequeueReusableCell(withIdentifier: "CellFive")!
          
        case 4:
            return tableView.dequeueReusableCell(withIdentifier: "CellSix")!
            
        default:
            return tableView.dequeueReusableCell(withIdentifier: "CellSeven")!
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
                if version?.state == .recommend || version?.state == .force {
                    UIApplication.shared.open(URL(string: "https://apps.apple.com/cn/app/id1379948642")!, options: [:]) { (isSuccess) in
                        
                    }
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

            YXFileManager.share.clearStudyCache()
            var service: YXExerciseService = YXExerciseServiceImpl()
            
            YYCache.set(nil, forKey: "LastStoredDate")
            self.view.makeToast("清除成功")
        }

        alertView.show()
    }
}
