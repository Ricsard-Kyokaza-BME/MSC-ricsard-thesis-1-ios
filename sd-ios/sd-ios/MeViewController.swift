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

class MeViewController: UITableViewController {
    
    @IBOutlet weak var firstNameTextField: UITextField!
    @IBOutlet weak var lastNameTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    var signedInUser: User?
    var feathers: Feathers?
    
    private var urlSession: URLSession = {
        let sessionConfiguration = URLSessionConfiguration.default
        return URLSession(configuration: sessionConfiguration, delegate: nil, delegateQueue: OperationQueue.main)
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        feathers = (UIApplication.shared.delegate as! AppDelegate).feathersRestApp
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

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func saveTouchUpInside(_ sender: Any) {
        let userService = feathers!.service(path: "users")
        
        signedInUser?.firstName = firstNameTextField.text!
        signedInUser?.lastName = lastNameTextField.text!
//        print(signedInUser)
        
        do {
            let encoder = JSONEncoder()
            let encodedUser = try encoder.encode(signedInUser)
//            var jsonData = try JSONSerialization.jsonObject(with: encodedUser, options: []) as? [String : Any]
//
//            let theJSONData = try JSONSerialization.data(
//                withJSONObject: jsonData!,
//                options: [])
//            let theJSONText = String(data: jsonData,
//                                     encoding: .ascii)
//            print("JSON string = \(theJSONText!)")
//            var jsonData2 = try JSONSerialization.jsonObject(with: theJSONData, options: []) as? [String : Any]
            
//            let xxxx = signedInUser?.toData()
//
//            print(xxxx)
            
//            let xy = User(0, id: "sad", firstName: "sadsad", lastName: "xcyxm,", email: "b@b.com", roles: ["user"], createdAt: Date(), updatedAt: Date())
//            let newencodedUser = try encoder.encode(xy)
//            var jsonData2 = try JSONSerialization.jsonObject(with: newencodedUser, options: JSONSerialization.ReadingOptions(rawValue: 0)) as? [String : Any]
////            jsonData?.removeValue(forKey: "createdAt")
////            jsonData?.removeValue(forKey: "updatedAt")
////            jsonData?.removeValue(forKey: "roles")
//
//            userService.request(.create(data: jsonData2!, query: nil)).on(value: { response in
//                print("Create: \(response)")
//            }).start()

//            if let user =  signedInUser {
//                userService.request(.patch(id: user._id, data: xxxx!, query: nil)).on(value: { response in
//                    print(response)
//                }).start()
//            }
            
//            var ehh = [String: Any]()
//            ehh["firstName"] = "ty"
//
//            userService.request(.patch(id: signedInUser!._id, data: ["firstName": "ty"], query: Query().eq(property: "_id", value: signedInUser!._id))).on(value: { response in
//                print(response)
//            }).start()
            
            
            let url = URL(string: Constants.api + "/users/" + signedInUser!._id)
            var request = URLRequest(url: url!)
            request.httpMethod = "PATCH"
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
            request.setValue(AuthManager.manager.accessToken!, forHTTPHeaderField: "authorization")
            request.httpBody = encodedUser
            
            URLSession.shared.dataTask(with: request) { data, response, error in
                print("ehh")
                if let error = error {
                    print("Error during comminication: \(error.localizedDescription).")
                    return
                } else if let data = data {
                    print(data)
                }
            }.resume()
            
//            userService.request(.patch(id: signedInUser!._id, data: ehh, query: nil)).on(value: { response in
//                print(response)
//            }).start()
            
//            if let user =  signedInUser, let serializedUser = jsonData2 {
//                print(serializedUser)
//                let ehh = ["firstName": "ty"]
//                userService.request(.patch(id: user._id, data: ehh, query: nil)).on(value: { response in
//                    print(response)
//                }).start()
//            }
        } catch {
            print(error)
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
