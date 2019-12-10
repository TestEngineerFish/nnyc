//
//  YXWordListViewController.swift
//  YXEDU
//
//  Created by Jake To on 12/9/19.
//  Copyright © 2019 shiji. All rights reserved.
//

import UIKit

enum YXWordListType {
    case learned
    case notLearned
    case collected
    case wrongWords
}

class YXWordListViewController: UIViewController {

    var wordListType: YXWordListType = .learned
    
    private var learnedWords: [YXWordModel] = []
    private var notLearnedWords: [YXWordModel] = []
    private var collectedWords: [YXWordModel] = []
    private var wrongWords: [YXWordModel] = []

    @IBAction func back(_ sender: UIBarButtonItem) {
        navigationController?.popViewController(animated: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        switch wordListType {
        case .learned:
            break
            
        case .notLearned:
            break
            
        case .collected:
            break
            
        case .wrongWords:
            break
        }
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
