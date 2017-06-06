//
//  AppDelegate.swift
//  PaymentDemo
//
//  Created by Apple on 6/2/17.
//  Copyright © 2017 Apple. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        //Wechatpay
        WXApi.registerApp("wx26ddbbc6ea531bba", enableMTA: true)

        return true
    }

}


//MARK:- Payment Stack
extension AppDelegate {
    
    func application(_ application: UIApplication, handleOpen url: URL) -> Bool {
        return WXApi.handleOpen(url, delegate: WeChatResponseHandller.shared)
    }
    
    //- (BOOL)application:(UIApplication *)app openURL:(NSURL *)url options:(NSDictionary<NSString*, id> *)options

   // - (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation {
    
    func application(_ app: UIApplication, open url: URL, options: [UIApplicationOpenURLOptionsKey : Any] = [:]) -> Bool {
        
        if url.host == "safepay" {
            
            AlipaySDK.defaultService().processAuthResult(url, standbyCallback: { (response) in
               
                print(response)
                
                let message = "Alipay response on app dlegate 1 "
                let currentController = getCurrentViewController()
                let alert = UIAlertController(title: "alipay", message: message, preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "Ok", style: .cancel, handler: nil))
                currentController?.present(alert, animated: true, completion: nil)
                
            })
            
            AlipaySDK.defaultService().processAuth_V2Result(url, standbyCallback: { (response) in
               
                print(response)
                
                let message = "Alipay response on app dlegate 2 "
                let currentController = getCurrentViewController()
                let alert = UIAlertController(title: "alipay", message: message, preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "Ok", style: .cancel, handler: nil))
                currentController?.present(alert, animated: true, completion: nil)
                
            })
        }
        
        WXApi.handleOpen(url, delegate: WeChatResponseHandller.shared)
        
        return true
        
    }
    
    // no equiv. notification. return NO if the application can't open for some reason
    func application(_ application: UIApplication, open url: URL, sourceApplication: String?, annotation: Any) -> Bool {
        
        if url.host == "safepay" {
            
            AlipaySDK.defaultService().processAuthResult(url, standbyCallback: { (response) in
                
                print(response)
                
                let message = "Alipay response on app dlegate 1 "
                let currentController = getCurrentViewController()
                let alert = UIAlertController(title: "alipay", message: message, preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "Ok", style: .cancel, handler: nil))
                currentController?.present(alert, animated: true, completion: nil)
                
            })
            
            AlipaySDK.defaultService().processAuth_V2Result(url, standbyCallback: { (response) in
                
                print(response)
                
                let message = "Alipay response on app dlegate 2 "
                let currentController = getCurrentViewController()
                let alert = UIAlertController(title: "alipay", message: message, preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "Ok", style: .cancel, handler: nil))
                currentController?.present(alert, animated: true, completion: nil)
                
            })
        }
        

        
        let isSuccess = WXApi.handleOpen(url, delegate: WeChatResponseHandller.shared)
        return true
    }
    
}

func getCurrentViewController() -> UIViewController? {
    
    if let rootController = UIApplication.shared.keyWindow?.rootViewController {
        var currentController: UIViewController! = rootController
        while( currentController.presentedViewController != nil ) {
            currentController = currentController.presentedViewController
        }
        return currentController
    }
    return nil
}


