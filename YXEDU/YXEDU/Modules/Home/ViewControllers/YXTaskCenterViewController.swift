//
//  YXTaskCenterViewController.swift
//  YXEDU
//
//  Created by Jake To on 12/16/19.
//  Copyright © 2019 shiji. All rights reserved.
//

import UIKit

class YXTaskCenterViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UITableViewDelegate, UITableViewDataSource {
    
    private var taskCenterData: YXTaskCenterDataModel!
    private var dailyDatas: [YXTaskCenterDailyDataModel] = []
    private var taskLists: [YXTaskListModel] = []

    @IBOutlet weak var integralLabel: YXDesignableLabel!
    @IBOutlet weak var dailyDataCollectionView: UICollectionView!
    @IBOutlet weak var punchButton: YXDesignableButton!
    @IBOutlet weak var todayPunchLabel: UILabel!
    @IBOutlet weak var totalPunchLabel: UILabel!
    @IBOutlet weak var weekendPunchLabel: UILabel!
    @IBOutlet weak var taskTableView: UITableView!
    @IBOutlet weak var taskTableViewHeight: NSLayoutConstraint!
    
    @IBAction func back(_ sender: UIBarButtonItem) {
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func tapQuestionIcon(_ sender: UIBarButtonItem) {
        YXAlertWebView.share.show(YXUserModel.default.coinExplainUrl ?? "")
    }
    
    @IBAction func punchIn(_ sender: Any) {
        let request = YXTaskCenterRequest.punchIn
        YYNetworkService.default.request(YYStructResponse<YXTaskCenterDataModel>.self, request: request, success: { (response) in
            self.taskCenterData = response.data
            self.reloadDailyData()
            
        }) { error in
            print("❌❌❌\(error)")
        }
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        dailyDataCollectionView.register(UINib(nibName: "YXTaskCenterDateCell", bundle: nil), forCellWithReuseIdentifier: "YXTaskCenterDateCell")
        taskTableView.register(UINib(nibName: "YXTaskCenterCell", bundle: nil), forCellReuseIdentifier: "YXTaskCenterCell")
        
        let punchDataRequest = YXTaskCenterRequest.punchData
        YYNetworkService.default.request(YYStructResponse<YXTaskCenterDataModel>.self, request: punchDataRequest, success: { (response) in
            self.taskCenterData = response.data
            self.reloadDailyData()

        }) { error in
            print("❌❌❌\(error)")
        }
        
        let taskListRequest = YXTaskCenterRequest.taskList
        YYNetworkService.default.request(YYStructDataArrayResponse<YXTaskListModel>.self, request: taskListRequest, success: { (response) in
            self.taskLists = response.dataArray ?? []
            self.taskTableViewHeight.constant = CGFloat(self.taskLists.count * 172)

            self.taskTableView.reloadData()

        }) { error in
            print("❌❌❌\(error)")
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.barStyle = .black
        self.navigationController?.setNavigationBarHidden(false, animated: animated)

        self.navigationController?.navigationBar.barTintColor = UIColor.hex(0xFFA83E)
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white, NSAttributedString.Key.font : UIFont.boldSystemFont(ofSize: 18)]
        self.navigationController?.navigationBar.tintColor = UIColor.white
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.navigationBar.barStyle = .default

        self.navigationController?.navigationBar.barTintColor = UIColor.white
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.black]
        self.navigationController?.navigationBar.tintColor = UIColor.black
    }
    
    private func reloadDailyData() {
        var dailyDatas = self.taskCenterData.dailyData ?? []
        
        var punchCount = 0
        var todayIntegral = 0
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
            
            if let today = self.taskCenterData.today, index == today - 1 {
                didFindWitchDayIsToday = true
                dailyDatas[index].dailyStatus = .today
                todayIntegral = dailyDatas[index].integral ?? 0
                
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
        
        let exIntegral = punchCount * (self.taskCenterData.exIntegral ?? 0)
        dailyDatas[6].integral = 10 + exIntegral
        self.dailyDatas = dailyDatas
        
        let integral = self.taskCenterData.integral ?? 0
        if self.integralLabel.text == "--" {
            self.integralLabel.count(from: 0, to: Float(integral), duration: 1)
        } else {
            self.integralLabel.countFromCurrent(to: Float(integral), duration: 1)
        }
        self.todayPunchLabel.text = "\(todayIntegral)"
        self.totalPunchLabel.text = "\(punchCount)"
        self.weekendPunchLabel.text = "\(exIntegral)"

        self.dailyDataCollectionView.reloadData()
    }
    

    
    // MARK：- table view
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return taskLists.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "YXTaskCenterCell", for: indexPath) as! YXTaskCenterCell
        let taskList = taskLists[indexPath.row]
        
