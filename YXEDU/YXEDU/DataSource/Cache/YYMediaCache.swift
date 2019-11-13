//
//  YYMediaCache.swift
//  YouYou
//
//  Created by sunwu on 2019/5/23.
//  Copyright © 2019 YueRen. All rights reserved.
//

import KTVHTTPCache
import AVKit

class YYMediaCache: NSObject {
    
    public static let `default` = YYMediaCache()
    
    private override init() {
        super.init()
        
        do {
            try  KTVHTTPCache.proxyStart()
        } catch let error {
            print(error)
        }
        
    }
    
    public func proxyUrl(_ url: URL) -> URL {
        guard let proxyUrl = KTVHTTPCache.proxyURL(withOriginalURL: url) else {
            return url
        }        
        return proxyUrl
    }
    
    
    public func playerItem(_ url: URL) -> AVPlayerItem {
        let item = AVPlayerItem(url: self.proxyUrl(url))
        return item
    }

    
}
