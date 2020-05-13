//
//  YXChallengeRankTopView.swift
//  YXEDU
//
//  Created by 沙庭宇 on 2019/12/11.
//  Copyright © 2019 shiji. All rights reserved.
//

import UIKit

class YXChallengeHeaderView: UIView {
    var isPreviousRank: Bool
    let headerView = YXChallengeHeaderTopView()
    lazy var myRankView: YXChallengeMyRankCell = {
        let view = YXChallengeMyRankCell(isPreviousRank: self.isPreviousRank)
        return view
    }()
    var headerBackgroundView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.hex(0xEFE1CE)
        return view
    }()
    var iconImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "cupIcon")
        return imageView
    }()
    var titleLabel: UILabel = {
        let label = UILabel()
        label.text          = "本期排行榜"
        label.textColor     = UIColor.hex(0x4F381D)
        label.font          = UIFont.mediumFont(ofSize: AdaptSize(15))
        label.textAlignment = .center
        return label
    }()
    var previousRankButton: UIButton = {
        let button = UIButton()
        button.isHidden = true
        button.setTitle("上期排名", for: .normal)
        button.setTitleColor(UIColor.hex(0xB18550), for: .normal)
        button.titleLabel?.font = UIFont.regularFont(ofSize: AdaptSize(12))
        return button
    }()

    init(_ isPeviousRank: Bool) {
        self.isPreviousRank = isPeviousRank
        super.init(frame: CGRect.zero)
        self.createSubviews()
        self.bindProperty()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func bindProperty() {
        self.backgroundColor = UIColor.clear
    }

    private func createSubviews() {
        if !isPreviousRank {
            self.addSubview(headerView)
            headerView.snp.makeConstraints { (make) in
                make.left.top.right.equalToSuperview()
                make.height.equalTo(AdaptSize(268))
            }
        }
        self.addSubview(myRankView)
        self.addSubview(headerBackgroundView)
        headerBackgroundView.addSubview(iconImageView)
        headerBackgroundView.addSubview(titleLabel)
        headerBackgroundView.addSubview(previousRankButton)

        headerBackgroundView.size = CGSize(width: AdaptSize(349), height: AdaptSize(48))
        headerBackgroundView.snp.makeConstraints { (make) in
            make.bottom.equalToSuperview()
            make.centerX.equalToSuperview()
            make.size.equalTo(headerBackgroundView.size)
        }
        headerBackgroundView.clipRectCorner(directionList: [.topLeft, .topRight], cornerRadius: AdaptSize(10))
        myRankView.snp.makeConstraints { (make) in
            make.bottom.equalTo(headerBackgroundView.snp.top).offset(AdaptSize(-11))
            make.centerX.equalToSuperview()
            make.width.equalToSuperview()
            make.height.equalTo(AdaptSize(81))
        }
        iconImageView.snp.makeConstraints { (make) in
            make.centerY.equalToSuperview()
            make.right.equalTo(titleLabel.snp.left).offset(AdaptSize(-6))
            make.size.equalTo(CGSize(width: AdaptSize(18), height: AdaptSize(18)))
        }
        titleLabel.snp.makeConstraints { (make) in
            make.center.equalToSuperview()
            make.size.equalTo(CGSize(width: AdaptSize(76), height: AdaptSize(21)))
        }
        previousRankButton.snp.makeConstraints { (make) in
            make.right.equalToSuperview().offset(AdaptSize(-14))
            make.bottom.equalTo(titleLabel)
            make.size.equalTo(CGSize(width: AdaptSize(50), height: 17))
        }
    }

    func bindData(_ challengeModel: YXChallengeModel?) {
        guard let challengeModel = challengeModel, let userModel = challengeModel.userModel else {
            return
        }
        if !isPreviousRank {
            self.headerView.bindData(challengeModel)
        }
        if (challengeModel.gameInfo?.lastRanking ?? false) && !self.isPreviousRank {
            self.previousRankButton.isHidden = false
        }
        self.myRankView.bindData(userModel)
        if challengeModel.rankedList.count > 0 {
            myRankView.snp.updateConstraints { (make) in
                make.height.equalTo(AdaptSize(81))
            }
            myRankView.isHidden = false
        } else {
            myRankView.snp.updateConstraints { (make) in
                make.height.equalTo(AdaptSize(12))
            }
            myRankView.isHidden = true
        }
    }

}

