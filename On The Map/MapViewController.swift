//
//  MapViewController.swift
//  On The Map
//
//  Created by Jess Gates on 8/3/16.
//  Copyright © 2016 Jess Gates. All rights reserved.
//

import UIKit
import MapKit

class MapViewController: UIViewController, MKMapViewDelegate {
    
    @IBOutlet var mapView: MKMapView!
    @IBOutlet var refreshButton: UIBarButtonItem!
    @IBOutlet var logoutButton: UIBarButtonItem!
    @IBOutlet var pinButton: UIBarButtonItem!
    
    
    override func viewWillAppear(animated: Bool) {
        super.viewDidLoad()
        mapView.delegate = self
        
        ParseClient.sharedInstance().getStudentLocations { (success, data, error) in
            
            performUIUpdatesOnMain {
                if error == nil {
                    self.mapView.addAnnotations(StudentModel.sharedInstance().annotations!)
                } else {
                    self.displayError("Student Data Was Not Downloaded")
                }
            }
        }
    }
    
    func mapView(mapView: MKMapView, viewForAnnotation annotation: MKAnnotation) -> MKAnnotationView? {
        
        let reuseId = "pin"
        
        var pinView = mapView.dequeueReusableAnnotationViewWithIdentifier(reuseId) as? MKPinAnnotationView
        
        if pinView == nil {
            pinView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: reuseId)
            pinView!.canShowCallout = true
            pinView!.pinTintColor = UIColor.redColor()
            pinView!.rightCalloutAccessoryView = UIButton(type: .DetailDisclosure)
        }
        else {
            pinView!.annotation = annotation
        }
        
        return pinView
    }
    
    func mapView(mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        if control == view.rightCalloutAccessoryView {
            let app = UIApplication.sharedApplication()
            if let toOpen = view.annotation?.subtitle!, url = NSURL(string: toOpen) {
                app.openURL(url)
            }
        }
    }
    
    private func displayError(errorString: String?) {
        
        let alertController = UIAlertController(title: nil, message: errorString, preferredStyle: .Alert)
        let defaultAction = UIAlertAction(title: "Cancel", style: .Default, handler: nil)
        alertController.addAction(defaultAction)
        presentViewController(alertController, animated: true, completion: nil)
    }
    
    @IBAction func refreshButtonPressed(sender: UIBarButtonItem) { 
        mapView.removeAnnotations(mapView.annotations)
    }
    
    @IBAction func logoutButtonPressed(sender: UIBarButtonItem) {
        dismissViewControllerAnimated(true, completion: nil)
        UdacityClient.sharedInstance().deleteSessionID()
    }
    
}

protocol TabViewControllersDelegate: class {
    func dismissTabBarController()
}