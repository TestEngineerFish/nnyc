//
//  YXWordListOrderView.swift
//  YXEDU
//
//  Created by Jake To on 12/9/19.
//  Copyright © 2019 shiji. All rights reserved.
//

import UIKit

enum YXWordListOrderType {
    case `default`
    case az
    case za
}

class YXWordListOrderView: UIView {
    var orderClosure: ((_ orderType: YXWordListOrderType) -> Void)?
    
    private var orderType: YXWordListOrderType = .default
    
    @IBOutlet var contentView: YXDesignableView!
    @IBOutlet weak var defaultButton: UIButton!
    @IBOutlet weak var azButton: UIButton!
    @IBOutlet weak var zaButton: UIButton!

    init(frame: CGRect, orderType: YXWordListOrderType) {
        super.init(frame: frame)
        self.orderType = orderType
        
        initializationFromNib()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        initializationFromNib()
    }
    
    func initializationFromNib() {
        Bundle.main.loadNibNamed("YXWordListOrderView", owner: self, options: nil)
        addSubview(contentView)
        contentView.frame = self.bounds
        
        switch orderType {
        case .default:
            defaultButton.setTitleColor(.orange1, for: .normal)
            azButton.setTitleColor(.black, for: .normal)
            zaButton.setTitleColor(.black, for: .normal)
            break

        case .az:
            defaultButton.setTitleColor(.black, for: .normal)
            azButton.setTitleColor(.orange1, for: .normal)
            zaButton.setTitleColor(.black, for: .normal)
            break

        case .za:
            defaultButton.setTitleColor(.black, for: .normal)
            azButton.setTitleColor(.black, for: .normal)
            zaButton.setTitleColor(.orange1, for: .normal)
            break

        default:
            break
        }
    }
    
    @IBAction func tapDefault(_ sender: Any) {
        orderClosure?(YXWordListOrderType.default)
    }
    
    @IBAction func tapAZ(_ sender: Any) {
        orderClosure?(YXWordListOrderType.az)
    }
    
    @IBAction func tapZA(_ sender: Any) {
        orderClosure?(YXWordListOrderType.za)
    }
}
