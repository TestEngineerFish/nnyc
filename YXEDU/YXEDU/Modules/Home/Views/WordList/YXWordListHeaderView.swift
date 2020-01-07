//
//  YXWordListHeaderView.swift
//  YXEDU
//
//  Created by Jake To on 12/9/19.
//  Copyright © 2019 shiji. All rights reserved.
//

import UIKit

class YXWordListHeaderView: UIView {
    var editClosure: (() -> Void)?

    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var editButton: UIButton!
    
    init() {
        super.init(frame: CGRect(x: 0, y: 0, width: screenWidth, height: 30))
        initializationFromNib()
    }
    
    deinit {
        print("ccc")
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        initializationFromNib()
    }
    
    func initializationFromNib() {
        Bundle.main.loadNibNamed("YXWordListHeaderView", owner: self, options: nil)
        addSubview(contentView)
        contentView.frame = self.bounds
    }
    
    @IBAction func edit(_ sender: Any) {
        editClosure?()
    }
}
