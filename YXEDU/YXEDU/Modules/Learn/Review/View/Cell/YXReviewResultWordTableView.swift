//
//  YXReviewResultTableView.swift
//  YXEDU
//
//  Created by sunwu on 2019/12/24.
//  Copyright © 2019 shiji. All rights reserved.
//

import UIKit

class YXReviewResultWordTableView: YXView, UITableViewDelegate, UITableViewDataSource {

    var words: [YXBaseWordModel] = [] { didSet{ bindData() } }
    var tableView = UITableView()
    let headerLabel = UILabel()
    var imageView = UIImageView()
    var shadowsView = UIView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.createSubviews()
        self.bindProperty()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func createSubviews() {
        self.addSubview(imageView)
        self.addSubview(headerLabel)
        self.addSubview(tableView)
        self.addSubview(shadowsView)
    }
    
    override func bindProperty() {
        
        self.headerLabel.text = "这些单词还需要加强"
        self.headerLabel.font = UIFont.regularFont(ofSize: AdaptFontSize(14))
        self.headerLabel.textColor = UIColor.black3
        
        
        self.tableView.backgroundColor = UIColor.clear
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.register(YXReviewResultTableViewCell.classForCoder(), forCellReuseIdentifier: "YXReviewResultTableViewCell")
        
        
        let gradient = CAGradientLayer()
        gradient.frame = CGRect(x: 0, y: 0, width: screenWidth - AS(99), height: AS(24))
        gradient.colors = [UIColor.white.withAlphaComponent(0.0).cgColor, UIColor.white.cgColor]
        gradient.startPoint = CGPoint(x: 0.5, y: 0)
        gradient.endPoint = CGPoint(x: 0.5, y: 1)
        shadowsView.layer.addSublayer(gradient)
        
    }
    
    
    override func layoutSubviews() {
        super.layoutSubviews()
                
        imageView.snp.remakeConstraints { (make) in
            make.top.bottom.equalTo(0)
            make.left.equalTo(AS(19))
            make.right.equalTo(AS(-19))
        }
        
        headerLabel.snp.remakeConstraints { (make) in
            make.top.equalTo(AS(23))
            make.left.equalTo(AS(69))
            make.size.equalTo(CGSize(width: AS(127), height: AS(20)))
        }
        
        tableView.snp.remakeConstraints { (make) in
            make.top.equalTo(AS(51))
            make.left.equalTo(AS(69))
            make.right.equalTo(AS(-49))
            make.bottom.equalTo(AS(-27))
        }
        
        shadowsView.snp.remakeConstraints { (make) in
            make.left.equalTo(AS(58))
            make.right.equalTo(AS(-41))
            make.height.equalTo(AS(24))
            make.bottom.equalTo(AS(-14))
        }
    }
    
    override func bindData() {
        self.tableView.isHidden = (words.count == 0)
        self.tableView.reloadData()
        
        if words.count > 3 {
            self.imageView.image = UIImage(named: "review_result_table_bg_b")
        } else {
            self.imageView.image = UIImage(named: "review_result_table_bg_s")
        }
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
        self.backgroundColor = UIColor.clear
        
        titleLabel.font = UIFont.mediumFont(ofSize: AdaptFontSize(17))
        titleLabel.textColor = UIColor.black1
        
        meaningLabel.font = UIFont.regularFont(ofSize: AdaptFontSize(14))
        meaningLabel.textColor = UIColor.black2
        meaningLabel.textAlignment = .right
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        titleLabel.snp.remakeConstraints { (make) in
            make.centerY.left.equalToSuperview()
            make.height.equalTo(AS(24))
        }
        
        meaningLabel.snp.remakeConstraints { (make) in
            make.centerY.right.equalToSuperview()
            make.left.equalTo(titleLabel.snp.right).offset(AS(10))
            make.width.equalTo(titleLabel)
            make.height.equalTo(AS(20))
        }
        
    }
    
    override func bindData() {
        self.titleLabel.text = word?.word
        self.meaningLabel.text = word?.meaning
    }
    
    override class func viewHeight(model: YXBaseWordModel) -> CGFloat {
        return AS(30)
    }
}


