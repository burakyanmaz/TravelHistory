//
//  SearchVenuesConnectionRepository.swift
//  TravelHistory
//
//  Created by Burak Yanmaz on 16.05.2019.
//  Copyright © 2019 Simpler. All rights reserved.
//

import UIKit

class VenueSearchConnectionRepository: NSObject {
    private var requester: Requester
    init(aRequester: Requester) {
        requester = aRequester // Dependency injection here
    }
    func searchVenues(for location: Location, searchString: String) {
        let parameters = [ConnectionHelper.Parameters.Body.app_id.rawValue: EnvironmentHolder.credentials.appID,
                          ConnectionHelper.Parameters.Body.app_code.rawValue: EnvironmentHolder.credentials.appCode, ConnectionHelper.Parameters.Body.at.rawValue: ConnectionHelper.LocationParameter.location(lat: "\(location.latitude)", long: "\(location.longitude)").value,
                           ConnectionHelper.Parameters.Body.q.rawValue: searchString]
        
        requester.requestGET(method: ConnectionHelper.Methods.discoverSearch, mappableObject: <#T##Mappable.Protocol#>, parameters: parameters, completionHandler: <#T##(Mappable?, Error?) -> Void#>)
        
        Requester.sharedInstance().requestPOSTFollowingByArrayResponse(method: ConnectionAPIHelper.Methods.idProtection, mappableObject: IDProtectionJSONResponse.self, parameters: parameters) { [weak self] (returnedJSON, error) in
            guard let theError = error else {
                self?.emailListDidFetch.call(returnedJSON?.idProtectionResult)
                return
            }
            
            // Error happened:
            print(theError.localizedDescription)
            self?.emailListDidFetch.call(nil)
        }
    }
}
