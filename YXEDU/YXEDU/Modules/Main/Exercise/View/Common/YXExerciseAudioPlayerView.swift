//
//  YXExerciseAudioPlayerView.swift
//  YXEDU
//
//  Created by sunwu on 2019/10/31.
//  Copyright © 2019 shiji. All rights reserved.
//

import UIKit
import AVKit

class YXExerciseAudioPlayerView: UIView {

    public var url: String? {
        didSet{
            if let u = self.url {
                self.play(url: u)
            }
        }
    }
    
    private var avPlayer = AVPlayer()
    private var playerButton: UIButton = UIButton()
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.createSubviews()
        self.bindProperty()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.setButtonFrame(width: 22)
    }
    
    func bindProperty() {
        playerButton.setBackgroundImage(UIImage(named: "playAudioIcon"), for: .normal)
        playerButton.addTarget(self, action: #selector(clickPlayerButton), for: .touchUpInside)
    }
    
    
    func createSubviews() {
        self.addSubview(playerButton)
    }

    
    func play(url: String) {
        
    }
    
    
    @objc func clickPlayerButton() {
        
        self.startAnimate()
    }
    

    func startAnimate() {
        self.setButtonFrame(width: 22)
        UIView.animate(withDuration: 1, animations: { [weak self] in
            guard let self = self else { return }
            self.setButtonFrame(width: 48)
        }) { (finish) in
            
            UIView.animate(withDuration: 1, animations: { [weak self] in
                guard let self = self else { return }
                self.setButtonFrame(width: 22)
            }) { (finish) in
                self.startAnimate()
            }
            
        }
    }
    
    func stopAnimate() {
        
    }
    
    
    func setButtonFrame(width: CGFloat) {
        let buttonX = (self.size.width - width) / 2
        self.playerButton.frame = CGRect(x: buttonX, y: buttonX, width: width, height: width)
        
    }
    
}
