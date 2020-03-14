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
    
    var descriptionLabel: UILabel = {
        let label = UILabel()
        label.textColor     = UIColor.black4
        label.font          = UIFont.regularFont (ofSize: AdaptSize(12))
        label.textAlignment = .center
        return label
    }()
    
    func setData(_ model: YXBadgeModel) {
        self.imageView.showImage(with: model.imageOfCompletedStatus ?? "")
        self.descriptionLabel.text = model.description ?? ""
    }

}
