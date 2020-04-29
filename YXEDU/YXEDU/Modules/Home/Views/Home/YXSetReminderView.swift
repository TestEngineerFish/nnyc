//
//  YXSetReminderView.swift
//  YXEDU
//
//  Created by Jake To on 3/26/20.
//  Copyright © 2020 shiji. All rights reserved.
//

import UIKit

@objc
class YXSetReminderView: YXTopWindowView {

    @IBOutlet var contentView: UIView!
    @IBOutlet weak var timePicker: UIDatePicker!
    
    init() {
        super.init(frame: CGRect(x: 0, y: 0, width: screenWidth, height: screenHeight))
        initializationFromNib()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        initializationFromNib()
    }
    
    private func initializationFromNib() {
        Bundle.main.loadNibNamed("YXSetReminderView", owner: self, options: nil)
        addSubview(contentView)
        contentView.frame = self.bounds
        
        if let startStudyTime = YYCache.object(forKey: "StartStudyTime") as? Date {
            let minute = Calendar.current.component(.minute, from: startStudyTime)
            
            if minute > 30 {
                let difference = minute - 30
                timePicker.date = Date(timeIntervalSince1970: startStudyTime.timeIntervalSince1970 - Double((difference * 60)))
                
            } else {
                timePicker.date = Date(timeIntervalSince1970: startStudyTime.timeIntervalSince1970 - Double((minute * 60)))
            }
        }
    }

    @IBAction func cancle(_ sender: Any) {
       let alertView = YXAlertView()
        alertView.titleLabel.text = "提示"
        alertView.descriptionLabel.text = "您随时可以在 “我的”->“每日提醒设置” 中设置提醒"
        alertView.shouldOnlyShowOneButton = true
        alertView.rightOrCenterButton.setTitle("好的", for: .normal)
        alertView.show()
        
        UserDefaults.standard.set(timePicker.date, forKey: "DidShowSetupReminderAlert")

        YXSetReminderView.didSetReminder(didOpen: 0)
        self.removeFromSuperview()
    }
    
    @IBAction func done(_ sender: Any) {
        let notificationCenter = UNUserNotificationCenter.current()
        
        let content = UNMutableNotificationContent()
        content.body = "今天的背单词计划还未完成哦，戳我一下马上开始学习~"
        content.sound = UNNotificationSound.default
        content.badge = 1
        
        let components = Calendar.current.dateComponents([.timeZone, .hour, .minute], from: timePicker.date)
        let trigger = UNCalendarNotificationTrigger(dateMatching: components, repeats: true)
        let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)
        notificationCenter.add(request)
        
        UserDefaults.standard.set(timePicker.date, forKey: "DidShowSetupReminderAlert")
        UserDefaults.standard.set(timePicker.date, forKey: "Reminder")
        
        YXSetReminderView.didSetReminder(didOpen: 1, time: NSNumber(value: timePicker.date.timeIntervalSince1970))
        self.removeFromSuperview()
    }
    
    @objc
    class func didSetReminder(didOpen: Int, time: NSNumber = 0) {
        let jsonString = "{\"is_open\":\(didOpen),\"time\":\(time.doubleValue)}"
        let request = YXHomeRequest.setReminder(dataString: "{\"learn_remind\": \(jsonString)}")
        YYNetworkService.default.request(YYStructResponse<YXResultModel>.self, request: request, success: { response in

        }) { error in
            YXUtils.showHUD(kWindow, title: error.message)
        }
    }
}
