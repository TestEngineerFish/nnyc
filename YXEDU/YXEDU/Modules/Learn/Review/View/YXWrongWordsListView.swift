//
//  YXWrongWordsListView.swift
//  YXEDU
//
//  Created by 沙庭宇 on 2020/1/13.
//  Copyright © 2020 shiji. All rights reserved.
//

import UIKit

class YXWrongWordsListView: UIView, UITableViewDataSource {

    var titleLabel: UILabel = {
        let label = UILabel()
        label.text          = "需要加强的单词"
        label.textColor     = UIColor.black1
        label.font          = UIFont.regularFont(ofSize: AdaptFontSize(17))
        label.textAlignment = .center
        label.backgroundColor = .white
        return label
    }()

    var tableView = UITableView()

    var shadowView: UIView = {
        let view = UIView()
        let s = CGSize(width: AdaptSize(304), height: AdaptSize(26))
        view.size = s
        view.backgroundColor = UIColor.gradientColor(with: s, colors: [UIColor.white.withAlphaComponent(0), UIColor.white], direction: .vertical)
        return view
    }()

    var wordsArray: [YXBaseWordModel] = []

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.createSubview()
        self.bindProperty()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func bindData(_ wordsArray: [YXBaseWordModel]) {
        self.wordsArray = wordsArray
        self.tableView.reloadData()
    }

    private func bindProperty() {
        self.tableView.dataSource = self
        self.tableView.rowHeight = AdaptIconSize(30)
        self.tableView.separatorStyle = .none
        self.tableView.indicatorStyle = .default
        self.tableView.register(YXWrongWordCell.classForCoder(), forCellReuseIdentifier: "kYXWrongWordCell")
    }

    private func createSubview() {
        self.addSubview(titleLabel)
        self.addSubview(tableView)
        self.addSubview(shadowView)

        titleLabel.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.width.equalToSuperview()
            make.height.equalTo(AdaptIconSize(24))
            make.top.equalToSuperview().offset(AdaptSize(24))
        }
        tableView.snp.makeConstraints { (make) in
            make.top.equalTo(titleLabel.snp.bottom).offset(AdaptSize(15))
            make.left.equalToSuperview().offset(AdaptSize(37))
            make.right.equalToSuperview().offset(AdaptSize(-8))
            make.bottom.equalToSuperview().offset(AdaptSize(-24))
        }
        shadowView.snp.makeConstraints { (make) in
            make.width.centerX.bottom.equalTo(tableView)
            make.height.equalTo(AdaptIconSize(26))
        }
    }

    // MARK: ==== UITableViewDataSource ====

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return wordsArray.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "kYXWrongWordCell") as? YXWrongWordCell else {
            return UITableViewCell()
        }
        let wordModel = self.wordsArray[indexPath.row]
        cell.bindData(wordModel.word ?? "", meaning: wordModel.meaning ?? "我居然没有值我居然没有值")
        return cell
    }
}
