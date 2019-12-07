//
//  BPItemContentView.swift
//  BPSegmentController
//
//  Created by 沙庭宇 on 2019/12/4.
//  Copyright © 2019 沙庭宇. All rights reserved.
//

import UIKit

class BPItemContentView: UICollectionViewCell {

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = self.shouldRandomColor()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func bindData(_ title: String) {
        self.contentView.backgroundColor = UIColor.orange
    }

    func shouldRandomColor() -> UIColor {
        let red   = CGFloat.random(in: 0..<1)
        let green = CGFloat.random(in: 0..<1)
        let blue  = CGFloat.random(in: 0..<1)
        let color = UIColor(red: red, green: green, blue: blue, alpha: 1.0)
        return color
    }
}
