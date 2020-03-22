//
//  YYNetworkService.swift
//  YouYou
//
//  Created by pyyx on 2018/10/23.
//  Copyright © 2018 YueRen. All rights reserved.
//

import Foundation
import Alamofire
import AlamofireObjectMapper
import ObjectMapper
import CocoaLumberjack

enum YXMiMeType: String {
    case image = "image/jpeg"
    case file  = "application/octet-stream"
}

struct YYNetworkService {
    public static let `default` = YYNetworkService()
    public let networkManager = NetworkReachabilityManager()
    
    private let maxOperationCount: Int = 3
    private let timeout: TimeInterval = 15
    
    private var sessionManager: SessionManager!
    
    private var defaultConfiguration: URLSessionConfiguration {
        let _configuration = URLSessionConfiguration.default
        _configuration.timeoutIntervalForRequest = timeout
        return _configuration
    }
    
    
    private init() {
        // 网络权限管理
        YXNetworkAuthManager.default.check()
        
        sessionManager = Alamofire.SessionManager.init(configuration: self.defaultConfiguration)
        sessionManager.session.delegateQueue.maxConcurrentOperationCount = maxOperationCount
    }
    
    //MARK: ----------------- Request -----------------
    /**
     *  普通HTTP Request, 支持GET、POST方式
     */
    @discardableResult
    public func request <T> (_ type: T.Type, request: YYBaseRequest, success: ((_ response: T) -> Void)?, fail: ((_ responseError: NSError) -> Void)?) -> YYTaskRequest? where T: YYBaseResopnse {
        
        // 先判断是否有网络
        if !isReachable {
            
            // 没有网络时，判断授权是否打开
            if !isAuth {
                fail?(authError)
                YXAuthorizationManager.authorizeNetwork()
                YXLog("【网络权限被关闭】 error: ", authError.message)
                return nil
            }
            
            fail?(networkError)
            YXLog("【没有网络】 error: ", networkError.message)
            
            return nil
        }
        
        // 方式1: 设置到body中
        if request.isHttpBody {
            var urlRequest = URLRequest(url: request.url)
            urlRequest.httpMethod = request.method.rawValue
            urlRequest.allHTTPHeaderFields = request.handleHeader(parameters: removeNilValue(request.parameters))
            
            if let params = removeNilValue(request.parameters) {
                urlRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
                urlRequest.httpBody = (params["json"] as? String)?.data(using: .utf8)
            }
            return self.postBody(type, request: urlRequest, success: { (response, httpStatusCode) in
                self.handleStatusCodeLogicResponseObject(response, statusCode: httpStatusCode, request: request, success: success, fail: fail)
            }, fail: { (error) in
                fail?(error as NSError)
            })
        }
        
        // 方式2: 表单提交方式，[Get & Post]
        return self.httpRequest(type, request: request, success: { (response, statusCode) in
            self.handleStatusCodeLogicResponseObject(response, statusCode: statusCode, request: request, success: success, fail: fail)
        }) { (error) -> Void? in
            YXUtils.showHUD(kWindow, title: error.message)
            fail?(error as NSError)
            return nil
        }
    }
    
    public func download <T> (_ type: T.Type, request: YYBaseRequest, localSavePath: String, success: ((_ response: T) -> Void)?, fail: ((_ responseError: NSError) -> Void)?) -> Void where T: YYBaseResopnse {
        
        let params = removeNilValue(request.parameters)
        Alamofire.download(request.url, method: HTTPMethod(rawValue: request.method.rawValue) ?? .get, parameters: params, headers: request.handleHeader(parameters: params, headers: request.header)) { (url, response) -> (destinationURL: URL, options: DownloadRequest.DownloadOptions) in
            let path = YYFileManager.share.createPath(documentPath: localSavePath)
            return (URL(fileURLWithPath: path), [.removePreviousFile, .createIntermediateDirectories])
            }.downloadProgress { (progress) in
                YXRequestLog("progress.completedUnitCount is \(progress.completedUnitCount)")
            }.response { (defaultDownloadResponse) in
                
        }
    }
    
    /**
     *  文件内容上传 Request
     */
    public func upload <T> (_ type: T.Type, request: YYBaseRequest, mimeType: String = YXMiMeType.image.rawValue, fileName: String = "photo", success: ((_ response: T) -> Void)?, fail: ((_ responseError: NSError) -> Void)?) -> Void where T: YYBaseResopnse {
        
        guard let parameters = request.parameters else {
            return
        }
        
        // 文件参数名称
        let name: String = "file"
                
        // 去除空值，删除文件参数
        var params = removeNilValue(parameters) ?? [:]
        if params.keys.contains(name) {
            params.removeValue(forKey: name)
        }
        
        // 构建新的header
        var headers = request.header
        headers["Content-Type"] = "multipart/form-data"
        headers = request.handleHeader(parameters: params, headers: headers)
        
        // 转换对象
        let method = HTTPMethod(rawValue: request.method.rawValue) ?? .post
    
        sessionManager.upload(multipartFormData: { (multipartFormData) in
            guard let fileData = parameters[name] else {
                return
            }
            
            // 文件数据 （先放前面）
            if fileData is String {
                multipartFormData.append(URL(fileURLWithPath:(fileData as! String)), withName: name, fileName: fileName, mimeType: mimeType)
            } else if fileData is Data {
                multipartFormData.append(fileData as! Data, withName: name, fileName: fileName, mimeType: mimeType)
            }
            
            // 普通表单参数 （放在文件数据的后面还是前面，要看后端接口的支持情况，目前是放在后面）
            // 普通表单数据使用 params 填充，删除了文件数据的
            for (key, value) in params {
                if let data = "\(value)".data(using: String.Encoding.utf8) {
                    multipartFormData.append(data, withName: key)
                }
            }
            
        }, usingThreshold: UInt64.init(), to: request.url, method: method , headers: headers) { (result) in
            switch result {
            case .success(let upload, _, _):
                upload.responseObject(completionHandler: { (response: DataResponse <T>) in
                    switch response.result {
                    case .success(let x):
                        self.handleStatusCodeLogicResponseObject(x, statusCode: (response.response?.statusCode) ?? 0, request: request, success: success, fail: fail)
                    case .failure(let error):
                        fail?(error as NSError)
                    }
                })
            case .failure(let error):
                fail?(error as NSError)
            }
        }
        
    }
    
