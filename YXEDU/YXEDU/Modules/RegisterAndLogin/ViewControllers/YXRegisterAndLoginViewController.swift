//
//  YXRegisterViewController.swift
//  YXEDU
//
//  Created by Jake To on 10/25/19.
//  Copyright © 2019 shiji. All rights reserved.
//

import UIKit

class YXRegisterAndLoginViewController: UIViewController {
    
    var shouldShowShanYan = true
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
        phoneNumberTextField.becomeFirstResponder()
    }
    
    @IBAction func sendSMSWithoutAuthCode(_ sender: UIButton) {
        sendSMS()
        authCodeTextField.becomeFirstResponder()
    }
    
    @IBAction func phoneLogin(_ sender: UIButton) {
        let loginModel = YXLoginSendModel()
        loginModel.pf = "mobile"
        loginModel.mobile = phoneNumberTextField.text
        loginModel.code = authCodeTextField.text
        loginModel.openid = ""

        login(loginModel)
    }
    
    @IBAction func loginWithQQ(_ sender: UIButton) {
        QQApiManager.shared().qqLogin()
    }
    
    @IBAction func loginWithWechat(_ sender: UIButton) {
        WXApiManager.shared().wxLogin()
    }
    
    @IBAction func showAgreement(_ sender: UIButton) {
        navigationController?.pushViewController(YXPolicyVC(), animated: true)
    }
    
    
    
    // MARK: -
    override func viewDidLoad() {
        super.viewDidLoad()
        if shouldShowShanYan {
            initShanYan()
        }

        NotificationCenter.default.addObserver(self, selector: #selector(thirdPartLogin), name: NSNotification.Name(rawValue: "CompletedBind"), object: nil)
        
        phoneNumberTextField.addTarget(self, action: #selector(changePhoneNumberTextField), for: UIControl.Event.editingChanged)
        authCodeTextField.addTarget(self, action: #selector(changeAuthCodeTextField), for: UIControl.Event.editingChanged)
        
        if let phoneNumber = YYCache.object(forKey: "PhoneNumber") as? String {
            phoneNumberTextField.text = phoneNumber
            clearPhoneNumberTextFieldButton.isHidden = false
            sendSMSButton.isUserInteractionEnabled = true
            sendSMSButton.setTitleColor(UIColor(red: 251/255, green: 162/255, blue: 23/255, alpha: 1), for: .normal)
        }
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
        
        timer?.invalidate()
        timer = nil
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "Bind" {
            let controller = segue.destination as! YXBindPhoneViewController
            controller.platform = platform
        }
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
    
    private func login(_ loginModel: YXLoginSendModel) {
        let parameters = loginModel.yrModelToDictionary() as! [AnyHashable : Any]
        YXDataProcessCenter.post("\(YXEvnOC.baseUrl())/v1/user/reg", parameters: parameters) { (response, isSuccess) in

            if isSuccess, let response = response?.responseObject {
                YXUserModel.default.token = (response as! [String: Any])["token"] as? String
                YXUserModel.default.uuid = (response as! [String: Any])["uuid"] as? String
                YXConfigure.shared().token = YXUserModel.default.token

                YXComHttpService.shared().requestConfig({ (response, isSuccess) in
                    if isSuccess, let response = response?.responseObject {
                        let config = response as! YXConfigModel

                        guard config.baseConfig.bindMobile else {
                            self.performSegue(withIdentifier: "Bind", sender: self)
                            return
                        }

                        YYCache.set(self.phoneNumberTextField.text, forKey: "PhoneNumber")
                        YXUserModel.default.didLogin = true
                        YXConfigure.shared().saveCurrentToken()

                        guard config.baseConfig.learning else {
                            let storyboard = UIStoryboard(name:"Home", bundle: nil)
                            let addBookViewController = storyboard.instantiateViewController(withIdentifier: "YXAddBookViewController") as! YXAddBookViewController
                            self.navigationController?.pushViewController(addBookViewController, animated: true)
                            return
                        }
                        
                        YXUserModel.default.login()
                        
                    } else if let error = response?.error {
                        print(error.desc)
                    }
                })
                
            } else if let error = response?.error {
                print(error.desc)
            }
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        self.view.endEditing(true)
    }
    
    
    
    // MARK: - 第三方登录
    @objc
    private func thirdPartLogin(_ notification: Notification) {
        guard let userInfo = notification.userInfo else { return }
        
        let loginModel = YXLoginSendModel()
        loginModel.pf = userInfo["platfrom"] as? String
        loginModel.code = userInfo["token"] as? String
        loginModel.openid = (userInfo["openID"] as? String == nil) ? "" : userInfo["openID"] as? String

        self.platform = loginModel.pf
        
        login(loginModel)
    }
    
    
    
    // MARK: - 闪验
    private func initShanYan() {
        CLShanYanSDKManager.initWithAppId("OoCjBtLT") { (result) in
            guard result.error == nil else { return }
            
            CLShanYanSDKManager.preGetPhonenumber { (result) in
                guard result.error == nil else { return }
                
                self.showShanYanAuthPage()
            }
        }
    }
    
    private func showShanYanAuthPage() {
        let configure = customShanYanView()
        
        CLShanYanSDKManager.quickAuthLogin(with: configure, openLoginAuthListener: { (resultOfShowAuthPage) in
            if let error = resultOfShowAuthPage.error {
                print(error.localizedDescription)
            }
            
        }) { (resultOfLogin) in
            if let _ = resultOfLogin.error {
                CLShanYanSDKManager.finishAuthControllerCompletion(nil)
                
            } else {
                YXDataProcessCenter.get("\(YXEvnOC.baseUrl())/api/v1/flash/mobile/\(resultOfLogin.data?["token"] ?? "")", parameters: [:]) { (response, isSuccess) in
                    guard isSuccess, let response = response else { return }
                    let phoneNumber = response.responseObject as! [String]
                         
                    YXDataProcessCenter.get("\(YXEvnOC.baseUrl())/api/v1/flash/login/\(phoneNumber[0])", parameters: [:]) { (response, isSuccess) in
                        if isSuccess, let response = response?.responseObject {
                            YXUserModel.default.token = (response as! [String: Any])["token"] as? String
                            YXUserModel.default.uuid = (response as! [String: Any])["uuid"] as? String
                            YXConfigure.shared().token = YXUserModel.default.token

                            YXComHttpService.shared().requestConfig({ (response, isSuccess) in
                                if isSuccess, let response = response?.responseObject {
                                    let config = response as! YXConfigModel

                                    YYCache.set(phoneNumber[0], forKey: "PhoneNumber")
                                    YXUserModel.default.didLogin = true
                                    YXConfigure.shared().saveCurrentToken()

                                    guard config.baseConfig.learning else {
                                        let storyboard = UIStoryboard(name:"Home", bundle: nil)
                                        let addBookViewController = storyboard.instantiateViewController(withIdentifier: "YXAddBookViewController") as! YXAddBookViewController
                                       
                                        CLShanYanSDKManager.finishAuthControllerCompletion {
                                            self.navigationController?.pushViewController(addBookViewController, animated: true)
                                        }
                                        return
                                    }
                                    
                                    CLShanYanSDKManager.finishAuthControllerCompletion {
                                        YXUserModel.default.login()
                                    }
                                    
                                } else if let error = response?.error {
                                    print(error.desc)
                                }
                            })
                            
                        } else if let error = response?.error {
                            print(error.desc)
                        }
                    }
                }
            }
        }
    }
    
    private func customShanYanView() -> CLUIConfigure {
        let configure = CLUIConfigure()
        configure.viewController = self
        configure.clAuthWindowPresentingAnimate = false
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
        layoutConfigure.clLayoutAppPrivacyCenterY = NSNumber(64)
        layoutConfigure.clLayoutAppPrivacyWidth = NSNumber(value: Float(screenWidth - 80))
        layoutConfigure.clLayoutAppPrivacyHeight = NSNumber(40)
        configure.clOrientationLayOutPortrait = layoutConfigure
        
        configure.customAreaView = { view in
            let iconImageView = UIImageView()
            iconImageView.contentMode = .scaleAspectFill
            iconImageView.image = #imageLiteral(resourceName: "Logo")
            
            let containerView = UIView()
            containerView.backgroundColor = .white
            containerView.layer.setDefaultShadow()
            
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
            qqLoginButton.tag = 1
            qqLoginButton.setImage(#imageLiteral(resourceName: "QQ"), for: .normal)
            qqLoginButton.addTarget(self, action: #selector(self.clickOtherLoginButton), for: .touchUpInside)

            let wechatLoginButton = UIButton()
            wechatLoginButton.tag = 2
            wechatLoginButton.setImage(#imageLiteral(resourceName: "Wechat"), for: .normal)
            wechatLoginButton.addTarget(self, action: #selector(self.clickOtherLoginButton), for: .touchUpInside)

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
            containerView.snp.makeConstraints { (make) in
                make.centerX.equalToSuperview()
                make.centerY.equalToSuperview().offset(-12)
                make.leading.trailing.equalToSuperview().inset(20)
                make.height.equalTo(246)
            }
            
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
        
        return configure
    }
    
    @objc func clickOtherLoginButton(_ sender: UIButton) {
        CLShanYanSDKManager.finishAuthControllerCompletion{
            if sender.tag == 1 {
                self.loginWithQQ(sender)
                
            } else if sender.tag == 2 {
                self.loginWithWechat(sender)
            }
        }
    }
}
