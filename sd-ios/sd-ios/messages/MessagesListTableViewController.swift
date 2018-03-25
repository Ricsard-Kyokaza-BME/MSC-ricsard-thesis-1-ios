//
//  MessagesListTableViewController.swift
//  sd-ios
//
//  Created by Balog Richárd on 2018. 03. 25..
//  Copyright © 2018. Richárd Balog. All rights reserved.
//

import UIKit
import Feathers
import FeathersSwiftRest

class GrouppedMessage {
    var groupId: String
    var otherPartnerName: String
    var messages: [Message]
    
    init(_ groupId: String, otherPartnerName: String, messages: [Message]) {
        self.groupId = groupId
        self.otherPartnerName = otherPartnerName
        self.messages = messages
    }
}

class MessagesListTableViewController: UITableViewController {

    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    var feathers: Feathers
    var messages = [Message]()
    var signedInUser: User?
    var grouppedMessages: [GrouppedMessage]
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        feathers = appDelegate.feathersRestApp
        messages = []
        grouppedMessages = []
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        feathers = appDelegate.feathersRestApp
        messages = []
        grouppedMessages = []
        super.init(coder: aDecoder)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if(!AuthManager.manager.isSignedIn) {
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "loginVC") as! LoginViewController
            present(vc, animated: false, completion: nil)
        } else {
            if let signedInUser = AuthManager.manager.getSignedInUser() {
                self.signedInUser = signedInUser
                downloadMessages()
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    func downloadMessages() {
        let userId = signedInUser!._id
        let url = URL(string: Constants.api + "/messages" + "?$limit=100&$or[0][to]=\(userId)&$or[1][from]=\(userId)&$populate=from")
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
                    self.groupMessages()
                    
                    DispatchQueue.main.async {
                        self.tableView.reloadData()
                    }
                } catch {
                    print(error)
                }
            }
            }.resume()
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return grouppedMessages.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "messageListCell", for: indexPath)

        cell.textLabel?.text = grouppedMessages[indexPath.row].otherPartnerName
        cell.detailTextLabel?.text = grouppedMessages[indexPath.row].messages.last?.content

        return cell
    }
    
    // MARK: - Helpers
    
    func groupMessages() {
        messages.forEach({ message in
            if message.from._id == signedInUser!._id {
                if grouppedMessageFindByGroupId(message.to) == nil {
                    grouppedMessages.append(GrouppedMessage(message.to, otherPartnerName: message.to, messages: [message]))
                } else {
                    grouppedMessageFindByGroupId(message.to)?.messages.append(message)
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

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
