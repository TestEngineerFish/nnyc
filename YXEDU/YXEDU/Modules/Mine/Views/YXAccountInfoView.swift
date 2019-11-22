//
//  YXAccountInfoView.swift
//  YXEDU
//
//  Created by Jake To on 10/31/19.
//  Copyright © 2019 shiji. All rights reserved.
//

import UIKit

class YXAccountInfoView: UIView {
    
    var bindQQClosure: (() -> Void)!
    var bindWechatClosure: (() -> Void)!
    var bindInfo: [String] = [] {
        didSet {
            updateData()
        }
    }
    
    @IBOutlet var contentView: UIView!
    @IBOutlet weak var phoneNumberLabel: UILabel!
    @IBOutlet weak var bindQQButton: UIButton!
    @IBOutlet weak var bindWechatButton: UIButton!

    init() {
        super.init(frame: CGRect(x: 0, y: 0, width: screenWidth, height: screenHeight))
        initializationFromNib()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        initializationFromNib()
    }
    
    func initializationFromNib() {
        Bundle.main.loadNibNamed("YXAccountInfoView", owner: self, options: nil)
        addSubview(contentView)
        contentView.frame = self.bounds
    }

    @IBAction func bindQQ(_ sender: UIButton) {
        bindQQClosure()
        self.removeFromSuperview()
    }
    
    @IBAction func bindWechat(_ sender: UIButton) {
        bindWechatClosure()
        self.removeFromSuperview()
    }
    
    @IBAction func done(_ sender: UIButton) {
        self.removeFromSuperview()
    }
    
    private func updateData() {
        phoneNumberLabel.text = bindInfo[0]
        
        if bindInfo[1] == "1" {
            bindQQButton.setImage(#imageLiteral(resourceName: "bindState"), for: .normal)
            bindQQButton.setTitle("", for: .normal)
            bindQQButton.backgroundColor = .white
            
        } else {
            bindQQButton.setImage(nil, for: .normal)
            bindQQButton.setTitle("    去绑定    ", for: .normal)
            bindQQButton.backgroundColor = UIColor.hex(0xFBA217)
        }
        
        if bindInfo[2] == "2" {
            bindWechatButton.setImage(#imageLiteral(resourceName: "bindState"), for: .normal)
            bindWechatButton.setTitle("", for: .normal)
            bindWechatButton.backgroundColor = .white
            
        } else {
            bindWechatButton.setImage(nil, for: .normal)
            bindWechatButton.setTitle("    去绑定    ", for: .normal)
            bindWechatButton.backgroundColor = UIColor.hex(0xFBA217)
        }
    }
    
    func show() {
        kWindow.addSubview(self)
    }
}
