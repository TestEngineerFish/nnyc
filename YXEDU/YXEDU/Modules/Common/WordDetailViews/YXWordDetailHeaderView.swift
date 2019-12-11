//
//  YXWordDetailHeaderView.swift
//  YXEDU
//
//  Created by Jake To on 11/11/19.
//  Copyright © 2019 shiji. All rights reserved.
//

import UIKit

class YXWordDetailHeaderView: UIView {
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
                expandButton.setTitle("收起", for: .normal)
                expandstateIcon.image = #imageLiteral(resourceName: "collapsedState")

            } else {
                expandButton.setTitle("查看单词变形", for: .normal)
                expandstateIcon.image = #imageLiteral(resourceName: "expandState")
            }
        }
    }
    
    var expandClosure: (() -> Void)?

    private var headerTitle: String = ""

    @IBOutlet var contentView: UIView!
    @IBOutlet weak var headerLabel: UILabel!
    @IBOutlet weak var expandButton: UIButton!
    @IBOutlet weak var expandstateIcon: UIImageView!
    
    init(headerTitle: String) {
        super.init(frame: CGRect(x: 0, y: 0, width: screenWidth, height: 54))
        self.headerTitle = headerTitle
        
        initializationFromNib()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        initializationFromNib()
    }
    
    private func initializationFromNib() {
        Bundle.main.loadNibNamed("YXWordDetailHeaderView", owner: self, options: nil)
        addSubview(contentView)
        contentView.frame = self.bounds
        
        headerLabel.text = headerTitle
    }
    
    @IBAction func expand(_ sender: Any) {
        expandClosure?()
    }
}
