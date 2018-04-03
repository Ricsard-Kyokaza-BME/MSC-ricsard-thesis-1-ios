//
//  GrouppedMessage.swift
//  sd-ios
//
//  Created by Balog Richárd on 2018. 04. 01..
//  Copyright © 2018. Richárd Balog. All rights reserved.
//

import Foundation

class GrouppedMessage: CustomDebugStringConvertible {
    var groupId: String
    var otherPartnerName: String
    var messages: [Message]
    
    init(_ groupId: String, otherPartnerName: String, messages: [Message]) {
        self.groupId = groupId
        self.otherPartnerName = otherPartnerName
        self.messages = messages
    }
    
    var debugDescription: String {
        return "GrouppedMessages: \ngroupId: \(groupId), otherPartnerName: \(otherPartnerName), messages: \(messages)"
    }
}
