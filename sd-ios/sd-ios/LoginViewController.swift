//
//  LoginViewController.swift
//  sd-ios
//
//  Created by Richárd Balog on 2017. 11. 26..
//  Copyright © 2017. Richárd Balog. All rights reserved.
//

import UIKit
import CoreData

class LoginViewController: UIViewController {

    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    var user: User?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = Constants.primaryColor
    }
    
    @IBAction func loginTouchUpInside(_ sender: Any) {
        if let email = emailTextField.text, let password = passwordTextField.text {
            AuthManager.manager.signIn(email: email, password: password)
            AuthManager.manager.addListenerToSignInStatusChange(listener: { (isSignedIn) in
                if(isSignedIn) {
                    let signedInUser = NSEntityDescription.insertNewObject(forEntityName: "SignedInUser", into: (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext)
                    signedInUser.setValue(email, forKey: "email")
                    signedInUser.setValue(password, forKey: "password")
                    (UIApplication.shared.delegate as! AppDelegate).saveContext()
                    
                    self.dismiss(animated: true, completion: nil)
                }
            })
        }
    }
    
    @IBAction func cancelClick(_ sender: Any) {
        if let presenter = presentingViewController as? HomeTabBarController {
            presenter.selectedIndex = 0
        }
        dismiss(animated: true, completion: nil)
    }

}
