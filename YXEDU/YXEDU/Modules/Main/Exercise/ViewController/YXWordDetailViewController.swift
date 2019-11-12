//
//  YXWordDetailViewControllerOld.swift
//  YXEDU
//
//  Created by Jake To on 11/12/19.
//  Copyright © 2019 shiji. All rights reserved.
//

import UIKit

class YXWordDetailViewController: UIViewController {
    private var wordDetailView: YXWordDetailCommonView!

    @IBOutlet weak var collectionButton: UIButton!
    
    @IBAction func collectWord(_ sender: UIButton) {
        
    }
    
    @IBAction func feedbackWord(_ sender: UIButton) {
        
    }
    
    @IBAction func continueStudy(_ sender: UIButton) {
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let word = YXWordModel(JSONString:
            """
            {
            "word_id" : 1,
            "unit_id" : 1,
            "is_ext_unit" : 0,
            "book_id" : 1,
            "property" : [
                {
                    "name" : "adj.",
                    "paraphrase" : "好的;优质的;"
                },
                {
                    "name" : "n.",
                    "paraphrase" : "合乎道德的行为;正直的行为;善行;"
                }
            ],
            "word" : "good",
            "symbol_us" : "美/ɡʊd/",
            "symbol_uk" : "英/ɡʊd/",
            "voice_us" : "voice/good_us.mp3",
            "voice_uk" : "voice/good_uk.mp3",
            "example_list" : [
                {
                    "en" : "You have such a <font color='#55a7fd'>good</font> chance.",
                    "cn" : "你有这么一个好的机会。",
                    "voice": "/speech/a00c5c2830ffc50a68f820164827f356.mp3"
                },
                {
                    "en" : "You have such a <font color='#55a7fd'>good</font> chance.",
                    "cn" : "你有这么一个好的机会。",
                    "voice": "/speech/a00c5c2830ffc50a68f820164827f356.mp3"
                }
            ],
            "image" : "/middle/good/1570699002.jpg",
            "synonym": "great,helpful",
            "antonym": "poor,bad",
            "usage_list": ["adj.+n.  good health 身体健康", "v.+adj.  look good 看起来不错"]
        }
        """)
        
        wordDetailView = YXWordDetailCommonView(frame: CGRect(x: 0, y: 40, width: screenWidth, height: screenHeight - 120), word: word!)
        self.view.addSubview(wordDetailView)
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
