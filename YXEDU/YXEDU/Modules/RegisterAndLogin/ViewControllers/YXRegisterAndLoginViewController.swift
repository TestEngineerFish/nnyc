//
//  YXRegisterViewController.swift
//  YXEDU
//
//  Created by Jake To on 10/25/19.
//  Copyright © 2019 shiji. All rights reserved.
//

import UIKit

class YXRegisterAndLoginViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        initShanYan()
    }
    
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
//        configure.clAuthWindowPresentingAnimate = false
        configure.clNavigationBarHidden = true
        configure.clPhoneNumberFont = UIFont.systemFont(ofSize: 20, weight: .regular)
        configure.clLoginBtnTextColor = .white
        configure.clLoginBtnTextFont = UIFont.systemFont(ofSize: 17)
        configure.clLoginBtnNormalBgImage = #imageLiteral(resourceName: "buttonBackground")
//        configure.clAppPrivacyTextFont = UIFont.systemFont(ofSize: 10, weight: .regular)
//        configure.clAppPrivacyPunctuationMarks = true
//        configure.clAppPrivacyFirst = ["《用户协议》", URL(string: "https://www.google.com")!]
        
        let layoutConfigure = CLOrientationLayOut()
        layoutConfigure.clLayoutPhoneCenterX = NSNumber(0)
        layoutConfigure.clLayoutPhoneCenterY = NSNumber(-84)
        layoutConfigure.clLayoutSloganCenterX = NSNumber(0)
        layoutConfigure.clLayoutSloganCenterY = NSNumber(-52)
        layoutConfigure.clLayoutLoginBtnCenterX = NSNumber(0)
        layoutConfigure.clLayoutLoginBtnCenterY = NSNumber(16)
//        layoutConfigure.clLayoutAppPrivacyCenterX = NSNumber(0)
        layoutConfigure.clLayoutAppPrivacyCenterY = NSNumber(10000)//44)
//        layoutConfigure.clLayoutAppPrivacyWidth = NSNumber(value: Float(screenWidth - 80))
//        layoutConfigure.clLayoutAppPrivacyHeight = NSNumber(40)
        configure.clOrientationLayOutPortrait = layoutConfigure
        
        configure.customAreaView = { [unowned self] view in
            let iconImageView = UIImageView()
            iconImageView.contentMode = .scaleAspectFill
            iconImageView.image = #imageLiteral(resourceName: "logo")
            
            let containerView = UIView()
//            containerView.layer.masksToBounds = false
//            containerView.layer.shadowOffset = .zero
//            containerView.layer.shadowOpacity = 1
//            containerView.layer.shadowRadius = 10
//            containerView.layer.shadowColor = UIColor(red: 0.78, green: 0.78, blue: 0.78, alpha: 0.5).cgColor
//            containerView.layer.borderWidth = 0.5
//            containerView.layer.borderColor = UIColor.white.cgColor
//            containerView.layer.cornerRadius = 6
            
//            let path = UIBezierPath(roundedRect: containerView.bounds, byRoundingCorners: .allCorners, cornerRadii: CGSize(width: 6, height: 6))
//            let shape = CAShapeLayer()
//            shape.path = path.cgPath
//            containerView.layer.mask = shape
            
            let authIconImageView = UIImageView()
            authIconImageView.contentMode = .scaleAspectFill
            authIconImageView.image = #imageLiteral(resourceName: "auth")
            
            let agreementLabel = UILabel()
            agreementLabel.text = "登录即同意"
            agreementLabel.textColor = UIColor(red: 0.53, green: 0.53, blue: 0.53, alpha: 1)
            agreementLabel.font = UIFont.systemFont(ofSize: 10)
            
            let agreementButton = UIButton()
            agreementButton.setTitle("《用户协议》", for: .normal)
            agreementButton.setTitleColor(UIColor(red: 0.2, green: 0.2, blue: 0.2, alpha: 1), for: .normal)
            agreementButton.titleLabel?.font = UIFont.systemFont(ofSize: 10)
            
            let underLineView = UIView()
            underLineView.backgroundColor = UIColor(red: 79/255, green: 79/255, blue: 79/255, alpha: 1)
            
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
            qqLoginButton.setImage(#imageLiteral(resourceName: "qq"), for: .normal)
            
            let wechatLoginButton = UIButton()
            wechatLoginButton.setImage(#imageLiteral(resourceName: "wechat"), for: .normal)
            
            let bottomImageView = UIImageView()
            bottomImageView.contentMode = .scaleAspectFill
            bottomImageView.image = #imageLiteral(resourceName: "loginBackground")
            
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
            
//            let path = UIBezierPath(roundedRect: containerView.bounds, byRoundingCorners: .allCorners, cornerRadii: CGSize(width: 6, height: 6))
//            let shape = CAShapeLayer()
//            shape.path = path.cgPath
//            containerView.layer.mask = shape
            
//            containerView.addSubview(authIconImageView)
//            authIconImageView.snp.makeConstraints { (make) in
//                make.centerX.equalToSuperview().offset(-54)
//                make.centerY.equalToSuperview().offset(-36)
//                make.height.width.equalTo(18)
//            }
            
            containerView.addSubview(agreementLabel)
            agreementLabel.snp.makeConstraints { (make) in
                make.centerX.equalToSuperview().offset(-24)
                make.centerY.equalToSuperview().offset(80)
                make.width.equalTo(54)
                make.height.equalTo(14)
            }
            
            containerView.addSubview(agreementButton)
            agreementButton.snp.makeConstraints { (make) in
                make.left.equalTo(agreementLabel.snp.right).offset(-8)
                make.centerY.equalTo(agreementLabel)
                make.height.equalTo(14)
            }
            
            containerView.addSubview(underLineView)
            underLineView.snp.makeConstraints { (make) in
                make.top.equalTo(agreementButton.snp.bottom)
                make.centerX.equalTo(agreementButton)
                make.width.equalTo(46)
                make.height.equalTo(0.5)
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
