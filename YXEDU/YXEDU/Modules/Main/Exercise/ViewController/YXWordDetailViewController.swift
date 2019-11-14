//
//  YXWordDetailViewControllerOld.swift
//  YXEDU
//
//  Created by Jake To on 11/12/19.
//  Copyright © 2019 shiji. All rights reserved.
//

import UIKit

class YXWordDetailViewController: UIViewController {
    var word: YXWordModel!
    var dismissClosure: (() -> Void)?

    private var wordDetailView: YXWordDetailView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        wordDetailView = YXWordDetailView(frame: self.view.bounds, word: word!)
        wordDetailView.dismissClosure = dismissClosure
        self.view.addSubview(wordDetailView)
    }
}
