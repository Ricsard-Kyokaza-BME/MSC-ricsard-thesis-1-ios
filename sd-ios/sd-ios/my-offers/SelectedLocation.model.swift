//
//  SelectedLocation.model.swift
//  sd-ios
//
//  Created by Richárd Balog on 2017. 12. 03..
//  Copyright © 2017. Richárd Balog. All rights reserved.
//

import Foundation

class SearchResult {
    var placeId: String
    var description: String
    
    init(placeId: String, description: String) {
        self.placeId = placeId
        self.description = description
    }
}

class SelectedLocation: SearchResult {
    var latitude: Double
    var longitude: Double
    
    init(placeId: String, description: String, latitude: Double, longitude: Double) {
        self.latitude = latitude
        self.longitude = longitude
        super.init(placeId: placeId, description: description)
    }
}
