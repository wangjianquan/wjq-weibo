//
//  MainViewController.swift
//  weibo_wjq
//
//  Created by landixing on 2017/5/16.
//  Copyright © 2017年 WJQ. All rights reserved.
//

import UIKit

class MainViewController: UITabBarController {

    //MARK: -- 懒加载属性
    fileprivate lazy var itemPicName : [String] = ["tabbar_home", "tabbar_message_center", "", "tabbar_discover", "tabbar_profile"]
    
    /*
       *发布按钮的创建
     */
    //1. 通过扩展的的类方法懒加载
      //fileprivate lazy var composeBtn : UIButton = UIButton.createImage(normal: "tabbar_compose_icon_add", seleImage: "tabbar_compose_button")
   //2. 构造函数的方式创建
       fileprivate lazy var composeBtn: UIButton = UIButton(normalImg: "tabbar_compose_icon_add", seleImg: "tabbar_compose_button")
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated) //一定不要忘记调用父类的viewWillAppear方法,否则点击第二个item是有效的,
        adjustItems()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        //添加发布按钮
        addComposeBtn()
        
    }
    
    
   
    
    
    
    
}

extension MainViewController {

    //添加发布按钮
    fileprivate func addComposeBtn() {
        //添加"发布"按钮
    tabBar.addSubview(composeBtn)
    

    //设置composeBtn的位置
    composeBtn.center = CGPoint(x: tabBar.center.x, y: tabBar.bounds.size.height * 0.5)
        
        composeBtn.addTarget(self, action: #selector(MainViewController.composeBtnClick), for: .touchUpInside)
    }
    
    //MARK: 设置第二个item不可用 (也可以直接设置More.storyboard的item的enable勾选掉)
    fileprivate func adjustItems() {
        // 遍历item设置其图片
        for i in 0..<tabBar.items!.count {
            // 1.取出item
            let item = tabBar.items![i]
            
            // 2.如果是第2个,则禁止交互
            if i == 2 {
                item.isEnabled = false
                continue
            }
            
            // 3.设置图片
            item.selectedImage = UIImage(named: itemPicName[i] + "_highlighted")
        }
    }
}

//MARK: -- 发布按钮点击事件
extension MainViewController{
    //监听事件的本质是发送消息, 但是发送消息是OC的特性
    //将方法包装成@SEL然后在类的方法列表中查找方法, 根据@SEL找到imp指针
    //如果swift中将函数声明成private,那么该函数不会被添加到方法列表中
    //既要保证不被外界随便访问,又要使之有效, 则在private前加@objc, 此时可以再方法列表中查找到该方法
  @objc  func composeBtnClick() {
    
    let composeVc = ComposeViewContro()
    let composeNavi = UINavigationController.init(rootViewController: composeVc)
    present(composeNavi, animated: true, completion: nil)
    
    }

}

