//
//  NewMessage.swift
//  sd-ios
//
//  Created by Balog Richárd on 2018. 04. 28..
//  Copyright © 2018. Richárd Balog. All rights reserved.
//

import Foundation

class NewMessage: Codable, CustomDebugStringConvertible {
    
    var to: User
    var content: String
    
    init(_ to: User, content: String ) {
        self.to = to
        self.content = content
    }
    
    var debugDescription: String {
        return "Message: to: \(to), content: \(String(describing: content))"
    }
    
}
