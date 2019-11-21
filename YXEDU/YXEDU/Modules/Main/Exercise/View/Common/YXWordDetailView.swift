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
    @IBOutlet weak var collectionButton: UIButton!
    
    @IBAction func collectWord(_ sender: UIButton) {
        YXWordModelManager.keepWordId("\(word.wordId ?? 0)", bookId: "\(word.bookId ?? 0)", isFav: collectionButton.currentImage == UIImage(named: "collectWord")) { [weak self] (response, isSuccess) in
            guard let self = self, isSuccess else { return }
            if self.collectionButton.currentImage == UIImage(named: "collectWord") {
                self.collectionButton.setImage(UIImage(named: "unCollectWord"), for: .normal)

            } else {
                self.collectionButton.setImage(UIImage(named: "collectWord"), for: .normal)
            }
        }
    }
    
    @IBAction func feedbackWord(_ sender: UIButton) {
        YXReportErrorView.show(to: self)
    }
    
    @IBAction func continueStudy(_ sender: UIButton) {
        self.dismissClosure?()
    }
    
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
        contentView.frame = self.bounds
        
        wordDetailView = YXWordDetailCommonView(frame: CGRect(x: 0, y: 40, width: self.frame.width, height: self.frame.height - 164), word: word!)
        self.addSubview(wordDetailView)
    }
}
