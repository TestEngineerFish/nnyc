//
//  YXWordDetailViewController.swift
//  YXEDU
//
//  Created by Jake To on 11/12/19.
//  Copyright © 2019 shiji. All rights reserved.
//

import UIKit

class YXWordDetailViewControllerNew: UIViewController {
    var word: YXWordModel?

    private var wordDetailView: YXWordDetailCommonView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let word = word {
            wordDetailView = YXWordDetailCommonView(frame: CGRect(x: 0, y: 0, width: screenWidth, height: screenHeight - kNavHeight), word: word)
            self.view.addSubview(wordDetailView)
        }
    }
}
