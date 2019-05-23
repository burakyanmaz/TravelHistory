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
    var results: Results?
    
    init?(map: Map) {
        
    }
    
    mutating func mapping(map: Map) {
        results <- map["results"]
    }
    
    struct Results: Mappable {
        var items: [Items]?
        
        init?(map: Map) {
            
        }
        
        mutating func mapping(map: Map) {
            items <- map["items"]
        }
        
        struct Items: Mappable {
            var position: [Double]?
            var distance: Int?
            var title: String?
            var averageRating: Int?
            var category: Category?
            var icon: URL?
            var vicinity: String?
            var type: String?
            var href: URL?
            var id: String?
            var authoritative: Bool?
            var alternativeNames: [AlternativeNames]?
            
            init?(map: Map) {
                
            }
            
            mutating func mapping(map: Map) {
                position <- map["position"]
                distance <- map["distance"]
                title <- map["title"]
                averageRating <- map["averageRating"]
                category <- map["category"]
                icon <- map["icon"]
                vicinity <- map["vicinity"]
                type <- map["type"]
                href <- map["href"]
                id <- map["id"]
                authoritative <- map["authoritative"]
                alternativeNames <- map["alternativeNames"]
            }
            struct Category: Mappable {
                var id: String?
                var title: String?
                var href: URL?
                var type: String?
                var system: String?
                
                init?(map: Map) {
                    
                }
                
                mutating func mapping(map: Map) {
                    id <- map["id"]
                    title <- map["title"]
                    href <- map["href"]
                    type <- map["type"]
                    system <- map["system"]
                }
            }
            
            struct AlternativeNames: Mappable {
                var name: String?
                var language: String?
                
                init?(map: Map) {
                    
                }
                
                mutating func mapping(map: Map) {
                    name <- map["name"]
                    language <- map["language"]
                }
            }
        }
    }
}
