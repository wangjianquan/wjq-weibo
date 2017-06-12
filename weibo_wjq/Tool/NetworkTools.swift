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
        let baseURL = URL(string: "https://api.weibo.com/")!

        let tools = NetworkTools(baseURL: baseURL, sessionConfiguration: URLSessionConfiguration.default)
        tools.responseSerializer.acceptableContentTypes = NSSet(objects:"application/json", "text/json", "text/javascript", "text/plain") as? Set
        
        return tools
    }()

    
}


//MARK: -- 总方法
extension NetworkTools {

    
    /// 封装GET和POST 请求
    ///
    /// - Parameters:
    ///   - requestType: 请求方式
    ///   - urlString: urlString
    ///   - parameters: 字典参数
    ///   - completion: 回调

    // 将成功和失败的回调写在一个逃逸闭包中
    func request(_ requestType : HTTPRequestType, url : String, parameters : [String : Any], resultBlock : @escaping(_ result: [String : Any]?, _ error: Error?) -> ()) {
        
        // 成功闭包
        let successBlock = { (task: URLSessionDataTask, responseObj: Any?) in
            resultBlock(responseObj as? [String : Any], nil)
        }
        
        // 失败的闭包
        let failureBlock = { (task: URLSessionDataTask?, error: Error) in
            resultBlock(nil, error)
        }
        
        // Get 请求
        if requestType == .GET {
            get(url, parameters: parameters, progress: nil, success: successBlock, failure: failureBlock)
        }
        
        // Post 请求
        if requestType == .POST {
            post(url, parameters: parameters, progress: nil, success: successBlock, failure: failureBlock)
        }
    }




}


//MARK: - 请求首页数据
extension NetworkTools {
    func loadStatus(since_id : Int, max_id : Int, _ finished: @escaping (_ result: [[String:Any]]?, _ error: Error?) -> ())  {
        
        assert(UserAccount.loadAccount() != nil, "必须授权之后才能获取微博数据")
        let url = "2/statuses/home_timeline.json"
        let access_token = UserAccount.loadAccount()!.access_token!
        
        let dict = ["access_token" : access_token, "since_id" : "\(since_id)", "max_id" : "\(max_id)"]
             
        request(.GET, url: url, parameters: dict) { (result, error) in
            
            if error == nil {
                guard let resultDic = result else {
    
                    finished(nil, error)
                    return
                }
                //2. 将数组数据回调给外界控制器
                finished(resultDic["statuses"] as? [[String : Any]], error)

            } else {
                print(error as Any)
            }
        }
    }
}


//MARK: - 发布微博
extension NetworkTools {
   
    func sendStatus(_ statusString: String, isSuccess:@escaping (_ isSuccess: Bool) -> ()){
        
        assert(UserAccount.loadAccount() != nil, "必须授权之后才能获取微博数据")
        let url = "2/statuses/update.json"
        let access_token = UserAccount.loadAccount()!.access_token!
        let dict = ["access_token" : access_token, "status" : statusString]
        
        request(.POST, url: url, parameters: dict)
        { (result, error) in
            
            if result != nil{
                isSuccess(true)
            }else {
                isSuccess(false)
            }
        }
        
    }

}

// MARK:- 发送微博并且携带照片
extension NetworkTools {
    func sendStatus(_ statusText : String, image : UIImage, isSuccess : @escaping (_ isSuccess : Bool) -> ()) {
        assert(UserAccount.loadAccount() != nil, "必须授权之后才能获取微博数据")
        let url = "2/statuses/upload.json"
        let access_token = UserAccount.loadAccount()!.access_token!
        let dict = ["access_token" : access_token, "status" : statusText]
       
        
        // 3.发送网络请求
       post(url, parameters: dict, constructingBodyWith: { (formData) in

        if let imageData = UIImageJPEGRepresentation(image, 0.5) {
        
            formData.appendPart(withFileData: imageData, name: "pic", fileName: "1.png", mimeType: "image/png")
        
        }
       
        
       }, progress: nil, success: { (_, _) in
            isSuccess(true)
       }) { (_, error) in
             Dlog(error)
        }
        
      
        
    }
}







