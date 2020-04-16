//
//  YXWordDetailView.swift
//  YXEDU
//
//  Created by Jake To on 11/14/19.
//  Copyright © 2019 shiji. All rights reserved.
//

import UIKit

class YXWordDetailView: UIView {
    
    var dismissClosure: (() -> Void)?
    
    private var word: YXWordModel!
    private var wordDetailView: YXWordDetailCommonView!
    
    @IBOutlet var contentView: UIView!
        
    @IBAction func continueStudy(_ sender: UIButton) {
        self.dismissClosure?()
    }
    
    init(frame: CGRect, word: YXWordModel) {
        super.init(frame: frame)
        self.word = word
        
        initializationFromNib()
    }

    deinit {
        YXLog("释放\(self.classForCoder)")
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        initializationFromNib()
    }
    
    private func initializationFromNib() {
        Bundle.main.loadNibNamed("YXWordDetailView", owner: self, options: nil)
        addSubview(contentView)
        contentView.frame = self.bounds
        
        wordDetailView = YXWordDetailCommonView(frame: CGRect(x: 0, y: 40, width: self.frame.width, height: self.frame.height - self.frame.minY - kSafeBottomMargin - 80), word: word!)
        self.addSubview(wordDetailView)
    }
}
