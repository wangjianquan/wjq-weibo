//
//  QRCodeViewController.swift
//  weibo_wjq
//
//  Created by landixing on 2017/5/26.
//  Copyright © 2017年 WJQ. All rights reserved.
//

//多余的冲击波通过view.clipsToBounds设置


import UIKit
import AVFoundation

class QRCodeViewController: UIViewController {

    //MARK: -- 属性
    @IBOutlet var customBar: UITabBar!
    
    @IBOutlet var containerViewHeight: NSLayoutConstraint! //容器视图的高度
    @IBOutlet var scroLineConstraint: NSLayoutConstraint! //冲击波的top约束
    
    @IBOutlet var describeLabel: UILabel! //描述文字
    
    @IBOutlet var scanlineImg: UIImageView!
    
    @IBOutlet var customContainerView: UIView!
    
    //MARK: -- 懒加载
    
    //输入对象
    fileprivate lazy var input: AVCaptureDeviceInput? = {
    
      let device = AVCaptureDevice.defaultDevice(withMediaType: AVMediaTypeVideo)
        
        return  try? AVCaptureDeviceInput(device: device)
    }()
    
    //输出
    fileprivate lazy var output : AVCaptureMetadataOutput = {
        // 设置输出对象解析数据时的范围(只有在冲击波的扫描区域才有效)
        let out = AVCaptureMetadataOutput()
        
        //1. 获取屏幕的frame
        let viewRect = self.view.frame
        
        //2. 获取扫描容器的frame
        let customContainerViewRect = self.customContainerView.frame

        //注意: 以横屏的左上角为参照做计算而不是以竖屏的左上角为参照
        let  x = customContainerViewRect.origin.y / viewRect.height
        let  y = customContainerViewRect.origin.x / viewRect.width
        let  width = customContainerViewRect.height / viewRect.height
        let  height = customContainerViewRect.width / viewRect.width
        
        out.rectOfInterest = CGRect(x: x, y: y, width: width, height: height)
        return out
    }()
    //会话
    fileprivate lazy var session: AVCaptureSession = AVCaptureSession()
    
    //预览图层
    fileprivate lazy var previewLayer: AVCaptureVideoPreviewLayer = AVCaptureVideoPreviewLayer(session:self.session)
    
    // 专门用于保存描边的图层
    fileprivate lazy var containerLayer :CALayer =  CALayer()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        //1. 默认选中第0个tabBar
        customBar.selectedItem = customBar.items?.first
        customBar.delegate = self
        view.backgroundColor = UIColor(white: 0.7, alpha: 0.8)
        
        //开始扫描
        scanQRCode()
        
        
    }
    
    fileprivate  func scanQRCode()  {
        // 1.判断输入能否添加到会话中
        if !session.canAddInput(input)
        {
            return
        }
        // 2.判断输出能够添加到会话中
        if !session.canAddOutput(output)
        {
            return
        }
        // 3.添加输入和输出到会话中
        session.addInput(input)
        session.addOutput(output)
        
        // 4.设置输出能够解析的数据类型
        // 注意点: 设置数据类型一定要在输出对象添加到会话之后才能设置
        output.metadataObjectTypes = output.availableMetadataObjectTypes
        
        // 5.设置监听监听输出解析到的数据
        output.setMetadataObjectsDelegate(self, queue: DispatchQueue.main)
        
        // 6.添加预览图层
        view.layer.insertSublayer(previewLayer, at: 0)
        previewLayer.frame = view.bounds
        
        //7.添加容器图层
        view.layer.addSublayer(containerLayer)
        containerLayer.frame = view.bounds
        
        //8. 开始扫描
        session.startRunning()
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        startAnimation()//开启动画
    }
    //MARK: -- 开启动画
    fileprivate func startAnimation() {
        // 1.设置冲击波底部和容器视图顶部对齐
        scroLineConstraint.constant = -containerViewHeight.constant
        view.layoutIfNeeded()
        
        // 2.执行扫描动画
        UIView.animate(withDuration: 2.0) { 
            UIView.setAnimationRepeatCount(MAXFLOAT)
            self.scroLineConstraint.constant = self.containerViewHeight.constant
            self.view.layoutIfNeeded()
        }
    }

    //MARK: -- 关闭
    @IBAction func dismissVC(_ sender: UIBarButtonItem) {
        dismiss(animated: true, completion: nil)
    
    }
    
    //MARK: -- 打开相册
    @IBAction func openPhoto(_ sender: UIBarButtonItem) {
        
        //1. 判断相册是否能被打开
        if !UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.photoLibrary){
                return
         }
        
        //2. 创建相册控制器
        
        let imagePicker = UIImagePickerController()
        
        imagePicker.delegate = self
        //3. 弹出相册
        present(imagePicker, animated: true, completion: nil)
        
        
    }
    
    //MARK: -- 我的名片
    @IBAction func VisitingCard(_ sender: UIButton) {
    }
    




}

