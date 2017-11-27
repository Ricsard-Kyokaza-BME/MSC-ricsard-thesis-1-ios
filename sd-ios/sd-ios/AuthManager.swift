//
//  AuthManager.swift
//  sd-ios
//
//  Created by Richárd Balog on 2017. 11. 22..
//  Copyright © 2017. Richárd Balog. All rights reserved.
//

import Foundation
import Feathers
import JWTDecode

class AuthManager {
    
    // MARK: - Properties
    
    static let manager = AuthManager()
    var isSignedIn: Bool
    let feathers: Feathers
    var signInStatusChangeListeners: [(_ isSignedIn: Bool) -> Void]
    var signedInUser: User?
    
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
                    do {
                        let jwt = try decode(jwt: response["accessToken"] as! String)
                        self.requestSignedInUser(jwt.body["userId"] as! String)
                    } catch {
                        print("Failed to decode JWT: \(error)")
                    }
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
    
    func getSignedInUser() -> User? {
        if let user = signedInUser {
            return user
        }
        
        return nil
    }
    
    private func requestSignedInUser(_ userId: String) -> Void {
        let userService = feathers.service(path: "users")
        let query = Query().eq(property: "_id", value: userId)
        
        userService.request(.find(query: query))
            .on(value: { response in
                let jsonDecoder = JSONDecoder()

                for user in response.data.value as! Array<[String: Any]> {
                    do {
                        let jsonData = try JSONSerialization.data(withJSONObject: user, options:  JSONSerialization.WritingOptions(rawValue: 0))
                        jsonDecoder.dateDecodingStrategy = .formatted(Formatter.iso8601)

                        self.signedInUser = try jsonDecoder.decode(User.self, from: jsonData)
                    } catch {
                        print(error)
                    }
                }
                
                self.isSignedIn = true
                self.notifySignInStatusChangeListeners(isSignedIn: true)
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
