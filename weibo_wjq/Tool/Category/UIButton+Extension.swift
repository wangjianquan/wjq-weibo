//
//  UIButton+Extension.swift
//  weibo_wjq
//
//  Created by landixing on 2017/5/22.
//  Copyright © 2017年 WJQ. All rights reserved.
//

import UIKit

//MARK: 扩展,一般扩展类方法(calss) 类似OC中的加号方法

extension UIButton {
    //扩展方式
    //1. 搞成类方法(calss),类方法类似OC中的加号方法
    class func createImage(normal: String, seleImage: String) -> UIButton{
        let btn = UIButton()
        btn.setImage(UIImage(named:normal), for: .normal)
        btn.setImage(UIImage(named:normal+"_highlighted"), for: .selected)
        btn.setBackgroundImage(UIImage(named:seleImage), for: .normal)
        btn.setBackgroundImage(UIImage(named:seleImage+"highlighted"), for: .selected)
        btn.sizeToFit()
        return btn
    }
    
    
    //2. 搞成构造函数
    // convenience : 便利,使用convenience修饰的构造函数叫做便利构造函数
    // 遍历构造函数通常用在对系统的类进行构造函数的扩充时使用
    /*
     遍历构造函数的特点
     1.遍历构造函数通常都是写在extension里面
     2.遍历构造函数init前面需要加载convenience
     3.在遍历构造函数中需要明确的调用self.init()
     */
  convenience  init(normalImg: String?, seleImg: String?)
  {
        self.init()
        if let name = normalImg
        
        {
            setImage(UIImage(named: name), for: .normal)
            setImage(UIImage(named: name + "_highlighted"), for: .highlighted)
        }
        
        if let sele = seleImg
        {
            setBackgroundImage(UIImage(named: sele), for: .normal)
            setBackgroundImage(UIImage(named: sele + "highlighted"), for: .highlighted)
        }
    
        sizeToFit()
    }
}