    //MARK: ----------------- Method -----------------
    @discardableResult
    private func postBody <T> (_ type: T.Type, request: URLRequest, success:@escaping (_ response: T, _ httpStatusCode: Int) -> Void?, fail: @escaping (_ error: NSError) -> Void?) -> YYTaskRequest where T: YYBaseResopnse {

        let request = sessionManager.request(request).responseObject { (response: DataResponse<T>) in
            switch response.result {
            case .success(var x):
                x.response = response.response
                x.request = response.request
                success(x, (response.response?.statusCode) ?? 0)
            case .failure(let error):
                fail(error as NSError)
            }
        }

        let taskRequest: YYTaskRequest = YYTaskRequestModel(request: request)
        return taskRequest
    }
    
    
    //MARK: Process
    private func httpRequest <T>(_ type: T.Type, request: YYBaseRequest, success:@escaping (_ response: T, _ httpStatusCode: Int) -> Void, fail: @escaping (_ error: NSError) -> Void?) -> YYTaskRequest? where T: YYBaseResopnse {
        
        let params = removeNilValue(request.parameters)
        let header = request.handleHeader(parameters: params)
        let encoding: ParameterEncoding = (request.method == .get) ? URLEncoding.default : URLEncoding.httpBody
        let method = HTTPMethod(rawValue: request.method.rawValue) ?? .get
        YXRequestLog(String(format: "%@ = request url:%@ params:%@", method.rawValue, request.url.absoluteString, params?.toJson() ?? ""))

        let task = sessionManager.request(request.url, method: method, parameters: params, encoding: encoding, headers: header)
        task.responseObject { (response: DataResponse <T>) in
            switch response.result {
            case .success(var x):
                if let data = response.data, let dataStr = String(data: data, encoding: String.Encoding.utf8) {
                    YXRequestLog(String(format: "【Success】 request url: %@, respnseObject: %@", request.url.absoluteString, dataStr))
                }
                x.response = response.response
                x.request  = response.request
                success(x, (response.response?.statusCode) ?? 0)
            case .failure(let error):
                let msg = (error as NSError).message
                YXRequestLog(String(format: "【❌Fail】 %@ = request url:%@ parames:%@, error:%@", method.rawValue, request.url.absoluteString, params?.toJson() ?? "", msg))
                fail(error as NSError)
            }
        }
        
        let taskRequest: YYTaskRequest = YYTaskRequestModel(request: task)
        return taskRequest
    }
    
    
    
    
    //MARK: ----------------- Response -----------------
    /**R
     *  请求状态码逻辑处理
     */
    private func handleStatusCodeLogicResponseObject <T> (_ response: T, statusCode: Int, request: YYBaseRequest, success: ((_ response: T) -> Void)?, fail: ((_ responseError: NSError) -> Void)?) -> Void where T: YYBaseResopnse {
        let baseResponse = response as YYBaseResopnse
        let responseStatusCode: Int = baseResponse.statusCode

        if responseStatusCode == 0 {
            success?(response)
            
        } else {
            if responseStatusCode == 10002 {
                // 当登录状态失效时，通知上层
                YXMediator.shared()?.tokenExpired()
            } else if responseStatusCode == 6666 {
                // 停服
                let serviceStop = YXNotification.kServiceStop
                NotificationCenter.default.post(name: serviceStop, object: baseResponse.statusMessage)
            
            } else if responseStatusCode == 10003 {
                YXMediator.shared().userKickedOut()
                
            }
            
            // 把错误抛会上层
            if let errorMsg = baseResponse.statusMessage {
                fail?(NSError(domain: "com.youyou.httpError", code: responseStatusCode, userInfo: [NSLocalizedDescriptionKey : errorMsg]))
            }
            
        }
    }

    
    /// 删除空的值
    /// - Parameter parameters: 参数集合
    private func removeNilValue(_ parameters: [String : Any?]?) -> [String : Any]? {
        guard let _parameters = parameters else  {
            return nil
        }
        var params: [String : Any] = [ : ]
        for (key, value) in _parameters {
            if let v = value {
                params[key] = v
            }
        }
        return params.count > 0 ? params : nil
    }
    
    
    public func retryRequest() {
        
        //                YXUserModel.default.updateToken { (result) in
        //                    if result {
        //                        self.retryRequest()
        //                    }
        //                }
        //                YXTokenExpired.default.addRequest(request: request, response: response, callback: success, fail: fail)
        
        
        
//        let callback = YXTokenExpired.default.callbacks.first as? ((YYBaseResopnse) -> Void)
//        let fail = YXTokenExpired.default.fails.first as? ((_ responseError: NSError) -> Void)
//
//        if let req = YXTokenExpired.default.requests.first,
//            let type = YXTokenExpired.default.types.first as? YYBaseResopnse {
//            self.request(type, request: req, success: callback, fail: fail)
//        }
    }
}
