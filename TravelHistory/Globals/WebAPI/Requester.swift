//
//  Requester.swift
//  TravelHistory
//
//  Created by Burak Yanmaz on 16.05.2019.
//  Copyright © 2019 Simpler. All rights reserved.
//

import UIKit
import Alamofire
import ObjectMapper
import AlamofireObjectMapper

class Requester: NSObject {
    func requestPOST<T: Mappable> (method: String?, mappableObject: T.Type, parameters: [String: String], completionHandler: @escaping (_ object: T?, _ error: Error?) -> Void) {
        
        let url = urlFor(parameters: [:], method: method)
        
        print(url.absoluteString)
        
        request(url.absoluteString, method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: getHeader())
            
            .responseString(completionHandler: { (response) in
                print(response)
                
            })
            
            .validate(statusCode: 200..<300)
            
            .responseObject { (response: DataResponse<T>) in
                switch response.result{
                case .success(let value):
                    completionHandler(value, nil)
                case .failure(let error):
                    completionHandler(nil, error)
                }
        }
    }
    
    func requestGET<T: Mappable> (method: String, mappableObject: T.Type, parameters: [String: String], completionHandler: @escaping (_ object: T?, _ error: Error?) -> Void) {
        let url = urlFor(parameters: parameters, method: method)
        print(url)
        
        request(url.absoluteString, method: .get, parameters: nil, encoding: JSONEncoding.default, headers: getHeader())
            
            .responseJSON(completionHandler: { (json) in
                print(json)
            })
            
            .responseObject { (response: DataResponse<T>) in
                
                switch response.result {
                case .success(let value):
                    completionHandler(value, nil)
                    
                case .failure(let error):
                    completionHandler(nil, error)
                }
            }
            
            .responseString { (response) in
                print(response)
        }
    }
    
    func urlFor(parameters: [String: String], method: String? = nil) -> URL {
        var components = URLComponents()
        components.path = ConnectionHelper.path + (method ?? "")
        components.scheme = ConnectionHelper.scheme
        components.host = ConnectionHelper.host
        components.queryItems = [URLQueryItem]()
        
        for (key, value) in parameters {
            let item = URLQueryItem(name: key, value: "\(value)")
            components.queryItems?.append(item)
        }
        return components.url!
    }
    
    /**
     Explained in https://developer.here.com/documentation/places/topics/app-authentication.html
     
     To construct your Authorization header:
     
     Combine your app_id and app_code in a string as follows "{YOUR_APP_ID}:{YOUR_APP_CODE}".
     
     Encode the resulting string using Base64.
     
     Set the Authorization header parameter to Basic {encoded value}.
     
     The result is as follows: Authorization:Basic {encoded value}
     */
    func getHeader() -> HTTPHeaders {
        var headers = SessionManager.defaultHTTPHeaders
        headers[ConnectionHelper.Parameters.Header.Basic.rawValue] = ConnectionHelper.Authorization.header(appID: EnvironmentHolder.credentials.appID, appCode: EnvironmentHolder.credentials.appCode).encoded
        return headers
    }
}
