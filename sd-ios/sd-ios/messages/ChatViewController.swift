//
//  ChatViewController.swift
//  sd-ios
//
//  Created by Balog Richárd on 2018. 04. 28..
//  Copyright © 2018. Richárd Balog. All rights reserved.
//

import UIKit

class ChatViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    var grouppedMessageIndex: Int?
    var grouppedMessage: GrouppedMessage?
    var signedInUser: User?
    var otherUser: User?
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var messageTextField: UITextField!
    @IBOutlet weak var messageSendButton: UIButton!
    
    override func viewWillAppear(_ animated: Bool) {
        if(!AuthManager.manager.isSignedIn) {
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "loginVC") as! LoginViewController
            present(vc, animated: false, completion: nil)
        } else {
            if let signedInUser = AuthManager.manager.getSignedInUser() {
                self.signedInUser = signedInUser
                self.grouppedMessage = MessageService.service.grouppedMessages[grouppedMessageIndex!]
                self.findOtherUser()
                navigationItem.title = self.otherUser!.getName()
            }
        }
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return (grouppedMessage?.messages.count)!
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 10
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "messageCell", for: indexPath)
        
        cell.textLabel?.text = grouppedMessage?.messages[indexPath.section].content
        cell.textLabel?.numberOfLines = 0;
        cell.textLabel?.lineBreakMode = NSLineBreakMode.byWordWrapping
        cell.contentView.layoutMargins.left = 20
        cell.contentView.layoutMargins.right = 20
        cell.contentView.layoutMargins.top = 120
        
        cell.layer.cornerRadius = 20
        cell.layer.masksToBounds = true
        
        if grouppedMessage?.messages[indexPath.section].from._id == signedInUser?._id {
            cell.textLabel?.textAlignment = NSTextAlignment.right
            cell.textLabel?.textColor = .white
            cell.backgroundColor = .gray
        } else {
            cell.textLabel?.textAlignment = NSTextAlignment.left
        }
        
        return cell
    }
    
    @IBAction func sendClick(_ sender: Any) {
        MessageService.service.sendMessage(message: NewMessage(otherUser!, content: messageTextField.text!), sentCallback: {
            MessageService.service.downloadMessages(self.signedInUser!._id, downloadedCallback: { grouppedMessages in
                self.grouppedMessage = MessageService.service.grouppedMessages[self.grouppedMessageIndex!]
                self.messageTextField!.text = ""
                self.view.endEditing(true)
                self.tableView.reloadData()
            })
        })
    }
    
    func findOtherUser() {
        for message in grouppedMessage!.messages {
            if(message.from._id == signedInUser!._id) {
                otherUser = message.to
            } else {
                otherUser = message.from
            }
        }
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
