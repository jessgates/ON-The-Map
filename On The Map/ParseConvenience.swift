//
//  ParseConvenience.swift
//  On The Map
//
//  Created by Jess Gates on 8/2/16.
//  Copyright © 2016 Jess Gates. All rights reserved.
//

import Foundation
import UIKit

extension ParseClient {
    
    func getStudentLocations(completionHandlerForGetLocations: (success: Bool, data: [StudentInformation]?, error: NSError?) -> Void) {
        
        let parameters = [ParseClient.Parameters.Limit: ParseClient.ParameterValue.Limit,
                          ParseClient.Parameters.Order: ParseClient.ParameterValue.Order]
        
        taskForGETMethod(parameters) { (result, error) in
            if let error = error {
                completionHandlerForGetLocations(success: false, data: nil, error: error)
            } else {
                
                if let results = result[ParseClient.JSONResponseKeys.Results] as? [[String:AnyObject]] {
                    
                    let students = StudentInformation.StudentsFromResults(results)
                    let annotations = self.studentModel.getStudentAnnotations(students)
                    self.studentModel.students = students
                    self.studentModel.annotations = annotations
                    completionHandlerForGetLocations(success: true, data: students, error: nil)
                    
                } else {
                    completionHandlerForGetLocations(success: false, data: nil, error: error)
                }
            }
        }
    }
    
    func postStudentLocation(studentInformation: StudentInformation, completionHandlerForStudenInformation: (error: String?) -> Void) {
        
        let parameters = [String:AnyObject]()
        
        let jsonBody = "{\"uniqueKey\": \"\(studentInformation.uniqueKey)\", \"firstName\": \"\(studentInformation.firstName)\", \"lastName\": \"\(studentInformation.lastName)\",\"mapString\": \"\(studentInformation.mapString)\", \"mediaURL\": \"\(studentInformation.mediaURL)\",\"latitude\": \(studentInformation.latitude), \"longitude\": \(studentInformation.longitude)}"
        
        taskForPOSTMethod(parameters, jsonBody: jsonBody) { (result, error) in
            
            if error != nil {
                print(error)
                
                completionHandlerForStudenInformation(error: "Post Failed: Please Check Your Connection And Try Again.")
        
            } else {
                if let results = result.valueForKey(ParseClient.JSONResponseKeys.ObjectId) as? String {
                    self.objectId = results
                }
                completionHandlerForStudenInformation(error: nil)
            }
        }
    }
}