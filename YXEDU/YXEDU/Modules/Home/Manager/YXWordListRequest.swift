//
//  YXWordListRequest.swift
//  YXEDU
//
//  Created by Jake To on 12/10/19.
//  Copyright © 2019 shiji. All rights reserved.
//

import UIKit

public enum YXWordListRequest: YYBaseRequest {
    case wordList(type: Int, page: Int)
    case wrongWordList
    case collectWord(wordId: Int, isComplexWord: Int)
    case cancleCollectWord(wordIds: String)
    case deleteWrongWord(wordIds: String)
    case didCollectWord(wordId: Int)
}

extension YXWordListRequest {
    var method: YYHTTPMethod {
        switch self {
        case .wordList, .wrongWordList, .didCollectWord:
            return .get
            
        case .collectWord, .cancleCollectWord, .deleteWrongWord:
            return .post
        }
    }
}

extension YXWordListRequest {
    var path: String {
        switch self {
        case .wordList:
            return YXAPI.WordList.wordList
            
        case .wrongWordList:
            return YXAPI.WordList.wrongWordList
            
        case .collectWord:
            return YXAPI.WordList.collectWord
            
        case .cancleCollectWord:
            return YXAPI.WordList.cancleCollectWord
            
        case .deleteWrongWord:
            return YXAPI.WordList.deleteWrongWord
            
        case .didCollectWord:
            return YXAPI.WordList.didCollectWord
        }
    }
}

extension YXWordListRequest {
    var parameters: [String : Any?]? {
        switch self {
        case .wordList(let type, let page):
            return ["type": type, "page": page]
            
        case .collectWord(let wordId, let isComplexWord):
            return ["word_id": wordId, "is_synthesis": isComplexWord]
            
        case .cancleCollectWord(let wordIds):
            return ["word_ids": wordIds]
            
        case .deleteWrongWord(let wordIds):
            return ["word_ids": wordIds]
            
        case .didCollectWord(let wordId):
            return ["word_id": wordId]
            
        default:
            return nil
        }
    }
}
