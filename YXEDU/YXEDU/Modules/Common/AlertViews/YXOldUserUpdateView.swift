//
//  YXBadgeDetailView.swift
//  YXEDU
//
//  Created by Jake To on 12/27/19.
//  Copyright © 2019 shiji. All rights reserved.
//

import UIKit

class YXOldUserUpdateView: YXTopWindowView {
    var closure: (() -> Void)?

    @IBOutlet var contentView: UIView!
    @IBOutlet weak var backgroundView: UIView!
    @IBOutlet weak var containerView: UIView!

    init() {
        super.init(frame: CGRect(x: 0, y: 0, width: screenWidth, height: screenHeight))

        initializationFromNib()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        initializationFromNib()
    }
    
    func initializationFromNib() {
        Bundle.main.loadNibNamed("YXOldUserUpdateView", owner: self, options: nil)
        addSubview(contentView)
        contentView.frame = self.bounds
    }
    
    override func show() {
        kWindow.addSubview(self)
        containerView.transform = CGAffineTransform(scaleX: 1.2, y: 1.2)
        containerView.alpha = 0
        backgroundView.alpha = 0
        
        UIView.animate(withDuration: 0.3, delay: 0, options: .curveEaseOut, animations: {
            self.containerView.transform = .identity
            self.containerView.alpha = 1
            self.backgroundView.alpha = 0.7
            
        }, completion: nil)
    }
    
    @IBAction func close(_ sender: Any) {
        UIView.animate(withDuration: 0.2, animations: {
            self.contentView.alpha = 0
            
        }, completion: { completed in
            self.removeFromSuperview()
            self.closure?()
        })
    }
}
