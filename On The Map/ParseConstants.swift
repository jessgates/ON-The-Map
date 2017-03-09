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
        static let UpdateStudentPath = "https://parse.udacity.com/parse/classes/StudentLocation/<objectId>"
        
    }
    
    struct Methods {
        
        static let PostMethod = "POST"
        static let GetMethod = "GET"
        static let PutMethod = "PUT"
        
    }
    
    struct Headers {
        
        static let ForHeaderFieldApiAplicationID = "X-Parse-Application-Id"
        static let ForHeaderFieldRestApiKey = "X-Parse-REST-API-Key"
        static let ForHeaderFieldContenetType = "Content-Type"
        static let ApiAplicationID = "QrX47CA9cyuGewLdsL7o5Eb8iug6Em8ye0dnAbIr"
        static let RestApiKey = "QuWThTdiRmTux3YaDseUSEpUKo7aBYM737yKd4gY"
        static let ContentType = "application/json"
        
    }
    
    struct Parameters {
        
        static let Limit = "limit"
        static let Skip = "skip"
        static let Order = "order"
        static let Where = "where"
        static let ObjectId = "objectId"
        
    }
    
    struct ParameterValue {
        
        static let Limit = "100"
        static let Order = "-updatedAt"

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
