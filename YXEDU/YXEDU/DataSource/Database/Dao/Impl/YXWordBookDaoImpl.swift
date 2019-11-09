//
//  YXWordDaoImpl.swift
//  YXEDU
//
//  Created by sunwu on 2019/11/8.
//  Copyright © 2019 shiji. All rights reserved.
//

import UIKit
import ObjectMapper

class YXWordBookDaoImpl: YYDatabase, YXWordBookDao {

    func insertBook(book: YXWordBookModel) -> Bool {
        return true
    }
    
    func selectBookHash(bookId: Int) -> String {
        return ""
    }
    
    func deleteBook(bookId: Int) -> Bool {
        return true
    }
    
    func insertWord(word: YXWordModel) -> Bool {
        return true
    }
    
    func deleteWord(bookId: Int) -> Bool {
        return true
    }
    
    
    func selectWord(wordId: Int) -> YXWordModel? {
        let json = """
            [{
                "en": "You have such a good chance.",
                "cn": "你有这么一个好的机会。",
                "voice": "/speech/a00c5c2830ffc50a68f820164827f356.mp3"
            }]
        """
        var word = YXWordModel()
        if let examples = Array<YXWordExampleModel>(JSONString: json){
            word.examples = examples
        }
        word.wordId = wordId
        word.gardeType = 2
        return word
    }
    

}
