//
//  User.model.swift
//  sd-ios
//
//  Created by Richárd Balog on 2017. 11. 27..
//  Copyright © 2017. Richárd Balog. All rights reserved.
//

import Foundation

class User: Codable, CustomDebugStringConvertible {
    
    var __v: Int
    var _id: String
    var firstName: String
    var lastName: String
    var email: String
    var roles: [String]
    
    var createdAt: Date
    var updatedAt: Date
    
    init(_ __v: Int, id: String, firstName: String, lastName: String, email: String, roles: [String], createdAt: Date, updatedAt: Date ) {
        self.__v = __v
        self._id = id
        self.firstName = firstName
        self.lastName = lastName
        self.email = email
        self.roles = roles
        self.createdAt = createdAt
        self.updatedAt = updatedAt
    }
    
    var debugDescription: String {
        return "User: \nid: \(_id), firstName: \(firstName), lastName: \(lastName), email: \(email), roles: \(roles), createdAt: \(String(describing: createdAt)), updatedAt: \(String(describing: updatedAt))"
    }
    
    func toData() -> [String: Any] {
        var dictionary = [String: Any]()

        dictionary["firstName"] = firstName
        dictionary["lastName"] = lastName

        return dictionary
    }
    
    func getName() -> String {
        return "\(firstName) \(lastName)"
    }
}
