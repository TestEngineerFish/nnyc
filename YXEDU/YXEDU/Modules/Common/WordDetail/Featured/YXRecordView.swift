//
//  YXRecordView.swift
//  YXEDU
//
//  Created by 沙庭宇 on 2020/4/14.
//  Copyright © 2020 shiji. All rights reserved.
//

import UIKit

class YXRecordView: UIView {
    let lineView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.black4.withAlphaComponent(0.5)
        return view
    }()
    let recordImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "recordedIcon")
        return imageView
    }()
    let recordLabel: UILabel = {
        let label = UILabel()
        label.text          = "单词跟读"
        label.textColor     = UIColor.black1
        label.font          = UIFont.regularFont(ofSize: AdaptSize(14))
        label.textAlignment = .left
        return label
    }()
    let recordButton: UIButton = {
        let button = UIButton()
        button.setTitle("跟读", for: .normal)
        button.setTitleColor(UIColor.orange1, for: .normal)
        button.titleLabel?.font    = UIFont.regularFont(ofSize: AdaptSize(14))
        button.layer.cornerRadius  = AdaptSize(13.5)
        button.layer.masksToBounds = true
        button.backgroundColor     = UIColor.hex(0xFFF4E9)
        button.isEnabled           = false
        return button
    }()
    let starView = YXStarView()
    var arrowImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "review_result_arrow")
        return imageView
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.createRecordView()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func createRecordView() {
        self.addSubview(lineView)
        self.addSubview(recordImageView)
        self.addSubview(recordLabel)
        self.addSubview(recordButton)
        self.addSubview(arrowImageView)
        self.addSubview(starView)

        lineView.snp.makeConstraints { (make) in
            make.top.equalToSuperview()
            make.centerX.equalToSuperview()
            make.width.equalToSuperview().offset(AdaptSize(-40))
            make.height.equalTo(AdaptSize(1))
        }
        recordImageView.snp.makeConstraints { (make) in
            make.left.equalToSuperview().offset(AdaptSize(18))
            make.height.width.equalTo(AdaptSize(22))
            make.centerY.equalToSuperview()
        }
        recordLabel.snp.makeConstraints { (make) in
            make.left.equalTo(recordImageView.snp.right).offset(AdaptSize(8))
            make.width.equalTo(AdaptSize(57))
            make.height.equalTo(AdaptSize(20))
            make.centerY.equalToSuperview()
        }
        recordButton.snp.makeConstraints { (make) in
            make.size.equalTo(CGSize(width: AdaptSize(68), height: AdaptSize(27)))
            make.centerY.equalToSuperview()
            make.right.equalToSuperview().offset(AdaptSize(-17))
        }
        arrowImageView.snp.makeConstraints { (make) in
            make.centerY.equalToSuperview()
            make.right.equalToSuperview().offset(AdaptSize(-21))
            make.size.equalTo(CGSize(width: AdaptSize(8), height: AdaptSize(15)))
        }
        starView.snp.makeConstraints { (make) in
            make.centerY.equalToSuperview()
            make.width.equalTo(AdaptSize(48))
            make.height.equalTo(AdaptSize(20))
            make.right.equalTo(arrowImageView.snp.left).offset(AdaptSize(-10))
        }
        // bind property
        self.isUserInteractionEnabled = true
        self.arrowImageView.isHidden  = true
        self.starView.isHidden        = true
    }

    // MARK: ---- Event ----

    func updateState(listenScore: Int) {
        if listenScore >= YXStarLevelEnum.zero.rawValue {
            self.arrowImageView.isHidden  = false
            self.starView.isHidden        = false
            self.recordButton.isHidden    = true
            self.starView.showWordDetailView(starNum: YXStarLevelEnum.getStarNum(listenScore))
        } else {
            self.arrowImageView.isHidden  = true
            self.starView.isHidden        = true
            self.recordButton.isHidden    = false
        }
    }
}
