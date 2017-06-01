//
//  Status.swift
//  weibo_wjq
//
//  Created by landixing on 2017/6/1.
//  Copyright © 2017年 WJQ. All rights reserved.
//

import UIKit

class Status: NSObject {
    /// 微博创建时间
    var created_at: String?
    
    /// 字符串型的微博ID
    var idstr: String?
    
    /// 微博信息内容
    var text: String?
    
    /// 微博来源
    var source: String?
    
    //微博作者用户信息
    var user : User?
    
    init(dict:[String : Any]) {
        super.init()
        setValuesForKeys(dict)
        // 1.将用户字典转成用户模型对象
        if let userDic = dict["user"] as? [String:Any] {
            user = User(dict: userDic)
        }
        }
    
    // KVC的setValuesForKeysWithDictionary方法内部会调用setValue方法
//    override func setValue(_ value: Any?, forKey key: String) {
//        
//        // 1.拦截user赋值操作
//        if key == "user"
//        {
//            user = User(dict: value as! [String : Any] )
//            return
//        }
//        super.setValue(value, forKey: key)
//    }
    
    override func setValue(_ value: Any?, forUndefinedKey key: String) {
        
    }
    
    override var description: String{
        let property = ["created_at","idstr","text","source"]
        let dict = dictionaryWithValues(forKeys: property)
        return "\(dict)"
    }

}
