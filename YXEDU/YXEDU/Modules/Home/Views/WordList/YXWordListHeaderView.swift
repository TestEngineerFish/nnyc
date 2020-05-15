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
    var deleteAllWordsClosure: (() -> Void)?
    var expandClosure: ((_: Bool) -> Void)?
    var isExpand = false {
        didSet {
            if isExpand {
                expandButton.setImage(#imageLiteral(resourceName: "expandState"), for: .normal)
            } else {
                expandButton.setImage(#imageLiteral(resourceName: "collapsedState"), for: .normal)
            }
        }
    }
    
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var editButton: UIButton!
    @IBOutlet weak var deleteButton: UIButton!
    @IBOutlet weak var expandButton: UIButton!
    
    init() {
        super.init(frame: CGRect(x: 0, y: 0, width: screenWidth, height: 30))
        initializationFromNib()
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
    
    @IBAction func deleteAll(_ sender: Any) {
        deleteAllWordsClosure?()
    }
    
    @IBAction func expand(_ sender: Any) {
        expandClosure?(isExpand)
    }
}
