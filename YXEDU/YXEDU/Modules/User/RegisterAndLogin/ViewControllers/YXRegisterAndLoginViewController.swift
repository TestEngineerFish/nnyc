//
//  YXRegisterViewController.swift
//  YXEDU
//
//  Created by Jake To on 10/25/19.
//  Copyright © 2019 shiji. All rights reserved.
//

import UIKit
import GrowingCoreKit
import GrowingAutoTrackKit

public let heightOfStateBar = UIApplication.shared.statusBarFrame.height
public let heightOfNavigationBar = heightOfStateBar + 44
public let heightOfSafeBotom: CGFloat = heightOfStateBar == 44 ? 34 : 0

class YXRegisterAndLoginViewController: YXViewController, UITextFieldDelegate {
    
    var shouldShowShanYan = true
    var platform: String?
    var appleModel: YXAppleModel?
    
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
    @IBOutlet weak var appleButton: UIButton!
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
        
        let request = YXRegisterAndLoginRequest.login(platfrom: "mobile", phoneNumber: phoneNumberTextField.text ?? "", code: authCodeTextField.text ?? "")
        YYNetworkService.default.request(YYStructResponse<YXAccountModel>.self, request: request, success: { [weak self] (response) in
            guard let self = self, let data = response.data else { return }

            YXUserModel.default.uuid           = data.uuid
            YXUserModel.default.token          = data.token
            YXUserModel.default.userName       = data.info?.username
            YXUserModel.default.userAvatarPath = data.info?.avatar
            
            YXLog("当前用户Token=====", YXUserModel.default.token ?? "")
            self.checkUserInfomation()
        }) { error in
            YXUtils.showHUD(nil, title: error.message)
        }
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
        self.customNavigationBar?.isHidden = true
        phoneNumberTextField.delegate = self
        phoneNumberTextField.addTarget(self, action: #selector(changePhoneNumberTextField), for: UIControl.Event.editingChanged)
        authCodeTextField.addTarget(self, action: #selector(changeAuthCodeTextField), for: UIControl.Event.editingChanged)
        if let phoneNumber = YXUserModel.default.mobile {
            phoneNumberTextField.text = phoneNumber
            sendSMSButton.isUserInteractionEnabled = true
            sendSMSButton.setTitleColor(UIColor(red: 251/255, green: 162/255, blue: 23/255, alpha: 1), for: .normal)
        }
        
        checkThirdPartyApp()
        YYCache.set(true, forKey: YXLocalKey.firstShowHome)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        NotificationCenter.default.addObserver(self, selector: #selector(thirdPartLogin), name: NSNotification.Name(rawValue: "CompletedBind"), object: nil)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        NotificationCenter.default.removeObserver(self)
    }
    
    deinit {
        timer?.invalidate()
        timer = nil
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "Bind" {
            guard let controller = segue.destination as? YXBindPhoneViewController else {
                return
            }
            controller.platform = platform
        }
    }
    
    @objc
    private func changePhoneNumberTextField() {
        if let phoneNumber = phoneNumberTextField.text, phoneNumber.isEmpty == false {
            clearPhoneNumberTextFieldButton.isHidden = false
            
            if phoneNumber.count >= 11 {
                phoneNumberTextField.text = phoneNumber.substring(maxIndex: 11)
                
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
        if let authCode = authCodeTextField.text, authCode.count >= 6 {
            authCodeTextField.text = authCode.substring(maxIndex: 6)
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

    // MARK: ==== Request ====

    private func sendSMS() {
        let request = YXRegisterAndLoginRequest.sendSms(phoneNumber: phoneNumberTextField.text ?? "", loginType: "login", SlidingVerificationCode: slidingVerificationCode)
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
            YXUtils.showHUD(nil, title: error.message)
        }
    }
    
    /// 更新用户信息
    private func checkUserInfomation() {
        YXUserDataManager.share.updateUserInfomation { [weakSelf = self] (userInfomation) in
            guard let _userInfomation = userInfomation else {
                return
            }
            guard _userInfomation.didBindPhone else {
                weakSelf.performSegue(withIdentifier: "Bind", sender: weakSelf)
                return
            }
            YXUserModel.default.mobile = weakSelf.phoneNumberTextField.text
            YXAlertQueueManager.default.processQueue()
            YXUserModel.default.login()
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
        let canOpenQQ          = YXCheckApp.canOpen(type: .qq)
        let canOpenWechat      = YXCheckApp.canOpen(type: .wechatSession)
        let canOpenApple: Bool = {
            if #available(iOS 13.0, *) {
                return true
            } else {
                return false
            }
        }()
        if !canOpenQQ && !canOpenWechat && !canOpenApple {
            fastLoginLeftLineView.isHidden  = true
            fastLoginRightLineView.isHidden = true
            fastLoginLabel.isHidden         = true
        }

        appleButton.isHidden  = !canOpenApple
        qqButton.isHidden     = !canOpenQQ
        wechatButton.isHidden = !canOpenWechat
    }
    
    // MARK: - 第三方登录
    @objc
    private func thirdPartLogin(_ notification: Notification) {
        guard let userInfo = notification.userInfo else { return }
        self.platform = userInfo["platfrom"] as? String
        
        let request = YXRegisterAndLoginRequest.thirdLogin(platfrom: self.platform ?? "", openId: (userInfo["openID"] as? String) ?? "", code: (userInfo["token"] as? String) ?? "")
        YYNetworkService.default.request(YYStructResponse<YXAccountModel>.self, request: request, success: { [weak self] (response) in
            guard let self = self, let data = response.data else { return }

            YXUserModel.default.uuid           = data.uuid
            YXUserModel.default.token          = data.token
            YXUserModel.default.userName       = data.info?.username
            YXUserModel.default.userAvatarPath = data.info?.avatar
            self.checkUserInfomation()
        }) { error in
            YXUtils.showHUD(nil, title: error.message)
        }
    }

    private func appleLogin() {
        guard let model = self.appleModel, let token = model.identityToken, let tokenStr = String(data: token, encoding: .utf8) else {
            YXLog("苹果登录失败，请重试")
            YXUtils.showHUD(nil, title: "Apple登录失败，请重试")
            return
        }
        let request = YXRegisterAndLoginRequest.appleLogin(userId: model.user, token: tokenStr, fullName: model.name)
        YYNetworkService.default.request(YYStructResponse<YXAccountModel>.self, request: request, success: { [weak self] (response) in
            guard let self = self, let data = response.data else { return }
            YXUserModel.default.uuid           = data.uuid
            YXUserModel.default.token          = data.token
            YXUserModel.default.userName       = data.info?.username
            YXUserModel.default.userAvatarPath = data.info?.avatar
            self.platform = "apple"
            self.checkUserInfomation()
        }) { (error) in
            YXUtils.showHUD(nil, title: error.message)
        }
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
                YXLog("闪验授权失败：", error.localizedDescription)
            }
            
        }) { (resultOfLogin) in
            if let _ = resultOfLogin.error {
                CLShanYanSDKManager.finishAuthControllerCompletion(nil)
                
            } else {
                let request = YXRegisterAndLoginRequest.SYGetPhoneNumber(token: (resultOfLogin.data?["token"] as? String) ?? "")
                let task = URLSession.shared.dataTask(with: request.url) { data, response, error in
                    DispatchQueue.main.async {
                        guard let data = data else {
                            CLShanYanSDKManager.finishAuthControllerCompletion(nil)
                            return
                        }
                        
                        struct PhoneNumber: Codable {
                            let data: [String]?
                        }

                        do {
                            let responseObject = try JSONDecoder().decode(PhoneNumber.self, from: data)
                            let request = YXRegisterAndLoginRequest.SYLogin(phoneNumber: responseObject.data?[0] ?? "")
                            YYNetworkService.default.request(YYStructResponse<YXAccountModel>.self, request: request, success: { [weak self] response in
                                guard let self = self, let data = response.data else {
                                    CLShanYanSDKManager.finishAuthControllerCompletion(nil)
                                    return
                                }
                                YXUserModel.default.uuid           = data.uuid
                                YXUserModel.default.token          = data.token
                                YXUserModel.default.userName       = data.info?.username
                                YXUserModel.default.userAvatarPath = data.info?.avatar
                                YXUserModel.default.didLogin = true
                                Growing.setUserId(YXUserModel.default.uuid ?? "")
                                self.checkUserInfomation()
                            }) { error in
                                YXUtils.showHUD(nil, title: error.message)
                                CLShanYanSDKManager.finishAuthControllerCompletion(nil)
                            }
                            
                        } catch {
                            CLShanYanSDKManager.finishAuthControllerCompletion(nil)
                        }
                    }
                }
                
                task.resume()
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
        layoutConfigure.clLayoutPhoneCenterX      = NSNumber(0)
        layoutConfigure.clLayoutPhoneCenterY      = NSNumber(-84)
        layoutConfigure.clLayoutSloganCenterX     = NSNumber(0)
        layoutConfigure.clLayoutSloganCenterY     = NSNumber(-52)
        layoutConfigure.clLayoutLoginBtnCenterX   = NSNumber(0)
        layoutConfigure.clLayoutLoginBtnCenterY   = NSNumber(16)
        layoutConfigure.clLayoutAppPrivacyCenterX = NSNumber(0)
        layoutConfigure.clLayoutAppPrivacyCenterY = NSNumber(64)
        layoutConfigure.clLayoutAppPrivacyWidth   = NSNumber(value: Float(screenWidth - 80))
        layoutConfigure.clLayoutAppPrivacyHeight  = NSNumber(40)
        configure.clOrientationLayOutPortrait     = layoutConfigure
        
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
            
            let qqLoginButton = UIButton(frame: CGRect(origin: .zero, size: CGSize(width: 40, height: 40)))
            qqLoginButton.tag = 1
            qqLoginButton.setImage(#imageLiteral(resourceName: "QQ"), for: .normal)
            qqLoginButton.addTarget(self, action: #selector(self.clickOtherLoginButton), for: .touchUpInside)
            
            let wechatLoginButton = UIButton(frame: CGRect(origin: .zero, size: CGSize(width: 40, height: 40)))
            wechatLoginButton.tag = 2
            wechatLoginButton.setImage(#imageLiteral(resourceName: "Wechat"), for: .normal)
            wechatLoginButton.addTarget(self, action: #selector(self.clickOtherLoginButton), for: .touchUpInside)

            let appleLoginButton = UIButton(frame: CGRect(origin: .zero, size: CGSize(width: 40, height: 40)))
            appleLoginButton.tag = 3
            appleLoginButton.setImage(UIImage(named: "apple"), for: .normal)
            appleLoginButton.addTarget(self, action: #selector(self.clickOtherLoginButton), for: .touchUpInside)
            
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
            return
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

            let otherLoginView = UIStackView(arrangedSubviews: [qqLoginButton, wechatLoginButton, appleLoginButton])
            otherLoginView.distribution = .equalSpacing
            view.addSubview(otherLoginView)
            otherLoginView.snp.makeConstraints { (make) in
                make.width.equalTo(208)
                make.height.equalTo(40)
                make.top.equalTo(quickLoginLabel.snp.bottom).offset(20)
                make.centerX.equalToSuperview()
            }
            let canOpenQQ          = YXCheckApp.canOpen(type: .qq)
            let canOpenWechat      = YXCheckApp.canOpen(type: .wechatSession)
            let canOpenApple: Bool = {
                if #available(iOS 13.0, *) {
                    return true
                } else {
                    return false
                }
            }()
            if !canOpenQQ && !canOpenWechat && !canOpenApple {
                lineView1.isHidden       = true
                lineView2.isHidden       = true
                quickLoginLabel.isHidden = true
            }

            appleLoginButton.isHidden  = !canOpenApple
            qqLoginButton.isHidden     = !canOpenQQ
            wechatLoginButton.isHidden = !canOpenWechat
        }
        
        return configure
    }
    
    @objc func clickOtherLoginButton(_ sender: UIButton) {
        CLShanYanSDKManager.finishAuthController(animated: false) {
            if sender.tag == 1 {
                self.loginWithQQ(sender)
            } else if sender.tag == 2 {
                self.loginWithWechat(sender)
            } else if sender.tag == 3 {
                self.loginWithApple(sender)
            }
        }
    }

    @IBAction func loginWithApple(_ sender: UIButton) {
        if #available(iOS 13.0, *) {
            let provider = ASAuthorizationAppleIDProvider()
            let request  = provider.createRequest()
            request.requestedScopes = [.fullName, .email]
            let controller = ASAuthorizationController(authorizationRequests: [request])
            controller.delegate = self
            controller.presentationContextProvider = self
            controller.performRequests()
        }
    }
}

@available(iOS 13.0, *)
extension YXRegisterAndLoginViewController: ASAuthorizationControllerDelegate, ASAuthorizationControllerPresentationContextProviding {

    // MARK: ==== ASAuthorizationControllerDelegate ====
    @available(iOS 13.0, *)
    func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) {
        YXLog("Sign in with apple error:\(error)")
    }

    @available(iOS 13.0, *)
    func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
        // 新用户
        if let credential = authorization.credential as? ASAuthorizationAppleIDCredential {
            let userIdentifier    = credential.user
            let identityToken     = credential.identityToken
            let authorizationCode = credential.authorizationCode
            let userEmail         = credential.email ?? ""
            let userName          = (credential.fullName?.familyName ?? "") + (credential.fullName?.givenName ?? "")
//            if let tokenData = identityToken, let codeData = authorizationCode {
//                let tokenStr = String(data: tokenData, encoding: .utf8) ?? ""
//                let codeStr  = String(data: codeData, encoding: .utf8) ?? ""
//                YXLog(String(format: "User ID:%@\nApple Token:%@\nAuthorization Code:%@\n", userIdentifier, tokenStr, codeStr))
//            }
            self.appleModel = YXAppleModel(user: userIdentifier, name: userName, email: userEmail, identityToken: identityToken, authorizationCode: authorizationCode)
            let appleIDProvider = ASAuthorizationAppleIDProvider()
            appleIDProvider.getCredentialState(forUserID: userIdentifier) {  (credentialState, error) in
                switch credentialState {
                case .authorized:
                    self.appleLogin()
                    break
                case .revoked:
                    YXUtils.showHUD(nil, title: "Apple账户失效，请重试，或更换其他登录方式")
                    break
                case .notFound:
                    YXUtils.showHUD(nil, title: "Apple账户尚未绑定，请重试，或更换其他登录方式")
                    break
                default:
                    break
                }
            }
        } else if let credential = authorization.credential as? ASPasswordCredential {
            // 老用户
//            let userIdentifier = credential.user

        }
    }

    // MARK: ==== ASAuthorizationControllerPresentationContextProviding ====
    func presentationAnchor(for controller: ASAuthorizationController) -> ASPresentationAnchor {
        return kWindow
    }
}
