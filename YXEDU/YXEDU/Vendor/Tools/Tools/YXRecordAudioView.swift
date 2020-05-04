//
//  YXRecordAudioView.swift
//  YXEDU
//
//  Created by 沙庭宇 on 2019/12/19.
//  Copyright © 2019 shiji. All rights reserved.
//

import UIKit
import MediaPlayer

class YXRecordAudioView: UIView {
    static let share = YXRecordAudioView()

    var backgroundView: UIView = {
        let view = UIView()
        view.backgroundColor     = UIColor.black5
        view.layer.masksToBounds = true
        view.layer.cornerRadius  = AdaptSize(6)
        return view
    }()
    var microphoneImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "microphone")
        return imageView
    }()
    var volume0: UIView = {
        let view = UIView()
        view.backgroundColor     = UIColor.hex(0x7C7C7C)
        view.layer.masksToBounds = true
        view.layer.cornerRadius  = AdaptSize(4)
        return view
    }()
    var volume1: UIView = {
        let view = UIView()
        view.backgroundColor     = UIColor.hex(0x7C7C7C)
        view.layer.masksToBounds = true
        view.layer.cornerRadius  = AdaptSize(4)
        return view
    }()
    var volume2: UIView = {
        let view = UIView()
        view.backgroundColor     = UIColor.hex(0x7C7C7C)
        view.layer.masksToBounds = true
        view.layer.cornerRadius  = AdaptSize(4)
        return view
    }()
    var volume3: UIView = {
        let view = UIView()
        view.backgroundColor     = UIColor.hex(0x7C7C7C)
        view.layer.masksToBounds = true
        view.layer.cornerRadius  = AdaptSize(4)
        return view
    }()

    var descriptionLable: UILabel = {
        let label = UILabel()
        label.text          = "录音中，请跟读"
        label.textColor     = UIColor.white
        label.font          = UIFont.regularFont(ofSize: AdaptFontSize(14))
        label.textAlignment = .center
        return label
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.createSubview()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func createSubview() {
        self.addSubview(backgroundView)
        self.addSubview(microphoneImageView)
        self.addSubview(volume0)
        self.addSubview(volume1)
        self.addSubview(volume2)
        self.addSubview(volume3)
        self.addSubview(descriptionLable)

        backgroundView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        microphoneImageView.snp.makeConstraints { (make) in
            make.left.equalToSuperview().offset(AdaptSize(36))
            make.top.equalToSuperview().offset(AdaptSize(53))
            make.size.equalTo(CGSize(width: AdaptSize(52), height: AdaptSize(74)))
        }
        volume0.snp.makeConstraints { (make) in
            make.bottom.equalTo(microphoneImageView)
            make.left.equalTo(microphoneImageView.snp.right).offset(AdaptSize(15))
            make.size.equalTo(CGSize(width: AdaptSize(35), height: AdaptSize(8)))
        }
        volume1.snp.makeConstraints { (make) in
            make.bottom.equalTo(volume0.snp.top).offset(AdaptSize(-12))
            make.left.equalTo(volume0)
            make.size.equalTo(CGSize(width: AdaptSize(43), height: AdaptSize(8)))
        }
        volume2.snp.makeConstraints { (make) in
            make.bottom.equalTo(volume1.snp.top).offset(AdaptSize(-12))
            make.left.equalTo(volume0)
            make.size.equalTo(CGSize(width: AdaptSize(56), height: AdaptSize(8)))
        }
        volume3.snp.makeConstraints { (make) in
            make.bottom.equalTo(volume2.snp.top).offset(AdaptSize(-12))
            make.left.equalTo(volume0)
            make.size.equalTo(CGSize(width: AdaptSize(69), height: AdaptSize(8)))
        }
        descriptionLable.sizeToFit()
        descriptionLable.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.bottom.equalToSuperview().offset(AdaptSize(-19))
            make.size.equalTo(descriptionLable.size)
        }
    }

    func show() {
        kWindow.addSubview(self)
        self.snp.makeConstraints { (make) in
            make.center.equalToSuperview()
            make.size.equalTo(CGSize(width: AdaptSize(198), height: AdaptSize(198)))
        }
    }

    func hide() {
        self.removeFromSuperview()
    }

    // MARK: ==== Event ====
    func updateVolume(_ volume: Int32) {
        let volumeLevel = volume / 10
        volume0.backgroundColor = UIColor.hex(0x7C7C7C)

        if volumeLevel > 0 {
            volume0.backgroundColor = UIColor.white
        } else {
            volume0.backgroundColor = UIColor.hex(0x7C7C7C)
        }
        if volumeLevel > 1 {
            volume1.backgroundColor = UIColor.white
        } else {
            volume1.backgroundColor = UIColor.hex(0x7C7C7C)
        }
        if volumeLevel > 2 {
            volume2.backgroundColor = UIColor.white
        } else {
            volume2.backgroundColor = UIColor.hex(0x7C7C7C)
        }
        if volumeLevel > 3 {
            volume3.backgroundColor = UIColor.white
        } else {
            volume3.backgroundColor = UIColor.hex(0x7C7C7C)
        }
    }
}
