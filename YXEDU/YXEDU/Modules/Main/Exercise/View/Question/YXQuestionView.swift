//
//  QuestionView.swift
//  YXEDU
//
//  Created by 沙庭宇 on 2019/10/24.
//  Copyright © 2019 shiji. All rights reserved.
//

import UIKit

protocol YXQuestionEventProtocol {
//    @objc func clickSpellView()
}

class YXQuestionView: UIView {
    var contentView  = UIView()
    var contentViewH = CGFloat(0)
    var margin       = CGFloat(5)
    let marginTop    = CGFloat(54)
    let marginBottom = CGFloat(54)

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.createUI()
    }

    required init?(coder: NSCoder) {
        print("???")
        fatalError("init(coder:) has not been implemented")
    }

    private func createUI() {
        self.backgroundColor = UIColor.white
        addSubview(contentView)
        contentView.snp.makeConstraints { (make) in
            make.center.equalToSuperview()
            make.width.equalToSuperview().offset(-10)
            make.height.equalTo(contentViewH)
        }
        self.layer.setDefaultShadow()
    }

    /// 动态添加自定自定义的view,添加后记得更新约束
    /// - returns: 返回最终内容高度
    func addCustomViews(_ subviews: [UIView]) -> CGFloat {
        for subview in subviews {
            self.contentView.addSubview(subview)
            let subviewH = subview.bounds.height
            let subviewW = subview.bounds.width
            subview.snp.makeConstraints { (make) in
                make.top.equalTo(contentViewH)
                make.centerX.equalToSuperview()
                make.width.equalTo(subviewW)
                make.height.equalTo(subviewH)
            }
            contentViewH += subviewH + margin
        }
        let maxHeight = contentViewH - margin
        contentView.snp.updateConstraints { (make) in
            make.height.equalTo(maxHeight)
        }
        return maxHeight + marginTop + marginBottom
    }

    private func bindProperty() {
        //  设置阴影
    }
}
