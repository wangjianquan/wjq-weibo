//
//  OAuthViewController.swift
//  weibo_wjq
//
//  Created by landixing on 2017/5/28.
//  Copyright © 2017年 WJQ. All rights reserved.
//
/*
 *
 App Key：53729570
 App Secret：cc23ae6e7f115b52c6c944a0d81057c0
 
 //授权页面
 https://api.weibo.com/oauth2/authorize?client_id=53729570&redirect_uri=http://www.baidu.com
 
 */
import UIKit
import SVProgressHUD

class OAuthViewController: UIViewController {

    //
    
    @IBOutlet var OAuthWebView: UIWebView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
      
        
        
        let urlStr = "https://api.weibo.com/oauth2/authorize?client_id=\(WB_App_Key)&redirect_uri=\(WB_Redirect_uri)"

        guard  let url = URL(string: urlStr) else{ return }

        let request = URLRequest(url: url)

        //加载登陆页面
        OAuthWebView.loadRequest(request)
        OAuthWebView.delegate = self

    }
  
}

//MARK: -- UIWebViewDelegate
extension OAuthViewController: UIWebViewDelegate{

    func webViewDidStartLoad(_ webView: UIWebView) {
        // 显示提醒
        SVProgressHUD.showInfo(withStatus: "正在加载中...")
    }
    
    func webViewDidFinishLoad(_ webView: UIWebView) {
        SVProgressHUD.dismiss()
    }
    
    
    // 该方法每次请求都会调用
    // 如果返回false代表不允许请求, 如果返回true代表允许请求
    func webView(_ webView: UIWebView, shouldStartLoadWith request: URLRequest, navigationType: UIWebViewNavigationType) -> Bool {
        
        //1. 判断当前是否是授权回调页面
       guard let urlStr = request.url?.absoluteString
        else {
            return false
        }

        if !urlStr.hasPrefix(WB_Redirect_uri) {
            return true
        }
        
        // 2.判断授权回调地址中是否包含code=
        // URL的query属性是专门用于获取URL中的参数的, 可以获取URL中?后面的所有内容
        let key = "code="
        guard let str = request.url?.query else
        {
            return false
        }
        
        if str.hasPrefix(key) {
            let code = str.substring(from:key.endIndex)

            loadAccessToken(codeStr: code)
            return false
            
        }
        
        return false
     }
    
    
    //MARK: -- 获取accessToken
    fileprivate  func loadAccessToken(codeStr: String?) {
    
        guard let code = codeStr  else { return  }
    
        let url = "https://api.weibo.com/oauth2/access_token"
        
        let dic = ["client_id": WB_App_Key, "client_secret": WB_App_Secret, "grant_type": "authorization_code", "code": code, "redirect_uri": WB_Redirect_uri]
        NetworkTools.shareInstance.request(requestType: .POST, urlString: url, parameters: dic as [String : AnyObject] ) { (json) in
           
            // 1.将授权信息转换为模型
            let account = UserAccount(dict:
                json as! [String : AnyObject])
            
            //2. 获取用户信息
            account.loadUserInfo({ (account) in
                //3. 闭包回调, 保存信息
               _ =  account?.saveAccount()
            })
           
            Dlog(json as Any)
        }
        
      
    }
    
}

