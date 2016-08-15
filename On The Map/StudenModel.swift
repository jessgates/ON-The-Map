//
//  StudenModel.swift
//  On The Map
//
//  Created by Jess Gates on 8/9/16.
//  Copyright © 2016 Jess Gates. All rights reserved.
//

import Foundation
import MapKit


class StudentModel {
    
    var students: [StudentInformation]?
    var annotations: [MKPointAnnotation]?
    
    func getStudentAnnotations(students: [StudentInformation]) ->[MKPointAnnotation] {
        
        var annotations = [MKPointAnnotation]()
        
        for student in students {
            
            let lat = CLLocationDegrees(student.latitude)
            let long = CLLocationDegrees(student.longitude)
            
            let coordinate = CLLocationCoordinate2D(latitude: lat, longitude: long)
            
            let first = student.firstName
            let last = student.lastName
            let mediaURL = student.mediaURL
            
            let annotation = MKPointAnnotation()
            annotation.coordinate = coordinate
            annotation.title = "\(first) \(last)"
            annotation.subtitle = mediaURL
            
            annotations.append(annotation)
        }
        
        return annotations
    }
    
    class func sharedInstance() -> StudentModel {
        struct Singleton {
            static var sharedInstance = StudentModel()
        }
        return Singleton.sharedInstance
    }
}