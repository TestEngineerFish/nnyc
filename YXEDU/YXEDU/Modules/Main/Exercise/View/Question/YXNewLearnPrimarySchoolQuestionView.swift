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
        label.numberOfLines = 0
        label.textAlignment = .center
        return label
    }()

    var chineseExampleLabel: UILabel = {
        let label = UILabel()
        label.textColor     = UIColor.black1
        label.font          = UIFont.regularFont(ofSize: AdaptSize(14))
        label.textAlignment = .center
        return label
    }()

    override init(exerciseModel: YXWordExerciseModel) {
        super.init(exerciseModel: exerciseModel)
        self.layer.removeShadow()
        self.clipsToBounds = true
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        let height = self.chineseExampleLabel.text?.textHeight(font: chineseExampleLabel.font, width: screenWidth - AdaptSize(74)) ?? 0
        self.chineseExampleLabel.snp.updateConstraints { (make) in
            make.height.equalTo(height)
        }
    }

    override func bindData() {
        guard let wordModel = self.exerciseModel.word else {
            return
        }

        self.titleLabel?.text            = wordModel.word
        self.subTitleLabel?.text         = (wordModel.partOfSpeech ?? "") + (wordModel.meaning ?? "")
        self.chineseExampleLabel.text    = wordModel.chineseExample
        self.exampleLabel.attributedText = {

            guard let example = wordModel.example else {
                return nil
            }

            var newExample     = example
            var newRangeList   = [NSRange]()
            var examplePattern = ""
            var wordPattern    = ""

            if example.contains("@") {
                examplePattern = "@[^*]+?@"
                wordPattern    = "@"
            } else {
                examplePattern = "<font[^*]+?font>"
                wordPattern    = "<[^>]*>"
            }
            ///1、提取
            let htmlRangeList = example.textRegex(pattern: examplePattern)
            ///2、剔除标签
            for (index, range) in htmlRangeList.enumerated() {
                let htmlStr = example.substring(fromIndex: range.location, length: range.length)
                let word = htmlStr.pregReplace(pattern: wordPattern, with: "")
                var offset = 0
                if index > 0 {
                    offset = example.count - newExample.count
                }
                ///3、替换原内容
                newExample = newExample.pregReplace(pattern: htmlStr, with: word)
                newRangeList.append(NSRange(location: range.location - offset, length: word.count))
            }

            let mAttr = NSMutableAttributedString(string: newExample, attributes: [NSAttributedString.Key.font : UIFont.pfSCSemiboldFont(withSize: AdaptSize(16)), NSAttributedString.Key.foregroundColor : UIColor.black1])
            newRangeList.forEach { (range) in
                mAttr.addAttributes([NSAttributedString.Key.foregroundColor : UIColor.orange1], range: range)
            }
            return mAttr
        }()
        self.layoutIfNeeded()
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

        self.titleLabel?.isHidden         = true
        self.subTitleLabel?.isHidden      = true
        self.exampleLabel.isHidden        = true
        self.chineseExampleLabel.isHidden = true
        self.imageView?.isHidden          = true

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
            make.width.equalToSuperview().offset(AdaptSize(-30))
            make.centerX.equalToSuperview()
            make.top.equalTo(exampleLabel.snp.bottom).offset(AdaptSize(2))
            make.height.equalTo(0)
        }

        self.imageView?.snp.makeConstraints({ (make) in
            make.centerX.equalToSuperview()
            make.size.equalTo(CGSize.zero)
            make.top.equalTo(chineseExampleLabel.snp.bottom).offset(AdaptSize(26))
        })
    }

    // MARK: ==== Event ====
    func showImageView() {
        self.imageView?.isHidden = false
        self.imageView?.snp.updateConstraints({ (make) in
            make.size.equalTo(CGSize(width: AdaptSize(150), height: AdaptSize(108 + 1/3)))
        })
    }

    func showExample() {
        self.exampleLabel.isHidden = false
        self.exampleLabel.sizeToFit()
        let h = self.exampleLabel.text?.textHeight(font: exampleLabel.font, width: screenWidth - AdaptSize(44)) ?? CGFloat.zero
        self.exampleLabel.snp.updateConstraints { (make) in
            make.height.equalTo(h)
        }
    }

    func showChineseExample() {
        if self.chineseExampleLabel.isHidden {
            self.chineseExampleLabel.isHidden = false
        } else {
            self.chineseExampleLabel.isHidden = true
        }
    }

    func showWordView() {
        self.titleLabel?.isHidden = false
        self.titleLabel?.sizeToFit()
        self.titleLabel?.snp.updateConstraints({ (make) in
            make.height.equalTo(titleLabel!.height)
        })
        self.subTitleLabel?.isHidden = false
        self.subTitleLabel?.sizeToFit()
        self.subTitleLabel?.snp.updateConstraints({ (make) in
            make.height.equalTo(subTitleLabel!.height)
        })
    }
    
}
