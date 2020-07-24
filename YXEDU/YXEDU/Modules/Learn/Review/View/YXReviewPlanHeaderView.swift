//
//  YXReviewPlanHeaderView.swift
//  YXEDU
//
//  Created by Jake To on 3/27/20.
//  Copyright © 2020 shiji. All rights reserved.
//

import UIKit

class YXReviewPlanHeaderView: UIView {
    @IBOutlet var contentView: UIView!
    @IBOutlet weak var statusView: UIView!
    @IBOutlet weak var statusLabel: UILabel!
    @IBOutlet weak var newIconButton: UIButton!
    @IBOutlet weak var newIconArrowButton: UIButton!
    @IBOutlet weak var statusViewHeight: NSLayoutConstraint!
    
    @IBOutlet weak var listenLabel: UILabel!
    @IBOutlet weak var noListenLabel: UILabel!
    @IBOutlet weak var listenStarsView: UIStackView!
    @IBOutlet weak var listenStart1: UIImageView!
    @IBOutlet weak var listenStart2: UIImageView!
    @IBOutlet weak var listenStart3: UIImageView!
    @IBOutlet weak var listenProgressView: UIProgressView!
    @IBOutlet weak var listenProgressLabel: UILabel!
    
    @IBOutlet weak var reviewLabel: UILabel!
    @IBOutlet weak var noReviewLabel: UILabel!
    @IBOutlet weak var reviewStarsView: UIStackView!
    @IBOutlet weak var reviewStart1: UIImageView!
    @IBOutlet weak var reviewStart2: UIImageView!
    @IBOutlet weak var reviewStart3: UIImageView!
    @IBOutlet weak var reviewProgressView: UIProgressView!
    @IBOutlet weak var reviewProgressLabel: UILabel!
    
    @IBOutlet weak var reportButton: UIButton!
    @IBOutlet weak var descriptionLabel: UILabel!
    
    var statusClosure: (() -> Void)?
    var reportClosure: (() -> Void)?
    var shareClosure: (() -> Void)?
    
    var detailModel: YXReviewPlanDetailModel? {
        didSet {
            guard let _detailModel = detailModel else {
                return
            }
            if let text = _detailModel.fromUser, text.isEmpty == false {
                descriptionLabel.text = text
                
            } else if let time = _detailModel.createTime {
                let date = Date(timeIntervalSince1970: time)
                
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "yyyy.MM.dd"
                
                descriptionLabel.text = "\(dateFormatter.string(from: date))由我创建"
            }
            
            if let totalCount = _detailModel.status?.totalCount, totalCount > 0 {
                statusViewHeight.constant = 36
                statusLabel.text = "\(totalCount)位用户保存了该词单，\(_detailModel.status?.finishCount ?? 0)人完成了学习"
                
                if _detailModel.status?.shouldShowNewIcon == 1 {
                    newIconButton.isHidden = false
                    
                } else {
                    newIconButton.isHidden = true
                }
                
            } else {
                statusViewHeight.constant = 0
            }
            
            switch _detailModel.listenState {
            case .normal:
                noListenLabel.isHidden = false
                listenStarsView.isHidden = true
                listenProgressView.isHidden = true
                listenProgressLabel.isHidden = true
                break
                
            case .learning:
                noListenLabel.isHidden = true
                listenStarsView.isHidden = true
                listenProgressView.isHidden = false
                listenProgressLabel.isHidden = false
                
                listenProgressView.progress = Float(_detailModel.listen) / 100
                listenProgressLabel.text = "\(_detailModel.listen)%"
                break
                
            case .finish:
                listenLabel.text = "听写成绩"
                noListenLabel.isHidden = true
                listenStarsView.isHidden = false
                listenProgressView.isHidden = true
                listenProgressLabel.isHidden = true
                
                if _detailModel.listen == 1 {
                    listenStart1.image = #imageLiteral(resourceName: "star_new_enable")
                } else if _detailModel.listen == 2 {
                    listenStart1.image = #imageLiteral(resourceName: "star_new_enable")
                    listenStart2.image = #imageLiteral(resourceName: "star_new_enable")
                    
                } else if _detailModel.listen == 3 {
                    listenStart1.image = #imageLiteral(resourceName: "star_new_enable")
                    listenStart2.image = #imageLiteral(resourceName: "star_new_enable")
                    listenStart3.image = #imageLiteral(resourceName: "star_new_enable")
                }
                
                reportButton.setTitle("学习报告", for: .normal)
                reportButton.setTitleColor(.black, for: .normal)
                reportButton.isEnabled = true
                
                break
            }
            
            switch _detailModel.reviewState {
            case .normal:
                noReviewLabel.isHidden = false
                reviewStarsView.isHidden = true
                reviewProgressView.isHidden = true
                reviewProgressLabel.isHidden = true
                break
                
            case .learning:
                noReviewLabel.isHidden = true
                reviewStarsView.isHidden = true
                reviewProgressView.isHidden = false
                reviewProgressLabel.isHidden = false
                
                reviewProgressView.progress = Float(_detailModel.review) / 100
                reviewProgressLabel.text = "\(_detailModel.review)%"
                break
                
            case .finish:
                reviewLabel.text = "学习成绩"
                noReviewLabel.isHidden = true
                reviewStarsView.isHidden = false
                reviewProgressView.isHidden = true
                reviewProgressLabel.isHidden = true
                
                if _detailModel.review == 1 {
                    reviewStart1.image = #imageLiteral(resourceName: "star_new_enable")
                } else if _detailModel.review == 2 {
                    reviewStart1.image = #imageLiteral(resourceName: "star_new_enable")
                    reviewStart2.image = #imageLiteral(resourceName: "star_new_enable")
                    
                } else if _detailModel.review == 3 {
                    reviewStart1.image = #imageLiteral(resourceName: "star_new_enable")
                    reviewStart2.image = #imageLiteral(resourceName: "star_new_enable")
                    reviewStart3.image = #imageLiteral(resourceName: "star_new_enable")
                }
                
                reportButton.setTitle("学习报告", for: .normal)
                reportButton.setTitleColor(.black, for: .normal)
                reportButton.isEnabled = true
                
                break
            }
        }
    }
    
    init() {
        super.init(frame: .zero)
        initializationFromNib()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        initializationFromNib()
    }
    
    private func initializationFromNib() {
        Bundle.main.loadNibNamed("YXReviewPlanHeaderView", owner: self, options: nil)
        addSubview(contentView)
        contentView.frame = self.bounds
        
        listenProgressView.progressImage = listenProgressView.progressImage?.resizableImage(withCapInsets: UIEdgeInsets(top: 0, left: 4, bottom: 0, right: 4))
        reviewProgressView.progressImage = reviewProgressView.progressImage?.resizableImage(withCapInsets: UIEdgeInsets(top: 0, left: 4, bottom: 0, right: 4))
    }
    
    @IBAction func tapNewIcon(_ sender: UIButton) {
        newIconButton.isHidden = true
        statusClosure?()
    }
    
    @IBAction func tapReport(_ sender: UIButton) {
        reportClosure?()
    }
    
    @IBAction func tapShare(_ sender: UIButton) {
        shareClosure?()
    }
    
}
