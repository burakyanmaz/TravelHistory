//
//  ConnectionHelper.swift
//  TravelHistory
//
//  Created by Burak Yanmaz on 16.05.2019.
//  Copyright © 2019 Simpler. All rights reserved.
//

import UIKit

enum ConnectionHelper {
    static let scheme = "https"
    static let host = "places.cit.api.here.com"
    static let path = "/places/v1"
    
    enum Methods {
        static let discoverHere = "/discover/here"
        static let discoverSearch = "/discover/search"
    }
    
    enum Parameters {
        /// Header parameters' keys.
        enum Header: String {
            case Basic = "Basic"
        }
        
        /// Parameter keys that are sent within body.
        enum Body: String {
            case app_id
            case app_code
            /// E.g. 52.531,13.3843
            case at
            case q
        }
    }
    
    enum Environment {
        case cit
        case staging
        case production
        
        var appID: String {
            switch self {
            case .cit:
                return Credentials.APP_ID_CIT
            case .staging:
                return ""
            case .production:
                return ""
            }
        }
        
        var appCode: String {
            switch self {
            case .cit:
                return Credentials.APP_CODE_CIT
            case .staging:
                return ""
            case .production:
                return ""
            }
        }
    }
    private enum Credentials {
        // Production/Staging credentials may come here as cit credentials came as below
        
        static let APP_ID_CIT = "JlTFg9um7XEpMtSw0WlW"
        static let APP_CODE_CIT = "ap8YDYGa3ZNUwTTT8jJbsA"
    }
    
    enum Authorization {
        /// Combine your app_id and app_code in a string as follows "{YOUR_APP_ID}:{YOUR_APP_CODE}".
        case header(appID: String, appCode: String)
        
        var encoded: String {
            switch self {
            case .header(let appID, let appCode):
                let encodedValue = Data("\(appID):\(appCode)".utf8).base64EncodedString()
                return encodedValue
            }
        }
    }
    
    enum LocationParameter {
        case location(lat: String, long: String)
        
        var value: String {
            switch self {
            case .location(let lat, let long):
                return "\(lat),\(long)"
            }
        }
    }
}
