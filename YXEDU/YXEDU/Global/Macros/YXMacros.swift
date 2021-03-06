//
//  YXMacros.swift
//  YXEDU
//
//  Created by 沙庭宇 on 2019/10/24.
//  Copyright © 2019 shiji. All rights reserved.
//

import Foundation

public let screenWidth  = UIScreen.main.bounds.size.width
public let screenHeight = UIScreen.main.bounds.size.height
public let screenScale  = UIScreen.main.scale
/// 状态栏高度
public var kStatusBarHeight:CGFloat {
    get {
        return iPhoneXLater ? 44.0 : 20.0
    }
}

/// Navigation Bar + 状态栏 高度
public var kNavHeight:CGFloat {
    get {
        return kStatusBarHeight + 44.0
    }
}

/// Navigation Bar 高度
public var kNavBarHeight:CGFloat {
    get {
        return 44.0
    }
}

// TabBar 高度
public var kTabBarHeight:CGFloat {
    get {
        return 49 + kSafeBottomMargin
    }
}

/// 当前Window
public var kWindow: UIWindow {
    get {
        guard let window = UIApplication.shared.keyWindow else {
            return UIWindow(frame: CGRect.zero)
        }
        return window
    }
}

/// 全面屏的底部安全高度
public var kSafeBottomMargin:CGFloat {
    get {
        return iPhoneXLater ? 34.0 : 0.0
    }
}

/// 是否是新学
/// - Parameter type: 题型
/// - Returns: 是否是新学
func isNewLearn(question type: YXQuestionType) -> Bool {
    let newLearnArray: [YXQuestionType] = [.newLearnPrimarySchool,
                                           .newLearnPrimarySchool_Group,
                                           .newLearnJuniorHighSchool,
                                           .newLearnMasterList]
    return newLearnArray.contains(type)
}

public let iPhoneXLater: Bool = {
    return YYDeviceModel.iPhoneXLater_Device
}()

public let iPhone4: Bool = {
    return YYDeviceModel.iPhone4_Device
}()

public let iPhone5: Bool = {
    return YYDeviceModel.iPhone5_Device
}()

public let iPhone6: Bool = {
    return YYDeviceModel.iPhone6_Device
}()

public let iPhone6p: Bool = {
    return YYDeviceModel.iPhone6p_Device
}()

public let iPhone6p_MIN: Bool = {
    return YYDeviceModel.iPhone6p_MIN_Device
}()

public let iPhoneX: Bool = {
    return YYDeviceModel.iPhoneX_Device
}()

public let iPhoneXS: Bool = {
    return YYDeviceModel.iPhoneXS_Device
}()

public let iPhoneXS_MAX: Bool = {
    return YYDeviceModel.iPhoneXS_MAX_Device
}()

public let iPhoneXR: Bool = {
    return YYDeviceModel.iPhoneXR_Device
}()

@objc public class YYDeviceModel: NSObject {
    @objc public static let iPhone4_Device: Bool = {
        guard let _currentModeSize = UIScreen.main.currentMode?.size else {
            return false
        }
        return _currentModeSize == CGSize(width: 640, height: 960)
    }()

    @objc public static let iPhone5_Device: Bool = {
        guard let _currentModeSize = UIScreen.main.currentMode?.size else {
            return false
        }
        return _currentModeSize == CGSize(width: 640, height: 1136)
    }()

    @objc public static let iPhone6_Device: Bool = {
        guard let _currentModeSize = UIScreen.main.currentMode?.size else {
            return false
        }
        return _currentModeSize == CGSize(width: 750, height: 1134)
    }()

    @objc public static let iPhone6p_Device: Bool = {
        guard let _currentModeSize = UIScreen.main.currentMode?.size else {
            return false
        }
        return _currentModeSize == CGSize(width: 1242, height: 2208)
    }()

    @objc public static let iPhone6p_MIN_Device: Bool = {
        guard let _currentModeSize = UIScreen.main.currentMode?.size else {
            return false
        }
        return _currentModeSize == CGSize(width: 1125, height: 2001)
    }()

    @objc public static let iPhoneX_Device: Bool = {
        guard let _currentModeSize = UIScreen.main.currentMode?.size else {
            return false
        }
        return _currentModeSize == CGSize(width: 1125, height: 2436)
    }()

    @objc public static let iPhoneXS_Device: Bool = {
        guard let _currentModeSize = UIScreen.main.currentMode?.size else {
            return false
        }
        return _currentModeSize == CGSize(width: 1125, height: 2436)
    }()

    @objc public static let iPhoneXS_MAX_Device: Bool = {
        guard let _currentModeSize = UIScreen.main.currentMode?.size else {
            return false
        }
        return _currentModeSize == CGSize(width: 1242, height: 2688)
    }()

    @objc public static let iPhoneXR_Device: Bool = {
        guard let _currentModeSize = UIScreen.main.currentMode?.size else {
            return false
        }
        return _currentModeSize == CGSize(width: 828, height: 1792)
    }()

    @objc public static let iPhoneXLater_Device: Bool = {
        return (iPhoneX || iPhoneXS || iPhoneXS_MAX || iPhoneXR)
    }()
}
//MARK: *************************** 屏幕尺寸判断  ******************/


/************************* 状态栏高度 *****************/
public let statusBar_Height: CGFloat = {

    return UIApplication.shared.statusBarFrame.size.height
}()

/************************* 导航栏高度 *****************/
//public let navigationBar_Height: CGFloat = 44.0

/************************* TabBar高度 *****************/
public let tabBar_Height: CGFloat = 51.0
public let newTabBar_Height: CGFloat = iPhoneXLater ? 85.0 : 51.0

/******************* 为适配iPHONEX以后设备 底部安全区域  ************/
public let bottom_Home_Safe_Area_Height: CGFloat = {
    return iPhoneXLater ? 34.0 : 0.0
}()

/// 记录普通操作日志
public func YXLog(_ items: Any..., separator: String = " ", terminator: String = "\n") {
    var message = ""
    items.forEach { (item) in
        if let itemStr = item as? String {
            message += " " + itemStr
        } else {
            message += " \(item)"
        }
    }
    YXOCLog.shared()?.eventLog(message)
}
 
/// 记录网络请求日志
public func YXRequestLog(_ items: Any..., separator: String = " ", terminator: String = "\n") {
    var message = ""
    items.forEach { (item) in
        if let itemStr = item as? String {
            message += " " + itemStr
        } else {
            message += " \(item)"
        }
    }
    YXOCLog.shared().request(message)
}
