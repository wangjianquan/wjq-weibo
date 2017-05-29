//
//  String + Extension.swift
//  weibo_wjq
//
//  Created by landixing on 2017/5/29.
//  Copyright © 2017年 WJQ. All rights reserved.
//

import UIKit

extension String {

     /// 快速生成缓存路径
    func cachesDirectory() -> String {
        
        // 1.获取缓存目录的路径
        let path = NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.cachesDirectory, FileManager.SearchPathDomainMask.userDomainMask, true).last!
        // 2.生成缓存路径
        let name = (self as NSString).lastPathComponent
        let filePath = (path as NSString).appendingPathComponent(name)
        
        return filePath
    }

    
    /// 快速生成文档路径
    func documentDirectory() -> String {
        // 1.获取缓存目录的路径
        let path = NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.documentDirectory, FileManager.SearchPathDomainMask.userDomainMask, true).last!
        // 2.生成缓存路径
        let name = (self as NSString).lastPathComponent
        let filePath = (path as NSString).appendingPathComponent(name)
        
        return filePath

    }
    
    /// 快速生成临时路径
    func tmpDirectory() -> String {
        // 1.获取缓存目录的路径
        let path = NSTemporaryDirectory()
        // 2.生成缓存路径
        let name = (self as NSString).lastPathComponent
        let filePath = (path as NSString).appendingPathComponent(name)
        
        return filePath
    }
}
