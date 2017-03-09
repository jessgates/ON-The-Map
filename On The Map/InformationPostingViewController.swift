//
//  InformationPostingViewController.swift
//  On The Map
//
//  Created by Jess Gates on 8/24/16.
//  Copyright © 2016 Jess Gates. All rights reserved.
//

import Foundation
import UIKit
import MapKit

class InformationPostingViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var findOnMapView: UIView!
    @IBOutlet weak var submitLinkView: UIView!
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var whereAreYouStudyingLabel: UILabel!
    @IBOutlet weak var locationTextField: UITextField!
    @IBOutlet weak var linkTextField: UITextField!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var findOnMapButton: UIButton!
    @IBOutlet weak var submitLinkButton: UIButton!
    @IBOutlet weak var cancelButton: UIBarButtonItem!
    
    var studentInformation = StudentInformation()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        stopSpinning()
        findOnMapView.hidden = false
        submitLinkView.hidden = true
        
        textFieldAttributes(locationTextField)
        textFieldAttributes(linkTextField)
        
        self.view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(InformationPostingViewController.dismissKeyboard)))
        
        subscribeToKeyboardNotifications()
        subscribeToKeyboardWillHideNotifications()
        
        locationTextField.text! = "Enter Your Location Here"
        linkTextField.text! = "Please Add A Link Here"
        
        let udacityStudentInstance = UdacityClient.sharedInstance()
        
        self.studentInformation.firstName = udacityStudentInstance.firstName!
        self.studentInformation.lastName = udacityStudentInstance.lastName!
        self.studentInformation.uniqueKey = udacityStudentInstance.accountKey!
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        unsubscribeFromKeyboardNotifications()
        unsubscribeFromKeyboardWillHideNotifications()
    }
    
    
    @IBAction func cancelButtonPressed(sender: UIBarButtonItem) {
        
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBAction func findOnMapButtonPressed(sender: UIButton) {
        startSpinning()
        
        guard let locationText = locationTextField.text where locationText != "" else {
            displayError("Please Enter a Location.")
            return
        }
        
        if Reachability.isConnectedToNetwork() == true {
            
            studentInformation.mapString = locationText
        
            findOnMapView.hidden = true
            submitLinkView.hidden = false
        
            let geocoder = CLGeocoder()
            geocoder.geocodeAddressString(locationText) { (placemark, error) in
            
                if let error = error {
                
                    print(error)
                    self.stopSpinning()
                    self.displayError("Location not Found; Please Try Again.")
                    self.submitLinkView.hidden = true
                    self.findOnMapView.hidden = false
                
                } else {
                    let coordinate = placemark![0].location!.coordinate
                
                    self.studentInformation.latitude = coordinate.latitude
                    self.studentInformation.longitude = coordinate.longitude
                
                    var annotations = [MKPointAnnotation]()
                    let annotation = MKPointAnnotation()
                    annotation.coordinate = coordinate
                    annotations.append(annotation)
                
                    self.mapView.showAnnotations(annotations, animated: true)
                    self.stopSpinning()
                    
                }
            }
        } else {
            displayError("No Internet Connection")
        }
    }
    
    @IBAction func submitButtonPressed(sender: UIButton) {
        startSpinning()
        
        guard let locationText = locationTextField.text where locationText != "" else {
            displayError("Please Enter a Location.")
            return
        }
        
        if linkTextField.text! == "" || linkTextField.text! == "Please Add A Link Here" {
            stopSpinning()
            displayError("Please Enter a Link")
        } else {
            
            studentInformation.mediaURL = linkTextField.text!
            
            setUIEnabled(false)
            
            ParseClient.sharedInstance().postStudentLocation(studentInformation) { (error) in
                performUIUpdatesOnMain {
                    self.setUIEnabled(true)
                    if let error = error {
                        self.displayError(error)
                    } else {
                        self.stopSpinning()
                        self.dismissViewControllerAnimated(true, completion: nil)
                    }
                }
            }
        }
    }
}

extension InformationPostingViewController {
    
    private func setUIEnabled(bool: Bool) {
        
        let bool = bool
        if bool ==  true {
            submitLinkButton.enabled = bool
            findOnMapView.hidden = true
        } else {
            submitLinkButton.enabled = bool
        }
    }
    
    func textFieldAttributes(textField: UITextField) {
        
        textField.textAlignment = .Center
        textField.delegate = self
    }

    
    func subscribeToKeyboardNotifications() {
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(InformationPostingViewController.keyboardWillShow(_:)), name: UIKeyboardWillShowNotification, object: nil)
    }
    
    func unsubscribeFromKeyboardNotifications() {
        NSNotificationCenter.defaultCenter().removeObserver(self, name: UIKeyboardWillShowNotification, object: nil)
    }
    
    func keyboardWillShow(notification: NSNotification) {
        if locationTextField.isFirstResponder() || linkTextField.isFirstResponder() {
            view.frame.origin.y =  getKeyboardHeight(notification) * -1
        }
    }
    
    func getKeyboardHeight(notification: NSNotification) -> CGFloat {
        let userInfo = notification.userInfo
        let keyboardSize = userInfo![UIKeyboardFrameEndUserInfoKey] as! NSValue
        return keyboardSize.CGRectValue().height
    }
    
    func keyboardWillHide(notification: NSNotification) {
        view.frame.origin.y = 0
    }
    
    func subscribeToKeyboardWillHideNotifications() {
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(InformationPostingViewController.keyboardWillHide(_:)), name:UIKeyboardWillHideNotification, object: nil)
    }
    
    func unsubscribeFromKeyboardWillHideNotifications() {
        NSNotificationCenter.defaultCenter().removeObserver(self, name:
            UIKeyboardWillHideNotification, object: nil)
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func dismissKeyboard() {
        locationTextField.resignFirstResponder()
        linkTextField.resignFirstResponder()
    }
    
    private func displayError(errorString: String?) {
        
        let alertController = UIAlertController(title: nil, message: errorString, preferredStyle: .Alert)
        let defaultAction = UIAlertAction(title: "Cancel", style: .Default, handler: nil)
        alertController.addAction(defaultAction)
        presentViewController(alertController, animated: true, completion: nil)
    }
    
    private func startSpinning() {
        activityIndicator.hidden = false
        activityIndicator.startAnimating()
    }
    
    private func stopSpinning() {
        activityIndicator.stopAnimating()
        activityIndicator.hidden = true
    }
}
