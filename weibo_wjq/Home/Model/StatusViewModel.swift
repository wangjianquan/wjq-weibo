//
//  StatusViewModel.swift
//  weibo_wjq
//
//  Created by landixing on 2017/6/2.
//  Copyright © 2017年 WJQ. All rights reserved.
//

import UIKit

class StatusViewModel: NSObject {

    var status : Status
    
    
    /// 用户头像URL地址
    var icon_URL: URL?
    
    /// 用户认证图片
    var verified_image: UIImage?
    
    /// 会员图片
    var mbrankImage: UIImage?
    
    /// 微博格式化之后的创建时间
    var created_Time: String = ""
    
    /// 微博格式化之后的来源
    var source_Text: String = ""
    
    init(status : Status) {
      
        self.status = status
        
        //头像
        icon_URL = URL(string: status.user?.profile_image_url ?? "")
        
        //认证图片用户认证类型 -1：没有认证，0，认证用户，2,3,5: 企业认证，220: 达人
        
            switch status.user?.verified_type ?? -1
            {
            case 0:
                verified_image = UIImage(named: "avatar_vip")
            case 2, 3, 5:
                verified_image = UIImage(named: "avatar_enterprise_vip")
            case 220:
                verified_image = UIImage(named: "avatar_grassroot")
            default:
                verified_image = nil
            }
        
        
        //会员等级
        if let rank = status.user?.mbrank {
            if rank >= 1 && rank <= 6 {
                mbrankImage = UIImage(named: "common_icon_membership_level\(rank)")
            }
        }
        
    
        
        //时间
        if let time = status.created_at, time != ""{
            created_Time = Date.createTimeWithString(time)
            
        }

        /// 微博格式化之后的来源
        // "<a href=\"http://app.weibo.com/t/feed/2cEJdS\" rel=\"nofollow\">IT之家</a>"
        if let sourceStr = status.source , sourceStr != ""
        {
            //从截取
            let startIndex = (sourceStr as NSString).range(of: ">").location + 1
            
            // let length = sourceStr.rangeOfString("</").location - startIndex
            //倒序查找
            let length = (sourceStr as NSString).range(of: "<", options: NSString.CompareOptions.backwards).location - startIndex
            let fromStr: String = "来自"
            
            source_Text = fromStr + " " + (sourceStr as NSString).substring(with: NSRange(location: startIndex, length: length))
        }

        
    }
    
    
    
    
}
