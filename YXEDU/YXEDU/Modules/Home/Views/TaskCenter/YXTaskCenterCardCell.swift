//
//  YXTaskCenterCardCell.swift
//  YXEDU
//
//  Created by Jake To on 12/16/19.
//  Copyright © 2019 shiji. All rights reserved.
//

import UIKit

enum YXTaskCardType: Int {
    case everydayTodayLearnPlan = 6
    case everydayCompleteChallenge = 7
    case everydayCompleteShareToWechat = 8
    case smartReview = 10
    case createPlan = 11
    case UnitStudy = 12
    case collectWord = 13
    case completeChallenge = 14
    case punchInWechat = 15
    case punchInQQ = 16
    case wrongWords = 17
}

enum YXTaskCardStatus: Int {
    case incomplete = 0
    case completed = 1
    case getReward = 2
}

class YXTaskCenterCardCell: UICollectionViewCell {
    var todoClosure: (() -> Void)?
    
    var didRepeat = false
    var taskType: YXTaskCardType = .smartReview
    var cardStatus: YXTaskCardStatus = .incomplete

    @IBOutlet weak var shadowView: UIView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var statusLabel: UILabel!
    @IBOutlet weak var rewardLabel: UILabel!
    @IBOutlet weak var iconImageView: UIImageView!
    @IBOutlet weak var todoButton: YXDesignableButton!

    override func awakeFromNib() {
        super.awakeFromNib()
        
        shadowView.layer.cornerRadius = 6
        shadowView.layer.shadowColor = UIColor.black.cgColor
        shadowView.layer.shadowOffset = CGSize(width: 0, height: 2)
        shadowView.layer.shadowOpacity = 0.1
        shadowView.layer.shadowRadius = 5
        shadowView.layer.masksToBounds = false
    }

    func adjustCell() {
        switch taskType {
        case .everydayTodayLearnPlan:
            iconImageView.image = #imageLiteral(resourceName: "everydayTodayLearnPlan")
            break

        case .everydayCompleteChallenge, .completeChallenge:
            iconImageView.image = #imageLiteral(resourceName: "everydayCompleteChallenge")
            break

        case .everydayCompleteShareToWechat, .punchInWechat:
            iconImageView.image = #imageLiteral(resourceName: "everydayCompleteShareToWechat")
            break

        case .smartReview:
            iconImageView.image = #imageLiteral(resourceName: "smartReview")
            break

        case .createPlan:
            iconImageView.image = #imageLiteral(resourceName: "createPlan")
            break

        case .UnitStudy:
            iconImageView.image = #imageLiteral(resourceName: "UnitStudy")
            break

        case .punchInQQ:
            iconImageView.image = #imageLiteral(resourceName: "punchInQQ")
            break

        case .wrongWords:
            iconImageView.image = #imageLiteral(resourceName: "wrongWords")
            break
            
        case .collectWord:
            iconImageView.image = #imageLiteral(resourceName: "collectWords")
            break
        }
        
        switch cardStatus {
        case .incomplete:
            if didRepeat {
                statusLabel.isHidden = true
                todoButton.isHidden = false
                todoButton.borderColor = UIColor.hex(0xDCDCDC)
                todoButton.borderWidth = 0.5
                todoButton.setTitleColor(UIColor.black, for: .normal)
                todoButton.setTitle("去完成", for: .normal)

            } else {
                statusLabel.isHidden = false
                statusLabel.text = "待完成"
                todoButton.isHidden = true
            }
            break
            
        case .completed:
            statusLabel.isHidden = true
            todoButton.isHidden = false
            todoButton.borderColor = UIColor.hex(0xDCDCDC)
            todoButton.borderWidth = 0.5
            todoButton.setTitleColor(UIColor.orange1, for: .normal)
            todoButton.setTitle("可领取", for: .normal)
            break
            
        case .getReward:
            statusLabel.isHidden = false
            statusLabel.text = "已领取"
            todoButton.isHidden = true
            break
        }
        
        todoButton.contentEdgeInsets.left = 16
        todoButton.contentEdgeInsets.right = 16
        todoButton.titleEdgeInsets.left = -todoButton.imageView!.bounds.width - 10
        todoButton.imageEdgeInsets.left = todoButton.titleLabel!.bounds.width + 4
        todoButton.imageEdgeInsets.right = -4
    }
    
    @IBAction func todo(_ sender: Any) {
        todoClosure?()
    }
}
