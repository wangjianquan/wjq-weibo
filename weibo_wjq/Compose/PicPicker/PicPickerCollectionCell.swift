//
//  PicPickerCollectionCell.swift
//  weibo_wjq
//
//  Created by landixing on 2017/6/7.
//  Copyright © 2017年 WJQ. All rights reserved.
//

import UIKit

@objc
protocol picCollectionCellDelegate : NSObjectProtocol {
    @objc optional func picPickerViewCellWithaddPhotoBtnClick(_ cell : PicPickerCollectionCell)
    @objc optional func PicPickerViewCellWithRemovePhotBtnClick(_ cell : PicPickerCollectionCell)
}


class PicPickerCollectionCell: UICollectionViewCell {
    
    @IBOutlet var addBtn: UIButton!
    @IBOutlet var picImage: UIImageView!
    @IBOutlet var deleteBtn: UIButton!
    
    
    
    weak var delegate: picCollectionCellDelegate?

    var image: UIImage?
    {
        didSet {
        
            picImage.image = image
            picImage.contentMode = UIViewContentMode.scaleAspectFill
            picImage.clipsToBounds = true
            picImage.isHidden = image == nil
            deleteBtn.isHidden = image == nil
            addBtn.isUserInteractionEnabled = image == nil
            
        }
    }
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
       
    
    }
    
    @IBAction func addBtnAction() {
        if delegate?.responds(to: #selector(picCollectionCellDelegate.picPickerViewCellWithaddPhotoBtnClick(_:))) != nil {
            delegate?.picPickerViewCellWithaddPhotoBtnClick!(self)
        }
    }
    @IBAction func deleBtnAction() {
        if delegate?.responds(to: #selector(picCollectionCellDelegate.PicPickerViewCellWithRemovePhotBtnClick(_:))) != nil {
            delegate?.PicPickerViewCellWithRemovePhotBtnClick!(self)
        }

    }

}











