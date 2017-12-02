//
//  Category.swift
//  sd-ios
//
//  Created by Richárd Balog on 2017. 12. 02..
//  Copyright © 2017. Richárd Balog. All rights reserved.
//

import Foundation

class Category: Codable, CustomDebugStringConvertible {
    
    var _id: String
    var name: String
    var description: String?
    
    var createdAt: Date
    var updatedAt: Date
    
    init(_ id: String, name: String, description: String?, createdAt: Date, updatedAt: Date ) {
        self._id = id
        self.name = name
        self.description = description
        self.createdAt = createdAt
        self.updatedAt = updatedAt
    }
    
    var debugDescription: String {
        return "User: \nid: \(_id), name: \(name), description: \(String(describing: description)), createdAt: \(String(describing: createdAt)), updatedAt: \(String(describing: updatedAt))"
    }
    
}
