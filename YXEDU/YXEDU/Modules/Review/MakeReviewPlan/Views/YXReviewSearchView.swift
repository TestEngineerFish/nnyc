//
//  YXReviewSearchView.swift
//  YXEDU
//
//  Created by 沙庭宇 on 2020/2/7.
//  Copyright © 2020 shiji. All rights reserved.
//

import UIKit

class YXReviewSearchView: UIView, UITextFieldDelegate, UITableViewDelegate, UITableViewDataSource, UIGestureRecognizerDelegate {
    
    let searchBar: UITextField = {
        let textField = UITextField()
        textField.placeholder         = "请输入要查询的单词"
        textField.layer.cornerRadius  = AdaptSize(17)
        textField.layer.masksToBounds = true
        textField.leftViewMode        = .always
        textField.leftView            = UIView(frame: CGRect(x: 0, y: 0, width: AdaptSize(22), height: 0))
        textField.backgroundColor     = UIColor.hex(0xF2f2f2)
        return textField
    }()
    
    let cancelButton: YXButton = {
        let button = YXButton()
        button.setTitle("取消", for: .normal)
        button.setTitleColor(UIColor.black3, for: .normal)
        button.titleLabel?.font = UIFont.regularFont(ofSize: AdaptSize(14))
        return button
    }()

    let tipsBookImageView: UIImageView = {
        let imageView = UIImageView(image: UIImage(named: "book_selected"))
        return imageView
    }()
    
    let tipsDesciptionLabel: UILabel = {
        let label = UILabel()
        label.font      = UIFont.regularFont(ofSize: AdaptSize(12))
        label.textColor = UIColor.black3
        return label
    }()

    final let kYXReviewUnitListCell       = "YXReviewUnitListCell"
    final let kYXReviewUnitListHeaderView = "YXReviewUnitListHeaderView"
    let tableView = UITableView()
    var pan: UIPanGestureRecognizer?
    var lastPassByIndexPath: IndexPath?
    var previousLocation: CGPoint?
    weak var delegate: YXReviewUnitListViewProtocol?
    
    var bookName = ""
    var unitListModel: [YXReviewUnitModel]       = []
    var resultUnitListModel: [YXReviewUnitModel] = []
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = UIColor.white
        self.bindProperty()
        self.createSubviews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func updateInfo() {
        let desc     = String(format: "在 %@ 中搜索", bookName)
        let mAttrStr = NSMutableAttributedString(string: desc)
        mAttrStr.addAttribute(NSAttributedString.Key.foregroundColor, value: UIColor.black1, range: NSRange(location: 2, length: bookName.count))
        self.tipsDesciptionLabel.attributedText = mAttrStr
        self.searchBar.resignFirstResponder()
        self.searchBar.text      = ""
        self.resultUnitListModel = []
        self.tableView.reloadData()
    }
    
