//
//  YXSearchTableViewCell.swift
//  YXEDU
//
//  Created by sunwu on 2019/12/18.
//  Copyright © 2019 shiji. All rights reserved.
//

import UIKit


class YXSearchTableHeaderView: YXView {
    
    var removeEvent: (() -> Void)?
    
    var historyLabel = UILabel()
    var removeButton = BiggerClickAreaButton()
    
    deinit {
        removeButton.removeTarget(self, action: #selector(clickRemoveButton), for: .touchUpInside)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.createSubviews()
        self.bindProperty()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func createSubviews() {
        self.addSubview(historyLabel)
        self.addSubview(removeButton)
    }
    
    override func layoutSubviews() {
        historyLabel.snp.makeConstraints { (make) in
            make.top.equalTo(AS(15))
            make.left.equalTo(AS(22))
            make.height.equalTo(AS(18))
            make.width.equalTo(AS(53))
        }
        
        removeButton.snp.makeConstraints { (make) in
            make.centerY.equalTo(historyLabel)
            make.right.equalTo(AS(-25))
            make.width.equalTo(AS(13))
            make.height.equalTo(AS(13))
        }
    }
    
    override func bindProperty() {
        historyLabel.text = "历史搜索"
        historyLabel.textColor = UIColor.black3
        historyLabel.font = UIFont.mediumFont(ofSize: AdaptFontSize(13))
        
        removeButton.setImage(UIImage(named: "search_remove"), for: .normal)
        removeButton.addTarget(self, action: #selector(clickRemoveButton), for: .touchUpInside)
    }
    
    @objc private func clickRemoveButton() {
        self.removeEvent?()
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
        descLabel.font = UIFont.mediumFont(ofSize: AdaptFontSize(12))
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        imageView.snp.makeConstraints { (make) in
            make.top.centerX.equalToSuperview()
            make.width.equalTo(AS(277))
            make.height.equalTo(AS(205))
        }
        descLabel.snp.makeConstraints { (make) in
            make.top.equalTo(imageView.snp.bottom).offset(AS(5))
            make.centerX.equalToSuperview()
            make.width.equalTo(AS(73))
            make.height.equalTo(AS(17))
        }
    }
    
    
}




class YXHistorySearchRemoveAlertView: YXTopWindowView {
    
    var removeEvent: (() -> Void)?
    
    var titleLabel = UILabel()
    var removeButton = UIButton()
    var cancelButton = UIButton()
    
    deinit {
        removeButton.removeTarget(self, action: #selector(clickRemoveButton), for: .touchUpInside)
        cancelButton.removeTarget(self, action: #selector(clickCancelButton), for: .touchUpInside)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.createSubviews()
        self.bindProperty()
    }
    
       
    required init?(coder: NSCoder) {
           fatalError("init(coder:) has not been implemented")
    }

    override func createSubviews() {
        mainView.addSubview(titleLabel)
        mainView.addSubview(removeButton)
        mainView.addSubview(cancelButton)
    }

    override func bindProperty() {
        self.backgroundColor = UIColor.black.withAlphaComponent(0.7)
        mainView.layer.masksToBounds = true
        mainView.layer.cornerRadius = AS(7)
                        
        
        titleLabel.font = UIFont.pfSCRegularFont(withSize: AdaptFontSize(15))
        titleLabel.textColor = UIColor.black
        titleLabel.text = "确定要清空本地搜索记录吗？"
        titleLabel.textAlignment = .center
        titleLabel.numberOfLines = 0
        
        
        removeButton.layer.masksToBounds = true
        removeButton.layer.cornerRadius = AS(20)
        removeButton.layer.borderColor = UIColor.black6.cgColor
        removeButton.layer.borderWidth = 0.5
        removeButton.setTitle("清空", for: .normal)
        removeButton.titleLabel?.font = UIFont.regularFont(ofSize: AdaptFontSize(17))
        removeButton.setTitleColor(UIColor.red1, for: .normal)
        removeButton.setTitleColor(UIColor.black4, for: .highlighted)
        removeButton.addTarget(self, action: #selector(clickRemoveButton), for: .touchUpInside)
        
        
        cancelButton.layer.masksToBounds = true
        cancelButton.layer.cornerRadius = AS(20)
        cancelButton.layer.borderColor = UIColor.black6.cgColor
        cancelButton.layer.borderWidth = 0.5
        cancelButton.setTitle("点错了", for: .normal)
        cancelButton.setTitleColor(UIColor.black1, for: .normal)
        cancelButton.setTitleColor(UIColor.black4, for: .highlighted)
        cancelButton.titleLabel?.font = UIFont.regularFont(ofSize: AdaptFontSize(17))
        cancelButton.addTarget(self, action: #selector(clickCancelButton), for: .touchUpInside)
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        
        mainView.snp.makeConstraints { (make) in
            make.center.equalToSuperview()
            make.width.equalTo(AS(300))
            make.height.equalTo(AS(174))
        }
       
        titleLabel.snp.makeConstraints { (make) in
            make.top.equalTo(AS(31))
            make.left.equalTo(AS(16))
            make.right.equalTo(AS(-16))
            make.height.equalTo(AS(44))
        }
        
        removeButton.snp.makeConstraints { (make) in
            make.left.equalTo(AS(19))
            make.width.equalTo(AS(125))
            make.height.equalTo(AS(40))
            make.bottom.equalTo(AS(-30))
        }

        cancelButton.snp.makeConstraints { (make) in
            make.right.equalTo(AS(-19))
            make.width.equalTo(AS(125))
            make.height.equalTo(AS(40))
            make.bottom.equalTo(AS(-30))
        }

    }



    @objc private func clickRemoveButton() {
        self.removeEvent?()
        self.removeFromSuperview()
    }
    
    
    @objc private func clickCancelButton() {
        self.removeFromSuperview()
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
        wordLabel.font = UIFont.mediumFont(ofSize: AdaptFontSize(15))
        
        soundmarkLabel.textColor = UIColor.black3
        soundmarkLabel.font = UIFont.regularFont(ofSize: AdaptFontSize(14))
        
        descLabel.textColor = UIColor.black3
        descLabel.font = UIFont.regularFont(ofSize: AdaptFontSize(14))
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        let wordWidth = wordLabel.text?.textWidth(font: wordLabel.font, height: AS(22)) ?? 0
        wordLabel.snp.remakeConstraints { (make) in
            make.top.equalTo(AS(9))
            make.left.equalTo(AS(23))
            make.width.equalTo(wordWidth)
            make.height.equalTo(AS(22))
        }
        
        soundmarkLabel.snp.remakeConstraints { (make) in
            make.centerY.equalTo(wordLabel)
            make.left.equalTo(wordLabel.snp.right).offset(AS(20))
            make.right.equalTo(AS(-23))
            make.height.equalTo(AS(20))
        }
        
        descLabel.snp.remakeConstraints { (make) in
            make.left.equalTo(AS(23))
            make.right.equalTo(AS(-23))
            make.height.equalTo(AS(20))
            make.bottom.equalTo(AS(-9))
        }
    }
    
    override func bindData() {
        wordLabel.text = self.model?.word
        soundmarkLabel.text = self.model?.soundmark
        descLabel.text = (self.model?.partOfSpeech ?? "") + (self.model?.meaning ?? "")
    }
    
    override class func viewHeight(model: YXSearchWordModel) -> CGFloat {
        return AS(60)
    }

}
