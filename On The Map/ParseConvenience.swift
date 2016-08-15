//
//  ParseConvenience.swift
//  On The Map
//
//  Created by Jess Gates on 8/2/16.
//  Copyright © 2016 Jess Gates. All rights reserved.
//

import UIKit
import Foundation

extension ParseClient {
    
    func getStudentLocations(completionHandlerForLocations: (success: Bool, data: AnyObject?, error: NSError?) -> Void) {
        
        let parameters = [ParseClient.Parameters.Limit:"100"]
        
        taskForGETMethod(parameters) { (result, error) in
            if let error = error {
                completionHandlerForLocations(success: false, data: nil, error: error)
            } else {
                
                if let results = result[ParseClient.JSONResponseKeys.Results] as? [[String:AnyObject]] {
                    
                    let students = StudentInformation.StudentsFromResults(results)
                    let annotations = self.studentModel.getStudentAnnotations(students)
                    self.studentModel.students = students
                    self.studentModel.annotations = annotations
                    completionHandlerForLocations(success: true, data: results, error: nil)
                    
                } else {
                    completionHandlerForLocations(success: false, data: nil, error: error)
                }
            }
        }
    }
    
    
}