//MARK:
extension QRCodeViewController: AVCaptureMetadataOutputObjectsDelegate{
    func captureOutput(_ captureOutput: AVCaptureOutput!, didOutputMetadataObjects metadataObjects: [Any]!, from connection: AVCaptureConnection!){
    
        //1. 显示结果
        describeLabel.text = (metadataObjects.last as AnyObject).stringValue
       
        
        clearLayer()
        
        //2. .拿到扫描到的数据
        guard let metadata = metadataObjects.last as? AVMetadataObject else {
            return
        }
        
        //corners { 0.4,0.7 0.5,0.7 0.5,0.5 0.4,0.5 }
        //通过预览图层将corners的值转换为能识别的类型
        let objc = previewLayer.transformedMetadataObject(for:metadata )
        Dlog((objc as!  AVMetadataMachineReadableCodeObject).corners) //
        
        //二维码描边
        drawLines(objc: objc as!  AVMetadataMachineReadableCodeObject)
    }
    //MARK: -- 绘制描边
    fileprivate func drawLines(objc:  AVMetadataMachineReadableCodeObject) {
        
        //1. 安全校验
        guard let array = objc.corners else {
            return
        }
        
        //2. 创建图层, 用于保存绘制的矩形
        let layer = CAShapeLayer()
        layer.lineWidth = 2 //线段宽度
        layer.strokeColor = UIColor.red.cgColor //线段颜色
        layer.fillColor = UIColor.clear.cgColor //图层填充的颜色
        
        //3. 绘制矩形
        let path = UIBezierPath()
        var point = CGPoint.zero
        var index = 0
        
        
        point = CGPoint(dictionaryRepresentation: array[index] as! CFDictionary)!
        index += 1
        
        //3.1 将起点移动到某个点
        path.move(to: point)
       
        //3.2 连接其他线段
        while index < array.count {
            
            point = CGPoint(dictionaryRepresentation: array[index] as! CFDictionary)!
            index += 1
            path.addLine(to: point)
        }
        
        
        //2.3 关闭路径
        path.close()
        layer.path = path.cgPath
        
        
        //3. 将图层添加到view上
        containerLayer.addSublayer(layer)
        
    
    }
    
    //MAKR: -- 清空描边
    fileprivate func clearLayer() {
    
        guard let subLayers = containerLayer.sublayers else
        {
            return
        }
        for layer in subLayers
        {
            layer.removeFromSuperlayer()
        }
    }
    
}


//MARK: -- UITabBarDelegate
extension QRCodeViewController: UITabBarDelegate{
    func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
        
        // 根据当前选中的按钮重新设置二维码容器高度
        containerViewHeight.constant = (item.tag == 1) ? 150 : 280
        describeLabel.text = (item.tag == 1) ? "将条形码放入框内,即可自动扫描" : "将二维码放入框内,即可自动扫描"
        view.layoutIfNeeded()
        
        
        scanlineImg.layer.removeAllAnimations()//移除动画
        
        startAnimation()//重新开启动
    }
}


extension QRCodeViewController : UINavigationControllerDelegate,UIImagePickerControllerDelegate{
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
     
    //1. 取出图片
        guard  let image = info[UIImagePickerControllerOriginalImage] as? UIImage else {
            return
        }
        
       
        guard let  ciimage = CIImage(image: image) else { return  }
        
        //2. 从选中的图片中读取二维码数据
        
        //2.1 创建一个探测器
        let detector = CIDetector(ofType: CIDetectorTypeQRCode, context: nil, options: [CIDetectorAccuracy:CIDetectorAccuracyHigh])
        
       let results = detector?.features(in: ciimage)
        for result in (results)! {
            
        }
        picker(dismiss(animated: true, completion: nil))
    }

    

}

