//
//  YXReviewSearchView.swift
//  YXEDU
//
//  Created by 沙庭宇 on 2020/2/7.
//  Copyright © 2020 shiji. All rights reserved.
//

import UIKit

class YXReviewSearchView: UIView, UITableViewDelegate, UITableViewDataSource, UIGestureRecognizerDelegate {
    
    let searchBar: UITextField = {
        let textField = UITextField()
        textField.placeholder         = "请输入要查询的单词"
        textField.layer.cornerRadius  = AdaptSize(17)
        textField.layer.masksToBounds = true
        textField.leftViewMode        = .always
        textField.leftView            = UIView(frame: CGRect(x: 0, y: 0, width: AdaptSize(22), height: 0))
        textField.backgroundColor     = UIColor.hex(0xF2f2f2)
        textField.keyboardType        = .asciiCapable
        return textField
    }()
    
    let cancelButton: UIButton = {
        let button = UIButton()
        button.setTitle("取消", for: .normal)
        button.setTitleColor(UIColor.black3, for: .normal)
        button.titleLabel?.font = UIFont.regularFont(ofSize: AdaptFontSize(14))
        return button
    }()

    let tipsBookImageView: UIImageView = {
        let imageView = UIImageView(image: UIImage(named: "book_selected"))
        return imageView
    }()
    
    let tipsDesciptionLabel: UILabel = {
        let label = UILabel()
        label.font      = UIFont.regularFont(ofSize: AdaptFontSize(12))
        label.textColor = UIColor.black3
        return label
    }()
    
