//
//  LoginViewController.swift
//  On The Map
//
//  Created by Jess Gates on 7/25/16.
//  Copyright © 2016 Jess Gates. All rights reserved.
//

import Foundation
import UIKit


class LoginViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var udacityU: UIImageView!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var debugTextLabel: UILabel!
    @IBOutlet weak var udacitysignUpButton: UIButton!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        stopSpinning()
        
        subscribeToKeyboardNotifications()
        subscribeToKeyboardWillHideNotifications()
        
        usernameTextField.text! = "Username"
        textFieldAttributes(usernameTextField)
        
        passwordTextField.text! = "Password"
        textFieldAttributes(passwordTextField)
        
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        unsubscribeFromKeyboardNotifications()
        unsubscribeFromKeyboardWillHideNotifications()
    }
    
    private func completeLogin() {
        
        debugTextLabel.text = ""

            let controller = self.storyboard!.instantiateViewControllerWithIdentifier("tabBarViewController") as! UITabBarController
            self.presentViewController(controller, animated: true, completion: nil)
            setUIEnabled(true)
            self.stopSpinning()
    }
    
    @IBAction func loginButtonPressed(sender: AnyObject) {
        self.startSpinning()
        
        guard emptyText() else {
            displayError("A text field is empty")
            return
        }
        
        let username = usernameTextField.text!
        let password = passwordTextField.text!
        
        if Reachability.isConnectedToNetwork() == true {
        
            UdacityClient.sharedInstance().authenticateWithUsernamePassword(username, password: password) { (success, error) in
                performUIUpdatesOnMain {
                    if success {
                        self.completeLogin()
                    } else {
                        self.setUIEnabled(true)
                        self.displayError("Username or Password is incorrect")
                        self.stopSpinning()
                    }
                }
            }
        } else {
            displayError("No Internet Connection")
        }
    }

    
    @IBAction func udacitysignUpButtonPressed(sender: UIButton) {
        if let url = NSURL(string: UdacityClient.Constants.UdacitySignUpLink) {
            UIApplication.sharedApplication().openURL(url)
        }
    }
}

extension LoginViewController {
    
    private func setUIEnabled(enabled: Bool) {
        loginButton.enabled = enabled
        debugTextLabel.enabled = enabled
    }
    
    func textFieldAttributes(textField: UITextField) {
        
        let loginTextAttributes = [
            NSForegroundColorAttributeName : UIColor.grayColor(),
            NSFontAttributeName : UIFont(name: "FiraSans-Light", size: 20)!,
            NSStrokeWidthAttributeName : -3,
            ]
        
        textField.defaultTextAttributes = loginTextAttributes
        textField.textAlignment = .Left
        textField.delegate = self
    }

    
    func textFieldDidBeginEditing(textField: UITextField) {
        if usernameTextField.text! == "Username" || passwordTextField.text! == "Password" {
            textField.text = ""
        }
    }
    
    func subscribeToKeyboardNotifications() {
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(LoginViewController.keyboardWillShow(_:)), name: UIKeyboardWillShowNotification, object: nil)
    }
    
    func unsubscribeFromKeyboardNotifications() {
        NSNotificationCenter.defaultCenter().removeObserver(self, name: UIKeyboardWillShowNotification, object: nil)
    }
    
    func keyboardWillShow(notification: NSNotification) {
        if usernameTextField.isFirstResponder() || passwordTextField.isFirstResponder() {
            udacityU.hidden = true
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
        udacityU.hidden = false
    }
    
    func subscribeToKeyboardWillHideNotifications() {
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(LoginViewController.keyboardWillHide(_:)), name:UIKeyboardWillHideNotification, object: nil)
    }
    
    func unsubscribeFromKeyboardWillHideNotifications() {
        NSNotificationCenter.defaultCenter().removeObserver(self, name:
            UIKeyboardWillHideNotification, object: nil)
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    private func startSpinning() {
        activityIndicator.hidden = false
        activityIndicator.startAnimating()
    }
    
    private func stopSpinning() {
        activityIndicator.stopAnimating()
        activityIndicator.hidden = true
    }
    
    private func displayError(errorString: String?) {
        
        let alertController = UIAlertController(title: nil, message: errorString, preferredStyle: .Alert)
        let defaultAction = UIAlertAction(title: "Cancel", style: .Default, handler: nil)
        alertController.addAction(defaultAction)
        presentViewController(alertController, animated: true, completion: nil)
    }
    
    private func emptyText() -> Bool {
        if usernameTextField.text! == "" || passwordTextField.text! == "" {
            displayError("Username or Password is empty.")
        }
        
        return true
    }
}