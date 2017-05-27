//
//  HomeViewController.swift
//  weibo_wjq
//
//  Created by landixing on 2017/5/16.
//  Copyright © 2017年 WJQ. All rights reserved.
//

import UIKit

class HomeViewController: BaseViewController {

    //MARK: -- 懒加载
    
    fileprivate lazy var titleBtn : TitleButton = TitleButton()
    
    fileprivate lazy var popAnimation : PopAnimation = PopAnimation()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //没有登录时
      
        if !isLogin {
            visitorView.addRotationAnim()
            return
        }
        //导航栏设置
        setupNavigationBar()
    }

    
    
}

//MARK: -- 设置UI
extension HomeViewController {
    fileprivate func setupNavigationBar() {
    //MARK: -- 1. 导航栏按钮
        //左侧按钮
        navigationItem.leftBarButtonItem = UIBarButtonItem(imageName: "navigationbar_friendattention", target: self, action:#selector(HomeViewController.leftBarButtonItemClick))
       //右侧按钮
        navigationItem.rightBarButtonItem = UIBarButtonItem(imageName: "navigationbar_pop", target: self, action:#selector(HomeViewController.rightBarButtonItemClick))


    //MARK: -- 2. 标题按钮
        titleBtn.setTitle("白小黑", for: .normal)
        titleBtn.addTarget(self, action: #selector(HomeViewController.titleBtnClick(btn:)), for: .touchUpInside)
        
        navigationItem.titleView = titleBtn

    }

}

//MARK: -- 点击事件
extension HomeViewController{
    //MARK: --标题按钮
    @objc fileprivate func titleBtnClick(btn: TitleButton) {
        //1. . 弹出视图
        let popview = UIStoryboard(name: "PopViewController", bundle: nil)
        guard let menuView = popview.instantiateInitialViewController() else { return  }

        popAnimation.presentedFrame = CGRect(x: 100, y: 64, width: 180, height: 230)
        popAnimation.presentedCallBack = {[weak self] (isPresented) -> () in
            self?.titleBtn.isSelected = isPresented
        }
        //3. 设置代理, 并自定义
        menuView.transitioningDelegate = popAnimation
        menuView.modalPresentationStyle = .custom
        present(menuView, animated: true, completion: nil)
    }
    
    //MARK: -- 左侧item事件
    @objc fileprivate func leftBarButtonItemClick() {
        Dlog("leftBarButtonItemClick")
    }
    
    //MARK: -- 右侧item事件
    @objc fileprivate func rightBarButtonItemClick() {
        
        let QRCodeVC  = UIStoryboard(name: "QRCode", bundle: nil)
        guard  let qrcodeView = QRCodeVC.instantiateInitialViewController() else { return
        }
        present(qrcodeView, animated: true, completion: nil)
        
    
    
    }
}




