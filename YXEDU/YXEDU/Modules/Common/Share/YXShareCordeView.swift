//
//  YXShareCordeView.swift
//  YXEDU
//
//  Created by 沙庭宇 on 2019/12/30.
//  Copyright © 2019 shiji. All rights reserved.
//

import UIKit

class YXShareCordeView: UIView {

    static let share = YXShareCordeView()

    var backgroundView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.black.withAlphaComponent(0.7)
        return view
    }()

    var contentView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.white
        view.size = CGSize(width: screenWidth, height: AdaptSize(311) + kSafeBottomMargin)
        view.clipRectCorner(directionList: [.topLeft, .topRight], cornerRadius: AdaptSize(6))
        return view
    }()

    var codeTitleLabel: UILabel = {
        let label = UILabel()
        label.text          = "分享口令："
        label.textColor     = UIColor.black1
        label.font          = UIFont.regularFont(ofSize: AdaptSize(14))
        label.textAlignment = .left
        return label
    }()

    var codeBackgroundView: UIView = {
        let view = UIView()
        view.backgroundColor     = UIColor.hex(0xF5F5F5)
        view.layer.cornerRadius  = AdaptSize(8)
        view.layer.masksToBounds = true
        return view
    }()

    var codeLabel: UILabel = {
        let label = UILabel()
        label.textColor     = UIColor.black2
        label.font          = UIFont.regularFont(ofSize: AdaptSize(13))
        label.textAlignment = .center
        label.numberOfLines = 3
        return label
    }()

    var shareLabel: UILabel = {
        let label = UILabel()
        label.text          = "分享到"
        label.textColor     = UIColor.black3
        label.font          = UIFont.regularFont(ofSize: AdaptSize(12))
        label.textAlignment = .center
        return label
    }()

    var leftLine: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.black4
        return view
    }()

    var rightLine: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.black4
        return view
    }()

    var shareQQButton: YXButton = {
        let button = YXButton()
        button.setImage(UIImage(named: "gameShareQQ"), for: .normal)
        button.isEnabled = true
        return button
    }()

    var shareWechatButton: YXButton = {
        let button = YXButton()
        button.setImage(UIImage(named: "gameShareWechat"), for: .normal)
        button.isEnabled = true
        return button
    }()

    var shareQQLabel: UILabel = {
        let label = UILabel()
        label.text          = "QQ"
        label.textColor     = UIColor.black2
        label.font          = UIFont.regularFont(ofSize: AdaptSize(14))
        label.textAlignment = .center
        return label
    }()

    var shareWechatLabel: UILabel = {
        let label = UILabel()
        label.text          = "微信"
        label.textColor     = UIColor.black2
        label.font          = UIFont.regularFont(ofSize: AdaptSize(14))
        label.textAlignment = .center
        return label
    }()

    var closeButton: YXButton = {
        let button = YXButton()
        button.setImage(UIImage(named: "share_scan_close"), for: .normal)
        return button
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.bindData()
        self.createSubviews()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func bindData() {
        self.closeButton.addTarget(self, action: #selector(hideView), for: .touchUpInside)
        self.shareQQButton.addTarget(self, action: #selector(shareToQQ), for: .touchUpInside)
        self.shareWechatButton.addTarget(self, action: #selector(shareToWechat), for: .touchUpInside)
        let tap = UITapGestureRecognizer(target: self, action: #selector(hideView))
        self.backgroundView.addGestureRecognizer(tap)
    }

    private func createSubviews() {
        self.addSubview(backgroundView)
        self.addSubview(contentView)
        contentView.addSubview(closeButton)
        contentView.addSubview(codeTitleLabel)
        contentView.addSubview(codeBackgroundView)
        codeBackgroundView.addSubview(codeLabel)
        contentView.addSubview(shareLabel)
        contentView.addSubview(leftLine)
        contentView.addSubview(rightLine)
        contentView.addSubview(shareQQButton)
        contentView.addSubview(shareWechatButton)
        contentView.addSubview(shareQQLabel)
        contentView.addSubview(shareWechatLabel)

        backgroundView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        contentView.snp.makeConstraints { (make) in
            make.top.equalTo(self.snp.bottom)
            make.centerX.equalToSuperview()
            make.size.equalTo(contentView.size)
        }
        closeButton.snp.makeConstraints { (make) in
            make.right.equalToSuperview().offset(AdaptSize(-8))
            make.top.equalToSuperview().offset(AdaptSize(8))
            make.size.equalTo(CGSize(width: AdaptSize(22), height: AdaptSize(22)))
        }
        codeBackgroundView.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.top.equalToSuperview().offset(AdaptSize(60))
            make.size.equalTo(CGSize(width: AdaptSize(320), height: AdaptSize(93)))
        }
        codeTitleLabel.snp.makeConstraints { (make) in
            make.left.equalTo(codeBackgroundView)
            make.bottom.equalTo(codeBackgroundView.snp.top).offset(AdaptSize(-8))
            make.size.equalTo(CGSize(width: AdaptSize(94), height: AdaptSize(22)))
        }
        codeLabel.snp.makeConstraints { (make) in
            make.left.equalToSuperview().offset(AdaptSize(18))
            make.right.equalToSuperview().offset(AdaptSize(-18))
            make.top.equalToSuperview().offset(AdaptSize(18))
            make.bottom.equalToSuperview().offset(AdaptSize(-18))
        }
        shareLabel.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.top.equalTo(codeBackgroundView.snp.bottom).offset(AdaptSize(26))
            make.size.equalTo(CGSize(width: AdaptSize(37), height: AdaptSize(17)))
        }
        leftLine.snp.makeConstraints { (make) in
            make.right.equalTo(shareLabel.snp.left).offset(AdaptSize(-25))
            make.centerY.equalTo(shareLabel)
            make.size.equalTo(CGSize(width: AdaptSize(83), height: AdaptSize(1)))
        }
        rightLine.snp.makeConstraints { (make) in
            make.left.equalTo(shareLabel.snp.right).offset(AdaptSize(25))
            make.centerY.equalTo(shareLabel)
            make.size.equalTo(CGSize(width: AdaptSize(83), height: AdaptSize(1)))
        }
        shareQQButton.snp.makeConstraints { (make) in
            make.left.equalToSuperview().offset(AdaptSize(100))
            make.top.equalTo(shareLabel.snp.bottom).offset(AdaptSize(20))
            make.size.equalTo(CGSize(width: AdaptSize(38), height: AdaptSize(38)))
        }
        shareWechatButton.snp.makeConstraints { (make) in
            make.right.equalToSuperview().offset(AdaptSize(-100))
            make.top.equalTo(shareLabel.snp.bottom).offset(AdaptSize(20))
            make.size.equalTo(CGSize(width: AdaptSize(38), height: AdaptSize(38)))
        }
        shareQQLabel.snp.makeConstraints { (make) in
            make.centerX.equalTo(shareQQButton)
            make.top.equalTo(shareQQButton.snp.bottom).offset(AdaptSize(7))
            make.size.equalTo(CGSize(width: AdaptSize(30), height: AdaptSize(20)))
        }
        shareWechatLabel.snp.makeConstraints { (make) in
            make.centerX.equalTo(shareWechatButton)
            make.top.equalTo(shareWechatButton.snp.bottom).offset(AdaptSize(7))
            make.size.equalTo(CGSize(width: AdaptSize(30), height: AdaptSize(20)))
        }

    }

    // MARK: ==== Event ====
    func showView(_ code: String) {
        self.codeLabel.text = code
        kWindow.addSubview(self)
        self.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        self.showAnimation()
    }

    @objc func hideView() {
        self.hideAnimation {
            self.removeFromSuperview()
        }
    }

    // MARK: ==== Animation ====
    private func showAnimation() {
        UIView.animate(withDuration: 0.5) {
            self.contentView.transform = CGAffineTransform(translationX: 0, y: -self.contentView.size.height)
        }
    }

    private func hideAnimation(finished  block:(()->Void)?) {
        UIView.animate(withDuration: 0.5, animations: {
            self.contentView.transform = .identity
        }) { (finish) in
            if finish {
                block?()
            }
        }
    }

    // MARK: ==== Share ====
    @objc private func shareToQQ() {
        QQApiManager.shared()?.shareText(self.codeLabel.text ?? "")
    }

    @objc private func shareToWechat() {
        WXApiManager.shared()?.shareText(self.codeLabel.text ?? "", toPaltform: .wxSession)
    }
}
