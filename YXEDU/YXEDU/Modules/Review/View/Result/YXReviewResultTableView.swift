//
//  YXReviewResultTableView.swift
//  YXEDU
//
//  Created by sunwu on 2019/12/24.
//  Copyright © 2019 shiji. All rights reserved.
//

import UIKit

class YXReviewResultTableView: YXView, UITableViewDelegate, UITableViewDataSource {

    var words: [YXBaseWordModel] = [] { didSet{ bindData() } }
    var tableView = UITableView()
    
    private let leftView = YXReviewResultTableLeftView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.createSubviews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func createSubviews() {
        let headerLabel = UILabel(frame: CGRect(x: 40, y: 23, width: AS(127), height: AS(20)))
        headerLabel.text = "这些单词还需要加强"
        headerLabel.font = UIFont.regularFont(ofSize: AS(14))
        headerLabel.textColor = UIColor.black3
        
//        let headerView = UIView(frame: CGRect(x: 0, y: 0, width: AS(200), height: AS(23 + 20 + 9)))
//        headerView.addSubview(headerLabel)

        self.addSubview(headerLabel)
        self.addSubview(tableView)
        self.addSubview(leftView)
        leftView.snp.makeConstraints { (make) in
            make.left.top.bottom.equalToSuperview()
            make.width.equalTo(AS(26))
        }
        
    
        self.backgroundColor = UIColor.white
        self.layer.masksToBounds = true
        self.layer.cornerRadius = AS(5)
        self.layer.setDefaultShadow()
        
        tableView.snp.makeConstraints { (make) in
            make.top.equalTo(AS(51))
            make.left.right.equalToSuperview()
            make.bottom.equalTo(AS(-14))
        }
        
        
        
        
        self.tableView.delegate = self
        self.tableView.dataSource = self

        self.tableView.register(YXReviewResultTableViewCell.classForCoder(), forCellReuseIdentifier: "YXReviewResultTableViewCell")
        
        setBottomView()
        
        leftView.maxHeight = screenHeight
        

    }
    
    override func bindData() {
        self.tableView.isHidden = (words.count == 0)
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
    
    private func setBottomView() {
        let layerView = UIView()
//        layerView.frame = CGRect(x: 58, y: 525, width: 276, height: 24)
        // fillCode
        let bgLayer1 = CAGradientLayer()
        bgLayer1.colors = [UIColor(red: 1, green: 1, blue: 1, alpha: 0).cgColor, UIColor(red: 1, green: 1, blue: 1, alpha: 1).cgColor]
        bgLayer1.locations = [0, 1]
        bgLayer1.frame = layerView.bounds
        bgLayer1.startPoint = CGPoint(x: 0.5, y: 0)
        bgLayer1.endPoint = CGPoint(x: 0.72, y: 0.72)
        layerView.layer.addSublayer(bgLayer1)
        
        
        self.addSubview(layerView)
        layerView.snp.makeConstraints { (make) in
            make.left.equalTo(AS(29))
            make.right.equalTo(AS(-12))
            make.height.equalTo(AS(24))
            make.bottom.equalTo(AS(-14))
        }
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
        meaningLabel.textAlignment = .right
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        titleLabel.snp.makeConstraints { (make) in
            make.centerY.equalToSuperview()
            make.left.equalTo(AS(40))
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
        return AS(30)
    }
}


class YXReviewResultTableLeftView: YXView {
    var maxHeight: CGFloat = screenHeight {
        didSet { bindData() }
    }
    
    override func createSubviews() {
        self.backgroundColor = UIColor.clear
        self.clipsToBounds = true
//        self.frame = CGRect(x: 0, y: 0 , width: 26, height: maxHeight)
        
//        let top: CGFloat = 13
        let left: CGFloat = 9
        let count = Int(maxHeight / 21) + 1
        for i in 0..<count {
            let view = self.grayView()
            view.frame = CGRect(x: AS(left), y: AS(CGFloat(i * 29 + 13)) , width: AS(16), height: AS(16))
            self.addSubview(view)
        }
        
    }
    
    override func bindData() {
        self.createSubviews()
    }
    
    private func grayView() -> UIView {
        let view = UIView()
        view.layer.masksToBounds = true
        view.layer.cornerRadius = AS(5)
        view.backgroundColor = UIColor.colorD8D8D8
        return view
    }
    
    
}



