//
//  UdacityConstants.swift
//  On The Map
//
//  Created by Jess Gates on 7/25/16.
//  Copyright © 2016 Jess Gates. All rights reserved.
//

import UIKit

extension UdacityClient {
    
    struct Constants {
        
        static let ApiScheme = "https"
        static let ApiHost = "www.udacity.com"
        static let ApiPath = "/api"
        static let ApiPostandDeleteMethod = "/session"
        static let ApiUserMethod = "/users/<user_id>"
    }
    
    struct JSONBodyKeys {
        
        static let Username = "username"
        static let Password = "password"
        
    }
    
    struct JSONResponseKeys {
        
        static let Account = "account"
        static let Registered = "registered"
        static let Key = "key"
        static let Session = "session"
        static let SessionId = "id"
        static let Expiration = "expiration"
        static let User = "user"
        static let FirstName = "first_name"
        static let LastName = "last_name"
        
    }
}