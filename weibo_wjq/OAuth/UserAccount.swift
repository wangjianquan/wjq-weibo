//
//  UserAccount.swift
//  weibo_wjq
//
//  Created by landixing on 2017/5/29.
//  Copyright © 2017年 WJQ. All rights reserved.
//

import UIKit

class UserAccount: NSObject,NSCoding {

    /*
       **用户信息
     */
    var access_token : String? //  access_token
    var expires_Date : Date? // 真正过期时间
    var uid:           String? // 用户ID
    var avatar_large : String?  //用户头像地址（大图），180×180像素
    var screen_name :  String?// 用户昵称
    // 从授权那一刻开始, 多少秒之后过期时间
    var expires_in: Int = 0
    {
        didSet{
         // 生成真正过期时间
            expires_Date = Date(timeIntervalSinceNow: TimeInterval(expires_in))
        }
    }
    
    
    // MARK: - 生命周期方法
    init(dict: [String : AnyObject]) {
        super.init()
        self.setValuesForKeys(dict)
    }
    // 当KVC发现没有对应的key时就会调用
    override func setValue(_ value: Any?, forUndefinedKey key: String) {
        
    }
    
    override var description: String {
        // 将模型转换为字典
        let property = ["access_token", "expires_in", "uid","expires_Date","avatar_large", "screen_name"]
        let dict = dictionaryWithValues(forKeys: property)
        // 将字典转换为字符串
        return "\(dict)"
    }
    // 存储路径
    static let filePath: String = "useraccount.plist".cachesDirectory()
    static var account: UserAccount? //定义属性保存授权模型
    
    //MARK: -- 归档模型
    func saveAccount() -> Bool {
        Dlog(UserAccount.filePath)
        return  NSKeyedArchiver.archiveRootObject(self, toFile: UserAccount.filePath)
        
    }
    
    
    
    //MARK: -- 解档模型
    class  func loadAccount() -> UserAccount?
    {
        //1. 判断是否加载过
        if UserAccount.account != nil {
            Dlog("加载过")
            return UserAccount.account
        }
        Dlog("没有加载过")
       
        //2. 从缓存路径中加载
        guard let account =  NSKeyedUnarchiver.unarchiveObject(withFile: UserAccount.filePath) as? UserAccount else
       {
            Dlog("没有授权")
            return nil //默认值为 可选型
        }
        //3. 校验是否过期了,如果expires_Date为nil 说明没有授权
        guard let date = account.expires_Date else
        {
            return UserAccount.account //默认值为nil
        }
        
        //2016(真正过期时间) 2017(当前时间)
        //真正过期时间 和 当前时间 比较, 如果是orderedAscending (升序时间)则过期了
        if date.compare(Date()) == ComparisonResult.orderedAscending  {
            Dlog("过期了")
        }
        /*合句
        guard let date = account.expires_Date, date.compare(Date())  != ComparisonResult.orderedAscending else {
            return nil
        }
        */
        
        Dlog("授权了")
        UserAccount.account = account
        return  UserAccount.account
    }
    
    //MARK: -- 获取用户信息
    func loadUserInfo(_ finished: @escaping (_ account: UserAccount?)->()){
        
        
        //1.  断定access_token一定是不等于nil的, 如果运行的时access_token等于nil, 那么程序就会崩溃, 并且报错
        assert(access_token != nil, "使用该方法必须先授权")
        
        //2.请求地址
        let urlString = "https://api.weibo.com/2/users/show.json"
        //3.参数
        let dict = ["access_token" : access_token!, "uid" : uid!]
        
       //4.    GET
        NetworkTools.shareInstance.request(requestType: .GET, urlString: urlString, parameters: dict as [String : AnyObject]){ (objc) in
            
            let dic = objc as! [String : AnyObject]
            
            //1.取出用户信息
            self.avatar_large = dic["avatar_large"] as? String
            self.screen_name  = dic["screen_name"] as? String
            finished(self)
        }

    }
    
    //MARK: -- 判断用户是否登录(由是否授权决定)
    class func isLogin() -> Bool {
        return UserAccount.loadAccount() != nil
    
    }

    
    //MARK: -- NSCoding
    func encode(with aCoder: NSCoder) {
        aCoder.encode(access_token, forKey: "access_token")
        aCoder.encode(expires_in, forKey: "expires_in")
        aCoder.encode(uid, forKey: "uid")
        aCoder.encode(expires_Date, forKey: "expires_Date")
        aCoder.encode(avatar_large, forKey: "avatar_large")
        aCoder.encode(screen_name, forKey: "screen_name")
    }
    
    required init?(coder aDecoder: NSCoder) {
        self.access_token = aDecoder.decodeObject(forKey: "access_token") as? String
        self.avatar_large = aDecoder.decodeObject(forKey: "avatar_large") as? String
        self.expires_Date = aDecoder.decodeObject(forKey: "expires_Date") as? Date
        self.screen_name  = aDecoder.decodeObject(forKey: "screen_name") as? String
        self.expires_in = aDecoder.decodeInteger(forKey: "expires_in") as Int
        self.uid = aDecoder.decodeObject(forKey: "uid") as? String
    
    
    
    }
    
}
