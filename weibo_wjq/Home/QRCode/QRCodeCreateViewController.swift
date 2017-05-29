//
//  QRCodeCreateViewController.swift
//  weibo_wjq
//
//  Created by landixing on 2017/5/28.
//  Copyright © 2017年 WJQ. All rights reserved.
//

import UIKit

import SDWebImage

class QRCodeCreateViewController: UIViewController {
    @IBOutlet var cortainerView: UIView!
    
    @IBOutlet var avatorImage: UIImageView! //用户头像
    @IBOutlet var myQRCodeImageView: UIImageView! //

    @IBOutlet var userNameLabel: UILabel! //用户名
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        cortainerView.layer.cornerRadius = 3
        cortainerView.layer.masksToBounds = true

        
        assert(UserAccount.loadAccount() != nil, "必须授权之后才能显示欢迎界面")
        // 2.设置头像
        guard let url = URL(string: UserAccount.loadAccount()!.avatar_large!) else
        {
            return
        }
        avatorImage.sd_setImage(with: url)
        avatorImage.contentMode = UIViewContentMode.scaleAspectFill

        //1. 创建滤镜
        let filter = CIFilter(name: "CIQRCodeGenerator")
        
        //2. 还原滤镜默认属性
        filter?.setDefaults()
        
        //3. 设置需要生成二维码的数据到滤镜中
         filter?.setValue("曾经拥有9527".data(using: String.Encoding.utf8), forKeyPath: "InputMessage")
        //4. 从滤镜中取出生成好的二维码图片
         guard  let ciimage = filter?.outputImage else {
                return
            }
       
        myQRCodeImageView.image = createNonInterpolatedUIImageFormCIImage(ciimage, size: 80)
        
    }
    
    /**
     生成高清二维码
     
     - parameter image: 需要生成原始图片
     - parameter size:  生成的二维码的宽高
     */
    fileprivate func createNonInterpolatedUIImageFormCIImage(_ image: CIImage, size: CGFloat) -> UIImage {
        
        let extent: CGRect = image.extent.integral
        let scale: CGFloat = min(size/extent.width, size/extent.height)
        
        // 1.创建bitmap;
        let width = extent.width * scale
        let height = extent.height * scale
        let cs: CGColorSpace = CGColorSpaceCreateDeviceGray()
        let bitmapRef = CGContext(data: nil, width: Int(width), height: Int(height), bitsPerComponent: 8, bytesPerRow: 0, space: cs, bitmapInfo: 0)!
        
        let context = CIContext(options: nil)
        let bitmapImage: CGImage = context.createCGImage(image, from: extent)!
        
        bitmapRef.interpolationQuality = CGInterpolationQuality.none
        bitmapRef.scaleBy(x: scale, y: scale);
        bitmapRef.draw(bitmapImage, in: extent);
        
        // 2.保存bitmap到图片
        let scaledImage: CGImage = bitmapRef.makeImage()!
        
        return UIImage(cgImage: scaledImage)
    }

   
}
