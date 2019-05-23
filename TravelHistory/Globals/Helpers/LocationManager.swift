//
//  LocationManager.swift
//  TravelHistory
//
//  Created by Burak Yanmaz on 23.05.2019.
//  Copyright © 2019 Simpler. All rights reserved.
//

import UIKit
import INTULocationManager

class LocationManager: NSObject {
    // Gets the current location along with the accuracy
    func getCurrentLocation(completion: @escaping (_ location: Location?) -> Void) {
        let locationManager = INTULocationManager.sharedInstance()
        locationManager.requestLocation(withDesiredAccuracy: .block,
                                        timeout: 10.0,
                                        delayUntilAuthorized: true) { (currentLocation, achievedAccuracy, status) in
                                            if (status == INTULocationStatus.success) {
                                                // Request succeeded, meaning achievedAccuracy is at least the requested accuracy, and
                                                // currentLocation contains the device's current location
                                                let deviceLocation = Location(latitude: Float(currentLocation?.coordinate.latitude ?? 0.0), longitude: Float(currentLocation?.coordinate.longitude ?? 0.0), accuracy: achievedAccuracy.rawValue)
                                                completion(deviceLocation)
                                                
                                            }
                                            else if (status == INTULocationStatus.timedOut) {
                                                // Wasn't able to locate the user with the requested accuracy within the timeout interval.
                                                // However, currentLocation contains the best location available (if any) as of right now,
                                                // and achievedAccuracy has info on the accuracy/recency of the location in currentLocation.
                                                let deviceLocation = Location(latitude: Float(currentLocation?.coordinate.latitude ?? 0.0), longitude: Float(currentLocation?.coordinate.longitude ?? 0.0), accuracy: achievedAccuracy.rawValue)
                                                completion(deviceLocation)
                                            }
                                            else {
                                                // An error occurred, more info is available by looking at the specific status returned.
                                                completion(nil)
                                            }
        }
        
    }
    
}
