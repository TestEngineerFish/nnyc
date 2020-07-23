//
//  YXAboutUsViewController.swift
//  YXEDU
//
//  Created by Jake To on 11/22/19.
//  Copyright © 2019 shiji. All rights reserved.
//

import UIKit

class YXAboutUsViewController: YXViewController {
    @IBOutlet weak var copyrightLabel: UILabel!
    @IBOutlet weak var versionLabel: UILabel!

    @IBOutlet weak var buildLabel: UILabel!
    @IBOutlet weak var logoImageView: UIImageView!
    
    @IBAction func showUserAgreement(_ sender: UITapGestureRecognizer) {
        performSegue(withIdentifier: "UserAgreement", sender: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.customNavigationBar?.title = "关于我们"
        versionLabel.text = Bundle.main.infoDictionary!["CFBundleShortVersionString"] as? String
        let year = Calendar.current.component(.year, from: Date())
        copyrightLabel.text = "Copyright @2018-\(year) 念念有词"
        #if DEBUG
        self.buildLabel.text     = "build " + YRDevice.appBuild()
        self.buildLabel.isHidden = false
        let touchAction = UITapGestureRecognizer(target: self, action: #selector(reportLog))
        touchAction.numberOfTapsRequired = 5
        touchAction.numberOfTouchesRequired = 1
        self.logoImageView.isUserInteractionEnabled = true
        self.logoImageView.addGestureRecognizer(touchAction)
        #endif
    }

    @objc private func reportLog(_ tapGes: UITapGestureRecognizer) {
        YXWordBookDaoImpl().deleteAll()
    }
}
