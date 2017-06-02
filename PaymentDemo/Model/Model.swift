


import UIKit
import Foundation
import SwiftyJSON
import Alamofire


class AppModel:NSObject {
    
    
    class func makePaymentCall(_ parameters:Parameters? = nil, withPaymentMethod method:PayMentMethod, then:@escaping (_ success:Bool,_ response:JSON?)->()) {
        
        let headers: HTTPHeaders = [
            "X-Auth-Token":"125167901614963861651249200773"
        ]
        
        let paymentMethod = method == .alipay ? "alipay" : "wechat"
        
        let parameters: Parameters = ["order_details": [["quantity": "1", "id": "42"]], "payment_method": paymentMethod, "type": "product"]
        
        print(parameters)
        
        showProgressHUD(loadingString: "Buying")

        Alamofire.request(paymentBackEndUrl, method: .post, parameters: parameters,encoding: JSONEncoding.default,headers:headers).responseJSON { (response) in
            
            print(parameters)
            
            hideProgressHud()
            
            switch response.result {
                
            case .success(let value):
                
                let json = JSON(value)
                print("JSON: \(json)")
                
                then(true, json)
                
            case .failure(let error):
                then(false, nil)

                print(error)
            }
        }
    }
    
    
    
}

