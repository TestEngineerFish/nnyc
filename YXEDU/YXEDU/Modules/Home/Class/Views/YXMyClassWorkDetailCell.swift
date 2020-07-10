//
//  YXMyClassWorkDetailCell.swift
//  YXEDU
//
//  Created by 沙庭宇 on 2020/6/22.
//  Copyright © 2020 shiji. All rights reserved.
//

import Foundation

class YXMyClassWorkDetailCell: UITableViewCell {
    var wordLabel: UILabel = {
        let label = UILabel()
        label.text          = ""
        label.textColor     = UIColor.black1
        label.font          = UIFont.mediumFont(ofSize: AdaptFontSize(17))
        label.textAlignment = .left
        return label
    }()
    var chineseLabel: UILabel = {
        let label = UILabel()
        label.text          = ""
        label.textColor     = UIColor.black3
        label.font          = UIFont.regularFont(ofSize: AdaptFontSize(13))
        label.textAlignment = .left
        return label
    }()
    var resultView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.clear
        return view
    }()

    var resultViewHeight = AdaptSize(0) {
        willSet {
            self.resultView.snp.updateConstraints { (make) in
                make.height.equalTo(newValue)
            }
        }
    }

    let customTag = 100

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.bindProperty()
        self.createSubviews()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func bindProperty() {
        self.selectionStyle = .none
        self.separatorInset = UIEdgeInsets(top: 0, left: AdaptSize(15), bottom: 0, right: AdaptSize(-15))
    }

    private func createSubviews() {
        self.addSubview(wordLabel)
        self.addSubview(chineseLabel)
        self.addSubview(resultView)
        wordLabel.snp.makeConstraints { (make) in
            make.left.top.equalToSuperview().offset(AdaptSize(15))
            make.right.equalToSuperview().offset(AdaptSize(-132))
            make.height.equalTo(AdaptSize(24))
        }
        chineseLabel.snp.makeConstraints { (make) in
            make.left.right.equalTo(wordLabel)
            make.height.equalTo(AdaptSize(18))
            make.bottom.equalToSuperview().offset(AdaptSize(-15))
        }
        resultView.snp.makeConstraints { (make) in
            make.left.equalTo(chineseLabel.snp.right).offset(AdaptSize(30))
            make.right.equalToSuperview().offset(AdaptSize(5))
            make.height.equalTo(self.resultViewHeight)
            make.centerY.equalToSuperview()
        }
    }

    func setData(word model: YXMyClassReportWordModel) {
        self.removeCustomSubviews()
        var _customTag = self.customTag
        self.wordLabel.text    = model.word
        self.chineseLabel.text = String(format: "%@%@", model.paraphrase?.partOfSpeech ?? "", model.paraphrase?.meaning ?? "")
        var offsetY = AdaptSize(0)
        let wrongTextList = model.wrongTextList()
        if !wrongTextList.isEmpty {
            wrongTextList.forEach { (text) in
                _customTag += 1
                let iconImageView = UIImageView(image: UIImage(named: "error"))
                iconImageView.tag = _customTag
                _customTag += 1
                let textLabel: UILabel = {
                    let label = UILabel()
                    label.text          = text
                    label.textColor     = UIColor.red1
                    label.font          = UIFont.regularFont(ofSize: AdaptFontSize(13))
                    label.textAlignment = .left
                    return label
                }()
                textLabel.tag = _customTag
                resultView.addSubview(iconImageView)
                resultView.addSubview(textLabel)
                iconImageView.snp.makeConstraints { (make) in
                    make.left.equalToSuperview()
                    make.top.equalToSuperview().offset(AdaptSize(offsetY))
                    make.size.equalTo(CGSize(width: AdaptSize(16), height: AdaptSize(16)))
                }
                textLabel.snp.makeConstraints { (make) in
                    make.left.equalTo(iconImageView.snp.right).offset(AdaptSize(4))
                    make.centerY.equalTo(iconImageView)
                    make.height.equalTo(AdaptSize(18))
                    make.right.equalToSuperview()
                }
                offsetY += AdaptSize(21)
            }
        } else {
            _customTag += 1
            let iconImageView = UIImageView(image: UIImage(named: "success"))
            iconImageView.tag = _customTag
            _customTag += 1
            let textLabel: UILabel = {
                let label = UILabel()
                label.text          = "全对"
                label.textColor     = UIColor.hex(0x7ACC33)
                label.font          = UIFont.regularFont(ofSize: AdaptFontSize(13))
                label.textAlignment = .left
                return label
            }()
            textLabel.tag = _customTag
            resultView.addSubview(iconImageView)
            resultView.addSubview(textLabel)
            iconImageView.snp.makeConstraints { (make) in
                make.left.equalToSuperview()
                make.top.equalToSuperview()
                make.size.equalTo(CGSize(width: AdaptSize(16), height: AdaptSize(16)))
            }
            textLabel.snp.makeConstraints { (make) in
                make.left.equalTo(iconImageView.snp.right).offset(AdaptSize(4))
                make.centerY.equalTo(iconImageView)
                make.height.equalTo(AdaptSize(18))
                make.right.equalToSuperview()
            }
            offsetY += AdaptSize(21)
        }
        self.resultViewHeight = offsetY - AdaptSize(5)
    }

    // MARK: ==== Tools ====
    private func removeCustomSubviews() {
        for subview in self.resultView.subviews {
            if subview.tag > self.customTag {
                subview.removeFromSuperview()
            }
        }
    }
}
