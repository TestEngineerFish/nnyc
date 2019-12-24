//
//  YXReviewResultTableView.swift
//  YXEDU
//
//  Created by sunwu on 2019/12/24.
//  Copyright © 2019 shiji. All rights reserved.
//

import UIKit

class YXReviewResultTableView: YXView, UITableViewDelegate, UITableViewDataSource {

    var words: [YXBaseWordModel] = []
    var tableView = UITableView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.createSubviews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func createSubviews() {
        self.addSubview(tableView)
        tableView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.register(YXReviewResultTableViewCell.classForCoder(), forCellReuseIdentifier: "YXReviewResultTableViewCell")
        
        let headerView = UILabel(frame: CGRect(x: 0, y: 0, width: 127, height: 20))
        headerView.text = "这些单词还需要加强"
        headerView.font = UIFont.regularFont(ofSize: AS(14))
        headerView.textColor = UIColor.black3
        self.tableView.tableHeaderView = headerView
        
    }
            
    override func bindData() {
        self.tableView.reloadData()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return words.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let model = words[indexPath.row]
        return YXReviewResultTableViewCell.viewHeight(model: model)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "YXReviewResultTableViewCell", for: indexPath)
        cell.selectionStyle = .none
        tableView.separatorColor = UIColor.clear
        return cell
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        guard let _cell = cell as? YXReviewResultTableViewCell else { return }
        _cell.word = words[indexPath.row]
    }

}


class YXReviewResultTableViewCell: YXTableViewCell<YXBaseWordModel> {
    var word: YXBaseWordModel? {
        didSet { bindData() }
    }
    
    var titleLabel = UILabel()
    var meaningLabel = UILabel()
        
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.createSubviews()
        self.bindProperty()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func createSubviews() {
        self.addSubview(titleLabel)
        self.addSubview(meaningLabel)
    }
            
    override func bindProperty() {
        titleLabel.font = UIFont.mediumFont(ofSize: AS(17))
        titleLabel.textColor = UIColor.black1
        
        meaningLabel.font = UIFont.regularFont(ofSize: AS(14))
        meaningLabel.textColor = UIColor.black2
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        titleLabel.snp.makeConstraints { (make) in
            make.centerY.equalToSuperview()
            make.left.equalTo(AS(20))
            make.height.equalTo(AS(24))
        }
        
        meaningLabel.snp.makeConstraints { (make) in
            make.centerY.equalToSuperview()
            make.left.equalTo(titleLabel.snp.right).offset(AS(10))
            make.right.equalTo(AS(-20))
            make.width.equalTo(titleLabel)
            make.height.equalTo(AS(20))
        }
        
    }
    
    override func bindData() {
        self.titleLabel.text = word?.word
        self.meaningLabel.text = word?.meaning
    }
    
    override class func viewHeight(model: YXBaseWordModel) -> CGFloat {
        return 38
    }
}
