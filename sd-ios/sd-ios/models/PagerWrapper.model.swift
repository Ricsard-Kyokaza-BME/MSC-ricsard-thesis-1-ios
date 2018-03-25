//
//  PagerWrapper.model.swift
//  sd-ios
//
//  Created by Balog Richárd on 2018. 03. 25..
//  Copyright © 2018. Richárd Balog. All rights reserved.
//

import Foundation

class PagerWrapper<T: Codable>: Codable, CustomDebugStringConvertible {
    
    var data: [T]
    var limit: Int
    var skip: Int
    var total: Int
    
    init(_ data: [T], limit: Int, skip: Int, total: Int) {
        self.data = data
        self.limit = limit
        self.skip = skip
        self.total = total
    }
    
    var debugDescription: String {
        return "User: \ndata: \(data), limit: \(limit), skip: \(skip), total: \(total)"
    }
    
}
