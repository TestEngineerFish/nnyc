//
//  YXReviewUnitListView.swift
//  YXEDU
//
//  Created by 沙庭宇 on 2019/12/7.
//  Copyright © 2019 shiji. All rights reserved.
//

import UIKit

class YXReviewUnitListView: UIView, UITableViewDelegate, UITableViewDataSource {

    var tableView = UITableView()
    var listModel: [YXReviewUnitModel]
    weak var delegate: YXMakeReviewPlanProtocol?
    final let kYXReviewUnitListCell = "YXReviewUnitListCell"

    init(_ listModel: [YXReviewUnitModel], frame: CGRect) {
        self.listModel = listModel
        super.init(frame: frame)
        self.setSubviews()
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
        self.tableView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
    }

    // MARK: ==== UITableViewDataSource ====

    func numberOfSections(in tableView: UITableView) -> Int {
        return self.listModel.count
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.listModel[section].list.count
    }

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let model = self.listModel[section]
        let headerFrame = CGRect(x: 0, y: 0, width: screenWidth, height: AdaptSize(33))
        let headerView = YXReviewUnitListHeaderView(model, frame: headerFrame)
        return headerView
    }

    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
                guard let cell = cell as? YXReviewUnitListCell else {
            return
        }
        var wordModel = self.listModel[indexPath.section].list[indexPath.row]
        wordModel.isSelsected = self.delegate?.isContionWord(wordModel) ?? false
        cell.bindData(wordModel)
        print(wordModel.isSelsected, "=========")
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
        if wordModel.isSelsected {
            self.delegate?.unselectWord(wordModel)
        } else {
            self.delegate?.selectedWord(wordModel)
        }
//        self.listModel[indexPath.section].list[indexPath.row].isSelsected = !model.isSelsected
        tableView.reloadRows(at: [indexPath], with: .automatic)
    }
}
