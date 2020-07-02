//
//  YXBindPhoneViewController.swift
//  YXEDU
//
//  Created by Jake To on 10/25/19.
//  Copyright © 2019 shiji. All rights reserved.
//

import UIKit
import GrowingCoreKit
import GrowingAutoTrackKit

class YXBindPhoneViewController: YXViewController, UITextFieldDelegate {

    var platform: String!
    
    private var timer: Timer?
    private var countingDown = 60
    private var slidingVerificationCode: String?

    
    // MARK: - Interface Builder
    @IBOutlet weak var clearPhoneNumberTextFieldButton: UIButton!
    @IBOutlet weak var phoneNumberTextField: UITextField!
    @IBOutlet weak var authCodeTextField: UITextField!
    @IBOutlet weak var sendSMSButton: UIButton!
    @IBOutlet weak var loginButton: YXDesignableButton!
    
    @IBAction func back(_ sender: UIBarButtonItem) {
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func clearphoneNumberTextField(_ sender: UIButton) {
        clearPhoneNumberTextFieldButton.isHidden = true
        
        phoneNumberTextField.text = ""
        phoneNumberTextField.becomeFirstResponder()
        
        sendSMSButton.isUserInteractionEnabled = false
        sendSMSButton.setTitleColor(UIColor(red: 192/255, green: 192/255, blue: 192/255, alpha: 1), for: .normal)
        
        loginButton.isUserInteractionEnabled = false
    }
    
    @IBAction func sendSMSWithoutAuthCode(_ sender: UIButton) {
        phoneNumberTextField.resignFirstResponder()
        authCodeTextField.resignFirstResponder()
        
        sendSMS()
    }
    
    @IBAction func login(_ sender: UIButton) {
        let request = YXRegisterAndLoginRequest.bind(platfrom: platform, phoneNumber: phoneNumberTextField.text ?? "", code: authCodeTextField.text ?? "")
        YYNetworkService.default.request(YYStructResponse<YXAccountModel>.self, request: request, success: { response in
            guard let data = response.data else { return }

            YXUserModel.default.uuid           = data.info?.uuid
            YXUserModel.default.userName       = data.info?.username
            YXUserModel.default.userAvatarPath = data.info?.avatar
            
            YXUserModel.default.didLogin = true
            Growing.setUserId(YXUserModel.default.uuid ?? "")
            YXUserModel.default.login()
            
        }) { error in
            YXUtils.showHUD(kWindow, title: error.message)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        phoneNumberTextField.delegate = self
        phoneNumberTextField.addTarget(self, action: #selector(changePhoneNumberTextField), for: UIControl.Event.editingChanged)
        authCodeTextField.addTarget(self, action: #selector(changeAuthCodeTextField), for: UIControl.Event.editingChanged)
    }
    
    @objc
    private func changePhoneNumberTextField() {
        if var phoneNumber = phoneNumberTextField.text, phoneNumber.isEmpty == false {
            clearPhoneNumberTextFieldButton.isHidden = false

            if phoneNumber.count >= 11 {
                phoneNumberTextField.text = phoneNumber.substring(maxIndex: 11)
                phoneNumber = phoneNumberTextField.text!
                
                sendSMSButton.isUserInteractionEnabled = true
                sendSMSButton.setTitleColor(UIColor(red: 251/255, green: 162/255, blue: 23/255, alpha: 1), for: .normal)
                
                if let authCode = authCodeTextField.text, authCode.count == 6 {
                    loginButton.isUserInteractionEnabled = true
                }
                
            } else {
                sendSMSButton.isUserInteractionEnabled = false
                sendSMSButton.setTitleColor(UIColor(red: 192/255, green: 192/255, blue: 192/255, alpha: 1), for: .normal)
                
                loginButton.isUserInteractionEnabled = false
            }
            
        } else {
            clearPhoneNumberTextFieldButton.isHidden = true
        }
    }
    
    @objc
    private func changeAuthCodeTextField() {
        if var authCode = authCodeTextField.text, authCode.count >= 6 {
            authCodeTextField.text = authCode.substring(maxIndex: 6)
            authCode = authCodeTextField.text!
            
            if let phoneNumber = phoneNumberTextField.text, phoneNumber.count == 11 {
                loginButton.isUserInteractionEnabled = true
            }

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
        if countingDown <= 1 {
            timer?.invalidate()
            timer = nil
            
            countingDown = 60

            sendSMSButton.isUserInteractionEnabled = true
            sendSMSButton.setTitle("重新获取", for: .normal)
            sendSMSButton.setTitleColor(UIColor(red: 251/255, green: 162/255, blue: 23/255, alpha: 1), for: .normal)
            
        } else {
            countingDown = countingDown - 1
            sendSMSButton.isUserInteractionEnabled = false
            sendSMSButton.setTitle("\(countingDown)秒", for: .normal)
            sendSMSButton.setTitleColor(UIColor(red: 192/255, green: 192/255, blue: 192/255, alpha: 1), for: .normal)
        }
    }
    
    private func sendSMS() {
        let request = YXRegisterAndLoginRequest.sendSms(phoneNumber: phoneNumberTextField.text ?? "", loginType: "editMobile", SlidingVerificationCode: slidingVerificationCode)
        YYNetworkService.default.request(YYStructResponse<YXSlidingVerificationCodeModel>.self, request: request, success: { [weak self] (response) in
            guard let self = self, let slidingVerificationCodeModel = response.data else { return }
            
            if slidingVerificationCodeModel.isSuccessSendSms == 1 {
                self.slidingVerificationCode = nil
                
                self.startCountingDown()
                self.authCodeTextField.becomeFirstResponder()

            } else if slidingVerificationCodeModel.shouldShowSlidingVerification == 1 {
                self.authCodeTextField.resignFirstResponder()

                RegisterSliderView.show(.puzzle) { (isSuccess) in
                    if isSuccess {
                        self.slidingVerificationCode = slidingVerificationCodeModel.slidingVerificationCode
                        self.sendSMS()
                    } else {
                        YXLog("滑动解锁失败")
                    }
                }
            }
        }) { error in
            YXUtils.showHUD(kWindow, title: error.message)
        }
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        self.view.endEditing(true)
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        guard let text = textField.text, text.isEmpty == false else { return }
        clearPhoneNumberTextFieldButton.isHidden = false
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        clearPhoneNumberTextFieldButton.isHidden = true
    }
}
