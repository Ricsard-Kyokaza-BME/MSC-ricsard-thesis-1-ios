//
//  LoginViewController.swift
//  sd-ios
//
//  Created by Richárd Balog on 2017. 11. 26..
//  Copyright © 2017. Richárd Balog. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {

    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    var user: User?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = Constants.primaryColor
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func loginTouchUpInside(_ sender: Any) {
        if let email = emailTextField.text, let password = passwordTextField.text {
            AuthManager.manager.signIn(email: email, password: password)
            AuthManager.manager.addListenerToSignInStatusChange(listener: { (isSignedIn) in
                if(isSignedIn) {
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
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
