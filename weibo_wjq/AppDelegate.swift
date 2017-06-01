//
//  AppDelegate.swift
//  weibo_wjq
//
//  Created by landixing on 2017/5/16.
//  Copyright © 2017年 WJQ. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {

        //设置全局颜色
        UITabBar.appearance().tintColor = UIColor.orange
        UINavigationBar.appearance().tintColor = UIColor.orange
       
        // 2.注册监听
        NotificationCenter.default.addObserver(self, selector: #selector(AppDelegate.changeViewCotroller(_:)), name: NSNotification.Name(rawValue: SwitchRootViewController), object: nil)
        
        window = UIWindow(frame:UIScreen.main.bounds)
        window?.backgroundColor = UIColor.white
        window?.rootViewController = defaultViewController()
        window?.makeKeyAndVisible()
        
        return true
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
}

extension AppDelegate {
    
    // 切换根控制器
    func changeViewCotroller(_ notice: Notification)
    {
        if notice.object as! Bool
        {
            let sb = UIStoryboard(name: "Main", bundle: nil)
            window?.rootViewController = sb.instantiateInitialViewController()!
        }else
        {
            let sb = UIStoryboard(name: "Welcome", bundle: nil)
            window?.rootViewController = sb.instantiateInitialViewController()!
        }
    }
    
    
   //MARK: -- 用于返回默认界面
    /// 用于返回默认界面
  fileprivate  func defaultViewController() -> UIViewController
    {
        // 1.判断是否登录
        if UserAccount.isLogin()
        {
            // 2.判断是否有新版本
             return isNewVersion() ? UIStoryboard(name: "Newfeature", bundle: nil).instantiateInitialViewController()! : UIStoryboard(name: "Welcome", bundle: nil).instantiateInitialViewController()!
          
        }
        
        // 没有登录
        let sb = UIStoryboard(name: "Main", bundle: nil)
        return sb.instantiateInitialViewController()!
    }

    
    //MARK: -- 判断是否有新版本
    fileprivate  func isNewVersion() -> Bool {
        //1. 当前版本号
        let currentVersion = Bundle.main.infoDictionary! ["CFBundleShortVersionString"] as! String
        
        //2. 前一个版本号
        let userDefault = UserDefaults.standard
        // ?? 之前的版本号如果为空执行??后面的, 如果不为空则当执行??之前的  ,第一次安装时sanboxVersion绝对为0.0
        let sanboxVersion = (userDefault.object(forKey: "version") as? String) ?? "0.0"
        //3. 比较
        // 如果currentVersion和sanboxVersion比较 ,为 orderedDescending(降序), 说明
        if currentVersion.compare(sanboxVersion) == ComparisonResult.orderedDescending {
            Dlog("has new Version")
            
            //4. 存入最新版本号
            userDefault.setValue(currentVersion, forKey: "version")
            userDefault.synchronize()
            return true
        }
        return false
        

    }


}

//全局函数
//MARK: -- 自定义全局Log
func Dlog<T>(_ message : T, file : String = #file, funcName : String = #function, lineNum : Int = #line) {
    
    #if DEBUG
        // 1.获取打印所在的文件
        let fileName = (file as NSString).lastPathComponent
        
        print("\(fileName):  (\(lineNum))-\(message)")
        
    #endif
}



