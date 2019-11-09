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
        let json = ""                
        var word = YXWordModel()
        if let examples = Mapper<YXWordExampleModel>().map(JSONString: json) {
            word.examples = [examples]
        }
        
        return word
    }
    

}
