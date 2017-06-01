//
//  NewfeatureViewController.swift
//  weibo_wjq
//
//  Created by landixing on 2017/5/29.
//  Copyright © 2017年 WJQ. All rights reserved.
//

import UIKit
import SnapKit

class NewfeatureViewController: UIViewController {

    //item个数
    fileprivate var maxCount = 4
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    

}



extension NewfeatureViewController: UICollectionViewDataSource
{
    
   //分区
      func numberOfSections(in collectionView: UICollectionView) -> Int{
        return 1
    }
    
    //每个分区的item的个数
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int{
        return maxCount
    }
    
    
    // 绘制cell
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cellIdentifier", for: indexPath) as! NewfeatureCell
        
        
        cell.index = indexPath.item
        return cell
    }
   
}


extension NewfeatureViewController: UICollectionViewDelegate {

    //完全显示时调用
    func collectionView(_ collectionView: UICollectionView, didEndDisplaying cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        // 注意: 传入的cell和indexPath都是上一页的, 而不是当前页
        //        Dlog(indexPath.item)
        
        // 1.手动获取当前显示的cell对应的indexPath
        let index = collectionView.indexPathsForVisibleItems.last!
        Dlog(index.item)
        // 2.根据指定的indexPath获取当前显示的cell
        let currentCell = collectionView.cellForItem(at: index) as! NewfeatureCell
        // 3.判断当前是否是最后一页
        if index.item == (maxCount - 1)
        {
            // 做动画
            currentCell.startAniamtion()
        }
    }

}

class NewfeatureCell : UICollectionViewCell{
 
    //MARK: -- 懒加载
    
    //图片
    fileprivate lazy var imageView = UIImageView()
    // 开始按钮    闭包
    fileprivate lazy var startBtn: UIButton = {
        let btn = UIButton(normalImg: nil, seleImg:"new_feature_button")
        btn.addTarget(self, action: #selector(NewfeatureCell.startBtnClick), for: .touchUpInside)
        return btn
    }()
    
    var index: Int = 0
    {
        didSet{
            
            // 1.生成图片名称
            let name = "new_feature_\(index + 1)"
            // 2.设置图片
            imageView.image = UIImage(named: name)
            startBtn.isHidden = true
        }
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        // 初始化UI
        setupUI()
    }
    // 初始化UI
    fileprivate func setupUI(){
        contentView.addSubview(imageView)
        contentView.addSubview(startBtn)
        imageView.snp.makeConstraints { (make) in
            make.edges.equalTo(0)
        }
        
        startBtn.snp.makeConstraints { (make) -> Void in
            make.centerX.equalTo(contentView)
            make.bottom.equalTo(contentView).offset(-160)
        }

    }
    
    fileprivate func startAniamtion(){
        startBtn.isHidden = false
        startBtn.transform = CGAffineTransform(scaleX: 0.0, y: 0.0)
        startBtn.isUserInteractionEnabled = false
        
        UIView.animate(withDuration: 2.0, delay: 0.0, usingSpringWithDamping: 0.5, initialSpringVelocity: 10, options: UIViewAnimationOptions(rawValue: 0), animations: { 
            self.startBtn.transform = CGAffineTransform.identity
        }) { (_) in
            self.startBtn.isUserInteractionEnabled = true
        }
    
    }
    
    //MARK: -- 进入微博
    @objc private func startBtnClick(){
    
        NotificationCenter.default.post(name: Notification.Name(rawValue: SwitchRootViewController), object: true)
    }
   
}

// MARK: - 自定义布局类
class NewfeatureLayout: UICollectionViewFlowLayout {
    override func prepare() {
        // 1.设置每个cell的尺寸
        itemSize = UIScreen.main.bounds.size
        // 2.设置cell之间的间隙
        minimumInteritemSpacing = 0
        minimumLineSpacing = 0
        // 3.设置滚动方向
        scrollDirection = UICollectionViewScrollDirection.horizontal
        
        // 4.设置分页
        collectionView?.isPagingEnabled = true
        // 5.禁用回弹
        collectionView?.bounces = false
        // 6.取出滚动条
        collectionView?.showsHorizontalScrollIndicator = false
        collectionView?.showsVerticalScrollIndicator = false

    }
}

