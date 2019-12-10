//
//  YXReviewWordListView.swift
//  YXEDU
//
//  Created by 沙庭宇 on 2019/12/7.
//  Copyright © 2019 shiji. All rights reserved.
//

import UIKit

protocol YXReviewUnitListViewProtocol: NSObjectProtocol {
    func selectedWord(_ word: YXReviewWordModel)
    func unselectWord(_ word: YXReviewWordModel)
}

class YXReviewUnitListView: UIView, UITableViewDelegate, UITableViewDataSource, UIGestureRecognizerDelegate, YXReviewUnitListHeaderProtocol, YXReviewSelectedWordsListViewProtocol {

    var tableView = UITableView()
    var unitModelList: [YXReviewUnitModel]
    weak var delegate: YXReviewUnitListViewProtocol?
    final let kYXReviewUnitListCell       = "YXReviewUnitListCell"
    final let kYXReviewUnitListHeaderView = "YXReviewUnitListHeaderView"

    init(_ listModel: [YXReviewUnitModel], frame: CGRect) {
        self.unitModelList = listModel
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
        self.tableView.register(YXReviewWordListView.classForCoder(), forCellReuseIdentifier: kYXReviewUnitListCell)
        self.tableView.register(YXReviewUnitListHeaderView.classForCoder(), forHeaderFooterViewReuseIdentifier: kYXReviewUnitListHeaderView)
        self.tableView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
    }

    // MARK: ==== Event ====

    // MARK: ==== UIGestureRecognizerDelegate ====

//    @objc private func pan(_ pan: UIPanGestureRecognizer) {
//        guard let cell = pan.view?.superview?.superview as? YXReviewWordListView, let model = cell.model, let indexPath = cell.indexPath else {
//            return
//        }
//        if self.delegate?.isContainWord(model) ?? false {
//            self.delegate?.unselectWord(model)
//        } else {
//            self.delegate?.selectedWord(model)
//        }
//        self.tableView.reloadRows(at: [indexPath], with: .automatic)
//        let point = pan.translation(in: cell)
//        print(point)
//    }

    // MARK: ==== UITableViewDataSource ====

    func numberOfSections(in tableView: UITableView) -> Int {
        return self.unitModelList.count
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let unitModel = self.unitModelList[section]
        if unitModel.isOpenUp {
            return unitModel.list.count
        } else {
            return 0
        }
    }

    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        guard let headerView = view as? YXReviewUnitListHeaderView else {
            return
        }
        let unitModel = self.unitModelList[section]
        headerView.bindData(unitModel)
    }

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard let headerView = tableView.dequeueReusableHeaderFooterView(withIdentifier: kYXReviewUnitListHeaderView) as? YXReviewUnitListHeaderView else {
            return nil
        }
        headerView.tag = section
        headerView.delegate = self
        return headerView
    }

    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        guard let cell = cell as? YXReviewWordListView else {
            return
        }
        let wordModel = self.unitModelList[indexPath.section].list[indexPath.row]
        cell.bindData(wordModel)
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: kYXReviewUnitListCell) as? YXReviewWordListView else {
            return UITableViewCell()
        }
        cell.isUserInteractionEnabled = true
//        cell.indexPath = indexPath
//        let pan = UIPanGestureRecognizer(target: self, action: #selector(pan(_:)))
//        cell.selectView.addGestureRecognizer(pan)
        return cell
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return AdaptSize(58)
    }
    // MARK: ==== UITableViewDelegate ====

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let unitModel = self.unitModelList[indexPath.section]
        let wordModel = unitModel.list[indexPath.row]
        wordModel.bookId = self.tag
        wordModel.unitId = unitModel.id
        if wordModel.isSelected {
            self.delegate?.unselectWord(wordModel)
        } else {
            self.delegate?.selectedWord(wordModel)
        }
        wordModel.isSelected = !wordModel.isSelected
        tableView.reloadSections(IndexSet(integer: indexPath.section), with: .automatic)
    }

    // MARK: ==== YXReviewUnitListHeaderProtocol ====
    func checkAll(_ unitModel: YXReviewUnitModel, section: Int) {
        let unitModel = self.unitModelList[section]
        unitModel.list.forEach { (wordModel) in
            if !wordModel.isSelected {
                wordModel.isSelected = true
                wordModel.bookId = self.tag
                wordModel.unitId = unitModel.id
                self.delegate?.selectedWord(wordModel)
            }
        }
        self.tableView.reloadSections(IndexSet(integer: section), with: .automatic)
    }

    func uncheckAll(_ unitModel: YXReviewUnitModel, section: Int) {
        unitModel.list.forEach { (wordModel) in
            if wordModel.isSelected {
                wordModel.isSelected = false
                self.delegate?.unselectWord(wordModel)
            }
        }
        self.tableView.reloadSections(IndexSet(integer: section), with: .automatic)
    }

    func clickHeaderView(_ section: Int) {
        tableView.reloadSections(IndexSet(integer: section), with: .automatic)
    }

    // MARK: ==== YXReviewSelectedWordsListViewProtocol ====
    func remove(_ word: YXReviewWordModel) {
        if self.tag == word.bookId {
            for unitModel in self.unitModelList {
                if unitModel.id == word.unitId {
                    guard let wordIndex = unitModel.list.firstIndex(of: word) else {
                        return
                    }
                    unitModel.list[wordIndex].isSelected = false
                    self.tableView.reloadData()
                    break
                }
            }
        }
    }

}
