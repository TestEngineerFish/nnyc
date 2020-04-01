//
//  YRWebViewRecordAudioAction.swift
//  SongShuAI
//
//  Created by sunwu on 2020/3/13.
//  Copyright © 2020 yx. All rights reserved.
//

import UIKit

class YRWebViewRecordAudioAction: YRWebViewJSAction {
    var actionModel: RecordAudioActionModel?
    
    override func action() {
        super.action()
        
        if let json = self.params as? [String: Any] {
            actionModel = RecordAudioActionModel(JSON: json)
        }
    }
}



extension Data {
    mutating func append(_ string: String, using encoding: String.Encoding = .utf8) {
        if let data = string.data(using: encoding) {
            append(data)
        }
    }
}
