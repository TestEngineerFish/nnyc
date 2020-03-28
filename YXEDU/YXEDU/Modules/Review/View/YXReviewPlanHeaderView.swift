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
    
    @IBOutlet weak var noListenLabel: UILabel!
    @IBOutlet weak var listenStarsView: UIStackView!
    @IBOutlet weak var listenStart1: UIImageView!
    @IBOutlet weak var listenStart2: UIImageView!
    @IBOutlet weak var listenStart3: UIImageView!
    @IBOutlet weak var listenProgressView: UIProgressView!
    @IBOutlet weak var listenProgressLabel: UILabel!

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
    
    var detailModel: YXReviewPlanDetailModel! {
        didSet {
            if let totalCount = detailModel.status?.totalCount, totalCount > 0 {
                statusViewHeight.constant = 36
                statusLabel.text = "\(totalCount)位用户保存了该词单，\(detailModel.status?.finishCount ?? 0)人完成了学习"
                
                if detailModel.status?.isShowNewIcon == 1{
                    newIconButton.isHidden = false
                    
                } else {
                    newIconButton.isHidden = true
                }
                
            } else {
                statusViewHeight.constant = 0
                
                switch detailModel.listenState {
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
                    break
                    
                case .finish:
                    noListenLabel.isHidden = true
                    listenStarsView.isHidden = false
                    listenProgressView.isHidden = true
                    listenProgressLabel.isHidden = true
                    break
                }
                
                switch detailModel.reviewState {
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
                    break
                    
                case .finish:
                    noReviewLabel.isHidden = true
                    reviewStarsView.isHidden = false
                    reviewProgressView.isHidden = true
                    reviewProgressLabel.isHidden = true
                    break
                }
                
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
    }

    @IBAction func tapNewIcon(_ sender: UIButton) {
        statusClosure?()
    }
    
    @IBAction func tapReport(_ sender: UIButton) {
        reportClosure?()
    }
    
    @IBAction func tapShare(_ sender: UIButton) {
        shareClosure?()
    }

}
