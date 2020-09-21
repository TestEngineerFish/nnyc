//
//  YXHomeworkWordListViewController.swift
//  YXEDU
//
//  Created by 沙庭宇 on 2020/8/19.
//  Copyright © 2020 shiji. All rights reserved.
//

import Foundation

class YXHomeworkWordListViewController: YXViewController, UITableViewDelegate, UITableViewDataSource {

    var wordModelList    = [YXWordModel]()
    var bookName: String = ""

    var titleLabel: UILabel = {
        let label = UILabel()
        label.text          = ""
        label.textColor     = UIColor.black1
        label.font          = UIFont.mediumFont(ofSize: AdaptFontSize(17))
        label.textAlignment = .center
        return label
    }()
    var closeButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "close"), for: .normal)
        return button
    }()
    var lineView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.hex(0xE6E6E6)
        return view
    }()
    var tableView = UITableView()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.createSubview()
        self.bindProperty()
    }

    private func createSubview() {
        self.view.addSubview(titleLabel)
        self.view.addSubview(closeButton)
        self.view.addSubview(lineView)
        self.view.addSubview(tableView)
        titleLabel.snp.makeConstraints { (make) in
            make.left.equalToSuperview().offset(AdaptSize(15))
            make.top.equalToSuperview().offset(AdaptSize(17))
            make.right.equalToSuperview().offset(AdaptSize(-15))
        }
        closeButton.snp.makeConstraints { (make) in
            make.top.equalTo(titleLabel).offset(AdaptSize(-10))
            make.right.equalToSuperview().offset(AdaptSize(-12))
            make.size.equalTo(CGSize(width: AdaptSize(35), height: AdaptSize(35)))
        }
        lineView.snp.makeConstraints { (make) in
            make.left.right.equalToSuperview()
            make.height.equalTo(0.6)
            make.top.equalTo(titleLabel.snp.bottom).offset(AdaptSize(15))
        }
        tableView.snp.makeConstraints { (make) in
            make.left.right.bottom.equalToSuperview()
            make.top.equalTo(lineView.snp.bottom)
        }
    }

    private func bindProperty() {
        self.tableView.delegate   = self
        self.tableView.dataSource = self
        self.titleLabel.text      = "查看\(self.wordModelList.count)个单词"
        self.tableView.register(YXHomeworkWordListCell.classForCoder(), forCellReuseIdentifier: "kYXHomeworkWordCell")
        self.closeButton.addTarget(self, action: #selector(self.closedAction), for: .touchUpInside)
        self.customNavigationBar?.isHidden = true
        self.tableView.backgroundColor     = .white
    }

    // MARK: === Event ====
    @objc
    private func closedAction() {
        self.dismiss(animated: true, completion: nil)
    }


    // MARK: ==== UITableViewDelegate && UITableViewDataSource ====

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        self.wordModelList.count + 1
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 0 {
            let cell = YXHomeworkWordListHeaderCell(bookName: self.bookName)
            return cell
        } else {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "kYXHomeworkWordCell") as? YXHomeworkWordListCell else {
                return UITableViewCell()
            }
            let wordModel = self.wordModelList[indexPath.row - 1]
            cell.setData(word: wordModel)
            return cell
        }
    }

    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return UIView()
    }
}
