//
//  YXWordDetailTipView.swift
//  YXEDU
//
//  Created by Jake To on 11/14/19.
//  Copyright © 2019 shiji. All rights reserved.
//

import UIKit

class YXWordDetailTipView: UIView {

    var dismissClosure: (() -> Void)?
    
    private var word: YXWordModel!
    private var wordDetailView: YXWordDetailView!
    
    @IBOutlet var contentView: UIView!
    @IBOutlet var backgroundView: UIView!

    init(word: YXWordModel) {
        super.init(frame: CGRect(x: 0, y: 0, width: screenWidth, height: screenHeight))
        self.word = word
        
        initializationFromNib()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        initializationFromNib()
    }
    
    private func initializationFromNib() {
        Bundle.main.loadNibNamed("YXWordDetailTipView", owner: self, options: nil)
        addSubview(contentView)
        contentView.frame = self.bounds
        
        wordDetailView = YXWordDetailView(frame: CGRect(x: 0, y: 40, width: screenWidth, height: screenHeight - 40), word: word!)
        wordDetailView.layer.cornerRadius = 6
        wordDetailView.layer.masksToBounds = true
        wordDetailView.dismissClosure = {
            UIView.animate(withDuration: 0.2, delay: 0, options: .curveEaseOut, animations: {
                self.backgroundView.alpha = 0
                self.wordDetailView.transform = CGAffineTransform(translationX: 0, y: screenHeight - 44)
                
            }) { (isCompleted) in
                self.removeFromSuperview()
            }
            
            self.dismissClosure?()
        }
        
        let maskPath = UIBezierPath(roundedRect: wordDetailView.bounds, byRoundingCorners: [UIRectCorner.topLeft, UIRectCorner.topRight], cornerRadii: CGSize(width: 6, height: 6))
        let maskLayer = CAShapeLayer()
        maskLayer.frame = wordDetailView.bounds
        maskLayer.path = maskPath.cgPath
        wordDetailView.layer.mask = maskLayer
        
        self.addSubview(wordDetailView)
    }
    
    func showWithAnimation() {
        UIApplication.shared.keyWindow?.addSubview(self)
        
        backgroundView.alpha = 0
        wordDetailView.transform = CGAffineTransform(translationX: 0, y: screenHeight - 40)

        UIView.animate(withDuration: 0.2, delay: 0, options: .curveEaseOut, animations: {
            self.backgroundView.alpha = 0.7
            self.wordDetailView.transform = .identity
            
        }) { (isCompleted) in
            
        }
    }
}
