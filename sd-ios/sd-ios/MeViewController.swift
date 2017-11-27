//
//  MeViewController.swift
//  sd-ios
//
//  Created by Richárd Balog on 2017. 11. 26..
//  Copyright © 2017. Richárd Balog. All rights reserved.
//

import UIKit
import Feathers

class MeViewController: UITableViewController {
    
    @IBOutlet weak var firstNameTextField: UITextField!
    @IBOutlet weak var lastNameTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    var signedInUser: User?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let signedInUser = AuthManager.manager.getSignedInUser() {
            firstNameTextField.text = signedInUser.firstName
            lastNameTextField.text = signedInUser.lastName
            emailTextField.text = signedInUser.email
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if(!AuthManager.manager.isSignedIn) {
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "loginVC") as! LoginViewController
            present(vc, animated: true, completion: nil)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func saveTouchUpInside(_ sender: Any) {
        print("Save")
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
