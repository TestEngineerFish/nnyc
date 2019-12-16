//
//  BPItemView.swift
//  BPSegmentController
//
//  Created by 沙庭宇 on 2019/12/4.
//  Copyright © 2019 沙庭宇. All rights reserved.
//

import UIKit

protocol BPItemProtocol: NSObjectProtocol {
    /// 切入动画
    /// - Parameter progress: 切入进度
    func switchIn(progress: Float)
    /// 切出动画
    /// - Parameter progress: 切出进度
    func switchOut(progress: Float)
}

class BPItemHeaderView: UICollectionViewCell {
    var backgroundLayer = CALayer()
    var lineLayer       = CAShapeLayer()

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.createSubviews()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func createSubviews() {
//        self.contentView.layer.addSublayer(backgroundLayer)
        self.contentView.layer.addSublayer(lineLayer)

        backgroundLayer.frame = self.bounds
        backgroundLayer.backgroundColor = UIColor.gray.cgColor

        let lineHeight = CGFloat(5)
        lineLayer.frame = CGRect(x: 0, y: self.frame.height - lineHeight, width: CGFloat.zero, height: lineHeight)
        lineLayer.backgroundColor = UIColor.orange1.cgColor
        lineLayer.cornerRadius = lineHeight / 2
    }

    override var isSelected: Bool {
        didSet {
            if isSelected {
                self.backgroundLayer.opacity = 1.0
                self.lineLayer.width = self.width
            } else {
                self.backgroundLayer.opacity = 0.0
                self.lineLayer.width = CGFloat.zero
            }
        }
    }


    // TODO: ==== BPItemProtocol ====

    func switchIn(progress: CGFloat, direction: SwitchDirectionType) {
        self.lineLayer.opacity       = 1.0
        self.backgroundLayer.opacity = Float(progress)
        if direction == .left {
            self.lineLayer.left  = 0
            self.lineLayer.width = self.width * progress
        } else {
            self.lineLayer.left  = self.width - self.width * progress
            self.lineLayer.width = self.width * progress
        }
    }

    func switchOut(progress: CGFloat, direction: SwitchDirectionType) {
        self.lineLayer.opacity       = 1.0
        self.backgroundLayer.opacity = 1 - Float(progress)
        if direction == .left {
            self.lineLayer.left  = self.width * progress
            self.lineLayer.width = self.width - self.width * progress
        } else {
            self.lineLayer.left  = 0
            self.lineLayer.width = self.width - self.width * progress
        }
    }
}

enum SwitchDirectionType {
    case left
    case right
    case up
    case down
}
