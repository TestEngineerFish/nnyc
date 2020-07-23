//
//  YYEnvChangeViewController.swift
//  YouYou
//
//  Created by sunwu on 2018/12/27.
//  Copyright © 2018 YueRen. All rights reserved.
//

import UIKit


typealias YYEVC = YYEnvChangeViewController

@objc class YYEnvChangeViewController: YXViewController {
    
    var screenWidth: CGFloat = UIScreen.main.bounds.size.width
    var screenHeight: CGFloat = UIScreen.main.bounds.size.height
    
    var green1 = UIColor(red: 8 / 255, green: 207 / 255, blue: 78 / 255, alpha: 1)
    var white1 = UIColor(red: 252 / 255, green: 252, blue: 254, alpha: 1)
    var gray1 = UIColor(red: 136 / 255, green: 136 / 255, blue: 136 / 255, alpha: 1)
    var gray2 = UIColor(red: 165 / 255, green: 165 / 255, blue: 165 / 255, alpha: 1)
    var black2 = UIColor(red: 64 / 255, green: 64 / 255, blue: 64 / 255, alpha: 1)
    
    var contentView_TopOffset: CGFloat = 88 //kIsIPhoneXSerious ? 88 : 64

    @objc  func imageWithColor(_ color: UIColor, height: CGFloat = 1.0) -> UIImage {
        return self.imageWithColor(color, width: 1.0, height: height)
    }
    
    @objc  func imageWithColor(_ color: UIColor, width: CGFloat = 1.0, height: CGFloat = 1.0) -> UIImage {
        return self.imageWithColor(color, width: width, height: height, cornerRadius: 0.0)
    }
    
    @objc  func imageWithColor(_ color: UIColor, width: CGFloat = 1.0, height: CGFloat = 1.0, cornerRadius: CGFloat = 0) -> UIImage {
        
        let rect = CGRect(x: 0, y: 0, width: width, height: height)
        let roundedRect: UIBezierPath = UIBezierPath(roundedRect: rect, cornerRadius: cornerRadius)
        roundedRect.lineWidth = 0
        
        UIGraphicsBeginImageContextWithOptions(rect.size, false, 0.0)
        color.setFill()
        roundedRect.fill()
        roundedRect.stroke()
        roundedRect.addClip()
        var image: UIImage? = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        image = image?.resizableImage(withCapInsets: UIEdgeInsets(top: cornerRadius, left: cornerRadius, bottom: cornerRadius, right: cornerRadius))
        return image ?? UIImage()
    }


    private enum EnvType: Int {
        case dev = 0
        case test = 1
        case pre = 2
        case release = 3
    }

    private static let envKey = "YYEnvChangeView_Key";

    private var currentSelected: Int = 3

    private static let envData = [
        EnvType.dev  : ["title" : "开发环境", "api" : "http://common.api.xstudyedu.com",  "h5" : "http://common.api.xstudyedu.com"],
        EnvType.test : ["title" : "测试环境", "api" : "http://nnyc-api-test.xstudyedu.com", "h5" : "http://nnyc-api-test.xstudyedu.com"],
        EnvType.pre  : ["title" : "预发环境", "api" : "http://nnyc-api-pre.xstudyedu.com",  "h5" : "https://pre.helloyouyou.com"],
        EnvType.release : ["title" : "正式环境", "api" : "http://nnyc-api.xstudyedu.com",   "h5" : "http://nnyc-api.xstudyedu.com"]
    ]

    private lazy var tableView: UITableView = {
        let tv = UITableView()
        tv.frame = CGRect(x: 0 , y: contentView_TopOffset, width: screenWidth, height: screenHeight - contentView_TopOffset)
        tv.delegate = self
        tv.dataSource = self
        tv.tableFooterView = UIView(frame: CGRect(x: 0, y: 0, width: screenWidth, height: 160))
        tv.tableFooterView?.backgroundColor = white1
        tv.tableFooterView?.addSubview(self.button)
        tv.tableFooterView?.addSubview(self.tipsLabel)
        tv.tableFooterView?.addSubview(self.backButton)
        return tv
    }()


