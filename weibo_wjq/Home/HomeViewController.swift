//
//  HomeViewController.swift
//  weibo_wjq
//
//  Created by landixing on 2017/5/16.
//  Copyright © 2017年 WJQ. All rights reserved.
//

import UIKit
import SVProgressHUD



class HomeViewController: BaseViewController {

    //MARK: -- 懒加载
    
    fileprivate lazy var titleBtn : TitleButton = TitleButton()
    
    fileprivate lazy var popAnimation : PopAnimation = PopAnimation()
    
    fileprivate  lazy var homeTableView: UITableView = {
        let tempTableView = UITableView()
        tempTableView.delegate = self
        tempTableView.dataSource = self

        
        tempTableView.register(UINib.init(nibName: "HomeCell", bundle: nil), forCellReuseIdentifier: "cell")
        tempTableView.rowHeight = UITableViewAutomaticDimension
        tempTableView.estimatedRowHeight = 200
        return tempTableView
    }()

    
    /// 保存所有微博数据
   fileprivate var dataSource: [Status]?
    {
        didSet{
            homeTableView.reloadData()
        }
    }

    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //没有登录时
        if !isLogin {
            visitorView.addRotationAnim()
            return
        }
        //导航栏设置
        setupNavigationBar()
        
        
        
        view.addSubview(homeTableView)
        homeTableView.snp.makeConstraints { (make) in
            make.edges.equalTo(0)
        }
        loadData()
    }

    
    
}

//MARK: -- 代理方法
extension HomeViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.dataSource?.count ?? 0
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! HomeCell

        
        cell.status = dataSource?[indexPath.row]
        return cell
        
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

}

extension HomeViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 200
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
       let title = UserAccount.loadAccount()?.screen_name
        titleBtn.setTitle(title, for: .normal)
        titleBtn.addTarget(self, action: #selector(HomeViewController.titleBtnClick(btn:)), for: .touchUpInside)
        
        navigationItem.titleView = titleBtn

    }

}

//MAKR: -- 网络请求
extension HomeViewController {

    fileprivate func loadData() {
    
        NetworkTools.shareInstance.loadStatus { (result, error) in
                // 1.安全校验
                if error != nil
                {
                    SVProgressHUD.showError(withStatus: "获取微博数据失败")
                    return
                }
                guard let arr = result else {
                    return
                }
            
                // 2.将字典数组转换为模型数组
                var dataArray = [Status]()
                for dict in arr
                {
                    let status = Status(dict: dict)
                    dataArray.append(status)
                }
            
            self.dataSource = dataArray
            
                Dlog("\(dataArray),\(dataArray.count)")
        }
    
    
    
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




