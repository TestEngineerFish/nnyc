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