    private lazy var button: UIButton = {
        let button = UIButton()

        button.frame = CGRect(x: 30, y: 40, width: screenWidth - 60, height: 50)
        button.setTitle("确认切换", for: .normal)
        button.titleLabel?.textColor = self.black2
        button.setBackgroundImage(self.imageWithColor(self.green1), for: .normal)
        button.setBackgroundImage(self.imageWithColor(self.green1.withAlphaComponent(0.4)), for: .highlighted)
        button.addTarget(self, action: #selector(buttonDidClick), for: .touchUpInside)

        button.layer.cornerRadius = 10
        button.layer.masksToBounds = true

        button.isEnabled = false

        return button
    }()

    private lazy var tipsLabel: UILabel = {
        let label = UILabel()
        label.frame = CGRect(x: 0, y: 90, width: screenWidth, height: 30)
        label.text = "点击确认切换，会杀掉App"
        label.textColor = self.gray1
        label.font = UIFont.systemFont(ofSize: 14)
        label.textAlignment = .center
        return label
    }()
    
    
    private lazy var backButton: UIButton = {
        let button = UIButton()
        
        button.frame = CGRect(x: (screenWidth - screenWidth / 3) / 2 , y: 120, width: screenWidth / 3, height: 40)
        button.setTitle("返回", for: .normal)
        button.titleLabel?.textColor = self.black2
        button.setBackgroundImage(self.imageWithColor(self.green1), for: .normal)
        button.setBackgroundImage(self.imageWithColor(self.green1.withAlphaComponent(0.4)), for: .highlighted)
        button.addTarget(self, action: #selector(backButtonDidClick), for: .touchUpInside)
        
        button.layer.cornerRadius = 10
        button.layer.masksToBounds = true
        
        return button
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

//        self.navigationController?.navigationBar.isHidden = false
//        self.navigationController?.title = "选择环境"
        self.customNavigationBar?.title = "选择环境"

        self.view.addSubview(self.tableView)
        self.view.backgroundColor = white1
        self.currentSelected = (YYCache.object(forKey: YYEVC.envKey) as? Int) ?? 1
    }

}


extension YYEnvChangeViewController {
    @objc public static var apiUrl: String {
        #if DEBUG
            if let selected = YYCache.object(forKey: envKey) as? Int, let e = EnvType(rawValue: selected) {
                return envData[e]?["api"] ?? ""
            }
            return envData[.test]?["api"] ?? ""
        #else
            return envData[.release]?["api"] ?? ""
        #endif
    }

    @objc public static var h5Url: String {
        #if DEBUG
            if let selected = YYCache.object(forKey: envKey) as? Int, let e = EnvType(rawValue: selected) {
                return envData[e]?["h5"] ?? ""
            }
            return envData[.test]?["h5"] ?? ""
        #else
            return envData[.release]?["h5"] ?? ""
        #endif
    }
}


extension YYEnvChangeViewController: UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return YYEVC.envData.count
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let idf = "kUITableViewCell"

        var cell = tableView.dequeueReusableCell(withIdentifier: idf)
        if cell == nil {
            cell = UITableViewCell(style: .subtitle, reuseIdentifier: idf)
        }

        let type = EnvType(rawValue: indexPath.row) ?? .test

        cell?.textLabel?.text = YYEVC.envData[type]?["title"]
        cell?.textLabel?.font = UIFont.boldSystemFont(ofSize: 17)

        let detailText = "API: \(YYEVC.envData[type]?["api"] ?? "")\nH5: \(YYEVC.envData[type]?["h5"] ?? "")"
        cell?.detailTextLabel?.numberOfLines = 0
        cell?.detailTextLabel?.text = detailText
        cell?.detailTextLabel?.textColor = self.gray2


        if indexPath.row == currentSelected {
            cell?.accessoryType = .checkmark
            tableView.selectRow(at: indexPath, animated: false, scrollPosition: .none)
        }

        return cell ?? UITableViewCell()
    }

}


extension YYEnvChangeViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

        let lastCell = tableView.cellForRow(at: IndexPath(row: currentSelected, section: 0))
        lastCell?.accessoryType = .none

        tableView.cellForRow(at: indexPath)?.accessoryType = .checkmark

        self.currentSelected = indexPath.row

        if let selected = YYCache.object(forKey: YYEVC.envKey) as? Int, selected == currentSelected {
            self.button.isEnabled = false
        } else {
            self.button.isEnabled = true
        }
    }
}

extension YYEnvChangeViewController {
    @objc private func buttonDidClick() {

        YYCache.set(currentSelected, forKey: YYEVC.envKey)

        let exitBlock = {
            YXUtils.showHUD(self.view, title: "正在关闭App")
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.5) {
                exit(0)
            }
        }
        YXUserModel.default.logout {
            exitBlock()
        }
    }
    
    @objc private func backButtonDidClick() {
        self.navigationController?.popViewController(animated: true)
    }
}
