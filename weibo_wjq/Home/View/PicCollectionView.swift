//
//  PicCollectionView.swift
//  weibo_wjq
//
//  Created by landixing on 2017/6/13.
//  Copyright © 2017年 WJQ. All rights reserved.
//

import UIKit
import SDWebImage

private let edgeMargin : CGFloat = 10
private let itemMargin : CGFloat = 12

class PicCollectionView: UICollectionView {

    @IBOutlet var picCollecWidthConstr: NSLayoutConstraint!
    @IBOutlet var picCollecHeightConstr: NSLayoutConstraint!
    // MARK:- 属性
    var picURLs : [URL] = [URL]() {
        didSet {
            
            let picViewSize = calculatePicViewSize(picURLs.count)
            //更新collectionview的尺寸
            picCollecWidthConstr.constant = picViewSize.width
            picCollecHeightConstr.constant = picViewSize.height
           
            // 3.刷新表格
            reloadData()
        }
    }
    
    // MARK:- 系统回调函数
    override func awakeFromNib() {
        super.awakeFromNib()
        
        // 1.设置collectionView的属性
        self.dataSource = self
        self.delegate = self
    }

}

//MARK: --
extension PicCollectionView {
  

    
    // MARK: - 内部控制方法
    /// 计算cell和collectionview的尺寸
    fileprivate func calculatePicViewSize(_ count : Int) -> CGSize {
     
        let flowLayout = self.collectionViewLayout as! UICollectionViewFlowLayout
        // 1.没有配图
        if count == 0 {
            return CGSize.zero
        }
        
        // 2.单张配图
        if count == 1 {
            // 1.取出图片
            let urlString = picURLs
                .last?.absoluteString
            let image = SDWebImageManager.shared().imageCache.imageFromDiskCache(forKey: urlString)
            // 2.设置一张图片是layout的itemSize
            flowLayout.itemSize = CGSize(width: (image?.size.width)! * 2, height: (image?.size.height)! * 2)
            
            return CGSize(width: image!.size.width * 2, height: image!.size.height * 2)
        }
        
        // 3.计算出来imageViewWH
        let imageViewWH = (UIScreen.main.bounds.width - 2 * edgeMargin - 2 * itemMargin) / 3
        
        // 4.设置其他张图片时layout的itemSize
        flowLayout.itemSize = CGSize(width: imageViewWH, height: imageViewWH)
        
        // 5.四张配图
        if count == 4 {
            let picViewWH = imageViewWH * 2 + itemMargin
            return CGSize(width: picViewWH, height: picViewWH)
        }
        
        // 6.其他张配图
        // 6.1.计算行数
        let rows = CGFloat((count - 1) / 3 + 1)
        
        // 6.2.计算picView的高度
        let picViewH = rows * imageViewWH + (rows - 1) * itemMargin
        
        // 6.3.计算picView的宽度
        let picViewW = UIScreen.main.bounds.width - 2 * edgeMargin
        
        return CGSize(width: picViewW, height: picViewH)
    }
   
}

extension PicCollectionView : UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int
    {
        return picURLs.count 
        
    }
    
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell
    {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PicCollectionViewCell", for: indexPath) as! PicCollectionViewCell
        
        cell.url = picURLs[indexPath.item]
        
        return cell
    }
    
    
}

extension PicCollectionView : UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        
        // 1.获取发送通知需要携带的信息
        let userInfo = [showPhotoBrowserNotificationURLs : picURLs, showPhotoBrowserNotificationIndexPath : indexPath] as [String : Any]
        
        // 2.发出通知
        NotificationCenter.default.post(name: Notification.Name(rawValue: showPhotoBrowserNotification), object: self, userInfo: userInfo)
    }
    
}


extension PicCollectionView : AnimatorPresentDelegate {
   //开始位置
    func startAnimatorRect(indexpath: IndexPath) -> CGRect {
        // 1.根据indexPath取出cell
        let cell = self.cellForItem(at: indexpath)!
        
        // 2.取出cell相当于window的位置
        let frame = self.convert(cell.frame, to: UIApplication.shared.keyWindow!)
        
        return frame
    }
    
    //结束位置
    func endAnimatorRect(indexpath: IndexPath) -> CGRect {
    
        let  url = picURLs[indexpath.item]
         let image = SDWebImageManager.shared().imageCache.imageFromDiskCache(forKey: url.absoluteString)
        
        let screenH = UIScreen.main.bounds.height
        let screenW = UIScreen.main.bounds.width
        let imageWidth = image?.size.width
        let imageHeigth = screenW / imageWidth! * (image?.size.height)!
        
        var endFrame = CGRect.zero
        if imageHeigth > screenH {
            endFrame = CGRect(x: 0, y: 0, width: screenW, height: imageHeigth)
        } else {
            endFrame = CGRect(x: 0, y: (screenH - imageHeigth) * 0.5, width: screenW, height: imageHeigth)
        }
        
        return endFrame
    }
    
    //临时imageView
    func imageView(indexpath: IndexPath) -> UIImageView {
        
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        let image = SDWebImageManager.shared().imageCache.imageFromDiskCache(forKey: picURLs[indexpath.item].absoluteString)
        imageView.image = image
        return imageView
        
    }

    
    
}
