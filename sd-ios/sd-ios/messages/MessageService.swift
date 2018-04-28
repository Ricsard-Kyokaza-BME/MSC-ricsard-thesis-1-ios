//
//  MessageService.swift
//  sd-ios
//
//  Created by Balog Richárd on 2018. 04. 28..
//  Copyright © 2018. Richárd Balog. All rights reserved.
//

import Foundation

class MessageService {
    static let service = MessageService()
    private var messages = [Message]()
    var grouppedMessages = [GrouppedMessage]()
    
    private init() {
    }
    
    func downloadMessages(_ userId: String, downloadedCallback: @escaping ([GrouppedMessage]) -> Void) {
        let url = URL(string: Constants.api + "/messages" + "?$limit=100&$or[0][to]=\(userId)&$or[1][from]=\(userId)&$populate=from&$populate=to")
        var request = URLRequest(url: url!)
        request.httpMethod = "GET"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue(AuthManager.manager.getAccessToken()!, forHTTPHeaderField: "authorization")
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                print("Error during communication: \(error.localizedDescription).")
                return
            } else if data != nil {
                self.messages = []
                self.grouppedMessages = []
                let jsonDecoder = JSONDecoder()
                jsonDecoder.dateDecodingStrategy = .formatted(Formatter.iso8601)
                
                do {
                    let wrappedMessages = try jsonDecoder.decode(PagerWrapper<Message>.self, from: data!)
                    self.messages = wrappedMessages.data
                    self.groupMessages(userId)
                    
                    DispatchQueue.main.async {
                        downloadedCallback(self.grouppedMessages)
                    }
                } catch {
                    print(error)
                }
            }
        }.resume()
    }
    
    func groupMessages(_ userId: String) {
        messages.forEach({ message in
            if message.from._id == userId {
                if grouppedMessageFindByGroupId(message.to._id) == nil {
                    grouppedMessages.append(GrouppedMessage(message.to._id, otherPartnerName: message.to.getName(), messages: [message]))
                } else {
                    grouppedMessageFindByGroupId(message.to._id)?.messages.append(message)
                }
            } else if grouppedMessageFindByGroupId(message.from._id) == nil {
                grouppedMessages.append(GrouppedMessage(message.from._id, otherPartnerName: message.from.getName(), messages: [message]))
            } else {
                grouppedMessageFindByGroupId(message.from._id)?.messages.append(message)
            }
        })
    }
    
    func grouppedMessageFindByGroupId(_ groupId: String) -> GrouppedMessage? {
        var returnGrouppedMessage: GrouppedMessage?
        
        grouppedMessages.forEach({ grouppedMessage in
            if (grouppedMessage.groupId == groupId) {
                returnGrouppedMessage = grouppedMessage;
            }
        })
        
        return returnGrouppedMessage;
    }
    
    func sendMessage(message: NewMessage, sentCallback: @escaping () -> Void) {
        do {
            let encoder = JSONEncoder()
            let encodedMessage = try encoder.encode(message)
            
            let url = URL(string: Constants.api + "/messages")
            var request = URLRequest(url: url!)
            request.httpMethod = "POST"
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
            request.setValue(AuthManager.manager.getAccessToken()!, forHTTPHeaderField: "authorization")
            request.httpBody = encodedMessage
            
            URLSession.shared.dataTask(with: request) { data, response, error in
                if let error = error {
                    print("Error during communication: \(error.localizedDescription).")
                    return
                } else if data != nil {
                    sentCallback()
                }
            }.resume()
        } catch {
            print(error)
        }
    }
}
