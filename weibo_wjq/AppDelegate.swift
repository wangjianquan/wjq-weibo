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
        
       
        
        return true
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



