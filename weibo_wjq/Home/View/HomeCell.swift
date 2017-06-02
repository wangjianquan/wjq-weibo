//
//  HomeCell.swift
//  weibo_wjq
//
//  Created by landixing on 2017/6/1.
//  Copyright © 2017年 WJQ. All rights reserved.
//

import UIKit
import SDWebImage

class HomeCell: UITableViewCell {
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
    
    var  viewModel : StatusViewModel?
    {
        didSet {
            //头像
            iconImageView.layer.cornerRadius = 30
            iconImageView.layer.masksToBounds = true
            iconImageView.sd_setImage(with: viewModel?.icon_URL)
            
            //认证图标
           verifiedImageView.image = viewModel?.verified_image
            
            //会员图标
            /// 会员等级 ,取值范围 1~6
            vipImageView.image = nil
            nameLabel.textColor = UIColor.black
            if let vip = viewModel?.mbrankImage {
                vipImageView.image = vip
                nameLabel.textColor = UIColor.orange

            }
            
            //昵称
            if let nameStr = viewModel?.status.user?.screen_name {
                nameLabel.text = nameStr
            }
            
            //时间
            timeLabel.text = viewModel?.created_Time
            
            
            //微博来源
            sourceLabel.text = viewModel?.source_Text
           
            //内容
            contentLabel.text = viewModel?.status.text
           
            
        }
    }
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
