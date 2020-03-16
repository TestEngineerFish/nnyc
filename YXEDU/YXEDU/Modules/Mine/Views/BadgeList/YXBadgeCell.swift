//
//  YXBadgeCell.swift
//  YXEDU
//
//  Created by Jake To on 12/25/19.
//  Copyright © 2019 shiji. All rights reserved.
//

import UIKit

class YXBadgeCell: UICollectionViewCell {

    var imageView = YXKVOImageView()
    
    var dateLabel: UILabel = {
        let label = UILabel()
        label.font          = UIFont.regularFont (ofSize: AdaptSize(12))
        label.textAlignment = .center
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = UIColor.clear
        self.createSubviews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func createSubviews() {
        self.addSubview(imageView)
        self.addSubview(dateLabel)
        imageView.snp.makeConstraints { (make) in
            make.left.top.right.equalToSuperview()
            make.height.equalTo(AdaptSize(73.1))
        }
        dateLabel.snp.makeConstraints { (make) in
            make.height.equalTo(AdaptSize(17))
            make.left.right.equalToSuperview()
            make.bottom.equalToSuperview()
        }
    }
    
    func setData(_ model: YXBadgeModel) {
        let getTimeDouble = model.finishDateTimeInterval ?? 0.0
        if getTimeDouble != 0 {
            let getTimeDate          = NSDate(timeIntervalSince1970: getTimeDouble)
            self.dateLabel.textColor = UIColor.black6
            self.dateLabel.text      = getTimeDate.formatYMD() + "获得"
            self.imageView.showImage(with: model.imageOfCompletedStatus ?? "")
            
        } else {
            self.dateLabel.text      = "未获得"
            self.dateLabel.textColor = UIColor.black4
            self.imageView.showImage(with: model.imageOfIncompletedStatus ?? "")
        }
    }

}
