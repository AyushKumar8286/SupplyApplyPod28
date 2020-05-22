//
//  MyAPIClient.swift
//  SupplyApply
//
//  Created by Mac3 on 13/05/20.
//  Copyright © 2020 Suntec. All rights reserved.
//

import Foundation
import Stripe
import Alamofire

class MyAPIClient: NSObject,STPCustomerEphemeralKeyProvider {
    
    enum APIError: Error {
        case unknown
        
        var localizedDescription: String {
            switch self {
            case .unknown:
                return "Unknown error"
            }
        }
    }
    
    static let sharedClient = MyAPIClient()
    
    func createCustomerKey(withAPIVersion apiVersion: String, completion: @escaping STPJSONResponseCompletionBlock) {
        
        let parameters = ["api_version":apiVersion, "customer_id" : UserDefaults.standard.getCutomerID()]

        AF.request(URL(string: "https://tsprojects.net/demo/dev/supplyandapply/index.php?route=openapi/checkout/getStripeEphemeral")!, method: .post, parameters: parameters, encoding: URLEncoding.default, headers: [:]).responseJSON { (apiResponse) in
            let data = apiResponse.data
            guard let json = ((try? JSONSerialization.jsonObject(with: data!, options: []) as? [String : Any]) as [String : Any]??) else {
                completion(nil, apiResponse.error)
                return
            }
            completion(json, nil)
        }        
    }
    
    
    func createPaymentIntent(customerId: String, amount: String, paymentMethodId: String, completion: @escaping ((Result<String>) -> Void)) {
        
        let parameters = ["customer_id" : customerId,"amount": amount,"payment_method_id" : paymentMethodId]
        
        
        AF.request(URL(string: "https://tsprojects.net/demo/dev/supplyandapply/index.php?route=openapi/checkout/paymentInt")!, method: .post, parameters: parameters, encoding: URLEncoding.default, headers: [:]).responseJSON { (apiResponse) in
            
            let data = apiResponse.data
            guard let json = ((try? JSONSerialization.jsonObject(with: data!, options: []) as? [String : Any]) as [String : Any]??),
                let secret = json?["clientSecret"] as? String else {
                    //               completion(nil, apiResponse.error)
                    return
            }
            completion(.success(secret))
        }
    }
}


