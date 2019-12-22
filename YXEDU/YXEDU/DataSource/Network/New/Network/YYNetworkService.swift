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
                return nil
            }
            
            fail?(networkError)
            return nil
        }
        
        
        if request.method == .post {
            var urlRequest = URLRequest(url: request.url)
            urlRequest.httpMethod = request.method.rawValue
            urlRequest.allHTTPHeaderFields = request.handleHeader(parameters: removeNilValue(request.parameters))
            
            do {
                if let params = removeNilValue(request.parameters) {
                    if request.isHttpBody {
                        urlRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
                        urlRequest.httpBody = (params["json"] as? String)?.data(using: .utf8)
                    } else {
                        try urlRequest.httpBody = JSONSerialization.data(withJSONObject: params, options: [])
                    }
                }
                return self.post(type, request: urlRequest, success: { (response, httpStatusCode) in
                    self.handleStatusCodeLogicResponseObject(response, statusCode: httpStatusCode, request: request, success: success, fail: fail)
                }, fail: { (error) in
                    fail?(error as NSError)
                })
            } catch let parseError {
                fail?(parseError as NSError)
                return nil
            }
        } else {
            return self.get(type, request: request, header: request.handleHeader(parameters: removeNilValue(request.parameters)), success: { (response, httpStatusCode) in
                self.handleStatusCodeLogicResponseObject(response, statusCode: httpStatusCode, request: request, success: success, fail: fail)
            }, fail: { (error) in
                fail?(error as NSError)
            })
        }
    }
    
    
    public func download <T> (_ type: T.Type, request: YYBaseRequest, localSavePath: String, success: ((_ response: T) -> Void)?, fail: ((_ responseError: NSError) -> Void)?) -> Void where T: YYBaseResopnse {
        
        let params = removeNilValue(request.parameters)
        Alamofire.download(request.url, method: HTTPMethod(rawValue: request.method.rawValue) ?? .get, parameters: params, headers: request.handleHeader(parameters: params, headers: request.header)) { (url, response) -> (destinationURL: URL, options: DownloadRequest.DownloadOptions) in
            let path = YYFileManager.share.createPath(documentPath: localSavePath)
            return (URL(fileURLWithPath: path), [.removePreviousFile, .createIntermediateDirectories])
            }.downloadProgress { (progress) in
                DispatchQueue.main.async {
                    DDLogInfo("progress.completedUnitCount is \(progress.completedUnitCount)")
                }
            }.response { (defaultDownloadResponse) in
                
        }
        
    }
    
    /**
     *  文件内容上传 Request
     */
    public func upload <T> (_ type: T.Type, request: YYBaseRequest, mimeType: String = "image/jpeg", fileName: String = "photo", success: ((_ response: T) -> Void)?, fail: ((_ responseError: NSError) -> Void)?) -> Void where T: YYBaseResopnse {
        
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
    private func get <T>(_ type: T.Type, request: YYBaseRequest, header:[String:String], success:@escaping (_ response: T, _ httpStatusCode: Int) -> Void, fail: @escaping (_ error: NSError) -> Void?) -> YYTaskRequest where T: YYBaseResopnse {
        let encoding: ParameterEncoding = (.get == request.method ? URLEncoding.default : JSONEncoding.default)
        let request = sessionManager.request(request.url, method: HTTPMethod(rawValue: request.method.rawValue) ?? .get, parameters: removeNilValue(request.parameters), encoding: encoding, headers: header).responseObject { (response: DataResponse <T>) in

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
    
    
    @discardableResult
    private func post <T> (_ type: T.Type, request: URLRequest, success:@escaping (_ response: T, _ httpStatusCode: Int) -> Void?, fail: @escaping (_ error: NSError) -> Void?) -> YYTaskRequest where T: YYBaseResopnse {
        
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
    
    //MARK: ----------------- Response -----------------
    /**R
     *  请求状态码逻辑处理
     */
    private func handleStatusCodeLogicResponseObject <T> (_ response: T, statusCode: Int, request: YYBaseRequest, success: ((_ response: T) -> Void)?, fail: ((_ responseError: NSError) -> Void)?) -> Void where T: YYBaseResopnse {
        let baseResponse = response as YYBaseResopnse
        let responseStatusCode : Int = baseResponse.statusCode
        
        if responseStatusCode == 0 {
            success?(response)
        } else {
            if responseStatusCode == 10106 {
                // 当登录状态失效时，通知上层
//                let loginExpired = Notification.Name(YYNotificationCenter.kLoginStatusExpired)
//                NotificationCenter.default.post(name: loginExpired, object: nil)
            } else if responseStatusCode == 10109 {
                // 停服
                let serviceStop = YXNotification.kServiceStop
                NotificationCenter.default.post(name: serviceStop, object: baseResponse.statusMessage)
            }
//            else if responseStatusCode == 10107 {
//                //用户资料信息审核不通过
//                let infoBlocked = Notification.Name(YYNotificationCenter.kUserInfoHasBeenBlocked)
//                NotificationCenter.default.post(name: infoBlocked, object: nil)
//            } else if responseStatusCode == 10105 {
//                //用户头像信息审核不通过
//                let avatarBlocked = Notification.Name(YYNotificationCenter.kUserAvatarInfoHasBeenBlocked)
//                NotificationCenter.default.post(name: avatarBlocked, object: nil)
//            } else if responseStatusCode == 10108 {
//                //用户昵称信息审核不通过
//                let nicknameBlocked = Notification.Name(YYNotificationCenter.kUserNicknameInfoHasBeenBlocked)
//                NotificationCenter.default.post(name: nicknameBlocked, object: nil)
//            }
            
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
    
}
