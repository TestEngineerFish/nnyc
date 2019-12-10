//
//  YXWordDetailHeaderView.swift
//  YXEDU
//
//  Created by Jake To on 11/11/19.
//  Copyright © 2019 shiji. All rights reserved.
//

import UIKit

class YXWordDetailFeaturedSectionHeaderView: UIView {
    private var headerTitle: String = ""

    @IBOutlet var contentView: UIView!
    @IBOutlet weak var headerLabel: UILabel!
    
    init(headerTitle: String) {
        super.init(frame: CGRect(x: 0, y: 0, width: screenWidth, height: 16))
        self.headerTitle = headerTitle
        
        initializationFromNib()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        initializationFromNib()
    }
    
    private func initializationFromNib() {
        Bundle.main.loadNibNamed("YXWordDetailFeaturedSectionHeaderView", owner: self, options: nil)
        addSubview(contentView)
        contentView.frame = self.frame
        
        headerLabel.text = headerTitle
    }
}
