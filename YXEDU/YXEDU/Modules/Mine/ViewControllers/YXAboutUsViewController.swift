//
//  YXAboutUsViewController.swift
//  YXEDU
//
//  Created by Jake To on 11/22/19.
//  Copyright © 2019 shiji. All rights reserved.
//

import UIKit

class YXAboutUsViewController: UIViewController {
    @IBOutlet weak var versionLabel: UILabel!
    
    @IBAction func back(_ sender: UIBarButtonItem) {
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func showUserAgreement(_ sender: UITapGestureRecognizer) {
        performSegue(withIdentifier: "UserAgreement", sender: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        versionLabel.text = Bundle.main.infoDictionary!["CFBundleShortVersionString"] as? String
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
