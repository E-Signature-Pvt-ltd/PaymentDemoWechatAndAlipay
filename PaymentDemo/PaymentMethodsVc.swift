//
//  PaymentDemo
//  Created by dip on on 6/2/17.
//  Copyright © 2016 dip kasyap dpd.ghimire@gmail.com. All rights reserved.



import UIKit
import SwiftyJSON


class PaymentMethodsVc: UIViewController {
    
    @IBOutlet weak var buttonContainer: UIView!
    @IBOutlet var buttons: [UIButton]!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //wechat pay deletate
        WeChatResponseHandller.shared.delegate = self
        
        self.buttonContainer.makeCircular(withBorderColor: .clear, andBorderWidth: 0, andCornorRadious: 8)
        for button in buttons {
            button.makeCircular(withBorderColor: .clear, andBorderWidth: 0, andCornorRadious: 5)
        }
        
    }
    
    //MARK:- Actions
    
    @IBAction func alipay(_ sender: UIButton) {
        self.pay(withPaymentMethod: .alipay)
    }
    
    @IBAction func wechatPay(_ sender: UIButton) {
        self.pay(withPaymentMethod: .wechat)
    }
    
    func pay(withPaymentMethod method:PayMentMethod) {
        
        AppModel.makePaymentCall(withPaymentMethod: method) { (success, responseJson) in
            
            if success {
                
                switch method {
               
                case .alipay:
                    
                    let orderString = responseJson!["data"].stringValue
                    
                    print(orderString)
                    
                    //AlipaySDK.defaultService().setUrl("https://openapi.alipaydev.com/gateway.do") // sand box testing line remove this line on production
                    
                    AlipaySDK.defaultService().payOrder(orderString, fromScheme: "SuperAV") { [unowned self] response in
                        
                        if let response = response  {
                            
                            let responseJson = JSON(response)
                            print(responseJson)
                            
                            /* response resultStatus codes
                             9000	Successful order payment
                             8000	Under processing, unknown payment result (payment might have been made successfully), please inquiry order payment status in sellers' orders list. (This code returns from Alipay server side.)
                             4000	Failed order payment
                             6001	Canceled by user during the process
                             6002	Error in network connection
                             6004	Unknown payment result (payment might have been made successfully), please inquiry order payment status in sellers' orders list. (Usually caused by network issue, causing Alipay client cannot receive response from Alipay server side)
                             Other
                             
                             REsponse format
                             /*
                             "resultStatus" : "4000",
                             "result" : "",
                             "memo" : "Error Domain=系统繁忙，请稍后再试 Code=1000 \"(null)\""
                             */
                             */
                            
                            
                            switch responseJson["resultStatus"].stringValue {
                                
                            case "9000"://success
                                self.paymentMethodDidFihished(.success)
                                break
                                
                            case "6001"://user cancelled
                                self.paymentMethodDidFihished(.userCancelled)
                                break
                                
                            case "8000","6004"://pending
                                self.paymentMethodDidFihished(.pending)
                                break
                                
                            default:// failed
                                self.paymentMethodDidFihished(.failed)
                                break
                            }
                            
                            
                        } else {
                            fatalError("Ali pay throwed nil data")
                        }
                    }
                    
                    break
                    
                case .wechat:
                    
                    let data = responseJson!["data"]
                    let partnerId = data["partnerid"].stringValue
                    let prePayId = data["prepayid"].stringValue
                    let nonceStr = data["noncestr"].stringValue
                    let timeStamp:UInt32 = UInt32(data["timestamp"].intValue)
                    let sign = data["sign"].stringValue
                    
                    let request = PayReq()
                    request.partnerId = partnerId
                    request.prepayId = prePayId
                    request.nonceStr = nonceStr
                    request.timeStamp = timeStamp
                    request.package = "Sign=WXPay"
                    request.sign = sign
                    WXApi.send(request)
                    
                    break
                    
                }
            } else {
                print("Show alert for Backend call failled please retry")
            }
        }
    }
    
    
    ///Alipay Response handller method
    func paymentMethodDidFihished( _ payStatus:AlipayStatus) {
        
        let paymentAlert = UIAlertController(title: nil, message: nil, preferredStyle: .alert)
        
        switch payStatus {
            
        case .success:
            //do clear cart of particuler caller and pop srceen to toot view controller
            paymentAlert.message = "Payment success"
            paymentAlert.title = "Success"
            paymentAlert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { [unowned self] (aciton) in
                //TODO:- Do Something usefull
            }))
            break
            
        case .failed:
            //this is error case so show seero message ans do nothing
            paymentAlert.message = "Payment Failed Please try again or try later"
            paymentAlert.title = "Failed"
            paymentAlert.addAction(UIAlertAction(title: "Ok", style: .cancel, handler: nil))
            break
            
        case .userCancelled:
            //show user cancelled message do nothing
            paymentAlert.message = "Payment was cancelled"
            paymentAlert.title = "Cancelled"
            paymentAlert.addAction(UIAlertAction(title: "Ok", style: .cancel, handler: nil))
            break
            
        case .pending:
            //this is error case so show error message ans do nothing
            paymentAlert.message = "Payment Status is in pending Please wait till our server verifies the payment"
            paymentAlert.title = "Pending"
            paymentAlert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { [unowned self] (aciton) in
                //TODO:- Do Something usefull
            }))
            break
        }
        
        self.present(paymentAlert, animated: true, completion: nil)
        
    }
}

extension PaymentMethodsVc:WeChatResponseHandllerDelegate {
    
    //Wechat response paymnet handllerdelegate
    func weChatPaymnetDidCompleted(_ result:WeChatPaymentResult,withResponseData response:String?) {
        
        let paymentAlert = UIAlertController(title: nil, message: nil, preferredStyle: .alert)
        
        print(result)
        print(response ?? "Default respose")
        
        switch result {
        case .success:
            //do clear cart of particuler caller and pop srceen to toot view controller
            paymentAlert.message = "Payment success"
            paymentAlert.title = "Success"
            paymentAlert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { [unowned self] (aciton) in
                //TODO:- Do Something usefull
            }))
            break
            
        case .userCancelled:
            //show user cancelled message do nothing
            paymentAlert.message = "Payment was cancelled"
            paymentAlert.title = "Cancelled"
            paymentAlert.addAction(UIAlertAction(title: "Ok", style: .cancel, handler: nil))
            break
            
        default:
            //this is error case so show seero message ans do nothing
            paymentAlert.message = "Payment Failed Please try again or try later"
            paymentAlert.title = "Failed"
            paymentAlert.addAction(UIAlertAction(title: "Ok", style: .cancel, handler: nil))
            break
        }
        
        self.present(paymentAlert, animated: true, completion: nil)
    }
}



extension UIView {
    
    ///This method makes view circular with cornor radious provided
    
    func makeCircular(withBorderColor borderColor:UIColor, andBorderWidth borderWidth:CGFloat, andCornorRadious cRadious: CGFloat){
        self.layer.cornerRadius = cRadious
        self.layer.borderColor = borderColor.cgColor
        self.layer.borderWidth = borderWidth
        self.layer.masksToBounds = true
}

}
