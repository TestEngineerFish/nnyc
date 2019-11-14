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

        let word = YXWordModel(JSONString:
        """
        {
            "word_id" : 1,
            "unit_id" : 1,
            "is_ext_unit" : 0,
            "book_id" : 1,
            "word" : "good",
            "word_property" : "adj.",
            "word_paraphrase" : "好的;优质的;",
            "word_image" : "http://static.51jiawawa.com/images/goods/20181114165122185.png",
            "symbol_us" : "美/ɡʊd/",
            "symbol_uk" : "英/ɡʊd/",
            "voice_us" : "http://cdn.xstudyedu.com/res/rj_45/voice/overnight_uk.mp3",
            "voice_uk" : "http://cdn.xstudyedu.com/res/rj_45/voice/overnight_uk.mp3",
            "example_en" : "You have such a <font color='#55a7fd'>good</font> chance.",
            "example_cn" : "你有这么一个好的机会。",
            "example_voice": "http://cdn.xstudyedu.com/res/rj_45/voice/overnight_uk.mp3",
            "synonym": "great,helpful",
            "antonym": "poor,bad",
            "usage":  ["adj.+n.  early morning 清晨","n.+n.  morning exercise早操"]
        }
        """)
        
        wordDetailView = YXWordDetailView(frame: CGRect(x: 0, y: 40, width: screenWidth, height: screenHeight - 120), word: word!)
        wordDetailView.dismissClosure = dismissClosure
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
