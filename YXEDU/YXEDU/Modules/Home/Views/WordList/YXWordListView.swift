//
//  YXWordListView.swift
//  YXEDU
//
//  Created by Jake To on 12/9/19.
//  Copyright © 2019 shiji. All rights reserved.
//

import UIKit

class YXWordListView: UIView {
    var orderClosure: ((_ orderType: YXWordListOrderType) -> Void)?
    var editClosure: (() -> Void)?

    private var orderType: YXWordListOrderType = .default

    @IBOutlet var contentView: UIView!
    @IBOutlet weak var orderButtonDistance: NSLayoutConstraint!
    @IBOutlet weak var wordCountLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    
    @IBAction func order(_ sender: Any) {
        let view = YXWordListOrderView(frame: CGRect(x: 44, y: screenWidth - orderButtonDistance.constant, width: 120, height: 120), orderType: .default)
        view.orderClosure = orderClosure
        
        self.addSubview(view)
    }
    
    @IBAction func edit(_ sender: Any) {
        editClosure?()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        initializationFromNib()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        initializationFromNib()
    }
    
    func initializationFromNib() {
        Bundle.main.loadNibNamed("YXWordListView", owner: self, options: nil)
        addSubview(contentView)
        contentView.frame = self.bounds
    }
}
