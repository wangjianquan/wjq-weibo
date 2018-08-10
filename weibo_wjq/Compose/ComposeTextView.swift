//
//  ComposeTextView.swift
//  weibo_wjq
//
//  Created by landixing on 2017/6/6.
//  Copyright © 2017年 WJQ. All rights reserved.
//

import UIKit

class ComposeTextView: UITextView {

    lazy fileprivate var  placeHolderLabel:UILabel = {
        let placeholderLabel = UILabel()
        placeholderLabel.backgroundColor = UIColor.clear
        placeholderLabel.text = placeHolder
        placeholderLabel.font = self.font
        placeholderLabel.textColor = UIColor.lightGray
        placeholderLabel.numberOfLines = 0
        textContainerInset = UIEdgeInsets(top: 10, left: 8, bottom: 0, right: 10)
        return placeholderLabel
    }()
    
    @IBInspectable var placeholderColor: UIColor? = UIColor.lightText{
        didSet{
            guard let textColor = placeholderColor else { return }
            placeHolderLabel.textColor = textColor
        }
    }
    
    @IBInspectable var placeHolder:String? = "请输入内容..." {
        didSet{
            guard let str = placeHolder else {return}
            placeHolderLabel.text = str
        }
    }
    
    override init(frame: CGRect, textContainer: NSTextContainer?) {
        super.init(frame: frame, textContainer: textContainer)
        setupPlaceHolder()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupPlaceHolder()
    }
    
    fileprivate func setupPlaceHolder() {
        NotificationCenter.default.addObserver(self, selector: #selector(textDidChange(_:)), name: NSNotification.Name.UITextViewTextDidChange, object: nil)
        
        addSubview(placeHolderLabel)
        placeHolderLabel.translatesAutoresizingMaskIntoConstraints = false
        let top = NSLayoutConstraint(item: placeHolderLabel, attribute: .top, relatedBy: .equal, toItem: self, attribute:.top, multiplier: 1.0, constant: 8)
        let left = NSLayoutConstraint(item: placeHolderLabel, attribute: .leading, relatedBy: .equal, toItem: self, attribute:.leading, multiplier: 1.0, constant: 11)
        let width:NSLayoutConstraint = NSLayoutConstraint(item: placeHolderLabel, attribute: .width, relatedBy:.equal, toItem:nil, attribute: .notAnAttribute, multiplier:0.0, constant:self.bounds.size.width - (2 * left.constant))
        placeHolderLabel.addConstraint(width)//自己添加约束
        //子元素相对父亲的元素，由父添加
        self.addConstraints([top,left])
        
    }
    
    @objc fileprivate func textDidChange(_ notification: Notification){
        placeHolderLabel.isHidden = hasText
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
}









