//
//  YXWordDetailHeaderView.swift
//  YXEDU
//
//  Created by Jake To on 11/11/19.
//  Copyright © 2019 shiji. All rights reserved.
//

import UIKit

class YXWordDetailFeaturedSectionFooterView: UIView {
    var shouldShowExpand = false {
        didSet {
            if shouldShowExpand {
                expandButton.isHidden = false
                expandstateIcon.isHidden = false
                
            } else {
                expandButton.isHidden = true
                expandstateIcon.isHidden = true
            }
        }
    }
    
    var isExpand = false {
        didSet {
            if isExpand {
                
            } else {
                
            }
        }
    }
    
    var expandClosure: (() -> Void)?
    
    @IBOutlet var contentView: UIView!
    @IBOutlet weak var expandButton: UIButton!
    @IBOutlet weak var expandstateIcon: UIImageView!

    init() {
        super.init(frame: CGRect(x: 0, y: 0, width: screenWidth, height: 16))
        initializationFromNib()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        initializationFromNib()
    }
    
    private func initializationFromNib() {
        Bundle.main.loadNibNamed("YXWordDetailFeaturedSectionFooterView", owner: self, options: nil)
        addSubview(contentView)
        contentView.frame = self.frame
    }
    
    @IBAction func expand(_ sender: Any) {
        expandClosure?()
    }
}
