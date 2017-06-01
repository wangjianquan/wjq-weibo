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
    
    var  status : Status?
    {
        didSet {
            //头像
            if let url = URL(string: (status?.user?.profile_image_url)!) {
                 iconImageView.sd_setImage(with: url)
                iconImageView.layer.cornerRadius = 30
                iconImageView.layer.masksToBounds = true
            }
            
            //认证图标
            /// 用户认证类型 -1：没有认证，0，认证用户，2,3,5: 企业认证，220: 达人
            
            if let type = status?.user?.verified_type {
                
                var name = ""
                switch type
                {
                case 0:
                    name = "avatar_vip"
                case 2, 3, 5:
                    name = "avatar_enterprise_vip"
                case 220:
                    name = "avatar_grassroot"
                default:
                    name = ""
                }
                verifiedImageView.image = UIImage(named: name)
            }
            
            //会员图标
            /// 会员等级 ,取值范围 1~6
            if let rank = status?.user?.mbrank {
                
                if rank >= 1 && rank <= 6 {
                    vipImageView.image = UIImage(named: "common_icon_membership_level\(rank)")
                    nameLabel.textColor = UIColor.orange

                } else {
                    vipImageView.image = nil
                    nameLabel.textColor = UIColor.black
                }
                
            }
            
            //昵称
            nameLabel.text = status?.user?.screen_name
            
            //时间
            timeLabel.text = status?.created_at
            
            //来源
            sourceLabel.text = status?.source
            
            //内容
            contentLabel.text = status?.text
           
            
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
