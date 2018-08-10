//
//  ComposeViewContro.swift
//  weibo_wjq
//
//  Created by landixing on 2017/6/7.
//  Copyright © 2017年 WJQ. All rights reserved.
//

import UIKit
import SVProgressHUD


class ComposeViewContro: UIViewController {
    
    
    @IBOutlet var toolBarBottomCons: NSLayoutConstraint!
    @IBOutlet var toolBar: UIToolbar!
    @IBOutlet var customTextView: ComposeTextView!
    
    fileprivate lazy var emoticonVc : EmotionViewController = EmotionViewController {[weak self] (emoticon) -> () in
        self?.customTextView.insertEmoticon(emoticon)
        self?.textViewDidChange((self?.customTextView)!)
    }
    

    //MARK: -- 懒加载
    fileprivate lazy var titleView : ComposeTitleView = {
        let titleView = ComposeTitleView()
        titleView.frame = CGRect(x: 0, y: 0, width: 100, height: 40)
        titleView.screenNameLabel.text = UserAccount.loadAccount()?.screen_name
        return titleView
    }()
    
    //图片CollectionView
    fileprivate lazy var picPickerView: PicPickerViewContro = PicPickerViewContro(collectionViewLayout: layout())
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()

        //KeyboardWillChangeFrame
        NotificationCenter.default.addObserver(self, selector: #selector(ComposeViewContro.keyboardWillChangeFrame(_:)), name: NSNotification.Name.UIKeyboardWillChangeFrame, object: nil)
        // 3.初始化照片选择控制器
        setupPicPickerView()
    
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        customTextView.becomeFirstResponder()
    }

    //照片按钮
    @IBAction func picPickerItemClick() {
        //打开相册
       picPickerView.imagePickerControll()
        //显示照片选择
        self.showPicPickerView()
        
        
    }
    
    @IBAction func emoBtnAction(_ sender: UIButton) {
       sender.isSelected = !sender.isSelected
        customTextView.resignFirstResponder()
        
        customTextView.inputView = customTextView.inputView != nil ? nil : emoticonVc.view
        
        customTextView.becomeFirstResponder()
        
    }
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

}


//MARK: -- UI设置
extension ComposeViewContro {
    fileprivate func  setupUI() {
    
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "取消", style: .plain, target: self, action: #selector(ComposeViewContro.closeItemClick))
            
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "发布", style: .plain, target: self, action: #selector(ComposeViewContro.composeItemClick))
        
        navigationItem.titleView = titleView
        
        customTextView.delegate = self
    }
    
    // 3.初始化选择控制器(隐藏)
   fileprivate func  setupPicPickerView(){
    
       //添加照片选择器在
        view.insertSubview(picPickerView.view, belowSubview: toolBar)
        
        addChildViewController(picPickerView)
        
        picPickerView.view.snp.makeConstraints { (make) in
            make.left.equalTo(0)
            make.right.equalTo(0)
            make.bottom.equalTo(0)
            make.height.equalTo(0)
        }
    
    }
    
    // 4.显示选择控制器
    fileprivate func  showPicPickerView(){
        
        self.customTextView.resignFirstResponder()
        picPickerView.view.snp.remakeConstraints { (make) in
            make.left.equalTo(0)
            make.right.equalTo(0)
            make.bottom.equalTo(0)
            make.height.equalTo(self.view).multipliedBy(0.65)
        }
        
        UIView.animate(withDuration: 1.5) {
            self.view.layoutIfNeeded()
        }
       

    }
    
    
}


//MARK: -- 点击事件
extension ComposeViewContro {
    @objc fileprivate func closeItemClick() {
        customTextView.resignFirstResponder()
        dismiss(animated: true, completion: nil)
        
    }
    
    
    //MARK: -- 发布微博
    @objc fileprivate func composeItemClick() {
       
        customTextView.resignFirstResponder()
        let statusString = customTextView.getEmoticonString()//微博正文
        
        //回调成功与否闭包
        let finishedCallBack = {(isSuccess: Bool) -> () in
            if !isSuccess {
                SVProgressHUD.showError(withStatus: "发送微博失败")
                return
            }
            SVProgressHUD.showSuccess(withStatus: "发送微博成功")
            self.dismiss(animated: true, completion: nil)
        }
        
        
        if let image = picPickerView.images.first {
            //带图片
            NetworkTools.shareInstance.sendStatus(statusString, image: image, isSuccess: finishedCallBack)
        }else {
            
            NetworkTools.shareInstance.sendStatus(statusString, isSuccess: finishedCallBack)
        }
    }
    
    //MARK: -- 监听键盘弹出
    @objc fileprivate func keyboardWillChangeFrame(_ note: Notification)
    {
        let duration = note.userInfo![UIKeyboardAnimationDurationUserInfoKey] as! Double
        
        let endFrame = (note.userInfo![UIKeyboardFrameEndUserInfoKey] as! NSValue).cgRectValue
        
        let margin = UIScreen.main.bounds.height - endFrame.origin.y
        
        toolBarBottomCons.constant = margin
        UIView.animate(withDuration: duration) { 
            self.view.layoutIfNeeded()
        }
    }
    
    
    
    
    
}



//MARK: -- 代理方法

extension ComposeViewContro: UITextViewDelegate {
    
    func textViewDidChange(_ textView: UITextView) {
        navigationItem.rightBarButtonItem?.isEnabled = textView.hasText
    }
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        self.customTextView.resignFirstResponder()
    }
}














