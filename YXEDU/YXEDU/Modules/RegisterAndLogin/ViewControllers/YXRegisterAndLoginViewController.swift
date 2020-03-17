//
//  YXRegisterViewController.swift
//  YXEDU
//
//  Created by Jake To on 10/25/19.
//  Copyright © 2019 shiji. All rights reserved.
//

import UIKit

public let heightOfStateBar = UIApplication.shared.statusBarFrame.height
public let heightOfNavigationBar = heightOfStateBar + 44
public let heightOfSafeBotom: CGFloat = heightOfStateBar == 44 ? 34 : 0

class YXRegisterAndLoginViewController: BSRootVC, UITextFieldDelegate {
    
    var shouldShowShanYan = true
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
    
    @IBOutlet weak var wechatButton: UIButton!
    @IBOutlet weak var qqButton: UIButton!
    @IBOutlet weak var fastLoginLabel: UILabel!
    @IBOutlet weak var fastLoginLeftLineView: UIView!
    @IBOutlet weak var fastLoginRightLineView: UIView!

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
        navigationController?.pushViewController(YXAgreementVC(), animated: true)
    }
    
    @IBAction func showPolicy(_ sender: UIButton) {
        navigationController?.pushViewController(YXPolicyVC(), animated: true)
    }
    
    
    
    // MARK: -
    override func viewDidLoad() {
        super.viewDidLoad()
        if shouldShowShanYan {
            initShanYan()
        }
        
        phoneNumberTextField.delegate = self
        phoneNumberTextField.addTarget(self, action: #selector(changePhoneNumberTextField), for: UIControl.Event.editingChanged)
        authCodeTextField.addTarget(self, action: #selector(changeAuthCodeTextField), for: UIControl.Event.editingChanged)
        
        if let phoneNumber = YYCache.object(forKey: "PhoneNumber") as? String {
            phoneNumberTextField.text = phoneNumber
            sendSMSButton.isUserInteractionEnabled = true
            sendSMSButton.setTitleColor(UIColor(red: 251/255, green: 162/255, blue: 23/255, alpha: 1), for: .normal)
        }
        
        checkThirdPartyApp()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
        
        NotificationCenter.default.addObserver(self, selector: #selector(thirdPartLogin), name: NSNotification.Name(rawValue: "CompletedBind"), object: nil)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.setNavigationBarHidden(false, animated: animated)
        
        NotificationCenter.default.removeObserver(self)
    }
    
    deinit {
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
        let request = YXRegisterAndLoginRequest.sendSms(phoneNumber: phoneNumberTextField.text ?? "", loginType: "login", SlidingVerificationCode: slidingVerificationCode)
        YYNetworkService.default.request(YYStructResponse<YXSlidingVerificationCodeModel>.self, request: request, success: { (response) in
            guard let slidingVerificationCodeModel = response.data else { return }
            
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
                        
                    }
                }
            }
            
        }) { error in
            print("❌❌❌\(error)")
        }
    }
    
    
    /// 手机号登陆
    /// - Parameter loginModel:
    private func login(_ loginModel: YXLoginSendModel) {
    let parameters = loginModel.yrModelToDictionary() as! [AnyHashable : Any]
    YXDataProcessCenter.post("\(YXEvnOC.baseUrl())/v1/user/reg", parameters: parameters) { (response, isSuccess) in
            
            if isSuccess, let response = response?.responseObject {
                let d1 = response as! [String: Any]
                YXUserModel.default.token = d1["token"] as? String
                YXUserModel.default.uuid = d1["uuid"] as? String
                
                let d2 = d1["user_info"] as! [String: Any]
                YXUserModel.default.username = d2["nick"] as? String
                YXUserModel.default.userAvatarPath = d2["avatar"] as? String
                
                YXConfigure.shared().token = YXUserModel.default.token
                YXConfigure.shared().uuid = YXUserModel.default.uuid

                self.checkUserInfomation()
                
            } else if let error = response?.error {
                print(error.desc)
            }
        }
    }
    
    private func checkUserInfomation() {
        let request = YXRegisterAndLoginRequest.userInfomation
        YYNetworkService.default.request(YYStructResponse<YXUserInfomationModel>.self, request: request, success: { (response) in
            guard let userInfomation = response.data else { return }
            YXConfigure.shared()?.showKeyboard = (userInfomation.fillType == .keyboard)
            
            guard userInfomation.didBindPhone == 1 else {
                self.performSegue(withIdentifier: "Bind", sender: self)
                return
            }
            YYCache.set(self.phoneNumberTextField.text, forKey: "PhoneNumber")
            YXConfigure.shared().saveCurrentToken()
            YXUserModel.default.didLogin = true
            YXUserModel.default.login()
            
            // 登陆后设置别名给极光
            JPUSHService.setAlias(YXUserModel.default.uuid, completion: { (code, alias, seq) in                
                DDLogInfo("设置别名alias ====登陆成功======= \(code),\(alias ?? ""),\(seq)")
            }, seq: Int(Date().timeIntervalSince1970))
                
            YXAlertQueueManager.default.restart()
            
        }) { error in
            print("❌❌❌\(error)")
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
    
    private func checkThirdPartyApp() {        
        let canOpenQQ = YXCheckApp.canOpen(type: .qq)
        let canOpenWechat = YXCheckApp.canOpen(type: .wechatSession)
        
        if !canOpenQQ && !canOpenWechat {
            fastLoginLeftLineView.isHidden = true
            fastLoginRightLineView.isHidden = true
            fastLoginLabel.isHidden = true
        }
        
        qqButton.isHidden = !canOpenQQ
        wechatButton.isHidden = !canOpenWechat
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
                            let d1 = response as! [String: Any]
                            YXUserModel.default.token = d1["token"] as? String
                            YXUserModel.default.uuid = d1["uuid"] as? String
                            
                            let d2 = d1["user_info"] as! [String: Any]
                            YXUserModel.default.username = d2["nick"] as? String
                            YXUserModel.default.userAvatarPath = d2["avatar"] as? String

                            YXConfigure.shared().token = YXUserModel.default.token
                            YXConfigure.shared().uuid = YXUserModel.default.uuid

                            YXConfigure.shared().saveCurrentToken()
                            YXUserModel.default.didLogin = true
                            YXUserModel.default.login()

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
        configure.manualDismiss = true
        configure.clAuthWindowPresentingAnimate = false
        configure.clNavigationBarHidden = true
        configure.clPhoneNumberFont = UIFont.systemFont(ofSize: 20, weight: .regular)
        configure.clLoginBtnTextColor = .white
        configure.clLoginBtnTextFont = UIFont.systemFont(ofSize: 17)
        configure.clLoginBtnNormalBgImage = #imageLiteral(resourceName: "buttonBackground")
        configure.clAppPrivacyTextFont = UIFont.systemFont(ofSize: 10, weight: .regular)
        configure.clAppPrivacyColor = [UIColor(red: 0.53, green: 0.53, blue: 0.53, alpha: 1), UIColor(red: 0.2, green: 0.2, blue: 0.2, alpha: 1)]
        configure.clAppPrivacyPunctuationMarks = true
        configure.clShanYanSloganTextColor = .clear
        configure.clAppPrivacyFirst = ["《用户协议》", URL(string: "\(YXEvnOC.baseUrl())/agreement.html")!]
        configure.clAppPrivacySecond = ["《隐私政策》", URL(string: "\(YXEvnOC.baseUrl())/privacy.html")!]

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
            let iconBackgroundImageView = UIImageView()
            iconBackgroundImageView.contentMode = .scaleAspectFill
            iconBackgroundImageView.image = #imageLiteral(resourceName: "registerAndLoginBackground")
            
            let iconImageView = UIImageView()
            iconImageView.contentMode = .scaleAspectFill
            iconImageView.image = #imageLiteral(resourceName: "Logo")
            iconImageView.isHidden = true
            
            let containerView = UIView()
            
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
            
            view.addSubview(containerView)
            containerView.snp.makeConstraints { (make) in
                make.center.equalToSuperview()
                make.leading.trailing.equalToSuperview().inset(20)
                make.height.equalTo(screenHeight * (246 / 667))
            }
            
            view.addSubview(iconBackgroundImageView)
            iconBackgroundImageView.snp.makeConstraints { (make) in
                make.top.left.right.equalToSuperview()
                make.height.lessThanOrEqualTo(224).priorityRequired()
                make.bottom.lessThanOrEqualTo(containerView.snp.top).offset(-10).priorityRequired()
            }
            
            iconBackgroundImageView.addSubview(iconImageView)
            iconImageView.snp.makeConstraints { (make) in
                make.center.equalToSuperview()
                make.height.equalToSuperview().multipliedBy(0.5)
                make.width.equalTo(iconBackgroundImageView.snp.height).multipliedBy(0.5)
            }
            
            containerView.addSubview(otherLoginButton)
            otherLoginButton.snp.makeConstraints { (make) in
                make.bottom.equalToSuperview()
                make.centerX.equalToSuperview()
            }
            
            view.addSubview(quickLoginLabel)
            quickLoginLabel.snp.makeConstraints { (make) in
                make.bottom.greaterThanOrEqualToSuperview().offset(-100).priorityRequired()
                make.bottom.equalToSuperview().offset(-(100 / 667) * screenHeight).priorityHigh()
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
        }
        
        return configure
    }
    
    @objc func clickOtherLoginButton(_ sender: UIButton) {
        CLShanYanSDKManager.finishAuthController(animated: false) {
            if sender.tag == 1 {
                self.loginWithQQ(sender)
                
            } else if sender.tag == 2 {
                self.loginWithWechat(sender)
            }
        }
    }
}
