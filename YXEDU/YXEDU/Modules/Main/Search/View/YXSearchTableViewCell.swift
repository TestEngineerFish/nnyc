//
//  YXSearchTableViewCell.swift
//  YXEDU
//
//  Created by sunwu on 2019/12/18.
//  Copyright © 2019 shiji. All rights reserved.
//

import UIKit


class YXSearchTableHeaderView: YXView {
    var historyLabel = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.createSubviews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func createSubviews() {
        self.addSubview(historyLabel)
        historyLabel.snp.makeConstraints { (make) in
            make.top.equalTo(15)
            make.left.equalTo(22)
            make.height.equalTo(18)
            make.width.equalTo(53)
        }
        historyLabel.text = "历史搜索"
        historyLabel.textColor = UIColor.black3
        historyLabel.font = UIFont.mediumFont(ofSize: 13)
    }
}


class YXSearchTableViewCell: YXTableViewCell<YXSearchWordModel> {
    
    var wordLabel: UILabel!
    var sysbolLabel: UILabel!
    var descLabel: UILabel!
    
    deinit {
//        listenButton.removeTarget(self, action: #selector(clickListenButton), for: .touchUpInside)
//        reviewButton.removeTarget(self, action: #selector(clickReviewButton), for: .touchUpInside)
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.createSubviews()
//        self.bindProperty()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func createSubviews() {
        self.addSubview(wordLabel)
        self.addSubview(sysbolLabel)
        self.addSubview(descLabel)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        wordLabel.snp.makeConstraints { (make) in
//            make.
        }
    }
    
    override class func viewHeight(model: YXSearchWordModel) -> CGFloat {
        return 60
    }

}
