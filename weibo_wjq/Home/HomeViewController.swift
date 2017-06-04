//
//  HomeViewController.swift
//  weibo_wjq
//
//  Created by landixing on 2017/5/16.
//  Copyright © 2017年 WJQ. All rights reserved.
//

import UIKit
import SVProgressHUD
import SDWebImage


class HomeViewController: BaseViewController {

    //MARK: -- 懒加载
    // 标题按钮
    fileprivate lazy var titleBtn : TitleButton = {
        let titleBtn = TitleButton()
        let title = UserAccount.loadAccount()?.screen_name
        titleBtn.setTitle(title, for: .normal)
        titleBtn.addTarget(self, action: #selector(HomeViewController.titleBtnClick(btn:)), for: .touchUpInside)
        return titleBtn
    }()
    
    
    fileprivate lazy var popAnimation : PopAnimation = PopAnimation()
    
    fileprivate  lazy var homeTableView: UITableView = {
        let tempTableView = UITableView()
        tempTableView.delegate = self
        tempTableView.dataSource = self
        tempTableView.separatorStyle = UITableViewCellSeparatorStyle.none
        tempTableView.register(UINib.init(nibName: "HomeCell", bundle: nil), forCellReuseIdentifier: "cell")
        
        //预设值cell高度
        tempTableView.estimatedRowHeight = 400
        return tempTableView
    }()

    
    /// 保存所有微博数据
   fileprivate var dataSource: [StatusViewModel]?
    {
        didSet{
            homeTableView.reloadData()
        }
    }

    /// 缓存行高
    fileprivate var rowHeightCaches = [String : CGFloat]()
    
    
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

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // 释放缓存数据
        rowHeightCaches.removeAll()
    }
    
}

//MARK: -- 代理方法
extension HomeViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.dataSource?.count ?? 0
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! HomeCell

        
        cell.viewModel = dataSource?[indexPath.row]
        return cell
        
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

}

extension HomeViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {

        let viewModel = dataSource![indexPath.row]
         // 1.从缓存中取行高
        guard let height = rowHeightCaches[viewModel.status.idstr ?? "-1" ] else {
           
            //缓存中没有,计算高度
            let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as! HomeCell
            //缓存行高
            let temp = cell.calculateRowHeight(viewModel)
            
            rowHeightCaches[viewModel.status.idstr ?? "-1"] = temp
            
            
            return temp
        }
        
        return height
        
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

    //MARK: -- 2. 标题按钮 (闭包)
        navigationItem.titleView = titleBtn

    }

}

//MAKR: -- 网络请求
extension HomeViewController {

    //MARK: --  loadData 网络请求
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
                var dataArray = [StatusViewModel]()
                for dict in arr
                {
                    let status = Status(dict: dict)
                    let viewModel = StatusViewModel(status: status)
                    dataArray.append(viewModel)
                }
           
            
                //缓存图片 先下载后刷新
                self.cachesImage(dataArr: dataArray)
        }
    
    
    }

    //MARK: --  cachesImage 缓存图片
    fileprivate func cachesImage(dataArr: [StatusViewModel]) {
    
        let group = DispatchGroup()
        
        //遍历数组,取model
        for viewModel in dataArr {
            
            //1. 从模型中取出配图URL数组
//            guard  let picUrlArr = viewModel.thumbnail_pic else {
//                continue
//            }
            
            //2. 从配图数组(pic_urls)中取出图片
            for url in viewModel.thumbnail_pic
            {
                // 将当前的下载操作添加到组中
                group.enter()
                
                SDWebImageManager.shared().downloadImage(with: url, options: [], progress: nil, completed: { (image, error, _, _, _) in
                        Dlog("图片下载完成")
                    // 将当前下载操作从组中移除
                    group.leave()
                })
            }
        }
        
        //监听下载操作, 当全部下载完后刷新表单
        // 监听下载 操作
        group.notify(queue: DispatchQueue.main) { () -> Void in
            Dlog("全部下载完成")
            self.dataSource = dataArr //刷新表单
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




