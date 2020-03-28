//
//  YXEditReviewPlanView.swift
//  YXEDU
//
//  Created by Jake To on 3/28/20.
//  Copyright © 2020 shiji. All rights reserved.
//

import UIKit

class YXEditReviewPlanView: UIView {

    var editClosure: (() -> Void)?
    var deleteClosure: (() -> Void)?
    
    @IBOutlet var contentView: UIView!
    @IBOutlet weak var topOffSet: NSLayoutConstraint!
    
    init() {
        super.init(frame: CGRect(x: 0, y: 0, width: screenWidth, height: screenHeight))
        initializationFromNib()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        initializationFromNib()
    }
    
    private func initializationFromNib() {
        Bundle.main.loadNibNamed("YXEditReviewPlanView", owner: self, options: nil)
        addSubview(contentView)
        contentView.frame = self.bounds
        contentView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(dismiss)))
        
        topOffSet.constant = kNavHeight
    }
    
    @objc
    private func dismiss() {
        self.removeFromSuperview()
    }
    
    @IBAction func editReviewPlan(_ sender: Any) {
        editClosure?()
        self.removeFromSuperview()
    }
    
    @IBAction func deleteReviewPlan(_ sender: Any) {
        deleteClosure?()
        self.removeFromSuperview()
    }
}
