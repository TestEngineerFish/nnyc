//
//  YXWordDetailViewController.swift
//  YXEDU
//
//  Created by Jake To on 11/12/19.
//  Copyright © 2019 shiji. All rights reserved.
//

import UIKit

class YXWordDetailViewControllerNew: UIViewController {
    @IBOutlet weak var collectionButton: UIBarButtonItem!

    @objc var wordId: Int = -1
    @objc var isComplexWord: Int = 0
    private var wordDetailView: YXWordDetailCommonView!

    override func handleData(withQuery query: [AnyHashable : Any]!) {
        self.wordId = query["word_id"] as? Int ?? -1
        self.isComplexWord = query["is_complex_word"] as? Int ?? 0
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let didCollectWordRequest = YXWordListRequest.didCollectWord(wordId: wordId)
        YYNetworkService.default.request(YYStructResponse<YXResultModel>.self, request: didCollectWordRequest, success: { (response) in
            if response.data?.didCollectWord == 1 {
                self.collectionButton.image = #imageLiteral(resourceName: "unCollectWord")

            } else {
                self.collectionButton.image = #imageLiteral(resourceName: "collectWord")
            }
            
        }) { error in
            print("❌❌❌\(error)")
        }
        
        let wordDetailRequest = YXWordBookRequest.wordDetail(wordId: wordId, isComplexWord: isComplexWord)
        YYNetworkService.default.request(YYStructResponse<YXWordModel>.self, request: wordDetailRequest, success: { (response) in
            guard let word = response.data else { return }
            
            self.wordDetailView = YXWordDetailCommonView(frame: CGRect(x: 0, y: 0, width: screenWidth, height: screenHeight - kNavHeight), word: word)
            self.view.addSubview(self.wordDetailView)
            
        }) { error in
            print("❌❌❌\(error)")
        }
        
//        if let word = YXWordBookDaoImpl().selectWord(wordId: wordId) {
//            wordDetailView = YXWordDetailCommonView(frame: CGRect(x: 0, y: 0, width: screenWidth, height: screenHeight - kNavHeight), word: word)
//            self.view.addSubview(wordDetailView)
//        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(false, animated: animated)
    }
    
    @IBAction func back(_ sender: UIBarButtonItem) {
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func collectWord(_ sender: UIBarButtonItem) {
        if self.collectionButton.image == #imageLiteral(resourceName: "unCollectWord") {
            let request = YXWordListRequest.cancleCollectWord(wordIds: "[{\"w\":\(wordId ?? 0),\"is\":\(isComplexWord ?? 0)}]")
            YYNetworkService.default.request(YYStructResponse<YXResultModel>.self, request: request, success: { (response) in
                self.collectionButton.image = #imageLiteral(resourceName: "collectWord")

            }) { error in
                print("❌❌❌\(error)")
            }
            
        } else {
            let request = YXWordListRequest.collectWord(wordId: wordId, isComplexWord: isComplexWord)
            YYNetworkService.default.request(YYStructResponse<YXResultModel>.self, request: request, success: { (response) in
                self.collectionButton.image = #imageLiteral(resourceName: "unCollectWord")

            }) { error in
                print("❌❌❌\(error)")
            }
        }
    }
    
    @IBAction func feedbackWord(_ sender: UIBarButtonItem) {
        YXReportErrorView.show(to: self.view)
    }
}
