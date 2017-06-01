//
//  WelcomeViewController.swift
//  weibo_wjq
//
//  Created by landixing on 2017/5/29.
//  Copyright © 2017年 WJQ. All rights reserved.
//

import UIKit
import SDWebImage


class WelcomeViewController: UIViewController {

    @IBOutlet var avatorImageView: UIImageView!
    
    @IBOutlet var nameLabel: UILabel!
    
    @IBOutlet var iconBottomConstaint: NSLayoutConstraint!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        avatorImageView.layer.cornerRadius = 40
        avatorImageView.layer.masksToBounds = true
        assert(UserAccount.loadAccount() != nil,"必须授权之后才能显示欢迎界面")
        
        guard let url = URL(string: (UserAccount.loadAccount()?.avatar_large)!) else {
            return
        }
        avatorImageView.sd_setImage(with: url)
        
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
     iconBottomConstaint.constant = (UIScreen.main.bounds.height - iconBottomConstaint.constant)
     UIView.animate(withDuration: 2.0, animations: { 
        self.view.layoutIfNeeded()
     }) { (_) in
        UIView.animate(withDuration: 2.0, animations: { () -> Void in
            self.nameLabel.alpha = 1.0
        }, completion: { (_) -> Void in

            //动画结束,进入欢迎界面
             NotificationCenter.default.post(name: Notification.Name(rawValue: SwitchRootViewController), object: true)
        })
        }
    
    
    }
    
    
}
