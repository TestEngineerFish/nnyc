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
    func isSelectedWordModel(wordModel: YXReviewWordModel) -> Bool
}

protocol YXReviewUnitListUpdateProtocol: NSObjectProtocol {
    func updateSelectStatus(_ wordModel: YXReviewWordModel)
}

enum YXReviewBookType: Int {
    case wrongList  = 1
    case collect    = 2
    case unit       = 3
    case reviewPlan = 4
}

class YXReviewUnitListView: UIView, UITableViewDelegate, UITableViewDataSource, UIGestureRecognizerDelegate, YXReviewUnitListHeaderProtocol, YXReviewUnitListUpdateProtocol {

    var loading = false
    var guideView = YXMakeReviewGuideView()
    var tableView = UITableView()
    var pan: UIPanGestureRecognizer?
    var lastPassByIndexPath: IndexPath?
    var previousLocation: CGPoint?
    var bookModel: YXReviewWordBookItemModel

    var model: YXReviewBookModel
    var unitModelList: [YXReviewUnitModel] = []

    weak var delegate: YXReviewUnitListViewProtocol?
    final let kYXReviewUnitListCell       = "YXReviewUnitListCell"
    final let kYXReviewUnitListHeaderView = "YXReviewUnitListHeaderView"
    
    init(_ model: YXReviewBookModel, bookModel: YXReviewWordBookItemModel, frame: CGRect) {
        self.model     = model
        self.bookModel = bookModel
        super.init(frame: frame)

        if let _unitModelList = model.modelDict["\(bookModel.id)"] {
            self.unitModelList = _unitModelList
        } else {
            self.requestWordsList(bookModel.id, type: bookModel.type)
        }

        // ---- 数据处理 ----
        if bookModel.type == .unit {
            self.unitModelList.forEach { (unitModel) in
                unitModel.list.forEach { (wordModel) in
                    if self.delegate?.isSelectedWordModel(wordModel: wordModel) ?? false {
                        wordModel.isSelected = true
                    } else {
                        wordModel.isSelected = false
                    }
                }
            }
        }
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
        self.tableView.register(YXReviewWordViewCell.classForCoder(), forCellReuseIdentifier: kYXReviewUnitListCell)
        self.tableView.register(YXReviewUnitListHeaderView.classForCoder(), forHeaderFooterViewReuseIdentifier: kYXReviewUnitListHeaderView)
        pan = UIPanGestureRecognizer(target: self, action: #selector(pan(_:)))
        pan!.delegate = self
        self.tableView.addGestureRecognizer(pan!)
        self.tableView.panGestureRecognizer.require(toFail: pan!)
        self.tableView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
    }
    
    // MARK: ==== Event ====
    
    private func selectCell(with indexPath: IndexPath) {
        guard let cell = tableView.cellForRow(at: indexPath) as? YXReviewWordViewCell, let headerCell = tableView.headerView(forSection: indexPath.section) else {
            return
        }
        var unitModelId = 0
        let wordModel: YXReviewWordModel = {

            let unitModel = self.unitModelList[indexPath.section]
            unitModelId = unitModel.id
            return unitModel.list[indexPath.row]
        }()

        wordModel.bookId     = self.bookModel.id
        wordModel.unitId     = unitModelId
        wordModel.isSelected = !wordModel.isSelected
        cell.model           = wordModel
        if wordModel.isSelected {
            self.delegate?.selectedWord(wordModel)
        } else {
            self.delegate?.unselectWord(wordModel)
        }
        headerCell.layoutSubviews()
    }
    // MARK: ---- Request ----

    private func requestWordsList(_ bookId: Int, type: YXReviewBookType) {
        let request = YXReviewRequest.reviewWordList(bookId: bookId, bookType: type.rawValue)
        YYNetworkService.default.request(YYStructDataArrayResponse<YXReviewUnitModel>.self, request: request, success: { [weak self] (response) in
            guard let self = self, let unitModelList = response.dataArray else {
                return
            }
            if type != .unit {
                unitModelList.first?.isOpenUp = true
            }
            unitModelList.forEach { (unitModel) in
                unitModel.list.forEach { (_wordModel) in
                    if self.delegate?.isSelectedWordModel(wordModel: _wordModel) ?? false {
                        _wordModel.isSelected = true
                    } else {
                        _wordModel.isSelected = false
                    }
                }
            }
            self.unitModelList = unitModelList
            self.model.modelDict.updateValue(unitModelList, forKey: "\(bookId)")
            self.tableView.reloadData()
        }) { (error) in
            YXUtils.showHUD(kWindow, title: error.message)
        }
    }

    // MARK: ==== UIGestureRecognizerDelegate ====
    
    override func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        guard let _pan = self.pan, _pan == gestureRecognizer else {
            return true
        }
        let point = gestureRecognizer.location(in: self.tableView)
        if point.x <= AdaptSize(56) {
            return true
        } else {
            return false
        }
    }
    
