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
                expandStateIcon.isHidden = false
                
            } else {
                expandButton.isHidden = true
                expandStateIcon.isHidden = true
            }
        }
    }
    
    var isExpand = false {
        didSet {
            if isExpand {
                expandButton.setTitle("收起", for: .normal)
                expandStateIcon.image = #imageLiteral(resourceName: "collapsedState")
                
            } else {
                expandButton.setTitle("展开", for: .normal)
                expandStateIcon.image = #imageLiteral(resourceName: "expandState")
            }
        }
    }
    
    var expandClosure: (() -> Void)?
    
    @IBOutlet var contentView: UIView!
    @IBOutlet weak var expandButton: UIButton!
    @IBOutlet weak var expandStateIcon: UIImageView!

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
