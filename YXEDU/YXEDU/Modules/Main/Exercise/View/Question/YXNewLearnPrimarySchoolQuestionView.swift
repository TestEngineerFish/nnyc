//
//  YXNewLearnPrimarySchoolQuestionView.swift
//  YXEDU
//
//  Created by 沙庭宇 on 2019/11/4.
//  Copyright © 2019 shiji. All rights reserved.
//

import UIKit


enum NewLearnSubviewType: Int {
    case imageAndAudio
    case wordAndAudio
    case wordAndImageAndAudio
}

class YXNewLearnPrimarySchoolQuestionView: YXBaseQuestionView {

    var exampleLabel: UILabel = {
        let label = UILabel()
        label.textColor     = UIColor.black1
        label.font          = UIFont.pfSCSemiboldFont(withSize: AdaptSize(16))
        label.textAlignment = .center
        return label
    }()

    var chineseExampleLabel: UILabel = {
        let label = UILabel()
        label.textColor     = UIColor.black1
        label.font          = UIFont.pfSCSemiboldFont(withSize: AdaptSize(16))
        label.textAlignment = .center
        return label
    }()

    override init(exerciseModel: YXWordExerciseModel) {
        super.init(exerciseModel: exerciseModel)
        self.layer.removeShadow()
        self.clipsToBounds = true
    }

    override func bindData() {
        guard let wordModel = self.exerciseModel.word else {
            return
        }

        self.titleLabel?.text            = wordModel.word
        self.subTitleLabel?.text         = wordModel.meaning
        self.exampleLabel.text           = wordModel.example
        self.chineseExampleLabel.text    = wordModel.chineseExample
//        self.exampleLabel.attributedText = {
//            guard let attributionStr = (wordModel.example ?? "").html2AttributedString else {
//                return nil
//            }
//            let mAttr = NSMutableAttributedString(attributedString: attributionStr)
//            mAttr.addAttributes([NSAttributedString.Key.font : UIFont.pfSCSemiboldFont(withSize: AdaptSize(16)), NSAttributedString.Key.foregroundColor : UIColor.black1], range: NSRange(location: 0, length: attributionStr.length))
//            return mAttr
//        }()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func createSubviews() {
        super.createSubviews()
        self.initTitleLabel()
        self.initSubTitleLabel()
        self.initImageView()
        self.addSubview(exampleLabel)
        self.addSubview(chineseExampleLabel)

        self.titleLabel?.snp.makeConstraints({ (make) in
            make.centerX.equalToSuperview()
            make.top.equalToSuperview().offset(AdaptSize(69))
            make.width.equalToSuperview()
            make.height.equalTo(0)
        })

        self.subTitleLabel?.snp.makeConstraints({ (make) in
            make.centerX.equalToSuperview()
            make.top.equalTo(titleLabel!.snp.bottom)
            make.width.equalToSuperview()
            make.height.equalTo(0)
        })

        self.exampleLabel.snp.makeConstraints { (make) in
            make.centerX.width.equalToSuperview()
            make.top.equalTo(subTitleLabel!.snp.bottom).offset(AdaptSize(56))
            make.height.equalTo(0)
        }

        self.chineseExampleLabel.snp.makeConstraints { (make) in
            make.centerX.width.equalToSuperview()
            make.top.equalTo(exampleLabel.snp.bottom).offset(AdaptSize(2))
            make.height.equalTo(0)
        }

        self.imageView?.snp.makeConstraints({ (make) in
            make.centerX.equalToSuperview()
            make.size.equalTo(CGSize(width: AdaptSize(150), height: AdaptSize(109)))
            make.top.equalTo(chineseExampleLabel.snp.bottom).offset(AdaptSize(26))
        })
    }

    // MARK: ==== Event ====
    func showExample() {
        self.exampleLabel.sizeToFit()
        self.exampleLabel.snp.updateConstraints { (make) in
            make.height.equalTo(exampleLabel.height)
        }
    }

    func showChineseExample() {
        self.chineseExampleLabel.sizeToFit()
        self.chineseExampleLabel.snp.updateConstraints { (make) in
            make.height.equalTo(chineseExampleLabel.height)
        }
    }

    func hideChineseExample() {
        self.chineseExampleLabel.snp.updateConstraints { (make) in
              make.height.equalTo(0)
          }
    }

    func showWordView() {
        self.titleLabel?.sizeToFit()
        self.titleLabel?.snp.updateConstraints({ (make) in
            make.height.equalTo(titleLabel!.height)
        })
        self.subTitleLabel?.sizeToFit()
        self.subTitleLabel?.snp.updateConstraints({ (make) in
            make.height.equalTo(subTitleLabel!.height)
        })
    }

//    override func playAudio() {
//        self.audioPlayerView?.play()
//    }
    
}
