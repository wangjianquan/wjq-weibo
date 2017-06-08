//
//  ComposeTitleView.swift
//  weibo_wjq
//
//  Created by landixing on 2017/6/6.
//  Copyright © 2017年 WJQ. All rights reserved.
//

import UIKit

import SnapKit

class ComposeTitleView: UIView {

    fileprivate lazy var titleLabel: UILabel = UILabel()
    //昵称
    lazy var screenNameLabel: UILabel = UILabel()
   
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupUI()
    }

}

extension ComposeTitleView {
    fileprivate func setupUI() {
    
        addSubview(titleLabel)
        addSubview(screenNameLabel)
        
        //约束
        titleLabel.snp.makeConstraints { (make) in
            make.centerX.equalTo(self.snp.centerX)
            make.top.equalTo(self.snp.top)
        }
        
        screenNameLabel.snp.makeConstraints { (make) in
            make.centerX.equalTo(self.titleLabel.snp.centerX)
            make.top.equalTo(self.titleLabel.snp.bottom).offset(3)
        }
        
        //属性
        titleLabel.font = UIFont.systemFont(ofSize: 15)
        screenNameLabel.font = UIFont.systemFont(ofSize: 13)
        screenNameLabel.textColor = UIColor.lightGray
        titleLabel.textColor = UIColor.black
        
        titleLabel.text = "发微博"
        
        
    }

}
