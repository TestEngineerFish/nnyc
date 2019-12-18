//
//  YXSearchDataManager.swift
//  YXEDU
//
//  Created by sunwu on 2019/12/17.
//  Copyright © 2019 shiji. All rights reserved.
//

import Foundation


struct YXSearchDataManager {
    
    func searchData(keyword: String, completion: ((_ model: YXSearchWordListModel?, _ errorMsg: String?) -> Void)?) {
        let request = YXSearchRequest.search(keyword: keyword)
        YYNetworkService.default.request(YYStructResponse<YXSearchWordListModel>.self, request: request, success: { (response) in
            completion?(response.data, nil)
        }) { (error) in
            completion?(nil, error.message)
        }
    }
    
    
    
}
