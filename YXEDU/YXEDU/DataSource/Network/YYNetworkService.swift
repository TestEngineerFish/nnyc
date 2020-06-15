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


@objc class YYNetworkService: NSObject {
    @objc public static let `default` = YYNetworkService()
    public let networkManager = NetworkReachabilityManager()
    
    private let maxOperationCount: Int = 3
    private let timeout: TimeInterval = 15

    
    private var sessionManager: SessionManager!
    
    private var defaultConfiguration: URLSessionConfiguration {
        let _configuration = URLSessionConfiguration.default
        _configuration.timeoutIntervalForRequest = timeout
        return _configuration
    }


    private var requestCountDict: [String:Int] = [:]

    
    
    private override init() {
        super.init()
        // 网络权限管理
        YXNetworkAuthManager.default.check()
        
        sessionManager = Alamofire.SessionManager.init(configuration: self.defaultConfiguration)
        sessionManager.session.delegateQueue.maxConcurrentOperationCount = maxOperationCount
    }
    
    //MARK: ----------------- Request -----------------


    @objc enum YXOCRequestType: Int {
        case feedback

        case errorWordFeedback
        case getMonthlyInfo
        case getDayInfo
        case changeName
        case changeAvatar
        case changeUserInfo
    }

    @objc public func ocRequest(type: YXOCRequestType, params: [String: Any], isUpload: Bool = false, success: ((_ model: YXOCModel) -> Void)?, fail: ((_ responseError: NSError) -> Void)?) {

        var request: YYBaseRequest!
        switch type {
        case .errorWordFeedback:
            request = YXOCRequest.errorWordFeedback(wordId: params["wordId"] as? Int ?? 0, word: params["word"] as? String ?? "", content: params["content"] as? String ?? "", type: params["type"] as? String ?? "")
            
        case .feedback:
            request = YXOCRequest.feedback(feed: params["feed"] as? String ?? "", env: params["env"] as? String ?? "", file: params["files"] as? [Data])
            
        case .getMonthlyInfo:
            request = YXOCRequest.getMonthlyInfo(time: Int(params["time"] as? Double ?? 0))
            
        case .getDayInfo:
            request = YXOCRequest.getDayInfo(time: Int(params["time"] as? Double ?? 0))
            
        case .changeName:
            request = YXOCRequest.changeName(name: params["name"] as? String ?? "")
            
        case .changeAvatar:
            request = YXOCRequest.changeAvatar(file: params["file"] as! Data)
            
        case .changeUserInfo:
            request = YXOCRequest.changeUserInfo(params: params as? [String : Any?] ?? ["": nil])
        }
        
        if isUpload {
            YYNetworkService.default.upload(YYStructResponse<YXOCModel>.self, request: request, success: { (response) in
                guard let model = response.data else {
                    return
                }
                success?(model)
            }, fail: fail)
            
        } else {
            YYNetworkService.default.request(YYStructResponse<YXOCModel>.self, request: request, success: { (response) in
                guard let model = response.data else {
                    return
                }
                success?(model)
            }, fail: fail)
        }
    }

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
            fail?(error as NSError)
            return nil
        }
    }
    
    public func download <T> (_ type: T.Type, request: YYBaseRequest, localSavePath: String, success: ((_ response: T) -> Void)?, fail: ((_ responseError: NSError) -> Void)?) -> Void where T: YYBaseResopnse {

        let params = removeNilValue(request.parameters)
        Alamofire.download(request.url, method: HTTPMethod(rawValue: request.method.rawValue) ?? .get, parameters: params, headers: request.handleHeader(parameters: params, headers: request.header)) { (url, response) -> (destinationURL: URL, options: DownloadRequest.DownloadOptions) in
            YXFileManager.share.saveFile(to: localSavePath)
            return (URL(fileURLWithPath: localSavePath), [.removePreviousFile, .createIntermediateDirectories])
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
                
        // 去除空值，删除文件参数
        var params = removeNilValue(parameters) ?? [:]
        if params.keys.contains("file") {
            params.removeValue(forKey: "file")
        }
        
        // 构建新的header
        var headers = request.header
        headers["Content-Type"] = "multipart/form-data"
        headers = request.handleHeader(parameters: params, headers: headers)
        
        // 转换对象
        let method = HTTPMethod(rawValue: request.method.rawValue) ?? .post
    
        sessionManager.upload(multipartFormData: { (multipartFormData) in
            var fileData: Any!
            var name: String!
            
            if let data = parameters["file"] {
                fileData = data
                name = "file"
                
            } else if let data = parameters["files[]"] {
                fileData = data
                name = "files[]"

            } else {
                return
            }
            
            // 文件数据 （先放前面）
            if fileData is String {
                multipartFormData.append(URL(fileURLWithPath:(fileData as! String)), withName: name, fileName: fileName, mimeType: mimeType)
                
            } else if fileData is Data {
                multipartFormData.append(fileData as! Data, withName: name, fileName: fileName, mimeType: mimeType)
                
            } else if fileData is [Data] {
                for data in fileData as! [Data] {
                    multipartFormData.append(data, withName: name, fileName: fileName, mimeType: mimeType)
                }
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

    private func postBody <T> (_ type: T.Type, request: URLRequest, success: @escaping (_ response: T, _ httpStatusCode: Int) -> Void?, fail: @escaping (_ error: NSError) -> Void?) -> YYTaskRequest where T: YYBaseResopnse {
        let requestStr = request.url?.absoluteString ?? ""
        YXRequestLog(String(format: "POST = request url:%@ params:%@", requestStr))
        let dataResquest = sessionManager.request(request).responseObject { (response: DataResponse<T>) in
            switch response.result {
            case .success(var x):
                x.response = response.response
                x.request  = response.request
                if let data = response.data, let dataStr = String(data: data, encoding: String.Encoding.utf8) {
                    YXRequestLog(String(format: "【Success】 request url: %@, respnseObject: %@", requestStr, dataStr))
                }
                if (x as YYBaseResopnse).statusCode == .some(10002) {
                    if self.addCountAction(requestStr) {
                        self.tokenRenewal {
                            self.postBody(type, request: request, success: success, fail: fail)
                        }
                    }
                } else {
                    success(x, (response.response?.statusCode) ?? 0)
                    self.clearCountAction(requestStr)
                }
            case .failure(let error):
                let msg = (error as NSError).message
                YXRequestLog(String(format: "【❌Fail❌】 POST = request url:%@, error:%@", requestStr, msg))
                fail(error as NSError)
                self.clearCountAction(requestStr)
            }
        }

        let taskRequest: YYTaskRequest = YYTaskRequestModel(request: dataResquest)
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
            let requestStr = request.url.absoluteString
            switch response.result {
            case .success(var x):
                if let data = response.data, let dataStr = String(data: data, encoding: String.Encoding.utf8), !request.url.absoluteString.hasSuffix(YXAPI.Word.getBookWords) {

                    YXRequestLog(String(format: "【Success】 request url: %@, respnseObject: %@", request.url.absoluteString, dataStr))
                }
                x.response = response.response
                x.request  = response.request
                if (x as YYBaseResopnse).statusCode == .some(10002) {
                    if self.addCountAction(requestStr) {
                        self.tokenRenewal {
                            _ = self.httpRequest(type, request: request, success: success, fail: fail)
                        }
                    }
                } else {
                    success(x, (response.response?.statusCode) ?? 0)
                    self.clearCountAction(requestStr)
                }

            case .failure(let error):
                let msg = (error as NSError).message
                YXRequestLog(String(format: "【❌Fail❌】 %@ = request url:%@ parames:%@, error:%@", method.rawValue, request.url.absoluteString, params?.toJson() ?? "", msg))
                fail(error as NSError)
                self.clearCountAction(requestStr)
            }
        }
        
        let taskRequest: YYTaskRequest = YYTaskRequestModel(request: task)
        return taskRequest
    }


    // MARK: ==== Token 管理 ====

    /// 添加请求计数
    private func addCountAction(_ key: String) -> Bool {
        let count = self.requestCountDict[key] ?? 0
        YXLog("接口", key, "返回；10002，重新请求接口，次数：\(count)")
        if count < 2 {
            self.requestCountDict.updateValue(count + 1, forKey: key)
            return true
        }
        return false
    }

    /// 清除请求计数
    private func clearCountAction(_ path: String) {
        if self.requestCountDict.isEmpty { return }
        if !path.hasSuffix(YXNetworkRequest.renewal.path) {
            self.requestCountDict.removeAll()
        }
    }

    /// Token续期
    private func tokenRenewal(complete block:@escaping (()->Void)) {
        let request = YXNetworkRequest.renewal
        YYNetworkService.default.request(YYStructResponse<YXNetworkModel>.self, request: request, success: { (response) in
            block()
            guard let model = response.data else {return}
            YXLog("Token续期成功，新Token:", model.token)
        }, fail: { (error) in
            block()
            YXLog("Token续期失败，error:\(error)")
        })
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
                // 上层已处理
//                YXLog("Token过期 10002")
//                YXMediator.shared()?.tokenExpired()
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
}
