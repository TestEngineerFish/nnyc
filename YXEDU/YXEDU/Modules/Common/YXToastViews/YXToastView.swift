//
//  YXToastView.swift
//  YXEDU
//
//  Created by 沙庭宇 on 2020/1/13.
//  Copyright © 2020 shiji. All rights reserved.
//

import UIKit

class YXToastView: UIView {

    static let share = YXToastView()

    var backgroundView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.black.withAlphaComponent(0.7)
        return view
    }()
    var coinImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "alertCoin")
        return imageView
    }()
    var textBackgroundView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.black1
        return view
    }()
    var descriptionLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        return label
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.bindProperty()
        self.createSubviews()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func bindProperty() {
//        let tap = UITapGestureRecognizer(target: self, action: #selector(hideView))
//        self.backgroundView.addGestureRecognizer(tap)
    }

    private func createSubviews() {
        self.addSubview(backgroundView)
        self.addSubview(coinImageView)
        self.addSubview(textBackgroundView)
        textBackgroundView.addSubview(descriptionLabel)

        backgroundView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        coinImageView.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.centerY.equalToSuperview().offset(AdaptSize(-40))
            make.size.equalTo(CGSize(width: AdaptSize(239), height: AdaptSize(147)))
        }
        textBackgroundView.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.top.equalTo(coinImageView.snp.bottom).offset(AdaptSize(25))
            make.height.equalTo(AdaptSize(34))
            make.width.equalTo(0)
        }
        textBackgroundView.layer.cornerRadius = AdaptSize(17)
        descriptionLabel.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
    }

    private func bindData(_ coinAmount: Int) {
        let text = "获得 \(coinAmount) 个松果币"
        let mAttr = NSMutableAttributedString(string: text, attributes: [NSAttributedString.Key.foregroundColor : UIColor.white, NSAttributedString.Key.font : UIFont.regularFont(ofSize: AdaptSize(15))])
        mAttr.addAttributes([NSAttributedString.Key.foregroundColor : UIColor.orange1, NSAttributedString.Key.font : UIFont.mediumFont(ofSize: AdaptSize(22))], range: NSRange(location: 3, length: "\(coinAmount)".count))
        self.descriptionLabel.attributedText = mAttr
        self.descriptionLabel.sizeToFit()
        self.textBackgroundView.snp.updateConstraints { (make) in
            make.width.equalTo(descriptionLabel.width + AdaptSize(20))
        }
    }

    func showCoinView(_ coinAmount: Int) {
        self.bindData(coinAmount)
        kWindow.addSubview(self)
        self.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) { [weak self] in
            self?.hideView()
        }
    }

    @objc func hideView() {
        self.removeFromSuperview()
    }
}
