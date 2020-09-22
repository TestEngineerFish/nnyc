//
//  YXNewLearningResultShareView.swift
//  YXEDU
//
//  Created by 沙庭宇 on 2020/9/1.
//  Copyright © 2020 shiji. All rights reserved.
//

import Foundation

protocol YXNewLearningResultShareViewProtocol: NSObjectProtocol {
    func refreshAction(complete block: ((UIImage?)->Void)?)
    func shareFinished(type: YXShareChannel)
}

class YXNewLearningResultShareView: YXView {

    weak var delegate: YXNewLearningResultShareViewProtocol?

    var refreshButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "shareRefresh"), for: .normal)
        return button
    }()
    var closeButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "close_white"), for: .normal)
        return button
    }()
    var shareImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.backgroundColor = .white
        return imageView
    }()
    var leftLineView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.white.withAlphaComponent(0.5)
        return view
    }()
    var rightLineView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.white.withAlphaComponent(0.5)
        return view
    }()
    var shareTitleLabel: UILabel = {
        let label = UILabel()
        label.text          = "分享我的坚持"
        label.textColor     = UIColor.white
        label.font          = UIFont.regularFont(ofSize: AdaptFontSize(13))
        label.textAlignment = .center
        return label
    }()
    var shareChannelView: YXShareDefaultView = {
        let shareView = YXShareDefaultView(type: .white, frame: CGRect.zero)
        shareView.shareType = .image
        return shareView
    }()
    var loadingView = UIActivityIndicatorView(style: .gray)

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.createSubviews()
        self.bindProperty()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func createSubviews() {
        super.createSubviews()
        self.addSubview(refreshButton)
        self.addSubview(closeButton)
        self.addSubview(shareImageView)
        self.addSubview(leftLineView)
        self.addSubview(rightLineView)
        self.addSubview(shareTitleLabel)
        self.addSubview(shareChannelView)
        shareImageView.addSubview(loadingView)
        shareImageView.size = CGSize(width: AdaptSize(295), height: AdaptSize(407))
        shareImageView.snp.makeConstraints { (make) in
            make.centerY.equalToSuperview().offset(AdaptSize(-45))
            make.size.equalTo(shareImageView.size)
            make.centerX.equalToSuperview()
        }
        loadingView.snp.makeConstraints { (make) in
            make.size.equalTo(CGSize(width: AdaptIconSize(45), height: AdaptIconSize(45)))
            make.center.equalToSuperview()
        }
        closeButton.snp.makeConstraints { (make) in
            make.right.equalTo(shareImageView)
            make.bottom.equalTo(shareImageView.snp.top).offset(AdaptSize(-10))
            make.size.equalTo(CGSize(width: AdaptSize(20), height: AdaptSize(20)))
        }
        refreshButton.snp.makeConstraints { (make) in
            make.right.equalTo(closeButton.snp.left).offset(AdaptSize(-20))
            make.bottom.equalTo(shareImageView.snp.top).offset(AdaptSize(-10))
            make.size.equalTo(CGSize(width: AdaptSize(20), height: AdaptSize(20)))
        }
        shareChannelView.snp.makeConstraints { (make) in
            make.left.equalTo(shareImageView).offset(AdaptIconSize(10))
            make.height.equalTo(AdaptIconSize(65))
            make.right.equalTo(shareImageView).offset(AdaptSize(-10))
            make.bottom.equalToSuperview().offset(AdaptSize(-45) - kSafeBottomMargin)
        }
        shareTitleLabel.snp.makeConstraints { (make) in
            make.bottom.equalTo(shareChannelView.snp.top).offset(AdaptSize(-15))
            make.centerX.equalToSuperview()
        }
        leftLineView.snp.makeConstraints { (make) in
            make.centerY.equalTo(shareTitleLabel)
            make.size.equalTo(CGSize(width: AdaptSize(70), height: AdaptSize(0.6)))
            make.right.equalTo(shareTitleLabel.snp.left).offset(AdaptSize(-13))
        }
        rightLineView.snp.makeConstraints { (make) in
            make.size.centerY.equalTo(leftLineView)
            make.left.equalTo(shareTitleLabel.snp.right).offset(AdaptSize(13))
        }
        shareImageView.clipRectCorner(directionList: [.topLeft, .topRight, .bottomLeft, .bottomRight], cornerRadius: AdaptSize(13))
    }

    override func bindProperty() {
        super.bindProperty()
        self.layer.opacity   = 0.0
        self.backgroundColor = UIColor.black.withAlphaComponent(0.7)
        self.closeButton.addTarget(self, action: #selector(self.hide), for: .touchUpInside)
        self.refreshButton.addTarget(self, action: #selector(self.refreshAction), for: .touchUpInside)
        self.shareChannelView.finishedBlock = { [weak self] type in
            self?.delegate?.shareFinished(type: type)
        }
    }

    // MARK: ==== Event ====

    func show() {
        kWindow.addSubview(self)
        self.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        UIView.animate(withDuration: 0.25) { [weak self] in
            self?.layer.opacity = 1.0
        }
    }

    @objc
    private func hide() {
        UIView.animate(withDuration: 0.25, animations: { [weak self] in
            self?.layer.opacity = 0.0
        }) { [weak self] (finished) in
            self?.removeFromSuperview()
        }
    }

    @objc
    private func refreshAction() {
        self.loadingView.startAnimating()
        self.delegate?.refreshAction(complete: { [weak self] (image: UIImage?) in
            guard let self = self else { return }
            self.loadingView.stopAnimating()
            self.shareChannelView.shareImage  = image
            self.shareImageView.image         = image
            self.shareImageView.layer.opacity = 1.0
        })
    }
}