    @objc private func pan(_ pan: UIPanGestureRecognizer) {
        if pan.state == .began {
            self.lastPassByIndexPath = nil
            self.previousLocation    = pan.location(in: pan.view)
        } else if pan.state == .changed {
            let newLocation = pan.location(in: pan.view)
            if newLocation.x > AdaptSize(56) {
                return
            }
            self.commitNewLocation(newLocation)
            self.previousLocation = newLocation
        }
    }
    
    private func commitNewLocation(_ newLocation: CGPoint) {
        guard let previousLocation = self.previousLocation else {
            return
        }
        let offsetX = newLocation.x - previousLocation.x
        let offsetY = newLocation.y - previousLocation.y
        if fabsf(Float(offsetY)) > fabsf(Float(offsetX)) {
            let point = newLocation
            guard let indexPath = self.tableView.indexPathForRow(at: point) else {
                return
            }
            if self.lastPassByIndexPath != indexPath {
                self.updateWordSelectStatus(indexPath)
                self.lastPassByIndexPath = indexPath
            }
        }
    }
    
    private func updateWordSelectStatus(_ indexPath: IndexPath) {
        self.selectCell(with: indexPath)
    }
    
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
        unitModel.list.forEach { (_wordModel) in
            if self.delegate?.isSelectedWordModel(wordModel: _wordModel) ?? false {
                _wordModel.isSelected = true
            } else {
                _wordModel.isSelected = false
            }
        }
        headerView.bindData(unitModel)
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard let headerView = tableView.dequeueReusableHeaderFooterView(withIdentifier: kYXReviewUnitListHeaderView) as? YXReviewUnitListHeaderView else {
            return nil
        }
        headerView.tag      = section
        headerView.delegate = self
        return headerView
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        guard let cell = cell as? YXReviewWordViewCell else {
            return
        }
        let wordModel: YXReviewWordModel = {
            let _wordModel = self.unitModelList[indexPath.section].list[indexPath.row]
            if self.delegate?.isSelectedWordModel(wordModel: _wordModel) ?? false {
                _wordModel.isSelected = true
            } else {
                _wordModel.isSelected = false
            }
            return _wordModel
        }()
        cell.bindData(wordModel)
        cell.indexPath = indexPath
        cell.clickBlock = { [weak self] (indexPath: IndexPath?) in
            guard let self = self, let indexPath = indexPath else {
                return
            }
            self.selectCell(with: indexPath)
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: kYXReviewUnitListCell) as? YXReviewWordViewCell else {
            return UITableViewCell()
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return AdaptSize(58)
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return AdaptSize(40)
    }
    // MARK: ==== UITableViewDelegate ====
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let wordModel: YXReviewWordModel = {
            return self.unitModelList[indexPath.section].list[indexPath.row]
        }()
        let home = UIStoryboard(name: "Home", bundle: nil)
        let wordDetialViewController           = home.instantiateViewController(withIdentifier: "YXWordDetailViewControllerNew") as! YXWordDetailViewControllerNew
        wordDetialViewController.wordId        = wordModel.id
        wordDetialViewController.isComplexWord = 0
        self.currentViewController?.navigationController?.pushViewController(wordDetialViewController, animated: true)
    }
    
    // MARK: ==== YXReviewUnitListHeaderProtocol ====
    func checkAll(_ unitModel: YXReviewUnitModel, section: Int) {
        let wordList: [YXReviewWordModel] = {
            return self.unitModelList[section].list
        }()
        wordList.forEach { (wordModel) in
            if !wordModel.isSelected {
                wordModel.isSelected = true
                wordModel.bookId     = self.bookModel.id
                wordModel.unitId     = unitModel.id
                self.delegate?.selectedWord(wordModel)
            }
        }
        self.tableView.reloadSections(IndexSet(integer: section), with: .automatic)
    }
    
    func uncheckAll(_ unitModel: YXReviewUnitModel, section: Int) {
        let wordList: [YXReviewWordModel] = {
            return self.unitModelList[section].list
        }()
        wordList.forEach { (wordModel) in
            if wordModel.isSelected {
                wordModel.isSelected = false
                self.delegate?.unselectWord(wordModel)
            }
        }
        self.tableView.reloadSections(IndexSet(integer: section), with: .automatic)
    }
    
    func clickHeaderView(_ section: Int) {

        let unitModel = self.unitModelList[section]
        unitModel.isOpenUp = !unitModel.isOpenUp
        // ---- 是否展示引导图
        if unitModel.isOpenUp{
            if !(YYCache.object(forKey: YXLocalKey.alreadShowMakeReviewGuideView.rawValue) as? Bool ?? false) {
                self.guideView.show()
            }
        }
        tableView.reloadSections(IndexSet(integer: section), with: .automatic)
    }

    // MARK: ==== YXReviewUnitListUpdateProtocol ====
    func updateSelectStatus(_ wordModel: YXReviewWordModel) {
        self.unitModelList.forEach { (unitModel) in
            unitModel.list.forEach { (_wordModel) in
                if _wordModel.id == wordModel.id {
                    _wordModel.isSelected = wordModel.isSelected
                }
            }
        }
        self.tableView.reloadData()
    }
}
