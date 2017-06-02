
//
//  WeChatResponseHandller.swift
//  SuperAV
//
//  Created by Apple on 5/24/17.
//  Copyright © 2017 dip kasyap dpd.ghimire@gmail.com. All rights reserved.
//

import UIKit
import SwiftyJSON
import SVProgressHUD

let paymentBackEndUrl = "http://103.233.58.104/2017/magazine/public/api/v1/create_payment"

enum AlipayStatus {
    case success,userCancelled,failed,pending
}
enum PayMentMethod:String {
    case alipay,wechat
}

enum WeChatPaymentResult {
    case success,failed,userCancelled
}

protocol WeChatResponseHandllerDelegate:class {
    
    func weChatPaymnetDidCompleted(_ result:WeChatPaymentResult,withResponseData response:String?)
    
}

//progress hud
func showProgressHUD(loadingString : String?){
    
    SVProgressHUD.show(withStatus: loadingString)
    SVProgressHUD.setDefaultStyle(SVProgressHUDStyle.custom)
    SVProgressHUD.setForegroundColor (UIColor.green)
    
    if loadingString != nil {
        SVProgressHUD.setBackgroundColor (UIColor.black.withAlphaComponent(0.3))
    } else {
        SVProgressHUD.setBackgroundColor (UIColor.clear)
    }
    
    SVProgressHUD.setDefaultMaskType(SVProgressHUDMaskType.black)
    SVProgressHUD.setRingNoTextRadius(20)
    SVProgressHUD.setRingThickness(3)
    SVProgressHUD.setDefaultAnimationType(SVProgressHUDAnimationType.flat)
}

func hideProgressHud() {
    SVProgressHUD.dismiss()
}

/**********************************************************************************************************************************/


class WeChatResponseHandller: NSObject,WXApiDelegate {
    
    static let shared = WeChatResponseHandller()
    var delegate:WeChatResponseHandllerDelegate?
    
    
    func onReq(_ req: BaseReq?) {
        
    }
    
    func onResp(_ resp: BaseResp?) {
        
        
        if let response = resp {
            
            switch (response.errCode) {
                
            case 0:
                if let delegate = WeChatResponseHandller.shared.delegate {
                    delegate.weChatPaymnetDidCompleted(.success, withResponseData: response.errStr)
                }
                //success
                break
                
            case -2:
                //user canceled
                if let delegate = WeChatResponseHandller.shared.delegate {
                    delegate.weChatPaymnetDidCompleted(.userCancelled, withResponseData: response.errStr)
                }
                break
            default:
                // other all fail
                if let delegate = WeChatResponseHandller.shared.delegate {
                    delegate.weChatPaymnetDidCompleted(.failed, withResponseData: response.errStr)
                }
                break
            }
            
        } else  {
            // value nil show failure messes
        }
    }
}
