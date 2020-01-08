//
//  YXExerciseBottomView.swift
//  YXEDU
//
//  Created by sunwu on 2019/10/28.
//  Copyright © 2019 shiji. All rights reserved.
//

import UIKit

protocol YXExerciseBottomViewProtocol: NSObjectProtocol {
    /// 点击提示一下按钮事件
    func clickTipsBtnEvent()
    /// 点击下一步视图事件
    func clickNextViewEvent()
    /// 点击下一步按钮事件
    func clickNextButtonEvent()
}

/// 练习模块：底部View
class YXExerciseBottomView: UIView {
    
    //MARK: - 私有属性
    var tipsButton: UIButton = {
        let button = UIButton()
        button.setTitle("提示一下", for: .normal)
        button.titleLabel?.contentMode = .left
        button.setImage(UIImage(named: "exercise_tips"), for: .normal)
        button.setTitleColor(UIColor.black3, for: .normal)
        button.setTitleColor(UIColor.black2, for: .highlighted)
        button.titleLabel?.font = UIFont.pfSCRegularFont(withSize: AdaptSize(12))
        return button
    }()

    var nextButton: UIButton = {
        let button = UIButton()
        button.setTitle("Next", for: .normal)
        button.setTitleColor(UIColor.black1, for: .normal)
        button.titleLabel?.font    = UIFont.regularFont(ofSize: AdaptSize(17))
        button.layer.borderColor   = UIColor.black6.cgColor
        button.layer.borderWidth   = AdaptSize(1)
        button.layer.masksToBounds = true
        button.layer.cornerRadius  = AdaptSize(21)
        button.isHidden            = true
        return button
    }()

    var nextView: UIView = {
        let view = UIView()
        view.isHidden = true
        return view
    }()
    var nextLabel: UILabel = {
        let label = UILabel()
        label.text          = "Next"
        label.textColor     = UIColor.black2
        label.font          = UIFont.regularFont(ofSize: AdaptSize(13))
        label.textAlignment = .center
        return label
    }()
    var arrowImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "arrow_right")
        return imageView
    }()

    weak var delegate: YXExerciseBottomViewProtocol?

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = UIColor.red

        self.createSubviews()
        self.bindProperty()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func createSubviews() {
        self.addSubview(tipsButton)
        self.addSubview(nextButton)
        self.addSubview(nextView)
        nextView.addSubview(nextLabel)
        nextView.addSubview(arrowImageView)

        self.tipsButton.snp.makeConstraints { (make) in
            make.centerY.equalToSuperview()
            make.left.equalTo(AdaptSize(18))
            make.width.equalTo(AdaptSize(91))
            make.height.equalTo(AdaptSize(18))
        }
        self.nextView.snp.makeConstraints { (make) in
            make.top.right.bottom.equalToSuperview()
            make.width.equalTo(AdaptSize(68))
        }
        nextLabel.snp.makeConstraints { (make) in
            make.left.equalToSuperview().offset(AdaptSize(5))
            make.centerY.equalToSuperview()
            make.size.equalTo(CGSize(width: AdaptSize(28), height: AdaptSize(18)))
        }
        arrowImageView.snp.makeConstraints { (make) in
            make.centerY.equalToSuperview()
            make.left.equalTo(nextLabel.snp.right).offset(AdaptSize(5))
            make.size.equalTo(CGSize(width: AdaptSize(8), height: AdaptSize(15)))
        }
        self.nextButton.snp.makeConstraints { (make) in
            make.center.equalToSuperview()
            make.size.equalTo(CGSize(width: AdaptSize(273), height: AdaptSize(42)))
        }
    }
    
    func bindProperty() {
        self.backgroundColor = UIColor.white
        self.tipsButton.addTarget(self, action: #selector(clickTipsButton), for: .touchUpInside)
        let tap = UITapGestureRecognizer(target: self, action: #selector(clickNextView))
        self.nextView.addGestureRecognizer(tap)
        nextButton.addTarget(self, action: #selector(clickNextButton), for: .touchUpInside)
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        self.tipsButton.titleLabel?.sizeToFit()
        let w = (self.tipsButton.titleLabel?.width ?? 0) + AdaptSize(20)
        self.tipsButton.snp.updateConstraints { (make) in
            make.width.equalTo(w)
        }
    }

    @objc func clickTipsButton() {
        self.delegate?.clickTipsBtnEvent()
    }

    @objc func clickNextView() {
        self.nextButton.isHidden = false
        self.tipsButton.isHidden = true
        self.nextView.isHidden   = true
        self.delegate?.clickNextViewEvent()
        self.superview?.bringSubviewToFront(self)
        self.layer.setDefaultShadow(cornerRadius: 0)
    }

    @objc func clickNextButton() {
        self.nextButton.isHidden = true
        self.tipsButton.isHidden = false
        self.nextView.isHidden   = true
        self.delegate?.clickNextButtonEvent()
        self.layer.removeShadow()
    }
    
}
