//
//  NetworkManager.swift
//  Vome
//
//  Created by Bheem Singh on 10/09/17.
//  Copyright © 2017 Bheem Singh. All rights reserved.
//

import Foundation
import Alamofire
import AlamofireObjectMapper


class NetworkManager {
    
    static let shareInstance: NetworkManager = NetworkManager()
    
    var AlamofireManager = Alamofire.SessionManager(configuration: .default)
    init() {
        let configration = URLSessionConfiguration.default
        configration.timeoutIntervalForRequest = 180 // second
        
        self.AlamofireManager = Alamofire.SessionManager(configuration: configration)
    }
    
    
    func callServiceWithName(_ serviceName:String, method: HTTPMethod, param: [String: Any] = ["":""], callbackSuccess:@ escaping(_ response: AnyObject) -> Void, callbackFaliure: @escaping (_ messgae:AnyObject?) -> Void) {
        
        var header = [String: String]()
        
        header [APIHeaderEnum.CONTENT_TYPE] = APIHeaderEnum.CONTENT_TYPE_VALUE
        header [APIHeaderEnum.AUTHORIZATION] = USER_AUTHORIZATION
        
        AlamofireManager.request(serviceName, method: method, parameters: param, headers: header).responseJSON { response in
            
            switch response.result {
            case .success:
                if let statusCode = APIStatusCode(rawValue: (response.response?.statusCode)!){
                    switch statusCode{
                        case .statusCode_200:
                            callbackSuccess(response.result.value as AnyObject)
                            break
                        default:
                            let objectModel = ErrorResponse(JSON: getResultDictWithoutDataKey(response.result.value as AnyObject))
                            NotificationCenter.ShowNormalAlert(title: objectModel?.error, message: objectModel?.error_description, actionTitle: "Ok", complitionHandler: { (index) in
                                
                            })
                            callbackFaliure(response.result.value as AnyObject)
                            break
                        
                    }
                }
                break
                
            case .failure:
                callbackFaliure(nil)
                break
            }
            
        }
        
    }
    
    
    
    
}
