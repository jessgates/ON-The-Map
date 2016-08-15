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
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var debugTextLabel: UILabel!
    
    var onTheMaptabBarController: UITabBarController?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        usernameTextField.text! = "Username"
        textFieldAttributes(usernameTextField)
        
        passwordTextField.text! = "Password"
        textFieldAttributes(passwordTextField)
        
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
    
    @IBAction func loginButtonPressed(sender: AnyObject) {
        
        guard emptyText() else {
            print("A text field is empty")
            return
        }
        
        let username = usernameTextField.text!
        let password = passwordTextField.text!
    
        UdacityClient.sharedInstance().authenticateWithUsernamePassword(username, password: password) { (success, error) in
            performUIUpdatesOnMain {
                if success {
                    print(success)
                    self.completeLogin()
                } else {
                    self.displayError(error)
                }
            }
        }
    }
    
    private func completeLogin() {
        debugTextLabel.text = ""

            let controller = self.storyboard!.instantiateViewControllerWithIdentifier("tabBarViewController") as! UITabBarController
            self.presentViewController(controller, animated: true, completion: nil)
    }
    
}

extension LoginViewController {
    
    private func setUIEnabled(enabled: Bool) {
        loginButton.enabled = enabled
        debugTextLabel.enabled = enabled
        
        // adjust login button alpha
        if enabled {
            loginButton.alpha = 1.0
        } else {
            loginButton.alpha = 0.5
        }
    }
    
    private func displayError(errorString: String?) {
        if let errorString = errorString {
            debugTextLabel.text = errorString
        }
    }
    
    private func emptyText() -> Bool {
        if usernameTextField.text! == "" || passwordTextField.text! == "" {
            displayError("Username or Password is empty.")
        }
        
        return true
    }
    
    private func configureBackground() {
        let backgroundGradient = CAGradientLayer()
        let colorTop = UIColor(red: 0.345, green: 0.839, blue: 0.988, alpha: 1.0).CGColor
        let colorBottom = UIColor(red: 0.023, green: 0.569, blue: 0.910, alpha: 1.0).CGColor
        backgroundGradient.colors = [colorTop, colorBottom]
        backgroundGradient.locations = [0.0, 1.0]
        backgroundGradient.frame = view.frame
        view.layer.insertSublayer(backgroundGradient, atIndex: 0)
    }
}