//
//  YXTaskCenterViewController.swift
//  YXEDU
//
//  Created by Jake To on 12/16/19.
//  Copyright © 2019 shiji. All rights reserved.
//

import UIKit

class YXTaskCenterViewController: YXViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UITableViewDelegate, UITableViewDataSource {
    
    var fromYXSquirrelCoinViewController = false
    private var taskCenterData: YXTaskCenterDataModel?
    private var dailyDatas: [YXTaskCenterDailyDataModel] = []
    private var taskLists: [YXTaskListModel] = []

    @IBOutlet weak var integralLabel: YXDesignableLabel!
    @IBOutlet weak var dailyDataCollectionView: UICollectionView!
    @IBOutlet weak var punchButton: YXDesignableButton!
    @IBOutlet weak var totalPunchLabel: UILabel!
    @IBOutlet weak var weekendPunchLabel: UILabel!
    @IBOutlet weak var taskTableView: UITableView!
    @IBOutlet weak var taskTableViewHeight: NSLayoutConstraint!
    @IBOutlet weak var viewTopConstraint: NSLayoutConstraint!
    
    @IBAction func punchIn(_ sender: Any) {
        let request = YXTaskCenterRequest.punchIn
        YYNetworkService.default.request(YYStructResponse<YXTaskCenterDataModel>.self, request: request, success: { [weak self] (response) in
            guard let self = self else { return }
            self.taskCenterData = response.data
            self.reloadDailyData()
            
            YXToastView().showCoinView(self.dailyDatas[(self.taskCenterData?.today ?? 1) - 1].integral ?? 0)
        }) { error in
            YXUtils.showHUD(nil, title: error.message)
        }
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }

    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.createSubviews()
        self.bindProperty()
        self.requestPunchData()
        self.requestTaskList()
    }

    private func createSubviews() {
        self.customNavigationBar?.title = "任务中心"
        self.customNavigationBar?.titleColor = .white
        self.customNavigationBar?.leftButton.setTitleColor(.white, for: .normal)
        self.customNavigationBar?.rightButton.setImage(#imageLiteral(resourceName: "questionIcon"), for: .normal)
        self.customNavigationBar?.rightButtonAction = {
            guard let urlStr = YXUserModel.default.coinExplainUrl, let url = URL(string: urlStr) else {
                return
            }
            let alertView = YXAlertWebView()
            alertView.url = url
            YXAlertQueueManager.default.addAlert(alertView: alertView)
        }
        self.viewTopConstraint.constant = kNavHeight
        dailyDataCollectionView.register(UINib(nibName: "YXTaskCenterDateCell", bundle: nil), forCellWithReuseIdentifier: "YXTaskCenterDateCell")
        taskTableView.register(UINib(nibName: "YXTaskCenterCell", bundle: nil), forCellReuseIdentifier: "YXTaskCenterCell")
    }

    private func bindProperty() {
        NotificationCenter.default.addObserver(self, selector: #selector(completedTask(notification:)), name: YXNotification.kCompletedTask, object: nil)
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)

        if fromYXSquirrelCoinViewController == false {
            self.navigationController?.navigationBar.barStyle = .default
            self.navigationController?.navigationBar.barTintColor = UIColor.white
            self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.black]
            self.navigationController?.navigationBar.tintColor = UIColor.black
        }
    }
    
    private func reloadDailyData() {
        var dailyDatas = self.taskCenterData?.dailyData ?? []
        
        var punchCount = 0
        var didFindWitchDayIsToday = false
        for index in 0..<dailyDatas.count {
            
            switch index {
            case 0:
                dailyDatas[index].weekName = "周一"
                
            case 1:
                dailyDatas[index].weekName = "周二"
                
            case 2:
                dailyDatas[index].weekName = "周三"
                
            case 3:
                dailyDatas[index].weekName = "周四"
                
            case 4:
                dailyDatas[index].weekName = "周五"
                
            case 5:
                dailyDatas[index].weekName = "周六"
                
            case 6:
                dailyDatas[index].weekName = "周末"
                
            default:
                break
            }
            
            if dailyDatas[index].didPunchIn == 1 {
                punchCount = punchCount + 1
            }
            
            if didFindWitchDayIsToday {
                dailyDatas[index].dailyStatus = .tomorrow
                
            } else {
                dailyDatas[index].dailyStatus = .yesterday
            }
            
            if let today = self.taskCenterData?.today, index == today - 1 {
                didFindWitchDayIsToday = true
                dailyDatas[index].dailyStatus = .today
                
                if dailyDatas[index].didPunchIn == 1 {
                    punchButton.setTitle("已签到", for: .normal)
                    punchButton.isEnabled = false
                    punchButton.alpha = 0.3
                    
                } else {
                    punchButton.isEnabled = true
                    punchButton.alpha = 1
                }
            }
        }
        
        var exIntegral = self.taskCenterData?.exIntegral ?? 0
        if dailyDatas[6].dailyStatus == .today, dailyDatas[6].didPunchIn == 1 {
            exIntegral = (punchCount - 1) * exIntegral

        } else {
            exIntegral = punchCount * exIntegral
        }
        dailyDatas[6].integral = 10 + exIntegral
        self.dailyDatas = dailyDatas
        
        let integral = self.taskCenterData?.integral ?? 0
        if self.integralLabel.text == "--" {
            self.integralLabel.count(from: 0, to: Float(integral), duration: 1)
        } else {
            self.integralLabel.countFromCurrent(to: Float(integral), duration: 1)
        }

        self.totalPunchLabel.text   = "\(punchCount)"
        self.weekendPunchLabel.text = "\(exIntegral)"

        self.dailyDataCollectionView.reloadData()
    }

    // MARK: ==== Notification ====
    @objc private func completedTask(notification: Notification) {
        if let taskId = notification.userInfo?["id"] as? Int, let indexPath = notification.userInfo?["indexPath"] as? IndexPath, let didRepeat = notification.userInfo?["didRepeat"] as? Bool, let integral = notification.userInfo?["integral"] as? Int {
            self.completed(task: taskId, indexPath: indexPath, didRepeat: didRepeat, integral: integral)
        }
    }

    // MARK: ==== Request ====

    private func completed(task id: Int, indexPath: IndexPath, didRepeat: Bool, integral: Int) {
        let request = YXTaskCenterRequest.getIntegral(taskId: id)
        YYNetworkService.default.request(YYStructResponse<YXResultModel>.self, request: request, success: { [weak self] (response) in
            guard let self = self else { return }
            self.requestTaskList { [weak self] in
                guard let self = self else { return }
                YXRedDotManager.share.updateTaskCenterBadge()
                if let currentIntegral = Int(self.integralLabel.text ?? "0") {
                    self.integralLabel.countFromCurrent(to: Float(currentIntegral + integral), duration: 1)
                    YXToastView().showCoinView(integral)
                }
            }
        }) { error in
            YXUtils.showHUD(nil, title: error.message)
        }
    }

    private func requestPunchData() {
        let punchDataRequest = YXTaskCenterRequest.punchData
        YYNetworkService.default.request(YYStructResponse<YXTaskCenterDataModel>.self, request: punchDataRequest, success: { [weak self] (response) in
            guard let self = self else { return }
            self.taskCenterData = response.data
            self.reloadDailyData()
        }) { error in
            YXUtils.showHUD(nil, title: error.message)
        }
    }

    private func requestTaskList(finished block: (()->Void)? = nil) {
        let taskListRequest = YXTaskCenterRequest.taskList
        YYNetworkService.default.request(YYStructDataArrayResponse<YXTaskListModel>.self, request: taskListRequest, success: { [weak self] (response) in
            guard let self = self else { return }
            self.taskLists = response.dataArray ?? []
            self.taskTableViewHeight.constant = CGFloat(self.taskLists.count * 172)
            self.taskTableView.reloadData()
            block?()
        }) { error in
            YXUtils.showHUD(nil, title: error.message)
        }
    }

    // MARK：- table view
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return taskLists.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "YXTaskCenterCell", for: indexPath) as? YXTaskCenterCell else {
            return UITableViewCell()
        }
        let taskList = taskLists[indexPath.row]
        
        if (taskList.list?.count ?? 0) > 0 {
            cell.titleLabel.text = taskList.typeName
            
        } else {
            cell.titleLabel.text = " "
        }
        let taskListModel = self.taskLists[indexPath.row]
        cell.setData(taskList: taskListModel, indexPath: indexPath)
        return cell
    }
    
    // MARK：- collection view
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dailyDatas.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "YXTaskCenterDateCell", for: indexPath) as? YXTaskCenterDateCell else {
            return UICollectionViewCell()
        }
        let dailyData = dailyDatas[indexPath.row]

        cell.weekLabel.text = dailyData.weekName

        switch dailyData.dailyStatus {
        case .yesterday:
            cell.containerView.backgroundColor = UIColor.hex(0xF3F3F3)
            cell.containerView.borderWidth = 0
            cell.integralLabel.text = "+\(dailyData.integral ?? 0)"
            cell.integralLabel.textColor = UIColor.hex(0xD0D0D0)
            cell.weekLabel.textColor = UIColor.hex(0xCDB291)

            if dailyData.didPunchIn == 1 {
                cell.noCoinView.isHidden = true
                cell.coinImageView.isHidden = false
                cell.coinImageView.image = #imageLiteral(resourceName: "coinGot")

            } else {
                cell.noCoinView.isHidden = false
                cell.coinImageView.isHidden = true
            }

            cell.leftLittlecoinImageView.isHidden = true
            cell.rightLittlecoinImageView.isHidden = true
            cell.giftImageView.isHidden = true
            break

        case .today:
            cell.weekLabel.text = "今天"

            cell.containerView.backgroundColor = UIColor.hex(0xFFF7EC)
            cell.containerView.borderWidth = 1
            cell.containerView.borderColor = UIColor.hex(0xFFA913)
            cell.integralLabel.text = "+\(dailyData.integral ?? 0)"
            cell.integralLabel.textColor = UIColor.hex(0xFF8000)
            cell.weekLabel.textColor = UIColor.hex(0xFF8000)
            cell.noCoinView.isHidden = true
            cell.coinImageView.isHidden = false

            if dailyData.didPunchIn == 1 {
                cell.coinImageView.image = #imageLiteral(resourceName: "coinGot")

                cell.leftLittlecoinImageView.isHidden = true
                cell.rightLittlecoinImageView.isHidden = true
                cell.giftImageView.isHidden = true

            } else {
                if indexPath.row == 6 {
                    cell.leftLittlecoinImageView.isHidden = false
                    cell.rightLittlecoinImageView.isHidden = false
                    cell.giftImageView.isHidden = false

                } else {
                    cell.coinImageView.image = #imageLiteral(resourceName: "coin")
                    cell.leftLittlecoinImageView.isHidden = true
                    cell.rightLittlecoinImageView.isHidden = true
                    cell.giftImageView.isHidden = true
                }
            }
            break

        case .tomorrow:
            cell.containerView.backgroundColor = UIColor.hex(0xFFF7EC)
            cell.containerView.borderWidth = 0
            cell.integralLabel.textColor = UIColor.hex(0xFF8000)
            cell.weekLabel.textColor = UIColor.hex(0xCDB291)
            cell.noCoinView.isHidden = true
            cell.coinImageView.isHidden = false
            cell.coinImageView.image = #imageLiteral(resourceName: "coin")

            if indexPath.row == 6 {
                cell.leftLittlecoinImageView.isHidden = false
                cell.rightLittlecoinImageView.isHidden = false

                if cell.integralLabel.text == "--" {
                    cell.integralLabel.text = "+\(dailyData.integral ?? 0)"

                } else {
                    cell.integralLabel.countFromCurrent(to: Float(dailyData.integral ?? 0), duration: 1, anySymbol: "+")
                }

                cell.giftImageView.isHidden = false

            } else {
                cell.integralLabel.text = "+\(dailyData.integral ?? 0)"

                cell.leftLittlecoinImageView.isHidden = true
                cell.rightLittlecoinImageView.isHidden = true
                cell.giftImageView.isHidden = true
            }

            break
        }

        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width  = (screenWidth - 60) / 7
        return CGSize(width: width, height: 90)
    }
}