    private func bindProperty() {
        self.searchBar.delegate   = self
        self.tableView.delegate   = self
        self.tableView.dataSource = self
        self.tableView.separatorInset = UIEdgeInsets(top: 0, left: 1000, bottom: 0, right: 0)
        self.tableView.register(YXReviewWordViewCell.classForCoder(), forCellReuseIdentifier: kYXReviewUnitListCell)
        self.tableView.register(YXReviewUnitListHeaderView.classForCoder(), forHeaderFooterViewReuseIdentifier: kYXReviewUnitListHeaderView)
        self.pan = UIPanGestureRecognizer(target: self, action: #selector(pan(_:)))
        self.pan!.delegate = self
        self.tableView.addGestureRecognizer(pan!)
        self.tableView.panGestureRecognizer.require(toFail: pan!)
        self.cancelButton.addTarget(self, action: #selector(cancelSearch), for: .touchUpInside)
    }
    
    private func createSubviews() {
        self.addSubview(self.searchBar)
        self.addSubview(self.cancelButton)
        self.addSubview(self.tipsBookImageView)
        self.addSubview(self.tipsDesciptionLabel)
        self.addSubview(self.tableView)
        self.searchBar.snp.makeConstraints { (make) in
            make.left.equalToSuperview().offset(AdaptSize(20))
            make.top.equalToSuperview().offset(AdaptSize(6))
            make.right.equalTo(self.cancelButton.snp.left).offset(AdaptSize(-20))
            make.height.equalTo(AdaptSize(34))
        }
        self.cancelButton.sizeToFit()
        self.cancelButton.snp.makeConstraints { (make) in
            make.centerY.equalTo(self.searchBar)
            make.right.equalToSuperview().offset(AdaptSize(-23))
            make.size.equalTo(self.cancelButton.size)
        }
        self.tipsBookImageView.snp.makeConstraints { (make) in
            make.left.equalToSuperview().offset(AdaptSize(22))
            make.top.equalTo(self.searchBar.snp.bottom).offset(AdaptSize(21))
            make.size.equalTo(CGSize(width: AdaptSize(20), height: AdaptSize(23)))
        }
        self.tipsDesciptionLabel.snp.makeConstraints { (make) in
            make.left.equalTo(self.tipsBookImageView.snp.right).offset(AdaptSize(8))
            make.centerY.equalTo(self.tipsBookImageView)
            make.height.equalTo(AdaptSize(17))
            make.right.equalToSuperview().offset(AdaptSize(20))
        }
        self.tableView.snp.makeConstraints { (make) in
            make.left.right.bottom.equalToSuperview()
            make.top.equalTo(self.tipsBookImageView.snp.bottom).offset(AdaptSize(12))
        }
    }
    
    // MARK: ==== Event ====
    
    private func selectCell(with indexPath: IndexPath) {
        guard let cell = tableView.cellForRow(at: indexPath) as? YXReviewWordViewCell, let headerCell = tableView.headerView(forSection: indexPath.section) else {
            return
        }
        let unitModel = self.resultUnitListModel[indexPath.section]
        let wordModel = unitModel.list[indexPath.row]
        wordModel.bookId     = self.tag
        wordModel.unitId     = unitModel.id
        wordModel.isSelected = !wordModel.isSelected
        cell.model           = wordModel
        if wordModel.isSelected {
            self.delegate?.selectedWord(wordModel)
        } else {
            self.delegate?.unselectWord(wordModel)
        }
        headerCell.layoutSubviews()
    }
    
    @objc private func cancelSearch() {
        self.endEditing(true)
        self.isHidden = true
    }
    
    private func search(_ keyValue: String) {
        self.resultUnitListModel = []
        if keyValue != "" {
            for unitModel in self.unitListModel {
                let resultWordList = unitModel.list.filter { (wordModel) -> Bool in
                    let lowKeyValue = keyValue.lowercased()
                    let lowWord     = wordModel.word.lowercased()
                    return lowWord.hasPrefix(lowKeyValue)
                }
                if !resultWordList.isEmpty {
                    let resultUnitModel = YXReviewUnitModel()
                    resultUnitModel.id          = unitModel.id
                    resultUnitModel.name        = unitModel.name
                    resultUnitModel.wordsNumber = resultWordList.count
                    resultUnitModel.list        = resultWordList
                    resultUnitModel.isOpenUp    = true
                    self.resultUnitListModel.append(resultUnitModel)
                }
            }
        }
    }
    
    // MARK: ==== UITextFieldDelegate ====
    func textFieldDidChangeSelection(_ textField: UITextField) {
        let keyValue = textField.text ?? ""
        self.search(keyValue)
        self.tableView.reloadData()
    }
 
    // MARK: ==== UITableViewDataSource ====
    func numberOfSections(in tableView: UITableView) -> Int {
        return self.resultUnitListModel.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let unitModel = self.resultUnitListModel[section]
        return unitModel.list.count
    }
    
    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        guard let headerView = view as? YXReviewUnitListHeaderView else {
            return
        }
        let unitModel = self.resultUnitListModel[section]
        headerView.bindData(unitModel)
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard let headerView = tableView.dequeueReusableHeaderFooterView(withIdentifier: kYXReviewUnitListHeaderView) as? YXReviewUnitListHeaderView else {
            return nil
        }
        headerView.tag      = section
        return headerView
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        guard let cell = cell as? YXReviewWordViewCell else {
            return
        }
        let wordModel = self.resultUnitListModel[indexPath.section].list[indexPath.row]
        cell.bindData(wordModel)
        cell.indexPath  = indexPath
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
        return AdaptSize(33)
    }
    
    // MARK: ==== UITableViewDelegate ====
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let wordModel = self.resultUnitListModel[indexPath.section].list[indexPath.row]
        let home = UIStoryboard(name: "Home", bundle: nil)
        let wordDetialViewController           = home.instantiateViewController(withIdentifier: "YXWordDetailViewControllerNew") as! YXWordDetailViewControllerNew
        wordDetialViewController.wordId        = wordModel.id
        wordDetialViewController.isComplexWord = 0
        self.currentViewController?.navigationController?.pushViewController(wordDetialViewController, animated: true)
    }
    
    // MARK: ==== UIGestureRecognizerDelegate ====
    
    override func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        guard let _pan = self.pan, _pan == gestureRecognizer else {
            return true
        }
        let point = gestureRecognizer.location(in: self.tableView)
        print(point)
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
                print(indexPath)
                self.updateWordSelectStatus(indexPath)
                self.lastPassByIndexPath = indexPath
            }
        }
    }
    
    private func updateWordSelectStatus(_ indexPath: IndexPath) {
        self.selectCell(with: indexPath)
    }
}
