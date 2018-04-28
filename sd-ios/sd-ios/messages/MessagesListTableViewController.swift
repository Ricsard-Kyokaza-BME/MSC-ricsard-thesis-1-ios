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

class MessagesListTableViewController: UITableViewController {

    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    var signedInUser: User?
    var grouppedMessages = [GrouppedMessage]()
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if(!AuthManager.manager.isSignedIn) {
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "loginVC") as! LoginViewController
            present(vc, animated: false, completion: nil)
        } else {
            if let signedInUser = AuthManager.manager.getSignedInUser() {
                self.signedInUser = signedInUser
                MessageService.service.downloadMessages(signedInUser._id, downloadedCallback: { grouppedMessages in
                    self.grouppedMessages = grouppedMessages
                    self.tableView.reloadData()
                })
            }
        }
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
    
    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ConversationDetailSegue" {
            let vc = segue.destination as? ChatViewController
            let row = tableView.indexPathForSelectedRow?.row
            vc?.grouppedMessageIndex = row!
        }
    }

}
