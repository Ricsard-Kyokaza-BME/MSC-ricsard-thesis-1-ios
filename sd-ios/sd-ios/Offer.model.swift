//
//  Offer.model.swift
//  sd-ios
//
//  Created by Richárd Balog on 2017. 11. 16..
//  Copyright © 2017. Richárd Balog. All rights reserved.
//

import Foundation

class Offer: Codable, CustomDebugStringConvertible {
    
    var title: String
    var description: String?
    var price: String?
    var categories: [String]?
    var owner: String
    var images: [String]?
    var address: String?
    var coordinates: [Double]?
    var createdAt: Date
    var updatedAt: Date
    
    init(_ title: String, description: String?, price: String?, categories: [String]?, owner: String, images: [String]?, address: String?, coordinates: [Double]?, createdAt: Date, updatedAt: Date ) {
        self.title = title
        self.description = description
        self.price = price
        self.categories = categories
        self.owner = owner
        self.images = images
        self.address = address
        self.coordinates = coordinates
        self.createdAt = createdAt
        self.updatedAt = updatedAt
    }
    
    var debugDescription: String {
        return "Offer: \ntitle: \(title), description: \(String(describing: description)), price: \(String(describing: price)), categories: \(String(describing: categories)), owner: \(owner), images: \(String(describing: images)), address: \(String(describing: address)), coordinates: \(String(describing: coordinates)), createdAt: \(String(describing: createdAt)), updatedAt: \(String(describing: updatedAt))"
    }
    
//    init?(json: [String: Any]) {
//        guard let title = json["title"] as? String else {
//                return nil
//        }
//        self.title = title
//    }
    
//    func toData() -> [String: Any] {
//        var dictionary = [String: Any]()
//        
//        dictionary["title"] = title
//        
//        return dictionary
//    }
}
