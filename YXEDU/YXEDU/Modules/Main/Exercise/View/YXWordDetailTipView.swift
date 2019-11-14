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

    init(frame: CGRect, word: YXWordModel) {
        super.init(frame: frame)
        self.word = word
        
        initializationFromNib()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        initializationFromNib()
    }
    
    private func initializationFromNib() {
        Bundle.main.loadNibNamed("YXWordDetailView", owner: self, options: nil)
        addSubview(contentView)
        contentView.frame = self.frame
        
        wordDetailView = YXWordDetailView(frame: CGRect(x: 0, y: 44, width: screenWidth, height: screenHeight - 44), word: word!)
        wordDetailView.dismissClosure = {
            UIView.animate(withDuration: 0.2, delay: 0, options: .curveEaseOut, animations: {
                self.backgroundView.alpha = 0
                self.wordDetailView.transform = CGAffineTransform(translationX: 0, y: screenHeight - 44)
                
            }) { (isCompleted) in
                self.removeFromSuperview()
            }
            
            self.dismissClosure?()
        }
        
        self.addSubview(wordDetailView)
    }
    
    func addAndShowWithAnimation(in superView: UIView) {
        superView.addSubview(self)
        
        backgroundView.alpha = 0
        wordDetailView.transform = CGAffineTransform(translationX: 0, y: screenHeight - 44)

        UIView.animate(withDuration: 0.2, delay: 0, options: .curveEaseOut, animations: {
            self.backgroundView.alpha = 0.7
            self.wordDetailView.transform = .identity
            
        }) { (isCompleted) in
            
        }
    }
}
