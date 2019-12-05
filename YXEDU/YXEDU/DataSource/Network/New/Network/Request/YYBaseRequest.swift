//
//  YYBaseRequest.swift
//  YouYou
//
//  Created by pyyx on 2018/10/25.
//  Copyright © 2018 YueRen. All rights reserved.
//

import Foundation

let kSault = "NvYP1OeQZqzJdxt8"

public enum YYHTTPMethod: String {
    case options = "OPTIONS"
    case get     = "GET"
    case head    = "HEAD"
    case post    = "POST"
    case put     = "PUT"
    case patch   = "PATCH"
    case delete  = "DELETE"
    case body    = "BODY"
}

protocol YYBaseRequest {
    var method: YYHTTPMethod { get }
    var header: [String : String] { get }
    var parameters: [String : Any?]? { get }
    var url: URL { get }
    var path: String { get }
    
    func handleHeader(parameters: [String : Any]?, headers: [String : String]?) -> [String : String]
}

extension YYBaseRequest {

    public var header: [String : String] {
        let _header = ["NNYC-TOKEN" : YXConfigure.shared()?.token ?? "",
                       "NNYC-REQUESTTIME" : YXConfigure.shared()?.time ?? "",
                       "NNYC-PLATFORM" : kPlatformValue,
                       "NNYC-VERSION" : UIDevice().appVersion()?.replacingOccurrences(of: ".", with: "") ?? ""]
        
        return _header
    }
    
    public var parameters: [String : Any?]? {
        return nil
    }
    
    public var baseURL: URL {
        return URL(string: YYEVC.apiUrl)!
    }
    
    public var method: YYHTTPMethod {
        return .get
    }
    
    public var url: URL {
        return URL(string: baseURL.absoluteString + path)!
    }
    
    public var path: String { return "" }
    
    func handleHeader(parameters: [String : Any]?, headers: [String : String]? = nil) -> [String : String] {
        
        var _header: [String : String] = self.header
        if headers != nil { _header = headers!}
        
        var kv: [String] = []
        let sortKeys: [String] = parameters?.keys.sorted() ?? []
        for key in sortKeys {
            if let value = parameters?[key] {
                kv.append("\(key)=\(value)")
            }
        }
        
        var sign = ""
        if kv.count > 0 {
            let array = kv as NSArray
            sign.append(array.componentsJoined(by: "&"))
        }
                
        if let time = _header["NNYC-REQUESTTIME"], time.count > 0 {
            sign.append("#\(time)#")
        } else {
            sign.append("#0#")
        }
        
        sign.append("\(kSault)@")
        
        if let token = _header["NNYC-TOKEN"], token.count > 0 {
            sign.append("#\(token)#")
        }
                
        if let data = sign.data(using: .utf8) as NSData? {
            _header["NNYC-SIGN"] = data.md5String()
        }

        return _header
    }
    
}