    let emptyView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.clear
        view.isHidden        = true
        return view
    }()
    
    let emptyImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "search_empty_data")
        return imageView
    }()
    
    let emptyDescLabel: UILabel = {
        let label = UILabel()
        label.text          = "暂无单词数据"
        label.textColor     = UIColor.black3
        label.font          = UIFont.regularFont(ofSize: AdaptFontSize(12))
        label.textAlignment = .center
        return label
    }()

    final let kYXReviewUnitListCell       = "YXReviewUnitListCell"
    final let kYXReviewSearchResultUnitListHederView = "YXReviewSearchResultUnitListHederView"
    let tableView = UITableView()
    var pan: UIPanGestureRecognizer?
    var lastPassByIndexPath: IndexPath?
    var previousLocation: CGPoint?
    weak var unitListDelegate: YXReviewUnitListViewProtocol?
    weak var selectedDelegate: YXReviewSelectedWordsListViewProtocol?

    var bookModel: YXReviewWordBookItemModel?
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
        guard let _bookModel = self.bookModel else {
            return
        }
        let desc     = String(format: "在 %@ 中搜索:", _bookModel.name)
        let mAttrStr = NSMutableAttributedString(string: desc)
        mAttrStr.addAttribute(NSAttributedString.Key.foregroundColor, value: UIColor.black1, range: NSRange(location: 2, length: _bookModel.name.count))
        self.tipsDesciptionLabel.attributedText = mAttrStr
        self.searchBar.becomeFirstResponder()
        self.searchBar.text      = ""
        self.resultUnitListModel = []
        self.tableView.reloadData()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        if self.resultUnitListModel.isEmpty {
            self.tableView.isHidden = true
            self.emptyView.isHidden = false
        } else {
            self.tableView.isHidden = false
            self.emptyView.isHidden = true
        }
    }
    
    private func bindProperty() {
        self.tableView.delegate   = self
        self.tableView.dataSource = self
        self.tableView.separatorInset = UIEdgeInsets(top: 0, left: 1000, bottom: 0, right: 0)
        self.tableView.register(YXReviewWordViewCell.classForCoder(), forCellReuseIdentifier: kYXReviewUnitListCell)
        self.tableView.register(YXReviewSearchResultUnitListHederView.classForCoder(), forHeaderFooterViewReuseIdentifier: kYXReviewSearchResultUnitListHederView)
        self.pan = UIPanGestureRecognizer(target: self, action: #selector(pan(_:)))
        self.pan?.delegate = self
        self.tableView.addGestureRecognizer(pan!)
        self.tableView.panGestureRecognizer.require(toFail: pan!)
        self.cancelButton.addTarget(self, action: #selector(cancelSearch), for: .touchUpInside)
        self.searchBar.addTarget(self, action: #selector(textFieldChange(_:)), for: .editingChanged)
    }
    
    private func createSubviews() {
        self.addSubview(self.searchBar)
        self.addSubview(self.cancelButton)
        self.addSubview(self.tipsBookImageView)
        self.addSubview(self.tipsDesciptionLabel)
        self.addSubview(self.emptyView)
        self.addSubview(self.tableView)
        self.emptyView.addSubview(self.emptyImageView)
        self.emptyView.addSubview(self.emptyDescLabel)
        self.searchBar.snp.makeConstraints { (make) in
            make.left.equalToSuperview().offset(AdaptIconSize(20))
            make.top.equalToSuperview().offset(AdaptIconSize(6))
            make.right.equalTo(self.cancelButton.snp.left).offset(AdaptIconSize(-20))
            make.height.equalTo(AdaptIconSize(34))
        }
        self.cancelButton.snp.makeConstraints { (make) in
            make.centerY.equalTo(self.searchBar)
            make.right.equalToSuperview().offset(AdaptIconSize(-23))
        }
        self.tipsBookImageView.snp.makeConstraints { (make) in
            make.left.equalToSuperview().offset(AdaptIconSize(22))
            make.top.equalTo(self.searchBar.snp.bottom).offset(AdaptIconSize(21))
            make.size.equalTo(CGSize(width: AdaptIconSize(20), height: AdaptIconSize(23)))
        }
        self.tipsDesciptionLabel.snp.makeConstraints { (make) in
            make.left.equalTo(self.tipsBookImageView.snp.right).offset(AdaptSize(8))
            make.centerY.equalTo(self.tipsBookImageView)
            make.height.equalTo(AdaptSize(17))
            make.right.equalToSuperview().offset(AdaptSize(20))
        }
        self.tableView.snp.makeConstraints { (make) in
            make.left.right.bottom.equalToSuperview()
            make.top.equalTo(self.tipsBookImageView.snp.bottom).offset(AdaptIconSize(12))
        }
        self.emptyView.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.top.equalTo(self.tableView)
            make.size.equalTo(CGSize(width: AdaptIconSize(277), height: AdaptIconSize(227)))
        }
        self.emptyImageView.snp.makeConstraints { (make) in
            make.top.left.right.equalToSuperview()
            make.height.equalTo(AdaptIconSize(205))
        }
        self.emptyDescLabel.sizeToFit()
        self.emptyDescLabel.snp.makeConstraints { (make) in
            make.left.bottom.right.equalToSuperview()
            make.height.equalTo(emptyDescLabel.height)
        }
    }
    
    // MARK: ==== Event ====
    private func selectCell(with indexPath: IndexPath) {
        self.searchBar.resignFirstResponder()
        guard let cell = tableView.cellForRow(at: indexPath) as? YXReviewWordViewCell, let headerCell = tableView.headerView(forSection: indexPath.section) else {
            return
        }
        let unitModel = self.resultUnitListModel[indexPath.section]
        let wordModel = unitModel.list[indexPath.row]
        wordModel.bookId     = self.bookModel?.id ?? 0
        wordModel.unitId     = unitModel.id
        wordModel.isSelected = !wordModel.isSelected
        cell.model           = wordModel
        if wordModel.isSelected {
            self.unitListDelegate?.selectedWord(wordModel)
            self.selectedDelegate?.selected(wordModel)
        } else {
            self.unitListDelegate?.unselectWord(wordModel)
            self.selectedDelegate?.unselect(wordModel)
        }
        headerCell.layoutSubviews()
    }
    
    @objc private func cancelSearch() {
        self.endEditing(true)
        UIView.animate(withDuration: 0.25) { [weak self] in
            guard let self = self else { return }
            self.layer.opacity = 0
        }
    }
    
    @objc private func textFieldChange(_ textField: UITextField) {
        let keyValue = textField.text ?? ""
        self.search(keyValue)
        self.tableView.reloadData()
        self.layoutSubviews()
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
        guard let headerView = tableView.dequeueReusableHeaderFooterView(withIdentifier: kYXReviewSearchResultUnitListHederView) as? YXReviewSearchResultUnitListHederView else {
            return nil
        }
        let unitName   = self.resultUnitListModel[section].name
        headerView.tag = section
        headerView.unitNameLabel.text = unitName
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
        return AdaptIconSize(58)
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return AdaptIconSize(33)
    }
    
    // MARK: ==== UITableViewDelegate ====
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let wordModel = self.resultUnitListModel[indexPath.section].list[indexPath.row]
        let home = UIStoryboard(name: "Home", bundle: nil)
        if let wordDetialViewController = home.instantiateViewController(withIdentifier: "YXWordDetailViewControllerNew") as? YXWordDetailViewControllerNew {
            wordDetialViewController.wordId        = wordModel.id
            wordDetialViewController.isComplexWord = 0
            self.currentViewController?.navigationController?.pushViewController(wordDetialViewController, animated: true)
        }
    }
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        self.searchBar.resignFirstResponder()
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
            self.searchBar.resignFirstResponder()
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
}
