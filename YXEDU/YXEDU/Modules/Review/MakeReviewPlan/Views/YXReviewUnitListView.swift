//
//  YXReviewWordListView.swift
//  YXEDU
//
//  Created by 沙庭宇 on 2019/12/7.
//  Copyright © 2019 shiji. All rights reserved.
//

import UIKit

class YXReviewWordListView: UIView, UITableViewDelegate, UITableViewDataSource, UIGestureRecognizerDelegate {

    var tableView = UITableView()
    var listModel: [YXReviewUnitModel]
    weak var delegate: YXMakeReviewPlanProtocol?
    final let kYXReviewUnitListCell       = "YXReviewUnitListCell"
    final let kYXReviewUnitListHeaderView = "YXReviewUnitListHeaderView"

    init(_ listModel: [YXReviewUnitModel], frame: CGRect) {
        self.listModel = listModel
        super.init(frame: frame)
        self.setSubviews()
        let pan = UIPanGestureRecognizer(target: self, action: #selector(pan(_:)))
    }

    @objc private func pan(_ pan: UIPanGestureRecognizer) {

//        self.tableView.selectRow(at: <#T##IndexPath?#>, animated: <#T##Bool#>, scrollPosition: <#T##UITableView.ScrollPosition#>)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setSubviews() {
        self.addSubview(tableView)
        self.tableView.delegate   = self
        self.tableView.dataSource = self
        self.tableView.separatorInset = UIEdgeInsets(top: 0, left: 1000, bottom: 0, right: 0)
        self.tableView.register(YXReviewUnitListCell.classForCoder(), forCellReuseIdentifier: kYXReviewUnitListCell)
        self.tableView.register(YXReviewUnitListHeaderView.classForCoder(), forHeaderFooterViewReuseIdentifier: kYXReviewUnitListHeaderView)
        self.tableView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
    }

    // MARK: ==== UIGestureRecognizerDelegate ====
    @objc private func tapListHeader(_ tap: UITapGestureRecognizer) {
        guard let headerView = tap.view as? YXReviewUnitListHeaderView else {
            return
        }
        if headerView.tag < self.listModel.count {
            let unitModel = self.listModel[headerView.tag]
            if self.delegate?.isContainUnit(unitModel) ?? false {
                self.delegate?.closeDownUnit(unitModel)
                headerView.arrowButton.transform = .identity
            } else {
                self.delegate?.openUpUnit(unitModel)
                headerView.arrowButton.transform = CGAffineTransform(rotationAngle: .pi)
            }
            tableView.reloadData()
        }
    }

    // MARK: ==== UITableViewDataSource ====

    func numberOfSections(in tableView: UITableView) -> Int {
        return self.listModel.count
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let unitModel = self.listModel[section]
        if self.delegate?.isContainUnit(unitModel) ?? false {
            return unitModel.list.count
        } else {
            return 0
        }
    }

    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        guard let headerView = view as? YXReviewUnitListHeaderView else {
            return
        }
        let unitModel = self.listModel[section]
        headerView.bindData(unitModel)
    }

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard let headerView = tableView.dequeueReusableHeaderFooterView(withIdentifier: kYXReviewUnitListHeaderView) as? YXReviewUnitListHeaderView else {
            return nil
        }
        headerView.tag = section
        let tap = UITapGestureRecognizer(target: self, action: #selector(tapListHeader(_:)))
        headerView.addGestureRecognizer(tap)
        return headerView
    }

    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        guard let cell = cell as? YXReviewUnitListCell else {
            return
        }
        let wordModel = self.listModel[indexPath.section].list[indexPath.row]
        let isSelsected = self.delegate?.isContainWord(wordModel) ?? false
        cell.bindData(wordModel, isSelected: isSelsected)
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: kYXReviewUnitListCell) as? YXReviewUnitListCell else {
            return UITableViewCell()
        }
        return cell
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return AdaptSize(58)
    }
    // MARK: ==== UITableViewDelegate ====

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let wordModel = self.listModel[indexPath.section].list[indexPath.row]
        if self.delegate?.isContainWord(wordModel) ?? false {
            self.delegate?.unselectWord(wordModel)
        } else {
            self.delegate?.selectedWord(wordModel)
        }
        tableView.reloadRows(at: [indexPath], with: .automatic)
    }
}
