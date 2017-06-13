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
    
    
    @IBOutlet var picCollectionView: PicCollectionView!
   
    
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
           
           
           
            picCollectionView.picURLs = viewModel.thumbnail_pic

            
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

extension HomeCell {
    
    func calculateRowHeight(_ viewModel: StatusViewModel) -> CGFloat {
        self.viewModel = viewModel
        self.layoutIfNeeded()
        return footerview.frame.maxY
    }
    
}






