//
//  UIBarButtonItem.swift
//  weibo_wjq
//
//  Created by landixing on 2017/5/23.
//  Copyright © 2017年 WJQ. All rights reserved.
//

import UIKit


extension UIBarButtonItem{

    /**
     * 便利构造函数 convenience , self.init
     */
    //方式1
    /*
     convenience init(imageName : String) {
     self.init()
     
     let btn = UIButton()
     btn.setImage(UIImage(named: imageName), forState: .Normal)
     btn.setImage(UIImage(named: imageName + "_highlighted"), forState: .Highlighted)
     btn.sizeToFit()
     
     self.customView = btn
     }
     */
    
    convenience init(imageName : String ,target: Any?, action: Selector) {
        
        let btn = UIButton()
        btn.setImage(UIImage(named: imageName), for: UIControlState())
        btn.setImage(UIImage(named: imageName + "_highlighted"), for: .highlighted)
        btn.addTarget(target, action: action, for: .touchUpInside)
        btn.sizeToFit()
        self.init(customView : btn)
    }
    
}
