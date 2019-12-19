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

class YXSearchEmptyDataView: YXView {
    var imageView = UIImageView()
    var descLabel = UILabel()
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
        self.addSubview(descLabel)
    }
    
    override func bindProperty() {
        imageView.image = UIImage(named: "search_empty_data")
        descLabel.text = "暂无单词数据"
        descLabel.textColor = UIColor.black3
        descLabel.font = UIFont.mediumFont(ofSize: 12)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        imageView.snp.makeConstraints { (make) in
            make.top.centerX.equalToSuperview()
            make.width.equalTo(277)
            make.height.equalTo(205)
        }
        descLabel.snp.makeConstraints { (make) in
            make.top.equalTo(imageView.snp.bottom).offset(5)
            make.centerX.equalToSuperview()
            make.width.equalTo(73)
            make.height.equalTo(17)
        }
    }
}




class YXSearchTableViewCell: YXTableViewCell<YXSearchWordModel> {
    
    var wordLabel = UILabel()
    var soundmarkLabel = UILabel()
    var descLabel = UILabel()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.createSubviews()
        self.bindProperty()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func createSubviews() {
        self.addSubview(wordLabel)
        self.addSubview(soundmarkLabel)
        self.addSubview(descLabel)
    }
    
    override func bindProperty() {
        wordLabel.textColor = UIColor.black1
        wordLabel.font = UIFont.mediumFont(ofSize: 15)
        
        soundmarkLabel.textColor = UIColor.black3
        soundmarkLabel.font = UIFont.regularFont(ofSize: 14)
        
        descLabel.textColor = UIColor.black3
        descLabel.font = UIFont.regularFont(ofSize: 14)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        let wordWidth = wordLabel.text?.textWidth(font: wordLabel.font, height: 22) ?? 0
        wordLabel.snp.makeConstraints { (make) in
            make.top.equalTo(9)
            make.left.equalTo(23)
            make.width.equalTo(wordWidth)
            make.height.equalTo(22)
        }
        
        soundmarkLabel.snp.makeConstraints { (make) in
            make.centerY.equalTo(wordLabel)
            make.left.equalTo(wordLabel.snp.right).offset(20)
            make.right.equalTo(-23)
            make.height.equalTo(20)
        }
        
        descLabel.snp.makeConstraints { (make) in
            make.left.equalTo(23)
            make.right.equalTo(-23)
            make.height.equalTo(20)
            make.bottom.equalTo(-9)
        }
    }
    
    override func bindData() {
        wordLabel.text = self.model?.word
        soundmarkLabel.text = self.model?.soundmark
        descLabel.text = (self.model?.partOfSpeech ?? "") + (self.model?.meaning ?? "")
    }
    
    override class func viewHeight(model: YXSearchWordModel) -> CGFloat {
        return 60
    }

}
