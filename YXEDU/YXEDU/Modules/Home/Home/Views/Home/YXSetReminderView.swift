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
        let service = YXExerciseServiceImpl()
        if let startStudyTime = service.studyDao.getBaseStudyLastStartTime() {
            let minute = Calendar.current.component(.minute, from: startStudyTime)
            let offsetTime = minute - 30
            if offsetTime < 0 {
                timePicker.date = startStudyTime.offsetMinutes(minutes: -(offsetTime + 30)) ?? Date()
            } else {
                timePicker.date = startStudyTime.offsetMinutes(minutes: -offsetTime) ?? Date()
            }
        }
    }

    @IBAction func cancle(_ sender: Any) {
       let alertView = YXAlertView()
        alertView.titleLabel.text = "提示"
        alertView.descriptionLabel.text = "您随时可以在 “我的”->“每日提醒设置” 中设置提醒"
        alertView.shouldOnlyShowOneButton = true
        alertView.rightOrCenterButton.setTitle("好的", for: .normal)

        YXAlertQueueManager.default.addAlert(alertView: alertView)
        YYCache.set(timePicker.date, forKey: .didShowSetupReminderAlert)
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
        
        YYCache.set(timePicker.date, forKey: .didShowSetupReminderAlert)
        YYCache.set(timePicker.date, forKey: .reminder)
        
        YXSetReminderView.didSetReminder(didOpen: 1, time: NSNumber(value: timePicker.date.timeIntervalSince1970))
        self.removeFromSuperview()
    }
    
    @objc
    class func didSetReminder(didOpen: Int, time: NSNumber = 0) {
        let jsonString = "{\"is_open\":\(didOpen),\"time\":\(time.doubleValue)}"
        self.requestReportNotification(dataString: "{\"learn_remind\": \(jsonString)}")
    }

    @objc
    class func setReminderTime(date: Date?) {
        YYCache.set(date, forKey: .didShowSetupReminderAlert)
        YYCache.set(date, forKey: .reminder)
    }

    @objc
    class func getReminderDate() -> Date? {
       return YYCache.object(forKey: .reminder) as? Date
    }

    class func requestReportNotification(dataString: String) {
        let request = YXHomeRequest.setReminder(dataString: dataString)
        YYNetworkService.default.request(YYStructResponse<YXResultModel>.self, request: request, success: { response in

        }) { error in
            YXUtils.showHUD(nil, title: error.message)
        }
    }
}
