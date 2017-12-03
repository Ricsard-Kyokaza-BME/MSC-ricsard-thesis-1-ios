//
//  Offer.model.swift
//  sd-ios
//
//  Created by Richárd Balog on 2017. 11. 16..
//  Copyright © 2017. Richárd Balog. All rights reserved.
//

import Foundation

class Offer: Codable, CustomDebugStringConvertible {
    
    var _id: String?
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
    
    init(_ _id: String?, title: String, description: String?, price: String?, categories: [String]?, owner: String, images: [String]?, address: String?, coordinates: [Double]?, createdAt: Date, updatedAt: Date ) {
        self._id = _id
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
        return "Offer: \nid: \(String(describing: _id)), title: \(title), description: \(String(describing: description)), price: \(String(describing: price)), categories: \(String(describing: categories)), owner: \(owner), images: \(String(describing: images)), address: \(String(describing: address)), coordinates: \(String(describing: coordinates)), createdAt: \(String(describing: createdAt)), updatedAt: \(String(describing: updatedAt))"
    }
}
