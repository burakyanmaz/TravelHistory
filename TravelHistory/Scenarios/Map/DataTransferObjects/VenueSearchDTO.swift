//
//  SearchVenuesDTO.swift
//  TravelHistory
//
//  Created by Burak Yanmaz on 16.05.2019.
//  Copyright © 2019 Simpler. All rights reserved.
//

import UIKit
import ObjectMapper

struct VenueSearchDTO: Mappable {
    var parameter: String?
    var type: String?
    var results: [IDProtectionResult]?
    
    init?(map: Map) {
        
    }
    
    mutating func mapping(map: Map) {
        parameter <- map["parameter"]
        type <- map["type"]
        results <- map["results"]
    }
}
