//
//  YYBaseViewController+CustomNavigationBar.swift
//  YouYou
//
//  Created by sunwu on 2018/12/15.
//  Copyright © 2018 YueRen. All rights reserved.
//

import UIKit


@objc public protocol YWCustomNavigationBarProtocol: NSObjectProtocol {
    
    /** 使用自定义的导航栏 */
    @objc optional func addCustomNavigationBar()
    
    /** 自定义的导航栏 */
    @objc optional var customNavigationBar: YYCustomNavigationBar? { get }
    
    /** 是否为大标题 */
    @objc var isLargeTitle: Bool { set get }
    
}


extension UIViewController: YWCustomNavigationBarProtocol {
    
    /** Runtime关联Key*/
    private struct AssociatedKeys {
        static var customeNavigationBar: String = "kCustomeNavigationBar"
        static var isLargeTitle: String = "kIsLargeTitle"
    }
    
    
    // MARK: ++++++++++ Public ++++++++++
    @objc public func addCustomNavigationBar() {
        self.view.addSubview(self.createCustomNavigationBar())
    }

    @objc public var customNavigationBar: YYCustomNavigationBar? {
        return objc_getAssociatedObject(self, &AssociatedKeys.customeNavigationBar) as? YYCustomNavigationBar
    }
    
    @objc public var isLargeTitle: Bool {
        set (newValue) {
            objc_setAssociatedObject(self, &AssociatedKeys.isLargeTitle, newValue, objc_AssociationPolicy.OBJC_ASSOCIATION_ASSIGN)
        }
        get {
            guard let value = objc_getAssociatedObject(self, &AssociatedKeys.isLargeTitle) as? Bool else {
                return false
            }
            return value
        }
    }
    
    
    // MARK: ++++++++++ Private ++++++++++
    private func createCustomNavigationBar() -> YYCustomNavigationBar {
        #if DEBUG
            // 摇一摇功能
            self.becomeFirstResponder()
        #endif
        
        let cnb = YYCustomNavigationBar(largeTitle: self.isLargeTitle)
        objc_setAssociatedObject(self, &AssociatedKeys.customeNavigationBar, cnb, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        return cnb
    }
    
}

extension YWCustomNavigationBarProtocol where Self: UIViewController {
    
    
}

extension UIViewController: UINavigationControllerDelegate {
    
    /** 当使用自定义导航条的时候，左滑返回会消失，因此需要实现该方法*/
    public func navigationController(_ navigationController: UINavigationController, willShow viewController: UIViewController, animated: Bool) {
        if viewController == self {
            navigationController.setNavigationBarHidden(true, animated: true)
            //            self.leftButtonAction?()
        } else {
            
            //系统相册继承自 UINavigationController 这个不能隐藏
            if navigationController.isKind(of: UIImagePickerController.self) {
                return
            }
            
            //当不显示本页时，要么就push到下一页，要么就被pop了，那么就将delegate设置为nil，防止出现BAD ACCESS
            let name: AnyClass? = (navigationController.delegate as? UIViewController)?.classForCoder
            if name == self.classForCoder {
                //如果delegate是自己才设置为nil，因为viewWillAppear调用的比此方法较早，其他controller如果设置了delegate就可能会被误伤
                navigationController.delegate = nil
            }
        }
    }
}


extension YXViewController {
    override func motionEnded(_ motion: UIEvent.EventSubtype, with event: UIEvent?) {
        #if DEBUG
        if event?.subtype == .motionShake
            && YRRouter.sharedInstance().currentViewController()?.classForCoder != YYEnvChangeViewController.classForCoder() {
            self.navigationController?.present(YYEnvChangeViewController(), animated: true, completion: nil)

            YXLog("用户UUID:", YXUserModel.default.uuid ?? "")
            YXLog("用户目录：", DDFileLogger().logFileManager.logsDirectory)
        }
        #endif
    }
}
