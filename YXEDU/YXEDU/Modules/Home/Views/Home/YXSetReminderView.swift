//
//  YXSetReminderView.swift
//  YXEDU
//
//  Created by Jake To on 3/26/20.
//  Copyright © 2020 shiji. All rights reserved.
//

import UIKit

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
    }

    @IBAction func cancle(_ sender: Any) {
       let alertView = YXAlertView()
        alertView.titleLabel.text = "提升"
        alertView.descriptionLabel.text = "您随时可以在 “我的”->“每日提醒设置” 中设置提醒"
        alertView.shouldOnlyShowOneButton = true
        
        alertView.show()
        
        self.didSetReminder(didOpen: 0)
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
        
        UserDefaults.standard.set(timePicker.date, forKey: "Reminder")
        
        self.didSetReminder(didOpen: 1)
        self.removeFromSuperview()
    }
    
    private func didSetReminder(didOpen: Int) {
        let request = YXHomeRequest.setReminder(dataString: "{\"open_learn_remind\": \(didOpen)}")
        YYNetworkService.default.request(YYStructResponse<YXResultModel>.self, request: request, success: { response in

        }) { error in
            YXUtils.showHUD(kWindow, title: error.message)
        }
    }
}
