//
//  MeViewController.swift
//  sd-ios
//
//  Created by Richárd Balog on 2017. 11. 26..
//  Copyright © 2017. Richárd Balog. All rights reserved.
//

import UIKit
import Feathers
import Alamofire
import CoreData

class MeViewController: UITableViewController {
    
    @IBOutlet weak var firstNameTextField: UITextField!
    @IBOutlet weak var lastNameTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    var signedInUser: User?
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if(!AuthManager.manager.isSignedIn) {
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "loginVC") as! LoginViewController
            present(vc, animated: false, completion: nil)
        } else {
            if let signedInUser = AuthManager.manager.getSignedInUser() {
                self.signedInUser = signedInUser
                firstNameTextField.text = signedInUser.firstName
                lastNameTextField.text = signedInUser.lastName
                emailTextField.text = signedInUser.email
            }
        }
    }
    
    @IBAction func saveTouchUpInside(_ sender: Any) {
        signedInUser?.firstName = firstNameTextField.text!
        signedInUser?.lastName = lastNameTextField.text!
        
        do {
            let encoder = JSONEncoder()
            let encodedUser = try encoder.encode(signedInUser)

            let url = URL(string: Constants.api + "/users/" + signedInUser!._id)
            var request = URLRequest(url: url!)
            request.httpMethod = "PATCH"
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
            request.setValue(AuthManager.manager.getAccessToken()!, forHTTPHeaderField: "authorization")
            request.httpBody = encodedUser
            
            URLSession.shared.dataTask(with: request) { data, response, error in
                if let error = error {
                    print("Error during comminication: \(error.localizedDescription).")
                    return
                } else if data != nil {
                    DispatchQueue.main.async {
                        self.tabBarController?.selectedIndex = 0
                    }
                }
            }.resume()
            
        } catch {
            print(error)
        }
    }

    @IBAction func logoutClick(_ sender: Any) {
        AuthManager.manager.addListenerToSignInStatusChange { (isSignedIn) in
            if(!isSignedIn) {
                AppDelegate.deleteAllSignedInUserRecords()
                
                DispatchQueue.main.async {
                    self.tabBarController?.selectedIndex = 0
                }
            }
        }
        AuthManager.manager.signOut()
    }
    
    
}
