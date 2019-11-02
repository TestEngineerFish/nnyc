//
//  YXQuestionAudioView.swift
//  YXEDU
//
//  Created by 沙庭宇 on 2019/10/28.
//  Copyright © 2019 shiji. All rights reserved.
//

import UIKit

class YXQuestionAudioSubview: UIView {
    let audioButton = UIButton()
    var exerciseModel: YXWordExerciseModel
    var delegate: YXQuestionEventProtocol?

    init(exerciseModel: YXWordExerciseModel,isShowBg: Bool = false) {
        self.exerciseModel = exerciseModel

        var width   = CGFloat(22)
        var height  = CGFloat(22)
        if isShowBg {
            width  = 52
            height = 52
            audioButton.backgroundColor    = UIColor.orange3
            audioButton.layer.cornerRadius = width/2
            audioButton.layer.borderWidth  = 3
            audioButton.layer.borderColor  = UIColor.orange2.cgColor
        } else {
            audioButton.backgroundColor = UIColor.white
        }
        super.init(frame: CGRect(x: 0, y: 0, width: width, height: height))
        audioButton.setImage(UIImage(named: "playAudioIcon"), for: .normal)
        audioButton.addTarget(self, action: #selector(clickAudioBtn(_:)), for: .touchUpInside)
        self.addSubview(audioButton)
        audioButton.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // TODO: Event

    @objc func clickAudioBtn(_ button: UIButton) {
        button.isSelected = !button.isSelected
        if button.isSelected {
            button.layer.addFlickerAnimation()
            print("开始播放音频")
        } else {
            button.layer.removeFlickerAnimation()
            print("停止播放音频")
        }
        delegate?.clickAudioButton(button)
    }


}
