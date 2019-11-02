//
//  YXBindPhoneViewController.swift
//  YXEDU
//
//  Created by Jake To on 10/25/19.
//  Copyright © 2019 shiji. All rights reserved.
//

import UIKit

class YXBindPhoneViewController: UIViewController {

    var platform: String!
    
    private var timer: Timer?
    private var CountingDown = 60
    
    
    // MARK: - Interface Builder
    @IBOutlet weak var clearPhoneNumberTextFieldButton: UIButton!
    @IBOutlet weak var phoneNumberTextField: UITextField!
    @IBOutlet weak var authCodeTextField: UITextField!
    @IBOutlet weak var sendSMSButton: UIButton!
    @IBOutlet weak var loginButton: YXDesignableButton!
    
    @IBAction func clearphoneNumberTextField(_ sender: UIButton) {
        phoneNumberTextField.text = ""
    }
    
    @IBAction func sendSMSWithoutAuthCode(_ sender: UIButton) {
        sendSMS()
    }
    
    @IBAction func login(_ sender: UIButton) {
        let bindModel = YXBindModel()
        bindModel.mobile = phoneNumberTextField.text
        bindModel.code = authCodeTextField.text
        bindModel.pf = platform
        
        let bindViewModel = YXBindViewModel()
        bindViewModel.bindPhone(bindModel) { (response, isSuccess) in
            guard isSuccess else { return }
            YXUserModel.default.didLogin = true
            YXConfigure.shared().saveCurrentToken()

            YXComHttpService.shared().requestConfig({ (response, isSuccess) in
                if isSuccess, let response = response?.responseObject {
                    let config = response as! YXConfigModel
                        
                    guard config.baseConfig.learning else {
                        let storyboard = UIStoryboard(name:"Home", bundle: nil)
                        let addBookViewController = storyboard.instantiateViewController(withIdentifier: "YXAddBookViewController") as! YXAddBookViewController
                        addBookViewController.finishClosure = {
                            YXUserModel.default.login()
                        }
                        
                        self.navigationController?.pushViewController(addBookViewController, animated: true)
                        return
                    }
                    
                    YXUserModel.default.login()
                    
                } else if let error = response?.error {
                    print(error.desc)
                }
            })
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        phoneNumberTextField.addTarget(self, action: #selector(changePhoneNumberTextField), for: UIControl.Event.editingChanged)
        authCodeTextField.addTarget(self, action: #selector(changeAuthCodeTextField), for: UIControl.Event.editingChanged)
    }
    
    @objc
    private func changePhoneNumberTextField() {
        guard var phoneNumber = phoneNumberTextField.text, phoneNumber.isEmpty == false else {
            clearPhoneNumberTextFieldButton.isHidden = true
            return
        }
        
        clearPhoneNumberTextFieldButton.isHidden = false
        
        if phoneNumber.count >= 11  {
            phoneNumberTextField.text = phoneNumber.substring(maxIndex: 11)
            phoneNumber = phoneNumberTextField.text!
        }
        
        if phoneNumber.substring(maxIndex: 1) == "1", phoneNumber.count == 11  {
            sendSMSButton.isUserInteractionEnabled = true
            sendSMSButton.setTitleColor(UIColor(red: 251/255, green: 162/255, blue: 23/255, alpha: 1), for: .normal)
            
            if let authCode = authCodeTextField.text, authCode.isEmpty == false {
                loginButton.isUserInteractionEnabled = true

            } else {
                loginButton.isUserInteractionEnabled = false
            }
            
        } else {
            sendSMSButton.isUserInteractionEnabled = false
            sendSMSButton.setTitleColor(UIColor(red: 192/255, green: 192/255, blue: 192/255, alpha: 1), for: .normal)
        }
    }
    
    @objc
    private func changeAuthCodeTextField() {
        guard let phoneNumber = phoneNumberTextField.text, phoneNumber.count == 11 else { return }

        if let authCode = authCodeTextField.text, authCode.isEmpty == false {
            loginButton.isUserInteractionEnabled = true
            
        } else {
            loginButton.isUserInteractionEnabled = false
        }
    }
    
    private func startCountingDown() {
        if timer == nil {
            let timer = Timer(timeInterval: 1.0, target: self, selector: #selector(updateTimer), userInfo: nil, repeats: true)
            RunLoop.current.add(timer, forMode: .common)
            timer.tolerance = 0.1
            self.timer = timer
        }
    }
    
    @objc
    private func updateTimer() {
        if CountingDown == 0 {
            timer?.invalidate()
            timer = nil
            
            sendSMSButton.isUserInteractionEnabled = true
            sendSMSButton.setTitle("获取验证码", for: .normal)
            sendSMSButton.setTitleColor(UIColor(red: 251/255, green: 162/255, blue: 23/255, alpha: 1), for: .normal)
            
        } else {
            CountingDown = CountingDown - 1
            sendSMSButton.isUserInteractionEnabled = false
            sendSMSButton.setTitle("\(CountingDown)", for: .normal)
            sendSMSButton.setTitleColor(UIColor(red: 192/255, green: 192/255, blue: 192/255, alpha: 1), for: .normal)
        }
    }
    
    private func sendSMS(with authCode: String = "") {
        let sendSMSModel = YXSendSMSModel()
        sendSMSModel.type = "editMobile"
        sendSMSModel.mobile = phoneNumberTextField.text
        sendSMSModel.captcha = authCode
        sendSMSModel.pf = platform
        
        let bindViewModel = YXBindViewModel()
        bindViewModel.sendSMS(sendSMSModel) { (code, isSuccess) in
            if isSuccess {
                self.startCountingDown()
                
            } else {
                guard let code = code as? Int, (code == USER_PF_MOBILE_CAPTCHA_CODE || code == USER_PF_MOBILE_CAPTCHA_EMPTY_CODE) else { return }
                self.showImageAuth(with: bindViewModel)
            }
        }
    }
    
    private func showImageAuth(with bindViewModel: YXBindViewModel) {
        let comAlertView: YXComAlertView = YXComAlertView.show(YXAlertType(rawValue: 3)!, in: self.view, info: "", content: "", firstBlock: { (alertView) in
            guard let alertView = alertView as? YXComAlertView else { return }
            
            if let text = alertView.verifyCodeField.text, text.isEmpty == false {
                self.sendSMS(with: text)
            }
            
            alertView.remove()
            
        }) { (alertView) in
            guard let alertView = alertView as? YXComAlertView else { return }
            
            bindViewModel.requestGraphCodeMobile(self.phoneNumberTextField.text!) { (data, isSuccess) in
                alertView.verifyCodeImage.image = UIImage(data: data as! Data)
            }
        } as! YXComAlertView
        
        bindViewModel.requestGraphCodeMobile(self.phoneNumberTextField.text!) { (data, isSuccess) in
            comAlertView.verifyCodeImage.image = UIImage(data: data as! Data)
        }
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        self.view.endEditing(true)
    }
}