        cell.titleLabel.text = taskList.typeName

        cell.collectionView.tag = indexPath.row
        cell.collectionView.delegate = self
        cell.collectionView.dataSource = self
        cell.collectionView.register(UINib(nibName: "YXTaskCenterCardCell", bundle: nil), forCellWithReuseIdentifier: "YXTaskCenterCardCell")
        cell.collectionView.reloadData()
        
        return cell
    }
    
    
    
    // MARK：- collection view
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView.tag == 999 {
            return dailyDatas.count

        } else {
            let taskList = taskLists[collectionView.tag]
            return taskList.list?.count ?? 0
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView.tag == 999 {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "YXTaskCenterDateCell", for: indexPath) as! YXTaskCenterDateCell
            let dailyData = dailyDatas[indexPath.row]
            
            cell.weekLabel.text = dailyData.weekName
            
            switch dailyData.dailyStatus {
            case .yesterday:
                if dailyData.didPunchIn == 1 {
                    cell.integralStatusLabel.text = "+\(dailyData.integral ?? 0)"

                } else {
                    cell.integralStatusLabel.text = "未获得"
                    cell.integralStatusLabel.font = UIFont.systemFont(ofSize: 10)
                }
                
                cell.integralStatusLabel.textColor = UIColor.hex(0xD98F36)
                cell.circleView.backgroundColor = UIColor.hex(0xFCD096)
                cell.indicatorImageView.isHidden = true
                break
                
            case .today:
                cell.integralStatusLabel.text = "今天"
                cell.integralStatusLabel.textColor = UIColor.hex(0xFF9B00)
                cell.circleView.backgroundColor = .white
                cell.circleView.layer.setDefaultShadow()
                cell.circleView.layer.cornerRadius = 16
                cell.circleView.layer.shadowColor = UIColor.hex(0xFF5400).cgColor
                cell.circleView.layer.shadowRadius  = 4
                cell.indicatorImageView.isHidden = false
                break
                
            case .tomorrow:
                if indexPath.row == 6, cell.integralStatusLabel.text != "--" {
                    cell.integralStatusLabel.countFromCurrent(to: Float(dailyData.integral ?? 0), duration: 1, anySymbol: "+")

                } else {
                    cell.integralStatusLabel.text = "+\(dailyData.integral ?? 0)"
                }
                cell.integralStatusLabel.textColor = UIColor.hex(0xFF9B00)
                cell.circleView.backgroundColor = .white
                cell.indicatorImageView.isHidden = true
                break
            }
            
            return cell
            
        } else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "YXTaskCenterCardCell", for: indexPath) as! YXTaskCenterCardCell
            let taskList = taskLists[collectionView.tag]
            let task = taskList.list?[indexPath.row]
            
            cell.titleLabel.text = task?.name
            cell.integral = task?.integral ?? 0
            cell.taskColor = YXTaskCardType(rawValue: task?.taskColor  ?? 0) ?? .cyanBlueCard
            cell.cardStatus = YXTaskCardStatus(rawValue: task?.state ?? 0) ?? .incomplete
            cell.didRepeat = taskList.typeName == "每日任务" ? true : false
            cell.adjustCell()

            cell.todoClosure = {
                switch task?.actionType {
                case 0:
                    self.navigationController?.popViewController(animated: true)
                    break
                    
                case 1:
                    self.tabBarController?.selectedIndex = 2
                    self.navigationController?.popViewController(animated: true)
                    break

                case 2:
                    break
                    
                default:
                    break
                }
            }

            cell.getRewardClosure = {
                let request = YXTaskCenterRequest.getIntegral(taskId: task?.id ?? 0)
                YYNetworkService.default.request(YYStructResponse<YXResultModel>.self, request: request, success: { (response) in
                    self.taskLists[collectionView.tag].list?[indexPath.row].state = 2
                    self.taskTableView.reloadData()

                    if let currentIntegral = Int(self.integralLabel.text ?? "0") {
                        self.integralLabel.countFromCurrent(to: Float(currentIntegral + (task?.integral ?? 0)), duration: 1)
                    }

                }) { error in
                    print("❌❌❌\(error)")
                }
            }
            
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if collectionView.tag == 999 {
            let width  = (screenWidth - 40) / 7
            return CGSize(width: width, height: 72)

        } else {
            return CGSize(width: 174, height: 138)
        }
    }
}
