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
        if self.collectionButton.currentImage == #imageLiteral(resourceName: "unCollectWord") {
            let request = YXWordListRequest.cancleCollectWord(wordIds: "[{\"w\":\(word.wordId ?? 0),\"is\":\(word.isComplexWord ?? 0)},")
            YYNetworkService.default.request(YYStructResponse<YXResultModel>.self, request: request, success: { (response) in
                self.collectionButton.setImage(#imageLiteral(resourceName: "collectWord"), for: .normal)
                
            }) { (error) in
                
            }
            
        } else {
            let request = YXWordListRequest.collectWord(wordId: word.wordId ?? 0, isComplexWord: word.isComplexWord ?? 0)
            YYNetworkService.default.request(YYStructResponse<YXResultModel>.self, request: request, success: { (response) in
                self.collectionButton.setImage(#imageLiteral(resourceName: "unCollectWord"), for: .normal)
                
            }) { (error) in
                
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
        
        let request = YXWordListRequest.didCollectWord(wordId: word.wordId ?? 0)
        YYNetworkService.default.request(YYStructResponse<YXResultModel>.self, request: request, success: { (response) in
            if response.data?.didCollectWord == 1 {
                self.collectionButton.setImage(#imageLiteral(resourceName: "unCollectWord"), for: .normal)

            } else {
                self.collectionButton.setImage(#imageLiteral(resourceName: "collectWord"), for: .normal)
            }
            
        }) { (error) in
            
        }
    }
}
