//
//  YRWebViewRecordAudioAction.swift
//  SongShuAI
//
//  Created by sunwu on 2020/3/13.
//  Copyright © 2020 yx. All rights reserved.
//

import UIKit

class YRWebViewShareAction: YRWebViewJSAction {
    var actionModel: ShareActionModel?
    
    override func action() {
        super.action()
        
        if let json = self.params as? [String: Any] {
            actionModel = ShareActionModel(JSON: json)
        }
        
    }
}
