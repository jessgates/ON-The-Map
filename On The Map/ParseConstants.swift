//
//  ParseConstants.swift
//  On The Map
//
//  Created by Jess Gates on 7/27/16.
//  Copyright © 2016 Jess Gates. All rights reserved.
//

import UIKit

extension ParseClient {
    
    struct Constants {
        
        static let ApiScheme = "https"
        static let ApiHost = "parse.udacity.com"
        static let ApiPath = "/parse/classes/StudentLocation"
        
    }
    
    struct Methods {
        
        static let PostMethod = "POST"
        static let GetMethod = "GET"
        
    }
    
    struct Headers {
        
        static let ForApiAplicationID = "X-Parse-Application-Id"
        static let ForRestApiKey = "X-Parse-REST-API-Key"
        static let ApiAplicationID = "QrX47CA9cyuGewLdsL7o5Eb8iug6Em8ye0dnAbIr"
        static let RestApiKey = "QuWThTdiRmTux3YaDseUSEpUKo7aBYM737yKd4gY"
        
    }
    
    struct Parameters {
        
        static let Limit = "limit"
        static let Skip = "skip"
        static let Order = "order"
        static let Where = "where"
        static let ObjectId = "objectId"
    }
    
    struct JSONResponseKeys {
        
        static let Results = "results"
        static let ObjectId = "objectId"
        static let UniqueKey = "uniqueKey"
        static let FirstName = "firstName"
        static let LastName = "lastName"
        static let MapString = "mapString"
        static let MediaURL = "mediaURL"
        static let Latitude = "latitude"
        static let Longitude = "longitude"
        
    }
}
