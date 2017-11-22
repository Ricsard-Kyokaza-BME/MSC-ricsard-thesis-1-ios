//
//  AuthManager.swift
//  sd-ios
//
//  Created by Richárd Balog on 2017. 11. 22..
//  Copyright © 2017. Richárd Balog. All rights reserved.
//

import Foundation
import Feathers

class AuthManager {
    
    // MARK: - Properties
    
    static let manager = AuthManager()
    var isSignedIn: Bool
    let feathers: Feathers
    var signInStatusChangeListeners: [(_ isSignedIn: Bool) -> Void]
    
    // MARK: - Init
    
    private init() {
        feathers = (UIApplication.shared.delegate as! AppDelegate).feathersRestApp
        self.isSignedIn = false
        signInStatusChangeListeners = []
    }
    
    // MARK: - Methods
    
    func signIn(email: String, password: String) {
        feathers.authenticate([
            "strategy": "local",
            "email": email,
            "password": password
            ]).on(value: { response in
                if response["accessToken"] != nil {
                    self.isSignedIn = true
                    self.notifySignInStatusChangeListeners(isSignedIn: true)
                }
            })
            .start()
    }
    
    func signOut() {
        feathers.logout().on(value: { response in
                self.isSignedIn = true
                self.notifySignInStatusChangeListeners(isSignedIn: false)
            })
            .start()
    }
    
    func addListenerToSignInStatusChange(listener: @escaping (_ isSignedIn: Bool) -> Void) -> Void {
        signInStatusChangeListeners.append(listener)
    }
    
    func notifySignInStatusChangeListeners(isSignedIn: Bool) -> Void {
        for listener in signInStatusChangeListeners {
            listener(isSignedIn)
        }
    }
    
}
