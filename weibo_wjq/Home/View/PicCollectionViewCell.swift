//
//  PicCollectionViewCell.swift
//  weibo_wjq
//
//  Created by landixing on 2017/6/4.
//  Copyright © 2017年 WJQ. All rights reserved.
//

import UIKit

class PicCollectionViewCell: UICollectionViewCell {
    @IBOutlet var picImageView: UIImageView!

    var url : URL?
    {
     didSet{
        picImageView.sd_setImage(with: url)
        }
    
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

}
