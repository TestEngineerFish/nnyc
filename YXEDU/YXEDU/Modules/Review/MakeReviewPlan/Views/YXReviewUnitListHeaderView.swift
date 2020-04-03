//
//  YXReviewUnitListHeaderView.swift
//  YXEDU
//
//  Created by 沙庭宇 on 2019/12/7.
//  Copyright © 2019 shiji. All rights reserved.
//

import UIKit

protocol YXReviewUnitListHeaderProtocol: NSObjectProtocol {
    func checkAll(_ unitModel: YXReviewUnitModel, section: Int)
    func uncheckAll(_ unitModel: YXReviewUnitModel, section: Int)
    func clickHeaderView(_ section: Int)
}

class YXReviewUnitListHeaderView: UITableViewHeaderFooterView {

    var model: YXReviewUnitModel?
    weak var delegate: YXReviewUnitListHeaderProtocol?

    var unitNameLabel: UILabel = {
        let label = UILabel()
        label.textColor     = UIColor.black2
        label.font          = UIFont.pfSCRegularFont(withSize: AdaptSize(12))
        label.textAlignment = .left
        return label
    }()
    var statisticsLabel: UILabel = {
        let label = UILabel()
        label.textColor     = UIColor.black2
        label.font          = UIFont.pfSCRegularFont(withSize: AdaptSize(12))
        label.textAlignment = .left
        return label
    }()
    var checkAllButton: UIButton = {
        let button = UIButton()
        button.setTitle("全选", for: .normal)
        button.setTitleColor(UIColor.orange1, for: .normal)
        button.contentHorizontalAlignment = .right
        button.titleLabel?.font = UIFont.pfSCRegularFont(withSize: AdaptSize(13))
        return button
    }()
    var arrowButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "unit_arrow"), for: .normal)
        return button
    }()
    var bottomView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.white
        return view
    }()

    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        self.contentView.backgroundColor = UIColor.hex(0xF2F2F2)
        self.isUserInteractionEnabled = true
        self.setSubviews()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func bindData(_ model: YXReviewUnitModel) {
        self.model              = model
        self.unitNameLabel.text = model.name
//        var unitWidth = model.name.textWidth(font: self.unitNameLabel.font, height: self.height)
//        unitWidth = unitWidth > ( self.unitNameLabel.frame.minY)
//        self.unitNameLabel.snp.updateConstraints { (make) in
//            make.width.equalTo(unitWidth)
//        }
//        self.setNeedsLayout()
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        guard let model = self.model else {
            return
        }
        var selectedNum = 0
        model.list.forEach { (wordModel) in
            if wordModel.isSelected {
                selectedNum += 1
            }
        }
        let numberColor = selectedNum > 0 ? UIColor.orange1 : UIColor.black6
        let statisticsText = String(format: "(%d/%d词)", selectedNum, model.list.count)
        let attrStr = NSMutableAttributedString(string: statisticsText, attributes: [NSAttributedString.Key.font : UIFont.regularFont(ofSize: AdaptSize(12)), NSAttributedString.Key.foregroundColor : UIColor.black2])
        attrStr.addAttributes([NSAttributedString.Key.foregroundColor : numberColor], range: NSRange(location: 1, length: "\(selectedNum)".count))
        self.statisticsLabel.attributedText = attrStr
        let checkAllText = model.isCheckAll ? "取消全选" : "全选"
        self.checkAllButton.setTitle(checkAllText, for: .normal)
        self.checkAllButton.isHidden = !model.isOpenUp
    }

    private func setSubviews() {
        self.contentView.addSubview(unitNameLabel)
        self.contentView.addSubview(statisticsLabel)
        self.contentView.addSubview(checkAllButton)
        self.contentView.addSubview(arrowButton)
        self.addSubview(bottomView)

        self.contentView.snp.remakeConstraints { (make) in
            make.left.top.right.equalToSuperview()
            make.bottom.equalTo(bottomView.snp.top).priorityHigh()
        }
        self.bottomView.snp.makeConstraints { (make) in
            make.left.right.bottom.equalToSuperview()
            make.height.equalTo(AdaptSize(5))
        }
        self.unitNameLabel.snp.makeConstraints { (make) in
            make.left.equalTo(AdaptSize(22))
            make.centerY.height.equalToSuperview()
            make.right.equalTo(self.statisticsLabel.snp.left)
        }

        self.arrowButton.snp.makeConstraints { (make) in
            make.right.equalToSuperview().offset(AdaptSize(-18))
            make.centerY.equalToSuperview()
            make.size.equalTo(CGSize(width: AdaptSize(18), height: AdaptSize(18)))
        }

        self.checkAllButton.snp.makeConstraints { (make) in
            make.right.equalTo(self.arrowButton.snp.left).offset(AdaptSize(-21))
            make.centerY.equalToSuperview()
            make.size.equalTo(CGSize(width: AdaptSize(60), height: AdaptSize(18)))
        }

        self.statisticsLabel.snp.makeConstraints { (make) in
            make.centerY.height.equalToSuperview()
            make.right.lessThanOrEqualTo(self.checkAllButton.snp.left).offset(AdaptSize(-5))
            make.width.greaterThanOrEqualTo(AdaptSize(55)).priorityHigh()
        }

        self.checkAllButton.addTarget(self, action: #selector(clickCheckAllBtn(_:)), for: .touchUpInside)
        let tap = UITapGestureRecognizer(target: self, action: #selector(clickView(_:)))
        self.addGestureRecognizer(tap)
    }

    // MARK: ==== Event ====

    @objc private func clickCheckAllBtn(_ button: UIButton) {
        guard let unitModel = self.model else {
            return
        }
        if unitModel.isCheckAll {
            self.delegate?.uncheckAll(unitModel, section: self.tag)
            button.setTitle("全选", for: .normal)
        } else {
            self.delegate?.checkAll(unitModel, section: self.tag)
            button.setTitle("取消全选", for: .normal)
        }
    }

    @objc private func clickView(_ tap: UITapGestureRecognizer) {
        guard let view = tap.view as? YXReviewUnitListHeaderView, let unitModel = view.model else {
            return
        }
        unitModel.isOpenUp = !unitModel.isOpenUp
        if unitModel.isOpenUp {
            view.arrowButton.transform = CGAffineTransform(rotationAngle: .pi)
        } else {
            view.arrowButton.transform = .identity
        }
        self.delegate?.clickHeaderView(self.tag)
    }
}
