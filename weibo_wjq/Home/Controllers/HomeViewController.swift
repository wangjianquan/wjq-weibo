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
import MJRefresh


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
    
    //MARK: -- 标题动画
    fileprivate lazy var popAnimation : PopAnimation = PopAnimation()
    
    //MARK: -- tableView
    fileprivate  lazy var homeTableView: UITableView = {
        let tableview = UITableView()
        tableview.delegate = self
        tableview.dataSource = self
        tableview.separatorStyle = UITableViewCellSeparatorStyle.none
        tableview.register(UINib.init(nibName: "HomeCell", bundle: nil), forCellReuseIdentifier: "cell")
        //预设值cell高度
        tableview.estimatedRowHeight = 400
        self.view.addSubview(tableview)
        tableview.snp.makeConstraints { (make) in
            make.edges.equalTo(0)
        }
        return tableview
    }()
    
    //MARK: -- 保存所有微博数据
   fileprivate lazy var dataSource: [StatusViewModel] = [StatusViewModel]()

    fileprivate lazy var tipLabel: UILabel = {
        let tipLabel : UILabel = UILabel()
//        self.navigationController?.navigationBar.insertSubview(tipLabel, at: 0)
        self.view.insertSubview(tipLabel, aboveSubview: self.homeTableView)
        tipLabel.frame = CGRect(x: 0, y: 10, width: UIScreen.main.bounds.width, height: 32)
        tipLabel.backgroundColor = UIColor.orange
        tipLabel.textColor = UIColor.white
        tipLabel.font = UIFont.systemFont(ofSize: 14)
        tipLabel.textAlignment = .center
        tipLabel.isHidden = true
        return tipLabel
    }()
    
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
        
        //下拉刷新, 上拉加载
        setupHeaderView()
        setupFooterView()
        
        
         NotificationCenter.default.addObserver(self, selector: Selector("showPhotoBrowser:"), name: NSNotification.Name(rawValue: showPhotoBrowserNotification), object: nil)
        

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // 释放缓存数据
        rowHeightCaches.removeAll()
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
    
    fileprivate func setupHeaderView()
    {
        let header = MJRefreshNormalHeader(refreshingTarget: self, refreshingAction: #selector(HomeViewController.loadNewData))
        header?.setTitle("下拉刷新", for: .idle)
        header?.setTitle("释放更新", for: .pulling)
        header?.setTitle("加载中...", for: .refreshing)
        homeTableView.mj_header = header
        homeTableView.mj_header.beginRefreshing()
    }
    
    fileprivate func setupFooterView()
    {
        homeTableView.mj_footer = MJRefreshAutoFooter(refreshingTarget: self, refreshingAction: #selector(HomeViewController.loadMoreData))
    }
    
    
}

//MARK: -- 代理方法
extension HomeViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.dataSource.count 
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! HomeCell

        
        cell.viewModel = dataSource[indexPath.row]
        return cell
        
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

}

extension HomeViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {

        let viewModel = dataSource[indexPath.row]
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



//MAKR: -- 网络请求
extension HomeViewController {
    /// 加载最新的数据
    @objc fileprivate func loadNewData() {
        loadData(true)
    }
    
    /// 加载最新的数据
    @objc fileprivate func loadMoreData() {
        loadData(false)
    }

    //MARK: --  loadData 网络请求
    fileprivate func loadData(_ isNewData: Bool) {
    
        //获取
        var since_id = 0 //下拉
        var max_id = 0
        
        if isNewData {
            since_id = dataSource.first?.status.mid ?? 0
        } else {
            max_id = dataSource.last?.status.mid ?? 0
            max_id = max_id == 0 ? 0 : (max_id - 1)
        }
        
        
        NetworkTools.shareInstance.loadStatus(since_id:since_id, max_id: max_id) { (result, error) in
                // 1.安全校验
                if error != nil
                {
                    SVProgressHUD.showError(withStatus: "获取微博数据失败")
                    return
                }
            // 2.获取可选类型中的数据
            guard let arr = result else {
                    return
                }
            
                // 3.将字典数组转换为模型数组
                    //3.1 临时数组
                var tempDataArray = [StatusViewModel]()
                for dict in arr
                {
                    let status = Status(dict: dict)
                    let viewModel = StatusViewModel(status: status)
                    tempDataArray.append(viewModel) //数据添加到临时数组中
                }
           
            //4. 将数据添加到总得dataSource中
            
            if isNewData{
                //第一次加载及下拉刷新
                self.dataSource = tempDataArray + self.dataSource
            }else {
                self.dataSource += tempDataArray
            }
            
                //缓存图片 先下载后刷新
                self.cachesImage(dataArr: tempDataArray)
        }
    
    
    }

    //MARK: --  cachesImage 缓存图片
    fileprivate func cachesImage(dataArr: [StatusViewModel]) {
    //1
        let group = DispatchGroup()
        
        //2.遍历数组,取model
        for viewModel in dataArr
        {
            //2. 从配图数组(pic_urls)中取出图片
            for url in viewModel.thumbnail_pic
            {
                //2.1 将当前的下载操作添加到组中
                group.enter()
                SDWebImageManager.shared().downloadImage(with: url, options: [], progress: nil, completed: { (image, error, _, _, _) in
                    // 将当前下载操作从组中移除
                    group.leave()
                })
            }
        }
        
        //3. 监听下载操作, 当全部下载完后刷新表单
        // 监听下载 操作
        group.notify(queue: DispatchQueue.main) { () -> Void in
        
            Dlog("全部下载完成")
            // 刷新表格
            self.homeTableView.reloadData()
            self.homeTableView.mj_header.endRefreshing()
            self.homeTableView.mj_footer.endRefreshing()
       
            // 显示刷新的微博条数
            self.showTipLabel(dataArr.count)
        }
        
    }
    
    //显示更新的微博条数
    fileprivate func showTipLabel(_ count: Int) {
        tipLabel.isHidden = false
        tipLabel.text = count == 0 ? "没有新数据" : "\(count) 条微博"
        //执行动画
        
        UIView.animate(withDuration: 1.0, animations: { 
            self.tipLabel.frame.origin.y = 70

        }) { (_) in
            UIView.animate(withDuration: 1.0, animations: { 
                self.tipLabel.frame.origin.y = 10
               
            }, completion: { (_) in
                self.tipLabel.isHidden = true
            })
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
    
    
    @objc fileprivate func showPhotoBrowser(_ note : Notification){
    
        
        guard let picUrls = note.userInfo![showPhotoBrowserNotificationURLs] as? [URL], let indexPath = note.userInfo![showPhotoBrowserNotificationIndexPath] as?  IndexPath else {
        return
        }
        
        
    
        let photoBrowseVC = PhotoBrowseController(indexPath: indexPath, picUrls:picUrls)
        
        
        
        present(photoBrowseVC, animated: true, completion: nil)
    
    }
    
}




