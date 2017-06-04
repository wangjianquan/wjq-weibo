//
//  HomeCell.swift
//  weibo_wjq
//
//  Created by landixing on 2017/6/1.
//  Copyright © 2017年 WJQ. All rights reserved.
//

import UIKit
import SDWebImage


private let edgeMargin : CGFloat = 10
private let itemMargin : CGFloat = 12

class HomeCell: UITableViewCell {
    
    @IBOutlet var picCollectionView: UICollectionView!
    
   
    
    @IBOutlet var flowLayout: UICollectionViewFlowLayout!
    
    /// 头像
    @IBOutlet weak var iconImageView: UIImageView!
    /// 认证图标
    @IBOutlet weak var verifiedImageView: UIImageView!
    /// 昵称
    @IBOutlet weak var nameLabel: UILabel!
    /// 会员图标
    @IBOutlet weak var vipImageView: UIImageView!
    /// 时间
    @IBOutlet weak var timeLabel: UILabel!
    /// 来源
    @IBOutlet weak var sourceLabel: UILabel!
    /// 正文
    @IBOutlet weak var contentLabel: UILabel!
    
    
    @IBOutlet var footerview: UIView!
    
    @IBOutlet var retweetBgView: UIView!
    //转发微博正文
    @IBOutlet var retweetedContentLabel: UILabel!
    @IBOutlet var retweetedContentLabelTopCons: NSLayoutConstraint!
    @IBOutlet var picCollecWidthConstr: NSLayoutConstraint!
    @IBOutlet var picCollecHeightConstr: NSLayoutConstraint!
    
    var  viewModel : StatusViewModel?
    {
        didSet {
            // 1.nil值校验
            guard let viewModel = viewModel else {
                return
            }

            //头像
            iconImageView.layer.cornerRadius = 30
            iconImageView.layer.masksToBounds = true
            iconImageView.sd_setImage(with: viewModel.icon_URL)
            
            //认证图标
           verifiedImageView.image = viewModel.verified_image
            
            //会员图标
            /// 会员等级 ,取值范围 1~6
            vipImageView.image = viewModel.mbrankImage
            
           
            //昵称
            if let nameStr = viewModel.status.user?.screen_name {
                nameLabel.text = nameStr
            }
             nameLabel.textColor = viewModel.mbrankImage == nil ? UIColor.black : UIColor.orange
            
            //时间
            timeLabel.text = viewModel.created_Time
            
            
            //微博来源
            sourceLabel.text = viewModel.source_Text
           
            //内容
            contentLabel.text = viewModel.status.text
           
            //注册重用标示符
            let nib = UINib(nibName: "PicCollectionViewCell", bundle: nil)
            picCollectionView.register(nib, forCellWithReuseIdentifier: "PicCollectionViewCell")
            picCollectionView.reloadData()
           
            //更新配图尺寸

             let picViewSize = calculatePicViewSize(viewModel.thumbnail_pic.count)
           
                //更新collectionview的尺寸
                picCollecWidthConstr.constant = picViewSize.width
                picCollecHeightConstr.constant = picViewSize.height
           
            
            
           //设置转发正文 
            if viewModel.status.retweeted_status != nil {
                //设置正文
                if let nickName = viewModel.status.retweeted_status?.user?.screen_name, let retweetText = viewModel.status.retweeted_status?.text {
                    retweetedContentLabel.text = "@" + "\(nickName): " + retweetText
                    retweetedContentLabelTopCons.constant = 15
                }
                //2. 设置背景显示
                retweetBgView.isHidden = false
                
            } else {
                // 1.设置转发微博的正文
                retweetedContentLabel.text = nil
                // 2.设置背景显示
                retweetBgView.isHidden = true
                // 3.设置转发正文距离顶部的约束
                retweetedContentLabelTopCons.constant = 0
            }

        }
    }
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
}

//MARK: -- 
extension HomeCell {

    // MARK: - 内部控制方法
    /// 计算cell和collectionview的尺寸
    fileprivate func calculatePicViewSize(_ count : Int) -> CGSize {
        // 1.没有配图
        if count == 0 {
            return CGSize.zero
        }
        
        // 2.单张配图
        if count == 1 {
            // 1.取出图片
            let urlString = viewModel?.thumbnail_pic
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
    
    
    func calculateRowHeight(_ viewModel: StatusViewModel) -> CGFloat {
        self.viewModel = viewModel
        self.layoutIfNeeded()
        return footerview.frame.maxY
    }
    
    
}

extension HomeCell : UICollectionViewDataSource {

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int
    {
        return viewModel?.thumbnail_pic.count ?? 0
    
    }
    
    
   
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell
    {
    
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PicCollectionViewCell", for: indexPath) as! PicCollectionViewCell
        
        cell.url = viewModel!.thumbnail_pic[indexPath.item]
        
        return cell
    }


}
