//
//  YXRegisterViewController.swift
//  YXEDU
//
//  Created by Jake To on 10/25/19.
//  Copyright © 2019 shiji. All rights reserved.
//

import UIKit

class YXRegisterAndLoginViewController: UIViewController {
    
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
        let sendModel = YXLoginSendModel()
        sendModel.pf = "mobile"
        sendModel.code = authCodeTextField.text
        sendModel.mobile = phoneNumberTextField.text
        sendModel.openid = ""
        
        YXDataProcessCenter.post("/v1/user/reg", parameters: sendModel.yrModelToDictionary() as! [AnyHashable : Any]) { (response, isSuccess) in
            if isSuccess {

            } else {
                
            }
        }
    }
    
    @objc
    @IBAction func loginWithQQ(_ sender: UIButton) {
        QQApiManager.shared().qqLogin()
    }
    
    @objc
    @IBAction func loginWithWechat(_ sender: UIButton) {
        WXApiManager.shared().wxLogin()
    }
    
    @IBAction func showAgreement(_ sender: UIButton) {
        navigationController?.pushViewController(YXPolicyVC(), animated: true)
    }
    
    
    
    // MARK: - Custom
    override func viewDidLoad() {
        super.viewDidLoad()
        
        phoneNumberTextField.addTarget(self, action: #selector(changePhoneNumberTextField), for: UIControl.Event.editingChanged)
        authCodeTextField.addTarget(self, action: #selector(changeAuthCodeTextField), for: UIControl.Event.editingChanged)

        initShanYan()
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
            
        } else {
            sendSMSButton.isUserInteractionEnabled = false
            sendSMSButton.setTitleColor(UIColor(red: 192/255, green: 192/255, blue: 192/255, alpha: 1), for: .normal)
        }
    }
    
    @objc
    private func changeAuthCodeTextField() {
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
        sendSMSModel.type = "login"
        sendSMSModel.mobile = phoneNumberTextField.text
        sendSMSModel.captcha = authCode
        
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
    
    private func loadMainPage() {
//        window = UIWindow(frame: UIScreen.main.bounds)
//        (window?.rootViewController as? YXNavigationController)?.viewControllers.removeAll()
//        window?.rootViewController = nil
//
//        tabBarController = YXTabBarController()
//        window?.rootViewController = tabBarController
//
//        window?.makeKeyAndVisible()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        self.view.endEditing(true)
    }
    
    
    // MARK: - 闪验
    private func initShanYan() {
        CLShanYanSDKManager.initWithAppId("OoCjBtLT") { (result) in
            if let error = result.error {
                print("初始化失败，\(error.localizedDescription)")
                
            } else {
                CLShanYanSDKManager.preGetPhonenumber { (result) in
                    if let error = result.error {
                        print("预取号失败，\(error.localizedDescription)")
                        
                    } else {
                        self.showShanYanAuthPage()
                    }
                }
            }
        }
    }
    
    private func showShanYanAuthPage() {
        let configure = CLUIConfigure()
        configure.viewController = self
        configure.clNavigationBarHidden = true
        configure.clPhoneNumberFont = UIFont.systemFont(ofSize: 20, weight: .regular)
        configure.clLoginBtnTextColor = .white
        configure.clLoginBtnTextFont = UIFont.systemFont(ofSize: 17)
        configure.clLoginBtnNormalBgImage = #imageLiteral(resourceName: "buttonBackground")
        configure.clAppPrivacyTextFont = UIFont.systemFont(ofSize: 10, weight: .regular)
        configure.clAppPrivacyColor = [UIColor(red: 0.53, green: 0.53, blue: 0.53, alpha: 1), UIColor(red: 0.2, green: 0.2, blue: 0.2, alpha: 1)]
        configure.clAppPrivacyPunctuationMarks = true
        configure.clAppPrivacyFirst = ["《用户协议》", URL(string: "https://www.google.com")!]
        
        let layoutConfigure = CLOrientationLayOut()
        layoutConfigure.clLayoutPhoneCenterX = NSNumber(0)
        layoutConfigure.clLayoutPhoneCenterY = NSNumber(-84)
        layoutConfigure.clLayoutSloganCenterX = NSNumber(0)
        layoutConfigure.clLayoutSloganCenterY = NSNumber(-52)
        layoutConfigure.clLayoutLoginBtnCenterX = NSNumber(0)
        layoutConfigure.clLayoutLoginBtnCenterY = NSNumber(16)
        layoutConfigure.clLayoutAppPrivacyCenterX = NSNumber(0)
        layoutConfigure.clLayoutAppPrivacyCenterY = NSNumber(80)
        layoutConfigure.clLayoutAppPrivacyWidth = NSNumber(value: Float(screenWidth - 80))
        layoutConfigure.clLayoutAppPrivacyHeight = NSNumber(40)
        configure.clOrientationLayOutPortrait = layoutConfigure
        
        configure.customAreaView = { [unowned self] view in
            let iconImageView = UIImageView()
            iconImageView.contentMode = .scaleAspectFill
            iconImageView.image = #imageLiteral(resourceName: "Logo")
            
            let containerView = UIView()
            
//            let agreementLabel = UILabel()
//            agreementLabel.text = "登录即同意"
//            agreementLabel.textColor = UIColor(red: 0.53, green: 0.53, blue: 0.53, alpha: 1)
//            agreementLabel.font = UIFont.systemFont(ofSize: 10)
            
//            let agreementButton = UIButton()
//            agreementButton.setTitle("《用户协议》", for: .normal)
//            agreementButton.setTitleColor(UIColor(red: 0.2, green: 0.2, blue: 0.2, alpha: 1), for: .normal)
//            agreementButton.titleLabel?.font = UIFont.systemFont(ofSize: 10)
            
//            let underLineView = UIView()
//            underLineView.backgroundColor = UIColor(red: 79/255, green: 79/255, blue: 79/255, alpha: 1)
            
            let otherLoginButton = UIButton()
            otherLoginButton.setTitle("其他手机号登录", for: .normal)
            otherLoginButton.setTitleColor(UIColor(red: 0.98, green: 0.64, blue: 0.09, alpha: 1), for: .normal)
            otherLoginButton.titleLabel?.font = UIFont.systemFont(ofSize: 12)
            otherLoginButton.addTarget(self, action: #selector(self.clickOtherLoginButton), for: .touchUpInside)
            
            let quickLoginLabel = UILabel()
            quickLoginLabel.text = "快捷登录"
            quickLoginLabel.textColor = UIColor(red: 0.53, green: 0.53, blue: 0.53, alpha: 1)
            quickLoginLabel.font = UIFont.systemFont(ofSize: 12)
            
            let lineView1 = UIView()
            lineView1.backgroundColor = UIColor(red: 220/255, green: 220/255, blue: 220/255, alpha: 1)
            
            let lineView2 = UIView()
            lineView2.backgroundColor = UIColor(red: 220/255, green: 220/255, blue: 220/255, alpha: 1)
            
            let qqLoginButton = UIButton()
            qqLoginButton.setImage(#imageLiteral(resourceName: "QQ"), for: .normal)
            
            let wechatLoginButton = UIButton()
            wechatLoginButton.setImage(#imageLiteral(resourceName: "Wechat"), for: .normal)
            
            let bottomImageView = UIImageView()
            bottomImageView.contentMode = .scaleAspectFill
            bottomImageView.image = #imageLiteral(resourceName: "LoginBackground")
            
            view.addSubview(iconImageView)
            iconImageView.snp.makeConstraints { (make) in
                make.top.equalTo(94)
                make.centerX.equalToSuperview()
                make.height.equalTo(36)
                make.width.equalTo(150)
            }
            
            view.addSubview(containerView)
            containerView.frame = CGRect(x: 20, y: (screenHeight - 246) / 2, width: screenWidth - 40, height: 246)
//            containerView.snp.makeConstraints { (make) in
//                make.centerX.equalToSuperview()
//                make.centerY.equalToSuperview().offset(-16)
//                make.leading.trailing.equalToSuperview().inset(20)
//                make.height.equalTo(246)
//            }
            
            containerView.layer.masksToBounds = false
            containerView.layer.shadowOffset = .zero
            containerView.layer.shadowOpacity = 1
            containerView.layer.shadowRadius = 10
            containerView.layer.shadowColor = UIColor(red: 0.78, green: 0.78, blue: 0.78, alpha: 0.5).cgColor
            containerView.layer.borderWidth = 0.5
            containerView.layer.borderColor = UIColor.white.cgColor
            containerView.layer.cornerRadius = 6
            
//            containerView.addSubview(authIconImageView)
//            authIconImageView.snp.makeConstraints { (make) in
//                make.centerX.equalToSuperview().offset(-54)
//                make.centerY.equalToSuperview().offset(-36)
//                make.height.width.equalTo(18)
//            }
            
//            containerView.addSubview(agreementLabel)
//            agreementLabel.snp.makeConstraints { (make) in
//                make.centerX.equalToSuperview().offset(-24)
//                make.centerY.equalToSuperview().offset(80)
//                make.width.equalTo(54)
//                make.height.equalTo(14)
//            }
            
//            containerView.addSubview(agreementButton)
//            agreementButton.snp.makeConstraints { (make) in
//                make.left.equalTo(agreementLabel.snp.right).offset(-8)
//                make.centerY.equalTo(agreementLabel)
//                make.height.equalTo(14)
//            }
            
//            containerView.addSubview(underLineView)
//            underLineView.snp.makeConstraints { (make) in
//                make.top.equalTo(agreementButton.snp.bottom)
//                make.centerX.equalTo(agreementButton)
//                make.width.equalTo(46)
//                make.height.equalTo(0.5)
//            }
            
            view.addSubview(otherLoginButton)
            otherLoginButton.snp.makeConstraints { (make) in
                make.top.equalTo(containerView.snp.bottom).offset(12)
                make.right.equalToSuperview().offset(-20)
            }
            
            view.addSubview(quickLoginLabel)
            quickLoginLabel.snp.makeConstraints { (make) in
                make.top.equalTo(containerView.snp.bottom).offset(54)
                make.centerX.equalToSuperview()
                make.height.equalTo(17)
                make.width.equalTo(50)
            }
            
            view.addSubview(lineView1)
            lineView1.snp.makeConstraints { (make) in
                make.centerY.equalTo(quickLoginLabel)
                make.right.equalTo(quickLoginLabel.snp.left).offset(-16)
                make.height.equalTo(0.5)
                make.width.equalTo(58)
            }
            
            view.addSubview(lineView2)
            lineView2.snp.makeConstraints { (make) in
                make.centerY.equalTo(quickLoginLabel)
                make.left.equalTo(quickLoginLabel.snp.right).offset(16)
                make.height.equalTo(0.5)
                make.width.equalTo(58)
            }
            
            view.addSubview(qqLoginButton)
            qqLoginButton.snp.makeConstraints { (make) in
                make.top.equalTo(lineView1.snp.bottom).offset(32)
                make.height.width.equalTo(40)
                make.centerX.equalTo(lineView1).offset(20)
            }
            
            view.addSubview(wechatLoginButton)
            wechatLoginButton.snp.makeConstraints { (make) in
                make.top.equalTo(lineView2.snp.bottom).offset(32)
                make.height.width.equalTo(40)
                make.centerX.equalTo(lineView2).offset(-20)
            }
            
            view.addSubview(bottomImageView)
            bottomImageView.snp.makeConstraints { (make) in
                make.left.right.bottom.equalToSuperview()
                make.height.equalTo(130)
            }
        }
        
        CLShanYanSDKManager.quickAuthLogin(with: configure, openLoginAuthListener: { (resultOfShowAuthPage) in
            if let error = resultOfShowAuthPage.error {
                print(error.localizedDescription)
                
            } else {
                
            }
            
        }) { (resultOfLogin) in
            if let error = resultOfLogin.error {
                print(error.localizedDescription)
                CLShanYanSDKManager.finishAuthControllerCompletion {
                    self.performSegue(withIdentifier: "Register", sender: nil)
                }
                
            } else {
                print(resultOfLogin.data)
                CLShanYanSDKManager.finishAuthControllerCompletion {
                    
                }
            }
        }
    }
    
    @objc func clickOtherLoginButton(_ sender: UIButton) {
        DispatchQueue.main.async(execute: {
            CLShanYanSDKManager.finishAuthControllerCompletion {
                
            }
        })
    }
}
