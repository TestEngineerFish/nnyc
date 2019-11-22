//
//  YXWordDetailViewController.swift
//  YXEDU
//
//  Created by Jake To on 11/12/19.
//  Copyright © 2019 shiji. All rights reserved.
//

import UIKit

@objc
class YXWordDetailViewControllerNew: UIViewController {
    var word: YXWordModel?
    @objc var wordId: Int = 0
    var dismissClosure: (() -> Void)?

    private var wordDetailView: YXWordDetailView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if wordId != 0 {
            YXWordBookDaoImpl().selectWord(wordId: wordId) { (word, isSuccess) in
                guard let word = word as? YXWordModel else { return }
                
                wordDetailView = YXWordDetailView(frame: self.view.bounds, word: word)
                wordDetailView.dismissClosure = dismissClosure
                self.view.addSubview(wordDetailView)
            }

        } else if let word = word {
            wordDetailView = YXWordDetailView(frame: self.view.bounds, word: word)
            wordDetailView.dismissClosure = dismissClosure
            self.view.addSubview(wordDetailView)
        }
    }
}
