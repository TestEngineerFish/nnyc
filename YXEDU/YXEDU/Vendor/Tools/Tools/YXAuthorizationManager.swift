//
//  YXAuthorizationManager.swift
//  YXEDU
//
//  Created by 沙庭宇 on 2019/11/21.
//  Copyright © 2019 shiji. All rights reserved.
//

import Photos
import UserNotifications
import UIKit

class YXAuthorizationManager: NSObject {

    // MARK: - ---获取相册权限
    class func authorizePhotoWith(_ autoAlert: Bool = true, completion:@escaping (Bool) -> Void) {
        let status = PHPhotoLibrary.authorizationStatus()
        switch status {
        case .authorized:
            completion(true)
        case .denied, .restricted:
            YXLog("无相册权限")
            completion(false)
            if autoAlert { showPhotoAlert() }
        case .notDetermined:
            PHPhotoLibrary.requestAuthorization({ (status) in
                DispatchQueue.main.async {
                    let result = (status == PHAuthorizationStatus.authorized)
                    completion(result)
                    if (!result && autoAlert) {
                        showPhotoAlert()
                        YXLog("用户拒绝了相册权限")
                    } else {
                        YXLog("用户授予了相册权限")
                    }
                }
            })
        @unknown default:
            return
        }
    }

    // MARK: - --相机权限
    class func authorizeCameraWith(_ autoAlert: Bool = true, completion:@escaping (Bool) -> Void ) {
        let status = AVCaptureDevice.authorizationStatus(for: AVMediaType.video)
        switch status {
        case .authorized:
            completion(true)
            break
        case .denied, .restricted:
            YXLog("无相机权限")
            completion(false)
            if autoAlert { showCameraAlert() }
            break
        case .notDetermined:
            AVCaptureDevice.requestAccess(for: AVMediaType.video, completionHandler: { (granted: Bool) in
                DispatchQueue.main.async {
                    completion(granted)
                    if (!granted && autoAlert) {
                        showCameraAlert()
                        YXLog("用户拒绝了相机权限")
                    } else {
                        YXLog("用户授予了相机权限")
                    }
                }
            })
        @unknown default:
            return
        }
    }

    // MARK: - --麦克风权限
    class func authorizeMicrophoneWith(_ autoAlert: Bool = true, completion:@escaping (Bool) -> Void ) {

        let status = AVAudioSession.sharedInstance().recordPermission

        switch status {
        case .granted:
            completion(true)
            break
        case .denied:
            YXLog("无麦克风权限")
            completion(false)
            if autoAlert { showMicrophoneAlert() }
            break
        case .undetermined:
            AVAudioSession.sharedInstance().requestRecordPermission { (allow) in
                DispatchQueue.main.async {
//                    completion(allow)
                    if (!allow && autoAlert) {
                        showMicrophoneAlert()
                        YXLog("用户拒绝了麦克风权限")
                    } else {
                        YXLog("用户授予了麦克风权限")
                    }
                }
            }
        @unknown default:
            return
        }
    }

    // MARK: - --位置权限
    class func authorizeLocationWith(_ autoAlert: Bool = true, completion:@escaping (Bool) -> Void ) {

        if CLLocationManager.locationServicesEnabled() {
            let authStatus = CLLocationManager.authorizationStatus()
            if authStatus == .notDetermined || authStatus == .authorizedWhenInUse { // App没有显示过授权，或者已经授权
                YXLog("用户授予了位置权限")
                completion(true)
            } else if authStatus == .restricted || authStatus == .denied { // App没有授权，或者授权后用户手动关闭了
                completion(false)
                YXLog("用户拒绝了位置权限")
                if autoAlert { showLocationAlert() }
            }
        } else {
            completion(false)
            if autoAlert { jumpToSystemLocationSetting() }
        }

    }

    // MARK: - --远程通知权限
    class func authorizeRemoteNotification(_ completion:@escaping (Bool) -> Void) {
        if #available(iOS 10.0, *) {
            UNUserNotificationCenter.current().getNotificationSettings { (settings) in
                DispatchQueue.main.async {
                    if settings.authorizationStatus == .denied || settings.authorizationStatus == .notDetermined {
                        completion(false)
                    }else{
                        completion(true)
                    }
                }
            }
        } else {
            if let userNotificationSettingTyps = UIApplication.shared.currentUserNotificationSettings?.types {
                if userNotificationSettingTyps.contains(.alert) ||
                    userNotificationSettingTyps.contains(.badge) ||
                    userNotificationSettingTyps.contains(.sound) {
                    completion(true)
                }else{
                    completion(false)
                }
            }else{
                completion(false)
            }
        }
    }

    @objc class func authorizeNetwork() {
        showNetworkAlert()
    }
    
    ///请求地理位置权限
    private lazy var locationManager: CLLocationManager = {
        let _locationManager = CLLocationManager()
        _locationManager.delegate = self
        return _locationManager
    }()

    private var authorizationComplet: (() -> Void)?

    func requestWhenInUseAuthorization(_ complet: (() -> Void)?) {
        self.authorizationComplet = complet
        locationManager.requestWhenInUseAuthorization()
    }
}

extension YXAuthorizationManager: CLLocationManagerDelegate {

    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        switch status {
        case .restricted, .denied, .authorizedWhenInUse, .authorizedAlways:
            self.authorizationComplet?()
        default:
            break
        }
    }
}

// MARK: 显示 Alert Controller ================
extension YXAuthorizationManager {

    class func showCameraAlert() {
        showAlert(title: "无法访问你的相机", message: "请到设置 -> 念念有词 -> 相机 ，打开访问权限")
    }

    class func showPhotoAlert() {
        showAlert(title: "无法访问你的照片", message: "请到设置 -> 念念有词 -> 照片 ，打开访问权限")
    }

    class func showLocationAlert() {
        showAlert(title: "无法访问你的位置", message: "请到设置 -> 念念有词 -> 位置 ，打开访问权限")
    }

    class func showMicrophoneAlert() {
        showAlert(title: "无法访问你的麦克风", message: "请到设置 -> 念念有词 -> 麦克风 ，打开访问权限")
    }
    
    class func showNetworkAlert() {
        showAlert(title: "您已关闭\"念念有词\"的无线数据网络", message: "您可以在\"设置\"中为此应用打开无线数据网络")
    }

    class func showAlert(title: String, message: String) {
        let alertView = YXAlertView()
        alertView.titleLabel.text = title
        alertView.descriptionLabel.text = message
        alertView.doneClosure = { _ in
            YXAuthorizationManager.jumpToAppSetting()
        }
        YXAlertQueueManager.default.addAlert(alertView: alertView)
    }

    // MARK: 跳转到APP内设置界面
    class func jumpToAppSetting() {
        guard let appSetting = URL(string: UIApplication.openSettingsURLString) else {
            return
        }
        UIApplication.shared.open(appSetting, options: [:], completionHandler: nil)
    }

    /** 跳转定位服务设置界面 ，使用私有链接，被拒绝了，因此只能提示，不能跳转 */
    class func jumpToSystemLocationSetting() {
//        YYAlertManager.showOneButtonAlertView(title: "APP定位服务未开启，不能推荐周边的朋友给你", description: "请到【设置 -> 隐私 -> 定位服务 -> 定位服务】进行开启", buttonName: "好的", buttonClosure: {})
    }


}
