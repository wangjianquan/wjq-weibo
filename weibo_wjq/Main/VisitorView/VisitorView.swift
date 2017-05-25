//
//  VisitorView.swift
//  weibo_wjq
//
//  Created by landixing on 2017/5/23.
//  Copyright © 2017年 WJQ. All rights reserved.
//

import UIKit

class VisitorView: UIView {

    //加载xib文件的类方法
    // MARK:- 提供快速通过xib创建的类方法
    class func loadVisitorView() -> VisitorView {
        return Bundle.main.loadNibNamed("VisitorView", owner: nil, options: nil)!.first as! VisitorView
    }

    
    //MARK: 控件属性
    @IBOutlet var rotationView: UIImageView!
    @IBOutlet var iconImgView: UIImageView!
    @IBOutlet var tipLabel: UILabel!
    @IBOutlet var registerBtn: UIButton!
    @IBOutlet var loginBtn: UIButton!
    
    
    // MARK:- 自定义函数
    func setupVisitorViewInfo(iconName : String, title : String) {
        iconImgView.image = UIImage(named: iconName)
        tipLabel.text = title
        rotationView.isHidden = true
    }
    
    func addRotationAnim() {
        // 1.创建动画
        let rotationAnim = CABasicAnimation(keyPath: "transform.rotation.z")
        
        // 2.设置动画的属性
        rotationAnim.fromValue = 0
        rotationAnim.toValue = Double.pi * 2
        rotationAnim.repeatCount = MAXFLOAT
        rotationAnim.duration = 5
        rotationAnim.isRemovedOnCompletion = false
        
        // 3.将动画添加到layer中
        rotationView.layer.add(rotationAnim, forKey: nil)
    }
}










