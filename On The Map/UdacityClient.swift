//
//  UdacityClient.swift
//  On The Map
//
//  Created by Jess Gates on 7/25/16.
//  Copyright © 2016 Jess Gates. All rights reserved.
//

import Foundation

class UdacityClient: NSObject {
    
    var session = NSURLSession.sharedSession()
    
    var sessionID: String? = nil
    
    var accountKey: String? = nil
    var firstName: String? = nil
    var lastName: String? = nil
    
    override init() {
        super.init()
    }
    
    func taskForGETMethod(completionHandlerforGET: (results: AnyObject!, error: NSError?) -> Void) {
        
        let request = NSMutableURLRequest(URL: udacityURLFromParameters(UdacityClient.Constants.ApiUserMethod.stringByReplacingOccurrencesOfString("<user_id>", withString: accountKey!)))
        
        request.HTTPMethod = "GET"
        
        let task = session.dataTaskWithRequest(request) { data, response, error in
            
            func sendError(error: String) {
                print(error)
                let userInfo = [NSLocalizedDescriptionKey : error]
                completionHandlerforGET(results: nil, error: NSError(domain: "taskForGETMethod", code: 1, userInfo: userInfo))
            }
            
            guard (error == nil) else {
                sendError("There was an error with your request: \(error)")
                return
            }
            
            guard let statusCode = (response as? NSHTTPURLResponse)?.statusCode where statusCode >= 200 && statusCode <= 299 else {
                sendError("Your request returned a status code other than 2xx!")
                return
            }
            
            guard let data = data else {
                sendError("No data was returned by the request!")
                return
            }
            
            let newData = data.subdataWithRange(NSMakeRange(5, data.length - 5))
            
            self.convertDataWithCompletionHandler(newData, completionHandlerForConvertData: completionHandlerforGET)
        }
        
        task.resume()
    }
    
    func taskForPOSTMethod(jsonBody: String, completionHandlerForPOST: (results: AnyObject!, error: NSError?) -> Void)
        {
    
        let request = NSMutableURLRequest(URL: udacityURLFromParameters(UdacityClient.Constants.ApiPostandDeleteMethod))
            
        request.HTTPMethod = "POST"
            
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.HTTPBody = jsonBody.dataUsingEncoding(NSUTF8StringEncoding)
        
        let task = session.dataTaskWithRequest(request) { data, response, error in
            
            func sendError(error: String) {
                print(error)
                let userInfo = [NSLocalizedDescriptionKey : error]
                completionHandlerForPOST(results: nil, error: NSError(domain: "taskForPOSTMethod", code: 1, userInfo: userInfo))
            }
    
            guard (error == nil) else {
                sendError("There was an error with your request: \(error)")
                return
            }
    
            guard let statusCode = (response as? NSHTTPURLResponse)?.statusCode where statusCode >= 200 && statusCode <= 299 else {
                sendError("Your request returned a status code other than 2xx!")
                return
            }
    
            guard let data = data else {
                sendError("No data was returned by the request!")
                return
            }
            
            let newData = data.subdataWithRange(NSMakeRange(5, data.length - 5))
    
            self.convertDataWithCompletionHandler(newData, completionHandlerForConvertData: completionHandlerForPOST)
        }
    
        task.resume()
    }
    
    
    func taskForDELETEMethod(completionHandlerForDELETE: (results: AnyObject!, error: NSError?) -> Void) {
        
        let request = NSMutableURLRequest(URL: udacityURLFromParameters(UdacityClient.Constants.ApiPostandDeleteMethod))
        
        request.HTTPMethod = "DELETE"
        
        var xsrfCookie: NSHTTPCookie? = nil
        
        let sharedCookieStorage = NSHTTPCookieStorage.sharedHTTPCookieStorage()
        
        for cookie in sharedCookieStorage.cookies! {
            if cookie.name == "XSRF-TOKEN" { xsrfCookie = cookie }
        }
        
        if let xsrfCookie = xsrfCookie {
            request.setValue(xsrfCookie.value, forHTTPHeaderField: "X-XSRF-TOKEN")
        }
        
        let task = session.dataTaskWithRequest(request) { data, response, error in
            
            func sendError(error: String) {
                print(error)
                let userInfo = [NSLocalizedDescriptionKey : error]
                completionHandlerForDELETE(results: nil, error: NSError(domain: "taskForDELETEMethod", code: 1, userInfo: userInfo))
            }
            
            guard (error == nil) else {
                sendError("There was an error with your request: \(error)")
                return
            }
            
            guard let statusCode = (response as? NSHTTPURLResponse)?.statusCode where statusCode >= 200 && statusCode <= 299 else {
                sendError("Your request returned a status code other than 2xx!")
                return
            }
            
            guard let data = data else {
                sendError("No data was returned by the request!")
                return
            }
            
            let newData = data.subdataWithRange(NSMakeRange(5, data.length - 5))
            
            self.convertDataWithCompletionHandler(newData, completionHandlerForConvertData: completionHandlerForDELETE)
        }
        
        task.resume()
    }
    
    
    private func convertDataWithCompletionHandler(data: NSData, completionHandlerForConvertData: (result: AnyObject!, error: NSError?) -> Void) {
        
        var parsedResult: AnyObject!
        do {
            parsedResult = try NSJSONSerialization.JSONObjectWithData(data, options: .AllowFragments)
        } catch {
            let userInfo = [NSLocalizedDescriptionKey : "Could not parse the data as JSON: '\(data)'"]
            completionHandlerForConvertData(result: nil, error: NSError(domain: "convertDataWithCompletionHandler", code: 1, userInfo: userInfo))
        }
        
        completionHandlerForConvertData(result: parsedResult, error: nil)
    }
    
    
    
    private func udacityURLFromParameters(parameters: String) -> NSURL {
        
        let components = NSURLComponents()
        components.scheme = UdacityClient.Constants.ApiScheme
        components.host = UdacityClient.Constants.ApiHost
        components.path = UdacityClient.Constants.ApiPath + parameters

        return components.URL!
    }
    
    
    
    class func sharedInstance() -> UdacityClient {
        struct Singleton {
            static var sharedInstance = UdacityClient()
        }
        return Singleton.sharedInstance
    }
    
}