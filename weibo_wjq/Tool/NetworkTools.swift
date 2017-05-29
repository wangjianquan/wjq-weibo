//
//  NetworkTools.swift
//  weibo_wjq
//
//  Created by landixing on 2017/5/28.
//  Copyright © 2017年 WJQ. All rights reserved.
//

import UIKit
import AFNetworking

//枚举定义请求方式
enum HTTPRequestType {
    case GET
    case POST
}

class NetworkTools: AFHTTPSessionManager {

    // Swift推荐我们这样编写单例
    static let shareInstance: NetworkTools = {
        let tools = NetworkTools()
        tools.responseSerializer.acceptableContentTypes = NSSet(objects:"application/json", "text/json", "text/javascript", "text/plain") as? Set
        return tools
    }()//    {
//
//        // 注意: baseURL后面一定更要写上./
//        let baseURL = URL(string: "https://api.weibo.com/")!
//        
//        let instance = NetworkTools(baseURL: baseURL, sessionConfiguration: URLSessionConfiguration.default)
//        
//        instance.responseSerializer.acceptableContentTypes = NSSet(object: "text/plain") as? Set
//        
//        return instance
//    }()
    
    
    
}



extension NetworkTools {

    
    /// 封装GET和POST 请求
    ///
    /// - Parameters:
    ///   - requestType: 请求方式
    ///   - urlString: urlString
    ///   - parameters: 字典参数
    ///   - completion: 回调
    func request(requestType: HTTPRequestType, urlString: String, parameters: [String: AnyObject]?, completion: @escaping (AnyObject?) -> ()) {
        
        //成功回调
        let success = { (task: URLSessionDataTask, json: Any)->() in
            completion(json as AnyObject?)
        }
        
        //失败回调
        let failure = { (task: URLSessionDataTask?, error: Error) -> () in
            print("网络请求错误 \(error)")
            completion(nil)
        }
        
        if requestType == .GET {
            get(urlString, parameters: parameters, progress: nil, success: success, failure: failure)
        } else {
            post(urlString, parameters: parameters, progress: nil, success: success, failure: failure)
        }
    }



}
