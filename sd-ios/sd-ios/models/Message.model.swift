//
//  Message.model.swift
//  sd-ios
//
//  Created by Balog Richárd on 2018. 03. 25..
//  Copyright © 2018. Richárd Balog. All rights reserved.
//

import Foundation

class Message: Codable, CustomDebugStringConvertible {
    
    var __v: Int
    var _id: String
    var from: User
    var to: User
    var content: String
    
    var createdAt: Date
    var updatedAt: Date
    
    init(_ __v: Int, id: String, from: User, to: User, content: String, createdAt: Date, updatedAt: Date ) {
        self.__v = __v
        self._id = id
        self.from = from
        self.to = to
        self.content = content
        self.createdAt = createdAt
        self.updatedAt = updatedAt
    }
    
    var debugDescription: String {
        return "Message: \nid: \(_id), from: \(from), to: \(to), content: \(String(describing: content)), createdAt: \(String(describing: createdAt)), updatedAt: \(String(describing: updatedAt))"
    }
    
}
