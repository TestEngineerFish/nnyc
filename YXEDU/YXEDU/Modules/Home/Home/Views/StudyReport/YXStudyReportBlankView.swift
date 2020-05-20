//
//  YXStudyReportBlankView.swift
//  YXEDU
//
//  Created by Jake To on 4/23/20.
//  Copyright © 2020 shiji. All rights reserved.
//

import UIKit

class YXStudyReportBlankView: UIView {
    
    @IBOutlet var contentView: UIView!
    
    var tapButtonClosure: (() -> Void)?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        initializationFromNib()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        initializationFromNib()
    }
    
    private func initializationFromNib() {
        Bundle.main.loadNibNamed("YXStudyReportBlankView", owner: self, options: nil)
        addSubview(contentView)
        contentView.frame = self.bounds
    }
    
    @IBAction func tapButton(_ sender: Any) {
        tapButtonClosure?()
    }
}
