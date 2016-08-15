//
//  UdacityConvenience.swift
//  On The Map
//
//  Created by Jess Gates on 7/28/16.
//  Copyright © 2016 Jess Gates. All rights reserved.
//

import UIKit
import Foundation

extension UdacityClient {
    
    func authenticateWithUsernamePassword(username: String, password: String, completionHandlerForAuth: (success: Bool, error: String) -> Void) {

        getSessionId(username, password: password) { (success, sessionId, accountKey, error) in
            if success {
                self.sessionID = sessionId
                self.accountKey = accountKey
            } else {
                completionHandlerForAuth(success: false, error: "Invalid Username or Password")
            }
            
            self.getUserdata()
        }
    }
    
    private func getSessionId(username: String, password: String, completionHandlerForSession: (success: Bool, sessionId: String?, accountKey: String?, error: NSError?) -> Void)  {

        
        let jsonBody = "{\"udacity\": {\"username\": \"\(username)\", \"password\": \"\(password)\"}}"
        
        taskForPOSTMethod(jsonBody) { (results, error) in
            
            if let error = error {
                completionHandlerForSession(success: false, sessionId: nil, accountKey: nil, error: error)
            } else {
                print(results)
                
                guard let accountDictionary = results[UdacityClient.JSONResponseKeys.Account] as? [String: AnyObject] else {
                    print("Could not find key \(UdacityClient.JSONResponseKeys.Account) in \(results)")
                    return
                }
                
                guard let sessionDictionary = results[UdacityClient.JSONResponseKeys.Session] as? [String: AnyObject] else {
                    print("Could not find key \(UdacityClient.JSONResponseKeys.Session) in \(results)")
                    return
                }
                
                if let accountKey = accountDictionary[UdacityClient.JSONResponseKeys.Key] as? String, sessionId = sessionDictionary[UdacityClient.JSONResponseKeys.SessionId] as? String {
                    completionHandlerForSession(success: true, sessionId: sessionId, accountKey: accountKey, error: nil)
                }
            }
        }
    }
    
    private func getUserdata() {
        
        taskForGETMethod { (results, error) in
            
            guard let userDictionary = results[UdacityClient.JSONResponseKeys.User] as? [String: AnyObject] else {
                    print("Could not find key \(UdacityClient.JSONResponseKeys.User) in \(results)")
                    return
            }
            
            if let firstName = userDictionary[UdacityClient.JSONResponseKeys.FirstName] as? String, lastName = userDictionary[UdacityClient.JSONResponseKeys.LastName] as? String {
                
                self.firstName = firstName
                self.lastName = lastName
                print(firstName)
                print(lastName)
            }
        }
    }
}

