//
//  YXExerciseResultView.swift
//  YXEDU
//
//  Created by sunwu on 2020/1/13.
//  Copyright © 2020 shiji. All rights reserved.
//

import UIKit

class YXReviewResultTipsListView: YXView, UITableViewDelegate, UITableViewDataSource {
    
    var showWordListEvent: (() -> ())?
    
    var dataSource: [(String, Int, Bool)] = [] {
        didSet { bindData() }
    }
    var textAlignment: NSTextAlignment = .left
        
    private var maxWidth: CGFloat = 0
    private var tableView = UITableView()
    
    private let cellHeight: CGFloat = AS(40)
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.createSubviews()
        self.bindProperty()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func createSubviews() {
        self.addSubview(tableView)
    }
    
    override func bindProperty() {
        self.tableView.backgroundColor = UIColor.clear
        self.tableView.separatorColor  = UIColor.black4.withAlphaComponent(0.5)
        self.tableView.separatorInset  = UIEdgeInsets(top: 0, left: AS(31), bottom: 0, right: AS(34))
        self.tableView.delegate        = self
        self.tableView.dataSource      = self
        self.tableView.register(UITableViewCell.classForCoder(), forCellReuseIdentifier: "UITableViewCell")
    }
    
    
    override func layoutSubviews() {
        super.layoutSubviews()
        tableView.snp.remakeConstraints { (make) in
            make.edges.equalToSuperview()
        }
    }
    
    override func bindData() {
        self.processMaxContentWidth()
        self.tableView.reloadData()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSource.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return cellHeight
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let value = dataSource[indexPath.row]
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "UITableViewCell", for: indexPath)
        cell.selectionStyle = .none
        
        let titleLabel = self.createTitleLabel()
        let countLabel = self.createCountLabel()
        
        titleLabel.text = value.0
        countLabel.text = "\(value.1)"
        
        cell.removeAllSubviews()
        cell.addSubview(titleLabel)
        cell.addSubview(countLabel)
        titleLabel.sizeToFit()
        titleLabel.snp.remakeConstraints { (make) in
            make.centerY.equalToSuperview()
            make.left.equalTo(AS(31))
            make.size.equalTo(titleLabel.size)
        }
        
        countLabel.snp.remakeConstraints { (make) in
            make.centerY.equalToSuperview()
            make.width.equalTo(AS(80))
            make.right.equalToSuperview().offset(AS(value.2 ? -44 : -34))
        }
        
        if value.2 {
            let imageView = createArrowImageView()
            cell.addSubview(imageView)
            imageView.snp.remakeConstraints { (make) in
                make.centerY.equalToSuperview()
                make.right.equalToSuperview().offset(AS(-33))
                make.width.equalTo(AS(8))
                make.height.equalTo(AS(15))
            }
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let data = dataSource[indexPath.row]
        if data.2 {
            self.showWordListEvent?()
        }
    }
    
    
    private func createTitleLabel() -> UILabel {
        let titleLabel = UILabel()
        titleLabel.font = UIFont.regularFont(ofSize: AS(14))
        titleLabel.textColor = UIColor.black2
        return titleLabel
    }
    
    private func createCountLabel() -> UILabel {
        let titleLabel = UILabel()
        titleLabel.font = UIFont.regularFont(ofSize: AS(17))
        titleLabel.textColor = UIColor.orange1
        titleLabel.textAlignment = .right
        return titleLabel
    }
    
    
    private func createArrowImageView() -> UIImageView {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "review_result_arrow")
        return imageView
    }
    
    private func processMaxContentWidth() {
        for content in dataSource {
            let w: CGFloat = content.0.textWidth(font: UIFont.regularFont(ofSize: AS(14)), height: AS(20))
            maxWidth = (w > maxWidth) ? w : maxWidth
        }
    }
    
    func viewHeight(count: Int) -> CGFloat {
        return cellHeight * CGFloat(count > 3 ? 3 : count)
    }
    
}
