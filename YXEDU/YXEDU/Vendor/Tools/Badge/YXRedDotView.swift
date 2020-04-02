//
//  YXRedDotView.swift
//  YXEDU
//
//  Created by 沙庭宇 on 2020/2/22.
//  Copyright © 2020 shiji. All rights reserved.
//

import Foundation

class YXRedDotView: UIView {
    let numLabel: UILabel = {
        let label = UILabel()
        label.text      = "0"
        label.font      = UIFont.regularFont(ofSize: AdaptSize(11))
        label.textColor = UIColor.white
        label.textAlignment = .center
        return label
    }()
    
    init(_ num: Int) {
        super.init(frame: CGRect(x: 0, y: 0, width: AdaptSize(15), height: AdaptSize(15)))
        self.isHidden = true
        self.createSubviews()
        self.updateBadge(num)
    }
    
    init() {
        super.init(frame: CGRect(x: 0, y: 0, width: AdaptSize(5), height: AdaptSize(5)))
        self.createSubviews(false)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func createSubviews(_ showNum: Bool = true) {
        self.backgroundColor     = UIColor.hex(0xFF532B)
        self.layer.cornerRadius  = AdaptSize(self.height/2)
        self.layer.masksToBounds = true
        if showNum {
            self.addSubview(self.numLabel)
            self.numLabel.snp.makeConstraints { (make) in
                make.edges.equalToSuperview()
            }
        }
    }
    
    private func updateBadge(_ num: Int) {
        let numStr = num > 9 ? "9+" : "\(num)"
        self.numLabel.text = numStr
        self.isHidden = num == 0
    }
    
    
}
