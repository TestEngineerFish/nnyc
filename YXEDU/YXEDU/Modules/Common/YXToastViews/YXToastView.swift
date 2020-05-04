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
    // ---- Coin ----
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
    // ---- Loading ----
    let activityView = UIActivityIndicatorView()
    var activityLabel: UILabel = {
        let label = UILabel()
        label.textColor     = UIColor.white
        label.font          = UIFont.regularFont(ofSize: AdaptFontSize(14))
        label.textAlignment = .center
        return label
    }()

    private func createCoinViews() {
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

    private func createLoadView() {
        self.addSubview(backgroundView)
        self.addSubview(activityView)
        self.addSubview(activityLabel)

        backgroundView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        activityView.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.centerY.equalToSuperview().offset(AdaptSize(-20))
            make.size.equalTo(CGSize(width: AdaptSize(65), height: AdaptSize(65)))
        }
        activityLabel.sizeToFit()
        activityLabel.snp.makeConstraints { (make) in
            make.top.equalTo(activityView.snp.bottom)
            make.centerX.equalToSuperview()
            make.size.equalTo(activityLabel.size)
        }
        self.activityView.startAnimating()
    }

    private func bindData(_ coinAmount: Int) {
        let text = "获得 \(coinAmount) 个松果币"
        let mAttr = NSMutableAttributedString(string: text, attributes: [NSAttributedString.Key.foregroundColor : UIColor.white, NSAttributedString.Key.font : UIFont.regularFont(ofSize: AdaptFontSize(15))])
        mAttr.addAttributes([NSAttributedString.Key.foregroundColor : UIColor.orange1, NSAttributedString.Key.font : UIFont.mediumFont(ofSize: AdaptFontSize(22))], range: NSRange(location: 3, length: "\(coinAmount)".count))
        self.descriptionLabel.attributedText = mAttr
        self.descriptionLabel.sizeToFit()
        self.textBackgroundView.snp.updateConstraints { (make) in
            make.width.equalTo(descriptionLabel.width + AdaptSize(20))
        }
    }

    func showCoinView(_ coinAmount: Int) {
        self.createCoinViews()
        self.bindData(coinAmount)
        kWindow.addSubview(self)
        self.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) { [weak self] in
            self?.hideView()
        }
    }

    func showLoadView(_ text: String) {
        self.activityLabel.text = text
        self.createLoadView()
        kWindow.addSubview(self)
        self.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
    }

    @objc func hideView() {
        self.removeFromSuperview()
    }
}
