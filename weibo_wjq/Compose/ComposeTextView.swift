//
//  ComposeTextView.swift
//  weibo_wjq
//
//  Created by landixing on 2017/6/6.
//  Copyright © 2017年 WJQ. All rights reserved.
//

import UIKit

class ComposeTextView: UITextView {

    lazy var placeHolderLabel : UILabel = UILabel()
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        setupPlaceHolder()
    }


}


extension ComposeTextView {
    
    fileprivate func setupPlaceHolder() {
        addSubview(placeHolderLabel)
        
        placeHolderLabel.snp.makeConstraints { (make) in
            make.top.equalTo(8)
            make.leading.equalTo(10)
        }

        placeHolderLabel.text = "分享新鲜事..."
        placeHolderLabel.font = font
        placeHolderLabel.textColor = UIColor.lightGray
        
        textContainerInset = UIEdgeInsets(top: 8, left: 7, bottom: 0, right: 10)
    }
}









