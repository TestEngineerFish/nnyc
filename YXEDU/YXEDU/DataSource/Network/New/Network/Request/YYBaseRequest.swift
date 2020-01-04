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
}

protocol YYBaseRequest {
    var method: YYHTTPMethod { get }
    var header: [String : String] { get }
    var parameters: [String : Any?]? { get }
    var url: URL { get }
    var path: String { get }
        
    /// 参数值是否需要设置到body中，如果是请重写该方法，默认为表单方式提交
    var isHttpBody: Bool { get }
        
    /// 设置header，包括加密方式
    /// - Parameters:
    ///   - parameters: 参数集合
    ///   - headers: 默认header
    func handleHeader(parameters: [String : Any]?, headers: [String : String]?) -> [String : String]
}

extension YYBaseRequest {

    public var header: [String : String] {
        let _header = ["NNYC-TOKEN" : YXConfigure.shared()?.token ?? "",
                       "NNYC-REQUESTTIME" : YXConfigure.shared()?.time ?? "",
                       "NNYC-PLATFORM" : kPlatformValue,
                       "NNYC-VERSION" : UIDevice().appVersion()?.replacingOccurrences(of: ".", with: "") ?? "",
                       "NNYC-VERSION-NAME" : UIDevice().appVersion() ?? ""]
        
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
        let bUrl = baseURL.absoluteString
        if bUrl.hasSuffix("/") == false && path.hasPrefix("/") == false {
            return URL(string: bUrl + "/" + path)!
        }                
        return URL(string: bUrl + path)!
    }
    
    public var path: String { return "" }
    
    public var isHttpBody: Bool { return false }
    
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


