//
//  StudentInformation.swift
//  On The Map
//
//  Created by Jess Gates on 8/2/16.
//  Copyright © 2016 Jess Gates. All rights reserved.
//

import Foundation

struct StudentInformation {
    
    var firstName: String!
    var lastName: String!
    var objectId: String!
    var mapString: String!
    var latitude: Double!
    var longitude: Double!
    var uniqueKey: String!
    var mediaURL: String!
    
    init(dictionary: [String:AnyObject]) {
        firstName = dictionary[ParseClient.JSONResponseKeys.FirstName] as? String
        lastName = dictionary[ParseClient.JSONResponseKeys.LastName] as? String
        objectId = dictionary[ParseClient.JSONResponseKeys.ObjectId] as? String
        mapString = dictionary[ParseClient.JSONResponseKeys.MapString] as? String
        latitude = dictionary[ParseClient.JSONResponseKeys.Latitude] as? Double
        longitude = dictionary[ParseClient.JSONResponseKeys.Longitude] as? Double
        uniqueKey = dictionary[ParseClient.JSONResponseKeys.UniqueKey] as? String
        mediaURL = dictionary[ParseClient.JSONResponseKeys.MediaURL] as? String
    }
    
    init() {
        firstName = String()
        lastName = String()
        objectId = String()
        mapString = String()
        latitude = Double()
        longitude = Double()
        uniqueKey = String()
        mediaURL = String()
    }
    
    static func StudentsFromResults(results: [[String:AnyObject]]) -> [StudentInformation] {
        
        var students = [StudentInformation]()
        
        for result in results {
            students.append(StudentInformation(dictionary: result))
        }
        
        return students
    }
    
}