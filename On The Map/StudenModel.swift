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
            
             if let lat = student.latitude,
                let long = student.longitude,
                let first = student.firstName,
                let last = student.lastName,
                let mediaURL = student.mediaURL {
                let coordinate = CLLocationCoordinate2D(latitude: CLLocationDegrees(lat), longitude: CLLocationDegrees(long))
            
                let annotation = MKPointAnnotation()
                annotation.coordinate = coordinate
                annotation.title = "\(first) \(last)"
                annotation.subtitle = mediaURL
            
                annotations.append(annotation)
            }
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