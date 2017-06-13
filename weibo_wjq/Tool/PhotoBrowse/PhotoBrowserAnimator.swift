//
//  PhotoBrowserAnimator.swift
//  weibo_wjq
//
//  Created by landixing on 2017/6/13.
//  Copyright © 2017年 WJQ. All rights reserved.
//

import UIKit


protocol AnimatorPresentDelegate: NSObjectProtocol {

    //开始位置
    func startAnimatorRect(indexpath: IndexPath) -> CGRect

    //结束位置
    func endAnimatorRect(indexpath: IndexPath) -> CGRect
    //临时
    func imageView(indexpath: IndexPath) -> UIImageView

}

protocol AnimatorDismissDelegate: NSObjectProtocol {
    
    func imageViewForDismissView() -> UIImageView
    func indexPathForDismissView() -> IndexPath
    
}

class PhotoBrowserAnimator: NSObject {

    var isPresented : Bool = false
    var presentDelegate : AnimatorPresentDelegate?
    var dismissDelegate : AnimatorDismissDelegate?
    
    var indexPath: IndexPath?
    
    func setIndexPath(_ indexPath : IndexPath, presentedDelegate : AnimatorPresentDelegate, dismissDelegate : AnimatorDismissDelegate) {
        self.indexPath = indexPath
        self.presentDelegate = presentedDelegate
        self.dismissDelegate = dismissDelegate
    }
    
    
}

extension PhotoBrowserAnimator : UIViewControllerTransitioningDelegate{
    
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        isPresented = true
        return self
    }
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        isPresented = false
        return self
    }
    
}

extension PhotoBrowserAnimator : UIViewControllerAnimatedTransitioning{
   
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval
    {
    
        return 0.5
    }
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning){
    
        isPresented ? animationForPresentedView(transitionContext) : animationForDismissView(transitionContext)
        
    }

}
extension PhotoBrowserAnimator {
    
    //present动画
    fileprivate func animationForPresentedView(_ transitionContext: UIViewControllerContextTransitioning?)
    {
        guard let presentDelegate = presentDelegate, let indexpath = indexPath else { return  }
        
        guard let presentView = transitionContext?.view(forKey: UITransitionContextViewKey.to) else {
        return
        }
        transitionContext?.containerView.addSubview(presentView)
        

        //临时iamgeview
        let imageview = presentDelegate.imageView(indexpath: indexpath)
        transitionContext?.containerView.addSubview(imageview)
        //开始位置
        imageview.frame = presentDelegate.startAnimatorRect(indexpath: indexpath)
        presentView.alpha = 0.0
        transitionContext?.containerView.backgroundColor = UIColor.black
        UIView.animate(withDuration: transitionDuration(using: transitionContext), animations: {
            
            //结束位置
            imageview.frame = presentDelegate.endAnimatorRect(indexpath: indexpath)
            
        }) { (_) in
            transitionContext?.containerView.backgroundColor = UIColor.clear
            imageview.removeFromSuperview()
            presentView.alpha = 1.0
            transitionContext?.completeTransition(true)
        }
        
    }
    
    
    //dismiss动画
   fileprivate func animationForDismissView(_ transitionContext: UIViewControllerContextTransitioning){
    
            guard let dismissDele = dismissDelegate, let presentDele = presentDelegate else {
                return
            }
            guard let dismissView = transitionContext.view(forKey: UITransitionContextViewKey.from) else {
                return
            }
            dismissView.removeFromSuperview()

    
            let imageview = dismissDele.imageViewForDismissView()
            transitionContext.containerView.addSubview(imageview)
    
            let indexpath = dismissDele.indexPathForDismissView()
    
    
            UIView.animate(withDuration: transitionDuration(using: transitionContext), animations: {

                imageview.frame = presentDele.startAnimatorRect(indexpath: indexpath)
                
            }) { (_) in
                imageview.removeFromSuperview()
                transitionContext.completeTransition(true)
            }
            

    
    
    }
    
}













