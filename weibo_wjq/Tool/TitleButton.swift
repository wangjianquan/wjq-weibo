//
//  TitleButton.swift
//  weibo_wjq
//
//  Created by landixing on 2017/5/24.
//  Copyright © 2017年 WJQ. All rights reserved.
//

import UIKit

class TitleButton: UIButton {
    //通过纯代码创建是调用
    //在Swift中如果重写父类的方法,必须在方法前面加上override
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    //Swift中规定, 如果重写了init(frame)或者init()方法,必须实现init?(corder)方法
    //通过xib/SB创建时调用
    required init?(coder aDecoder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
        super.init(coder: aDecoder)
        setupUI()
    }
  
    fileprivate  func setupUI()  {
        setImage(UIImage(named:"navigationbar_arrow_down"), for: .normal)
        setImage(UIImage(named:"navigationbar_arrow_up"), for: .selected)
        setTitleColor(UIColor.black, for: .normal)
        sizeToFit()
    }
    
    //设置文字图片的间距
    override func setTitle(_ title: String?, for state: UIControlState) {
       // ??    用于判断 ?? 前面的参数是否为空,如果为空执行??后面的语句,如果不为空,则执行??之前的语句即执行title
        //
        super.setTitle((title ?? "") + "  ", for: .normal)//或者使用imageView?.frame.origin.x = titleLabel!.frame.size.width + 5
    }
    //设置文字图片的位置
    override func layoutSubviews() {
        super.layoutSubviews()

        //和OC不同的是,Swift允许我们直接修改一个对象的结构体属性的成员
        titleLabel?.frame.origin.x = 0
        imageView?.frame.origin.x = titleLabel!.frame.size.width
    }

}
