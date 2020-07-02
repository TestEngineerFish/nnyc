//
//  YXHomeSubItemCell.swift
//  YXEDU
//
//  Created by Jake To on 10/24/19.
//  Copyright © 2019 shiji. All rights reserved.
//

import UIKit

class YXHomeSubItemCell: UICollectionViewCell {

    @IBOutlet weak var colorView: UIView!
    @IBOutlet weak var iconView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var newWorkImage: UIImageView!
    
    var dotView = YXRedDotView()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.addSubview(dotView)
        dotView.snp.makeConstraints { (make) in
            make.centerY.equalTo(titleLabel)
            make.left.equalTo(titleLabel.snp.right).offset(AdaptSize(5))
            make.size.equalTo(CGSize(width: AdaptSize(5), height: AdaptSize(5)))
        }
    }
    
    func setData(_ indexPath: IndexPath) {
        let hideDotView = YXRedDotManager.share.getTaskCenterBadgeNum() <= 0
        switch indexPath.row {
        case 0:
            self.colorView.backgroundColor = UIColor.hex(0xFFEFF0)
            self.iconView.image            = #imageLiteral(resourceName: "homeTask")
            self.titleLabel.text           = "任务中心"
            self.dotView.isHidden          = hideDotView
            self.newWorkImage.isHidden     = true
        case 1:
            self.colorView.backgroundColor = UIColor.hex(0xE8F6EA)
            self.iconView.image            = #imageLiteral(resourceName: "homeCalendar")
            self.titleLabel.text           = "打卡日历"
            self.dotView.isHidden          = true
            self.newWorkImage.isHidden     = true
        case 2:
            self.colorView.backgroundColor = UIColor.hex(0xF0F6FF)
            self.iconView.image            = #imageLiteral(resourceName: "homeReport")
            self.titleLabel.text           = "学习报告"
            self.dotView.isHidden          = true
            self.newWorkImage.isHidden     = true
        case 3:
            self.colorView.backgroundColor = UIColor.hex(0xFFF4E1)
            self.iconView.image            = UIImage(named: "homeChallenge")
            self.titleLabel.text           = "单词挑战"
            self.dotView.isHidden          = true
            self.newWorkImage.isHidden     = true
        default:
            break
        }
        
    }

}
