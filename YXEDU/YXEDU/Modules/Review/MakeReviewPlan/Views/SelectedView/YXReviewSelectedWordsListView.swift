//
//  YXReviewSelectedWordsListView.swift
//  YXEDU
//
//  Created by 沙庭宇 on 2019/12/9.
//  Copyright © 2019 shiji. All rights reserved.
//

import UIKit

protocol YXReviewSelectedWordsListViewProtocol {
    func remove(_ word: YXReviewWordModel)
}

class YXReviewSelectedWordsListView: UIView, UITableViewDataSource, UITableViewDelegate, YXReviewUnitListViewProtocol {

    var wordsModelList: [YXReviewWordModel] = []
    final let defalutHeight = AdaptSize(51)
    final let cellHeight    = AdaptSize(23)
    final let kYXReviewSelectedWordCell = "YXReviewSelectedWordCell"

    var delegate: YXReviewSelectedWordsListViewProtocol?

    var titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.pfSCMediumFont(withSize: AdaptSize(15))
        label.textColor = UIColor.black1
        label.textAlignment = .left
        return label
    }()
    var arrowButton: YXButton = {
        let button = YXButton()
        button.setImage(UIImage(named: "arrow_select"), for: .normal)
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
            make.right.equalToSuperview().offset(AdaptSize(-26))
            make.centerY.equalTo(titleLabel)
            make.size.equalTo(CGSize(width: AdaptSize(15), height: AdaptSize(5)))
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
            make.bottom.equalToSuperview().offset(AdaptSize(12))
        }

        self.arrowButton.addTarget(self, action: #selector(clickArrowBtn(_:)), for: .touchUpInside)
    }

    // MARK: ==== Event ====
    @objc func clickArrowBtn(_ button: YXButton) {
        button.isSelected = !button.isSelected
        if button.isSelected {
            let h = CGFloat(self.wordsModelList.count) * AdaptSize(23) + AdaptSize(10)
            UIView.animate(withDuration: 0.25) {
                self.height = h
            }
        } else {
            UIView.animate(withDuration: 0.25) {
                self.height = self.defalutHeight
            }
        }
    }

    @objc func clickRemoveBtn(_ button: YXButton) {
        if button.tag < self.wordsModelList.count {
            let model = self.wordsModelList[button.tag]
            self.delegate?.remove(model)
        }
    }

    // MARK: ==== UITableViewDataSource && UITableViewDelegate ====

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return wordsModelList.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: kYXReviewSelectedWordCell) as? YXReviewSelectedWordCell else {
            return UITableViewCell()
        }
        cell.removeButton.tag = indexPath.row
        cell.removeButton.addTarget(self, action: #selector(clickArrowBtn(_:)), for: .touchUpInside)
        return UITableViewCell()
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return self.cellHeight
    }


    // MARK: ==== YXReviewUnitListViewProtocol ====
    func selectedWord(_ word: YXReviewWordModel) {
        self.wordsModelList.append(word)
        self.setNeedsLayout()
        self.tableView.reloadData()
    }

    func unselectWord(_ word: YXReviewWordModel) {
        guard let firstIndex = self.wordsModelList.firstIndex(of: word) else {
            return
        }
        self.wordsModelList.remove(at: firstIndex)
        self.setNeedsLayout()
        self.tableView.reloadData()
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        self.titleLabel.text = String(format: "%@%d", "已选择：", self.wordsModelList.count)
        self.height = CGFloat(self.wordsModelList.count) * AdaptSize(23) + AdaptSize(10) + defalutHeight
    }
}
