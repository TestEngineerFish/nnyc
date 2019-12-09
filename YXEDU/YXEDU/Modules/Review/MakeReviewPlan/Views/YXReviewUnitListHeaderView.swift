//
//  YXReviewUnitListHeaderView.swift
//  YXEDU
//
//  Created by 沙庭宇 on 2019/12/7.
//  Copyright © 2019 shiji. All rights reserved.
//

import UIKit

class YXReviewUnitListHeaderView: UITableViewHeaderFooterView {

    var unitNameLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor.black2
        label.font      = UIFont.pfSCRegularFont(withSize: AdaptSize(12))
        return label
    }()
    var statisticsLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor.black2
        label.font      = UIFont.pfSCRegularFont(withSize: AdaptSize(12))
        return label
    }()
    var arrowButton: YXButton = {
        let button = YXButton()
        button.setImage(UIImage(named: "unit_arrow"), for: .normal)
        return button
    }()

    var model: YXReviewUnitModel?
    // ---- 点击回调
    var clickBlock: ((Bool) -> Void)?

    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        self.backgroundColor = UIColor.hex(0xF2F2F2)
        self.setSubviews()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func bindData(_ model: YXReviewUnitModel) {
        self.model = model
        self.unitNameLabel.text = model.name
        let selectedNum = "\(model.selectedWords.count)"
        let statisticsText = String(format: "（%@/%d词）", selectedNum, model.list.count)
        let attrStr = NSMutableAttributedString(string: statisticsText, attributes: [NSAttributedString.Key.font : UIFont.regularFont(ofSize: AdaptSize(12)), NSAttributedString.Key.foregroundColor : UIColor.black2])
        attrStr.addAttributes([NSAttributedString.Key.foregroundColor : UIColor.orange1], range: NSRange(location: 1, length: selectedNum.count))
        self.statisticsLabel.attributedText = attrStr
        self.setNeedsLayout()
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        guard let model = self.model else {
            return
        }
        let unitWidth = model.name.textWidth(font: self.unitNameLabel.font, height: self.height)
        self.unitNameLabel.snp.updateConstraints { (make) in
            make.width.equalTo(unitWidth)
        }
    }

    private func setSubviews() {
        self.addSubview(unitNameLabel)
        self.addSubview(statisticsLabel)
        self.addSubview(arrowButton)

        self.unitNameLabel.snp.makeConstraints { (make) in
            make.left.equalTo(AdaptSize(22))
            make.centerY.equalToSuperview()
            make.width.equalTo(CGFloat.zero)
        }
        self.arrowButton.snp.makeConstraints { (make) in
            make.right.equalToSuperview().offset(AdaptSize(-18))
            make.centerY.equalToSuperview()
            make.size.equalTo(CGSize(width: AdaptSize(18), height: AdaptSize(18)))
        }
        self.statisticsLabel.snp.makeConstraints { (make) in
            make.left.equalTo(self.unitNameLabel.snp.right)
            make.centerY.equalToSuperview()
            make.right.equalTo(self.arrowButton.snp.left)
        }
    }
}
