//
//  YXSettingsViewController.swift
//  YXEDU
//
//  Created by Jake To on 12/20/19.
//  Copyright © 2019 shiji. All rights reserved.
//

import UIKit

class YXSettingsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var tableView: UITableView!

    @IBAction func back(_ sender: UIBarButtonItem) {
        navigationController?.popViewController(animated: true)
    }
    
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

        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    

    // MARK: - TableView
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.row {
//        case 0:
//            return tableView.dequeueReusableCell(withIdentifier: "CellOne")!
        case 0:
            return tableView.dequeueReusableCell(withIdentifier: "CellTwo")!
        default:
            return tableView.dequeueReusableCell(withIdentifier: "CellThree")!
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    tableView.deselectRow(at: indexPath, animated: false)
    
        switch indexPath.row {
//        case 0:
//            self.performSegue(withIdentifier: "ManageMaterial", sender: self)
//            break
            
        case 0:
            self.performSegue(withIdentifier: "AboutUs", sender: self)
            break
            
        case 1:
            YXSettingDataManager().checkVersion { (version, error) in
                if version?.state == .recommend || version?.state == .force {
                    UIApplication.shared.open(URL(string: "https://apps.apple.com/cn/app/id1379948642")!, options: [:]) { (isSuccess) in
                        
                    }
                }
            }
            break
            
        default:
            break
        }
    }
}
