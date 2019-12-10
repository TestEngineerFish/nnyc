//
//  YXReviewSelectedWordsListView.swift
//  YXEDU
//
//  Created by 沙庭宇 on 2019/12/9.
//  Copyright © 2019 shiji. All rights reserved.
//

import UIKit

protocol YXReviewSelectedWordsListViewProtocol: NSObjectProtocol {
    func remove(_ word: YXReviewWordModel)
}

class YXReviewSelectedWordsListView: UIView, UITableViewDataSource, UITableViewDelegate, YXReviewUnitListViewProtocol {

    var wordsModelList: [YXReviewWordModel] = []
    final let defalutHeight = AdaptSize(54)
    final let cellHeight    = AdaptSize(30)
    final let maxWordsCount = 150
    final let kYXReviewSelectedWordCell = "YXReviewSelectedWordCell"

    weak var delegate: YXReviewSelectedWordsListViewProtocol?
    weak var delegateBottomView: YXReviewBottomView?

    var titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.pfSCMediumFont(withSize: AdaptSize(15))
        label.textColor = UIColor.black1
        label.textAlignment = .left
        return label
    }()
    var arrowButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "arrow_select"), for: .normal)
        button.imageEdgeInsets = UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 5)
        return button
    }()

    var tableView = UITableView()

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor      = UIColor.hex(0xFFF4E9)
        self.layer.masksToBounds  = true
        self.layer.cornerRadius   = AdaptSize(6)
        self.tableView.delegate   = self
        self.tableView.dataSource = self
        self.tableView.backgroundColor = UIColor.clear
        self.tableView.separatorInset  = UIEdgeInsets(top: 0, left: 1000, bottom: 0, right: 0)
        self.tableView.register(YXReviewSelectedWordCell.classForCoder(), forCellReuseIdentifier: kYXReviewSelectedWordCell)
        self.setSubviews()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setSubviews() {
        self.addSubview(titleLabel)
        self.addSubview(arrowButton)
        self.addSubview(tableView)

        arrowButton.snp.makeConstraints { (make) in
            make.right.equalToSuperview().offset(AdaptSize(-5))
            make.centerY.equalTo(titleLabel)
            make.size.equalTo(CGSize(width: AdaptSize(25), height: AdaptSize(18)))
        }

        titleLabel.snp.makeConstraints { (make) in
            make.left.equalToSuperview().offset(AdaptSize(20))
            make.top.equalToSuperview().offset(AdaptSize(15))
            make.height.equalTo(AdaptSize(21))
            make.right.equalTo(arrowButton.snp.left).offset(AdaptSize(-5))
        }

        tableView.snp.makeConstraints { (make) in
            make.top.equalTo(titleLabel.snp.bottom).offset(AdaptSize(10))
            make.left.right.equalToSuperview()
            make.bottom.equalToSuperview().offset(AdaptSize(-12)).priorityLow()
        }

        self.arrowButton.addTarget(self, action: #selector(clickArrowBtn(_:)), for: .touchUpInside)
    }

    // MARK: ==== Event ====
    @objc func clickArrowBtn(_ button: UIButton) {
        var h = CGFloat.zero
        if button.transform == .identity {
            h = self.getMaxHeight()
            button.transform = CGAffineTransform(rotationAngle: .pi)
        } else {
            h = self.defalutHeight
            button.transform = .identity
        }
        self.snp.updateConstraints { (make) in
            make.height.equalTo(h)
        }
    }

    @objc func clickRemoveBtn(_ button: YXButton) {
        if button.tag < self.wordsModelList.count {
            let wordModel = self.wordsModelList[button.tag]
            self.delegate?.remove(wordModel)
            self.removedWord(wordModel, index: button.tag)
        }
    }

    // MARK: ==== Tools ====
    private func getMaxHeight() -> CGFloat {
        let maxRows = self.wordsModelList.count > 5 ? 5 : self.wordsModelList.count
        let maxHeight = CGFloat(maxRows) * AdaptSize(23) + AdaptSize(10) + AdaptSize(12) + defalutHeight
        return self.wordsModelList.count > 0 ? maxHeight : defalutHeight
    }

    /// 添加单词
    private func appendWord(_ wordModel: YXReviewWordModel) {
        self.wordsModelList.append(wordModel)
        if self.wordsModelList.count > maxWordsCount {
            self.delegateBottomView?.showRemind()
        }
        self.setNeedsLayout()
        self.tableView.reloadData()
    }

    /// 移除单词
    private func removedWord(_ wordModel: YXReviewWordModel, index: Int? = nil) {
        if let _index = index {
            self.wordsModelList.remove(at: _index)
        } else {
            guard let firstIndex = self.wordsModelList.firstIndex(of: wordModel) else {
                return
            }
            self.wordsModelList.remove(at: firstIndex)
        }
        if self.wordsModelList.count <= maxWordsCount {
            self.delegateBottomView?.hideRemind()
        }
        self.setNeedsLayout()
        self.tableView.reloadData()
    }

    // MARK: ==== UITableViewDataSource && UITableViewDelegate ====

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return wordsModelList.count
    }

    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        guard let cell = cell as? YXReviewSelectedWordCell else {
            return
        }
        let wordModel = self.wordsModelList[indexPath.row]
        cell.bindData(wordModel)
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: kYXReviewSelectedWordCell) as? YXReviewSelectedWordCell else {
            return UITableViewCell()
        }
        cell.removeButton.tag = indexPath.row
        cell.removeButton.addTarget(self, action: #selector(clickRemoveBtn(_:)), for: .touchUpInside)
        return cell
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return self.cellHeight
    }


    // MARK: ==== YXReviewUnitListViewProtocol ====
    func selectedWord(_ word: YXReviewWordModel) {
        self.appendWord(word)
    }

    func unselectWord(_ word: YXReviewWordModel) {
        self.removedWord(word)
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        self.titleLabel.text = String(format: "%@%d", "已选择：", self.wordsModelList.count)
        if self.arrowButton.transform != .identity {
            let h = self.getMaxHeight()
            if self.superview != nil {
                self.snp.updateConstraints { (make) in
                    make.height.equalTo(AdaptSize(h))
                }
            }
            if self.wordsModelList.isEmpty {
                self.arrowButton.transform = .identity
            }
        }
    }
}
