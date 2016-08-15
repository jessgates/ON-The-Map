//
//  TableViewController.swift
//  On The Map
//
//  Created by Jess Gates on 8/3/16.
//  Copyright © 2016 Jess Gates. All rights reserved.
//

import UIKit
import Foundation

class TableViewController: UITableViewController {
    
    @IBOutlet weak var logoutButton: UIBarButtonItem!
    @IBOutlet weak var refreshButton: UIBarButtonItem!
    @IBOutlet weak var pinButton: UIBarButtonItem!
    
    
    @IBAction func logoutButtonPressed(sender: UIBarButtonItem) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewDidLoad()
        
        ParseClient.sharedInstance().getStudentLocations { (success, data, error) in
            performUIUpdatesOnMain() {
                if error == nil {
                    self.tableView.reloadData()
                } else {
                    self.displayError("Student Data Was Not Downloaded")
                }
            }
        }
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return StudentModel.sharedInstance().students?.count ?? 0
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cellReuseIdentifier = "OnTheMapTableViewCell"
        let cell = tableView.dequeueReusableCellWithIdentifier(cellReuseIdentifier) as UITableViewCell!
        
        if let students = StudentModel.sharedInstance().students?[indexPath.row] {
            cell.textLabel?.text = students.firstName + " " + students.lastName
            cell.detailTextLabel?.text = students.mediaURL
            cell.imageView?.image = UIImage(named: "pin")
        }
        
        return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        if let students = StudentModel.sharedInstance().students?[indexPath.row] {
            
            if let url = NSURL(string: students.mediaURL) {
                UIApplication.sharedApplication().openURL(url)
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
        
        ParseClient.sharedInstance().getStudentLocations { (success, data, error) in
            performUIUpdatesOnMain() {
                if error == nil {
                    self.tableView.reloadData()
                } else {
                    self.displayError("Student Data Was Not Downloaded")
                }
            }
        }
    }
}