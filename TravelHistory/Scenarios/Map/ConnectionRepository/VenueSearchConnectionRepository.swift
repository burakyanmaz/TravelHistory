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
    func searchVenues(for location: Location, searchString: String, completion: @escaping (_ venueDTO: VenueSearchDTO?) -> Void) {
        let parameters = [ConnectionHelper.Parameters.Body.app_id.rawValue: EnvironmentHolder.credentials.appID,
                          ConnectionHelper.Parameters.Body.app_code.rawValue: EnvironmentHolder.credentials.appCode, ConnectionHelper.Parameters.Body.at.rawValue: ConnectionHelper.LocationParameter.location(lat: "\(location.latitude)", long: "\(location.longitude)").value,
                           ConnectionHelper.Parameters.Body.q.rawValue: searchString]
        
        requester.requestGET(method: ConnectionHelper.Methods.discoverSearch, mappableObject: VenueSearchDTO.self, parameters: parameters) { (response, error) in
            guard let theError = error else {
                completion(response)
                return
            }
            
            // Error happened:
            print(theError.localizedDescription)
            completion(nil)
        }
    }
}
