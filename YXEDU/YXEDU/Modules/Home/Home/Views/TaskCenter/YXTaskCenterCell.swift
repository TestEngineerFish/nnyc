//
//  YXTaskCenterCell.swift
//  YXEDU
//
//  Created by Jake To on 12/16/19.
//  Copyright © 2019 shiji. All rights reserved.
//

import UIKit

class YXTaskCenterCell: UITableViewCell, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {

    var taskListModel:YXTaskListModel?
    var cellIndexPath: IndexPath?
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var collectionView: UICollectionView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.collectionView.delegate   = self
        self.collectionView.dataSource = self
        self.collectionView.register(UINib(nibName: "YXTaskCenterCardCell", bundle: nil), forCellWithReuseIdentifier: "YXTaskCenterCardCell")
    }

    func setData(taskList model: YXTaskListModel, indexPath: IndexPath) {
        self.taskListModel = model
        self.cellIndexPath = indexPath
        self.collectionView.reloadData()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

    // MARK: ==== UICollectionViewDataSource && UICollectionViewDelegate
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return taskListModel?.list?.count ?? 0
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "YXTaskCenterCardCell", for: indexPath) as? YXTaskCenterCardCell else {
            return UICollectionViewCell()
        }
        let task = taskListModel?.list?[indexPath.row]

        cell.titleLabel.text = task?.name
        cell.rewardLabel.text = "+\(task?.integral ?? 0)"
        cell.taskType = YXTaskCardType(rawValue: task?.taskType  ?? 0) ?? .smartReview
        cell.cardStatus = YXTaskCardStatus(rawValue: task?.state ?? 0) ?? .incomplete
        cell.didRepeat = taskListModel?.typeName == .some("每日任务")
        cell.adjustCell()
        cell.setData(task: task, indexPath: IndexPath(row: indexPath.row, section: self.cellIndexPath?.row ?? 0))
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 170, height: 110)
    }
}
