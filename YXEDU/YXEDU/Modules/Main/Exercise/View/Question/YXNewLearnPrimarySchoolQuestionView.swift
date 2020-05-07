//
//  YXNewLearnPrimarySchoolQuestionView.swift
//  YXEDU
//
//  Created by 沙庭宇 on 2019/11/4.
//  Copyright © 2019 shiji. All rights reserved.
//

import UIKit

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
        label.font          = UIFont.regularFont(ofSize: AdaptFontSize(14))
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
        let height = self.chineseExampleLabel.text?.textHeight(font: chineseExampleLabel.font, width: screenWidth - AdaptIconSize(74)) ?? 0
        self.chineseExampleLabel.snp.makeConstraints { (make) in
            make.height.equalTo(height)
        }
    }

    override func bindData() {
        guard let wordModel = self.exerciseModel.word else {
            return
        }

        self.titleLabel?.text            = wordModel.word
        self.subTitleLabel?.text         = self.exerciseModel.type == .some(.newLearnPrimarySchool_Group) ? (wordModel.meaning ?? "") : (wordModel.partOfSpeech ?? "") + " " + (wordModel.meaning ?? "")
        self.chineseExampleLabel.text    = wordModel.examples?.first?.chinese
        self.exampleLabel.attributedText = {

            guard let example = wordModel.examples?.first?.english else {
                return nil
            }

            let result = example.formartTag()

            let mAttr = NSMutableAttributedString(string: result.1, attributes: [NSAttributedString.Key.font : UIFont.pfSCSemiboldFont(withSize: AdaptFontSize(16)), NSAttributedString.Key.foregroundColor : UIColor.black1])
            result.0.forEach { (range) in
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

        self.titleLabel?.layer.opacity         = 0.0
        self.subTitleLabel?.layer.opacity      = 0.0
        self.exampleLabel.layer.opacity        = 0.0
        self.chineseExampleLabel.layer.opacity = 0.0
        self.imageView?.layer.opacity          = 0.0
        self.imageView?.backgroundColor        = UIColor.clear

        self.titleLabel?.snp.makeConstraints({ (make) in
            make.centerX.equalToSuperview()
            make.top.equalToSuperview().offset(AdaptIconSize(69))
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
            make.top.equalToSuperview().offset(AdaptIconSize(69))
            make.height.equalTo(0)
        }

        self.chineseExampleLabel.snp.makeConstraints { (make) in
            make.width.equalToSuperview()
            make.centerX.equalToSuperview()
            make.top.equalTo(exampleLabel.snp.bottom).offset(AdaptIconSize(2))
        }

        self.imageView?.snp.makeConstraints({ (make) in
            make.centerX.equalToSuperview()
            make.size.equalTo(CGSize.zero)
            make.top.equalTo(chineseExampleLabel.snp.bottom).offset(AdaptIconSize(26))
        })
    }

    // MARK: ==== Event ====
    func showImageView() {
        self.imageView?.layer.opacity = 1.0
        self.imageView?.snp.updateConstraints({ (make) in
            make.size.equalTo(CGSize(width: AdaptIconSize(177), height: AdaptIconSize(128)))
        })
    }

    func showExample() {
        self.exampleLabel.layer.opacity = 1.0
        self.exampleLabel.sizeToFit()
        let h = self.exampleLabel.text?.textHeight(font: exampleLabel.font, width: screenWidth - AdaptIconSize(44)) ?? CGFloat.zero
        self.exampleLabel.snp.updateConstraints { (make) in
            make.height.equalTo(h)
        }
    }

    func showChineseExample() {
        if self.chineseExampleLabel.layer.opacity == 0.0 {
            self.chineseExampleLabel.layer.opacity = 1.0
        } else {
            self.chineseExampleLabel.layer.opacity = 0.0
        }
    }

    func showWordView() {
        UIView.animate(withDuration: 0.8, animations: {
            self.exampleLabel.transform        = CGAffineTransform(translationX: 0, y: AdaptIconSize(78))
            self.chineseExampleLabel.transform = CGAffineTransform(translationX: 0, y: AdaptIconSize(78))
            self.imageView?.transform          = CGAffineTransform(translationX: 0, y: AdaptIconSize(78))
        })
        UIView.animate(withDuration: 0.5, delay: 0.5, options: .curveEaseInOut, animations: {
            self.titleLabel?.layer.opacity     = 1.0
            self.subTitleLabel?.layer.opacity  = 1.0
        }, completion: nil)
        self.titleLabel?.sizeToFit()
        self.titleLabel?.snp.updateConstraints({ (make) in
            make.height.equalTo(titleLabel!.height)
        })
        self.subTitleLabel?.sizeToFit()
        self.subTitleLabel?.snp.updateConstraints({ (make) in
            make.height.equalTo(subTitleLabel!.height)
        })
    }
    
}
