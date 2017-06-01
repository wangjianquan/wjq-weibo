//
//  BaseViewController.swift
//  weibo_wjq
//
//  Created by landixing on 2017/5/23.
//  Copyright © 2017年 WJQ. All rights reserved.
//

import UIKit

class BaseViewController: UIViewController {

    // MARK:- 懒加载属性
    lazy var visitorView : VisitorView = VisitorView.loadVisitorView()
    
    // MARK:- 定义变量
    var isLogin = UserAccount.isLogin()
    
    // MARK:- 系统回调函数
    override func loadView() {
        isLogin ? super.loadView() : setupVisitorView()
    }
    
   
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
         }
    
   
    
  
}


extension BaseViewController{
    fileprivate func setupVisitorView() {
        view = visitorView
        //注册按钮
        visitorView.registerBtn.addTarget(self, action: #selector(BaseViewController.registerBtnClick), for: .touchUpInside)
        
        //登录按钮
        visitorView.loginBtn.addTarget(self, action: #selector(BaseViewController.loginBtnClick), for: .touchUpInside)
    }
}

//MARK: -- 注册登录事件
extension BaseViewController {
    @objc fileprivate func registerBtnClick() {
        print("registerBtnClick")
    }
    
    //登录
    @objc fileprivate func loginBtnClick() {
        
        let oauth = UIStoryboard(name: "OAuth", bundle: nil)
        
       guard  let oauthVC = oauth.instantiateInitialViewController()
        else { return }
        
        
      present(oauthVC, animated: true, completion: nil)
        
        
    
    
    }

}
