//
//  PhotoBrowseCell.swift
//  weibo_wjq
//
//  Created by landixing on 2017/6/12.
//  Copyright © 2017年 WJQ. All rights reserved.
//

import UIKit

import SDWebImage

protocol tapImageDelegate: NSObjectProtocol {
    func imageViewClick(_ cell : PhotoBrowseCell)

}

class PhotoBrowseCell: UICollectionViewCell {
    
    lazy var scrollView : UIScrollView = UIScrollView()
   lazy var imageview = UIImageView()
    
    //加载进度
    fileprivate lazy var progressView : ProgressView = {
    
       let progressView : ProgressView = ProgressView()
        progressView.bounds = CGRect(x: 0, y: 0, width: 88, height: 88)
        progressView.center = CGPoint(x: UIScreen.main.bounds.width * 0.5, y: UIScreen.main.bounds.height * 0.5)
        progressView.backgroundColor = UIColor.clear
        progressView.isHidden = true
        return progressView
    }()
    
   var delegate : tapImageDelegate?
    
    
    var url : URL?
    {
        didSet{
        
            guard let url = url else { return  }
            
            setupContent(url: url)
            
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupUI()
    }
   
    
}


extension PhotoBrowseCell  {
    fileprivate func setupUI() {
    
        contentView.addSubview(scrollView)
        scrollView.addSubview(imageview)
        contentView.addSubview(progressView)
        scrollView.frame = contentView.bounds
        scrollView.frame.size.width -= 20
     
       
    
    
    
        // 4.给imageView添加监听手势
        let tapGest = UITapGestureRecognizer(target: self, action: #selector(PhotoBrowseCell.imageViewClick))
        imageview.addGestureRecognizer(tapGest)
        imageview.isUserInteractionEnabled = true
    }
    @objc fileprivate func imageViewClick() {
        delegate?.imageViewClick(self)
    }
}

extension PhotoBrowseCell  {
    
}

extension PhotoBrowseCell  {
    
    func setupContent(url : URL) {
        let image = SDWebImageManager.shared().imageCache.imageFromDiskCache(forKey: url.absoluteString)
        
        
        
        imageview.image = image
        
        imageFrame(image: image!)
        
        
        let bigPicUrl = getBigPicURL(url)
        progressView.isHidden = false
        imageview.sd_setImage(with: bigPicUrl, placeholderImage: image, options: [], progress: { (current, total) in
           
            
            DispatchQueue.main.async(execute: { 
                 self.progressView.progress = CGFloat(current) / CGFloat(total)
            })
           
            
        }) { (_, _, _, _) in
            self.imageFrame(image: image!)
            self.progressView.isHidden = true
        }

        
        
    }
    //imageFrame and scrollview.contentsize
    
    fileprivate func imageFrame(image: UIImage) {
    
        let screenW = UIScreen.main.bounds.width
        let screenH = UIScreen.main.bounds.height
        
        let imageWidth = screenW
        let imageHeight = imageWidth / (image.size.width) * (image.size.height)
        
        var y: CGFloat = 0
        
        if imageHeight > screenH{
            //大图
            y = 0
        }else {
            // 小图
            y = (screenH - imageHeight) * 0.5
            
        }
        
        imageview.frame =  CGRect(x: 0, y: y, width: imageWidth, height: imageHeight)
        scrollView.contentSize = CGSize(width: 0, height: imageHeight)

    }
    
    //MARK: -- 大图
    fileprivate func getBigPicURL(_ smallUrl: URL) -> URL?{
    
        let smallPicUrl = smallUrl.absoluteString
        
        let bigPicUrl = (smallPicUrl as NSString).replacingOccurrences(of: "thumbnail", with: "bmiddle")
        return URL(string: bigPicUrl)
    }
    
}


























