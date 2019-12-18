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
    private var taskLists: [YXTaskListModel] = []

    @IBOutlet weak var integralLabel: YXDesignableLabel!
    @IBOutlet weak var dailyDataCollectionView: UICollectionView!
    @IBOutlet weak var punchButton: YXDesignableButton!
    @IBOutlet weak var todayPunchLabel: UILabel!
    @IBOutlet weak var totalPunchLabel: UILabel!
    @IBOutlet weak var taskTableView: UITableView!

    @IBAction func back(_ sender: UIBarButtonItem) {
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func tapQuestionIcon(_ sender: UIBarButtonItem) {
        
    }
    
    @IBAction func punchIn(_ sender: Any) {
        let request = YXTaskCenterRequest.punchIn
        YYNetworkService.default.request(YYStructResponse<YXTaskCenterDataModel>.self, request: request, success: { (response) in
          
        }) { (error) in
            
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        dailyDataCollectionView.register(UINib(nibName: "YXTaskCenterDateCell", bundle: nil), forCellWithReuseIdentifier: "YXTaskCenterDateCell")
        taskTableView.register(UINib(nibName: "YXTaskCenterCell", bundle: nil), forCellReuseIdentifier: "YXTaskCenterCell")
        
        let punchDataRequest = YXTaskCenterRequest.punchData
        YYNetworkService.default.request(YYStructResponse<YXTaskCenterDataModel>.self, request: punchDataRequest, success: { (response) in
            self.taskCenterData = response.data
            
            self.integralLabel.text = "\(self.taskCenterData.integral ?? 0)"
            self.todayPunchLabel.text = "\(self.taskCenterData.todayEarnIntegral ?? 0)"
            self.totalPunchLabel.text = "已连续签到\(self.taskCenterData.punchInCount ?? 0)天"

            self.dailyDataCollectionView.reloadData()

        }) { (error) in
            
        }
        
        let taskListRequest = YXTaskCenterRequest.taskList
        YYNetworkService.default.request(YYStructDataArrayResponse<YXTaskListModel>.self, request: taskListRequest, success: { (response) in
            self.taskLists = response.dataArray ?? []
            self.taskTableView.reloadData()
            
        }) { (error) in
            
        }
    }
    

    
    // MARK：- table view
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return taskLists.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "YXTaskCenterCell", for: indexPath) as! YXTaskCenterCell
        let taskList = taskLists[indexPath.row]
        
        cell.titleLabel.text = taskList.typeName

        cell.collectionView.register(UINib(nibName: "YXTaskCenterCardCell", bundle: nil), forCellWithReuseIdentifier: "YXTaskCenterCardCell")
        cell.collectionView.tag = indexPath.row
        cell.collectionView.delegate = self
        cell.collectionView.dataSource = self
        cell.collectionView.reloadData()
        
        return cell
    }
    
    
    
    // MARK：- collection view
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView.tag == 999 {
            return 7

        } else {
            let taskList = taskLists[collectionView.tag]
            return taskList.list?.count ?? 0
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView.tag == 999 {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "YXTaskCenterDateCell", for: indexPath) as! YXTaskCenterDateCell
            
            return cell
            
        } else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "YXTaskCenterCardCell", for: indexPath) as! YXTaskCenterCardCell
            let taskList = taskLists[collectionView.tag]
            let task = taskList.list?[indexPath.row]
            
            cell.titleLabel.text = task?.name
            cell.titleLabel.layer.shadowOffset = CGSize(width: 0, height: 2)
            cell.titleLabel.layer.shadowOpacity = 0.5
            cell.titleLabel.layer.shadowRadius = 4
            
            if taskList.typeName == "每日任务" {
                
            } else {
                
            }
            
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let taskList = taskLists[collectionView.tag]
        let task = taskList.list?[indexPath.row]
        
        let request = YXTaskCenterRequest.getIntegral(taskId: task?.id ?? 0)
        YYNetworkService.default.request(YYStructResponse<YXResultModel>.self, request: request, success: { (response) in
          
        }) { (error) in
            
        }
    }
}
