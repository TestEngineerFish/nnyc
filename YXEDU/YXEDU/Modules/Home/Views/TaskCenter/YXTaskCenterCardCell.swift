//
//  YXTaskCenterCardCell.swift
//  YXEDU
//
//  Created by Jake To on 12/16/19.
//  Copyright © 2019 shiji. All rights reserved.
//

import UIKit

enum YXTaskCardType: Int {
    case cyanBlueCard = 0
    case yellowCard = 1
    case purpleCard = 2
    case greenCard = 3
    case pinkCard = 4
    case blueCard = 5
    case darkGreenCard = 6
    case redCard = 7
}

enum YXTaskCardStatus: Int {
    case incomplete = 0
    case completed = 1
    case getReward = 2
}

class YXTaskCenterCardCell: UICollectionViewCell {
    var todoClosure: (() -> Void)?
    var getRewardClosure: (() -> Void)!

    var integral = 0
    var didRepeat = false
    var taskType: YXTaskCardType = .cyanBlueCard
    var cardStatus: YXTaskCardStatus = .incomplete

    @IBOutlet weak var backgroungImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var coinImageView: UIImageView!
    @IBOutlet weak var statusLabel: UILabel!
    @IBOutlet weak var rewardLabel: UILabel!
    @IBOutlet weak var rewardLabelTopOffset: NSLayoutConstraint!
    @IBOutlet weak var todoButton: YXDesignableButton!
    @IBOutlet weak var getCoinButton: YXDesignableButton!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    func adjustCell() {
        titleLabel.layer.shadowOffset = CGSize(width: 0, height: 2)
        titleLabel.layer.shadowOpacity = 1
        titleLabel.layer.shadowRadius = 2
        
        statusLabel.text = "完成后可领取"

        rewardLabel.text = "+\(integral)"
        rewardLabel.layer.shadowOffset = CGSize(width: 0, height: 2)
        rewardLabel.layer.shadowOpacity = 1
        rewardLabel.layer.shadowRadius = 2
        
        todoButton.setTitle("\(integral)币 已领取", for: .normal)
        todoButton.isEnabled = true
        todoButton.backgroundColor = .white
        todoButton.borderWidth = 0
        todoButton.alpha = 1

        getCoinButton.setTitle("领取\(integral)", for: .normal)
        
        switch taskType {
        case .cyanBlueCard:
            backgroungImageView.image = #imageLiteral(resourceName: "cyanBlueCard")
            titleLabel.layer.shadowColor = UIColor.hex(0x5185E0).cgColor
            rewardLabel.layer.shadowColor = UIColor.hex(0x5185E0).cgColor
            statusLabel.textColor = UIColor.hex(0x87A7FD)
            todoButton.setTitleColor(UIColor.hex(0x4F7AEE), for: .normal)
            getCoinButton.setTitleColor(UIColor.hex(0x4F7AEE), for: .normal)
            getCoinButton.originTextColor = UIColor.hex(0x4F7AEE)
            getCoinButton.borderColor = UIColor.hex(0x95B1FB)
            getCoinButton.gradientColor1 = UIColor.hex(0xFFFFFF)
            getCoinButton.gradientColor2 = UIColor.hex(0xC4DCFF)
            break
            
        case .yellowCard:
            backgroungImageView.image = #imageLiteral(resourceName: "yellowCard")
            titleLabel.layer.shadowColor = UIColor.hex(0xD08900).cgColor
            rewardLabel.layer.shadowColor = UIColor.hex(0xD08900).cgColor
            statusLabel.textColor = UIColor.hex(0xEFA733)
            todoButton.setTitleColor(UIColor.hex(0xFF9700), for: .normal)
            getCoinButton.setTitleColor(UIColor.hex(0xFF9700), for: .normal)
            getCoinButton.originTextColor = UIColor.hex(0xFF9700)
            getCoinButton.borderColor = UIColor.hex(0xEBC255)
            getCoinButton.gradientColor1 = UIColor.hex(0xFFFFFF)
            getCoinButton.gradientColor2 = UIColor.hex(0xFFE79A)
            break
            
        case .purpleCard:
            backgroungImageView.image = #imageLiteral(resourceName: "purpleCard")
            titleLabel.layer.shadowColor = UIColor.hex(0x907DF2).cgColor
            rewardLabel.layer.shadowColor = UIColor.hex(0x907DF2).cgColor
            statusLabel.textColor = UIColor.hex(0x9B89F9)
            todoButton.setTitleColor(UIColor.hex(0x7F67FA), for: .normal)
            getCoinButton.setTitleColor(UIColor.hex(0x7F67FA), for: .normal)
            getCoinButton.originTextColor = UIColor.hex(0x7F67FA)
            getCoinButton.borderColor = UIColor.hex(0xA999FE)
            getCoinButton.gradientColor1 = UIColor.hex(0xFFFFFF)
            getCoinButton.gradientColor2 = UIColor.hex(0xDCD2FF)
            break
            
        case .greenCard:
            backgroungImageView.image = #imageLiteral(resourceName: "greenCard")
            titleLabel.layer.shadowColor = UIColor.hex(0x6B9530).cgColor
            rewardLabel.layer.shadowColor = UIColor.hex(0x6B9530).cgColor
            statusLabel.textColor = UIColor.hex(0x84B148)
            todoButton.setTitleColor(UIColor.hex(0x649224), for: .normal)
            getCoinButton.setTitleColor(UIColor.hex(0x649224), for: .normal)
            getCoinButton.originTextColor = UIColor.hex(0x649224)
            getCoinButton.borderColor = UIColor.hex(0x7EAF39)
            getCoinButton.gradientColor1 = UIColor.hex(0xFFFFFF)
            getCoinButton.gradientColor2 = UIColor.hex(0xE5FFD2)
            break
            
        case .pinkCard:
            backgroungImageView.image = #imageLiteral(resourceName: "pinkCard")
            titleLabel.layer.shadowColor = UIColor.hex(0xDF799E).cgColor
            rewardLabel.layer.shadowColor = UIColor.hex(0xDF799E).cgColor
            statusLabel.textColor = UIColor.hex(0xD57F9D)
            todoButton.setTitleColor(UIColor.hex(0xE37C86), for: .normal)
            getCoinButton.setTitleColor(UIColor.hex(0xE37C86), for: .normal)
            getCoinButton.originTextColor = UIColor.hex(0xE37C86)
            getCoinButton.borderColor = UIColor.hex(0xE48A9F)
            getCoinButton.gradientColor1 = UIColor.hex(0xFFFFFF)
            getCoinButton.gradientColor2 = UIColor.hex(0xFFD9E8)
            break
            
        case .blueCard:
            backgroungImageView.image = #imageLiteral(resourceName: "blueCard")
            titleLabel.layer.shadowColor = UIColor.hex(0x7CA0AF).cgColor
            rewardLabel.layer.shadowColor = UIColor.hex(0x7CA0AF).cgColor
            statusLabel.textColor = UIColor.hex(0x65B7D4)
            todoButton.setTitleColor(UIColor.hex(0x1A99FF), for: .normal)
            getCoinButton.setTitleColor(UIColor.hex(0x1A99FF), for: .normal)
            getCoinButton.originTextColor = UIColor.hex(0x1A99FF)
            getCoinButton.borderColor = UIColor.hex(0x65B4F4)
            getCoinButton.gradientColor1 = UIColor.hex(0xFFFFFF)
            getCoinButton.gradientColor2 = UIColor.hex(0xB7E3FF)
            break
            
        case .darkGreenCard:
            backgroungImageView.image = #imageLiteral(resourceName: "darkGreenCard")
            titleLabel.layer.shadowColor = UIColor.hex(0x79A359).cgColor
            rewardLabel.layer.shadowColor = UIColor.hex(0x79A359).cgColor
            statusLabel.textColor = UIColor.hex(0x48AE5B)
            todoButton.setTitleColor(UIColor.hex(0x259C46), for: .normal)
            getCoinButton.setTitleColor(UIColor.hex(0x259C46), for: .normal)
            getCoinButton.originTextColor = UIColor.hex(0x259C46)
            getCoinButton.borderColor = UIColor.hex(0x4FB66C)
            getCoinButton.gradientColor1 = UIColor.hex(0xFFFFFF)
            getCoinButton.gradientColor2 = UIColor.hex(0xD5FFDB)
            break
            
        case .redCard:
            backgroungImageView.image = #imageLiteral(resourceName: "redCard")
            titleLabel.layer.shadowColor = UIColor.hex(0xEA6750).cgColor
            rewardLabel.layer.shadowColor = UIColor.hex(0xEA6750).cgColor
            statusLabel.textColor = UIColor.hex(0xE5725D)
            todoButton.setTitleColor(UIColor.hex(0xFF6347), for: .normal)
            getCoinButton.setTitleColor(UIColor.hex(0xFF6347), for: .normal)
            getCoinButton.originTextColor = UIColor.hex(0xFF6347)
            getCoinButton.borderColor = UIColor.hex(0xE36E58)
            getCoinButton.gradientColor1 = UIColor.hex(0xFFFFFF)
            getCoinButton.gradientColor2 = UIColor.hex(0xFFD9E8)
            break
        }
        
        getCoinButton.layoutSubviews()
        getCoinButton.contentEdgeInsets.left = 16
        getCoinButton.contentEdgeInsets.right = 16
        getCoinButton.titleEdgeInsets.left = -getCoinButton.imageView!.bounds.width - 16
        getCoinButton.imageEdgeInsets.left = getCoinButton.titleLabel!.bounds.width
        
        switch cardStatus {
        case .incomplete:
            if didRepeat {
                statusLabel.isHidden = true
                coinImageView.isHidden = false
                rewardLabel.isHidden = false
                rewardLabelTopOffset.constant = 56
                
                todoButton.isHidden = false
                todoButton.setTitle("去完成", for: .normal)
                todoButton.setTitleColor(.white, for: .normal)
                todoButton.backgroundColor = .clear
                todoButton.borderWidth = 1
                
                getCoinButton.isHidden = true
                
            } else {
                statusLabel.isHidden = false
                coinImageView.isHidden = false
                rewardLabel.isHidden = false
                rewardLabelTopOffset.constant = 84
                todoButton.isHidden = true
                getCoinButton.isHidden = true
            }
            break
            
        case .completed:
            statusLabel.isHidden = false
            statusLabel.text = "已完成"
            coinImageView.isHidden = true
            rewardLabel.isHidden = true
            todoButton.isHidden = true
            todoButton.alpha = 0.3
            getCoinButton.isHidden = false
            break
            
        case .getReward:
            statusLabel.isHidden = false
            statusLabel.text = "已完成"
            coinImageView.isHidden = true
            rewardLabel.isHidden = true
            todoButton.isHidden = false
            todoButton.isEnabled = false
            todoButton.alpha = 0.3
            getCoinButton.isHidden = true
            break
        }
    }
    
    @IBAction func todo(_ sender: Any) {
        todoClosure?()
    }
    
    @IBAction func getReward(_ sender: Any) {
        getRewardClosure()
    }
}
