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

    var cusContentView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.hex(0xF2F2F2)
        return view
    }()
    var unitNameLabel: UILabel = {
        let label = UILabel()
        label.textColor     = UIColor.black2
        label.font          = UIFont.pfSCRegularFont(withSize: AdaptFontSize(12))
        label.textAlignment = .left
        return label
    }()
    var checkAllButton: UIButton = {
        let button = UIButton()
        button.setTitle("全选", for: .normal)
        button.setTitleColor(UIColor.orange1, for: .normal)
        button.contentHorizontalAlignment = .right
        button.titleLabel?.font = UIFont.pfSCRegularFont(withSize: AdaptFontSize(13))
        return button
    }()
    var arrowImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "unit_arrow")
        return imageView
    }()
    var bottomView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.white
        return view
    }()

    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        self.isUserInteractionEnabled    = true
        self.setSubviews()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func bindData(_ model: YXReviewUnitModel? = nil) {
        // 支持无数据刷新操作
        if let _model = model {
            self.model = _model
        }
        guard let model = self.model else {
            return
        }

        if model.isOpenUp {
            UIView.animate(withDuration: 0.25) { [weak self] in
                self?.arrowImageView.transform = CGAffineTransform(rotationAngle: .pi)
            }
        } else {
            UIView.animate(withDuration: 0.25) { [weak self] in
                self?.arrowImageView.transform = .identity
            }
        }
        var selectedNum = 0
        model.list.forEach { (wordModel) in
            if wordModel.isSelected {
                selectedNum += 1
            }
        }
        let checkAllText   = model.isSelectedAll ? "取消全选" : "全选"
        let numberColor    = selectedNum > 0 ? UIColor.orange1 : UIColor.black6
        let statisticsText = String(format: "%@(%d/%d词)", model.name, selectedNum, model.wordsNumber)

        let attrStr = NSMutableAttributedString(string: statisticsText, attributes: [NSAttributedString.Key.font : UIFont.regularFont(ofSize: AdaptFontSize(12)), NSAttributedString.Key.foregroundColor : UIColor.black2])
        attrStr.addAttributes([NSAttributedString.Key.foregroundColor : numberColor], range: NSRange(location: model.name.count + 1, length: "\(selectedNum)".count))

        self.unitNameLabel.attributedText = attrStr
        self.checkAllButton.isHidden      = !model.isOpenUp
        self.checkAllButton.setTitle(checkAllText, for: .normal)
    }

    private func setSubviews() {
        self.contentView.addSubview(cusContentView)
        self.contentView.addSubview(bottomView)
        cusContentView.addSubview(unitNameLabel)
        cusContentView.addSubview(checkAllButton)
        cusContentView.addSubview(arrowImageView)

        self.cusContentView.snp.remakeConstraints { (make) in
            make.left.top.right.equalToSuperview()
            make.bottom.equalTo(bottomView.snp.top)
        }
        self.bottomView.snp.makeConstraints { (make) in
            make.left.right.bottom.equalToSuperview()
            make.height.equalToSuperview().multipliedBy(0.125)
        }
        self.unitNameLabel.snp.makeConstraints { (make) in
            make.left.equalToSuperview().offset(AdaptSize(22))
            make.centerY.equalToSuperview()
            make.height.equalToSuperview()
            make.right.lessThanOrEqualTo(self.checkAllButton.snp.left).offset(AdaptSize(-5)).priorityLow()
        }
        self.arrowImageView.snp.makeConstraints { (make) in
            make.right.equalToSuperview().offset(AdaptIconSize(-18))
            make.centerY.equalToSuperview()
            make.size.equalTo(CGSize(width: AdaptIconSize(18), height: AdaptIconSize(18)))
        }
        self.checkAllButton.snp.makeConstraints { (make) in
            make.right.equalTo(self.arrowImageView.snp.left).offset(AdaptSize(-21))
            make.centerY.equalToSuperview()
            make.size.equalTo(CGSize(width: AdaptSize(60), height: AdaptSize(18)))
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
        if unitModel.isSelectedAll {
            self.delegate?.uncheckAll(unitModel, section: self.tag)
            button.setTitle("全选", for: .normal)
        } else {
            self.delegate?.checkAll(unitModel, section: self.tag)
            button.setTitle("取消全选", for: .normal)
        }
    }

    @objc private func clickView(_ tap: UITapGestureRecognizer) {
        self.delegate?.clickHeaderView(self.tag)
    }
}
