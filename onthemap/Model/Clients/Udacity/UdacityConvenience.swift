//
//  UdacityConvenience.swift
//  onthemap
//
//  Created by carloshenrique.carmo on 20/01/19.
//  Copyright © 2019 carloshpdoc. All rights reserved.
//

import Foundation


extension UdacityClient {

      func authenticateWithLogin(_ username: String, _ password: String, _ completionHandlerForAuth: @escaping (_ success: Bool, _ error: String?) -> Void) {
        
        // chain completion handlers for each request so that they run one after the other
        postSessionID(username, password) { (success, sessionID, uniqueKey, error) in
            
            if success {
                // success! we have the sessionID!
                ParseClient.sharedInstance().sessionID = sessionID
                ParseClient.sharedInstance().userID = uniqueKey
                completionHandlerForAuth(success, nil)
                
            } else {
                completionHandlerForAuth(false, error?.localizedDescription);
            }
        }
    }
    
    // MARK: Udacity Session (POST) Method
    private func postSessionID(_ username: String, _ password: String, _ completionHandlerForSession: @escaping (_ success: Bool, _ sessionID: String?, _ uniqueKey: String?, _ error: NSError?) -> Void) {
        
        /* 1. Specify parameters, method (if has {key}), and HTTP body (if POST) */
        let parameters = [String:AnyObject]()
        
        /* 2. Make the request */
        let jsonBody = "{\"udacity\": {\"\(UdacityClient.JSONBodyKeys.UserName)\": \"\(username)\",\"\(UdacityClient.JSONBodyKeys.Password)\": \"\(password)\"}}"
        
        /* 2. Make the request */
        let _ = taskForPOSTMethod(Methods.Session, parameters: parameters as [String:AnyObject], jsonBody: jsonBody) { (results, error) in
            
            /* 3. Send the desired value(s) to completion handler */
            if let error = error {
                completionHandlerForSession(false, nil, nil, error)
            } else {
                if let session = results?[UdacityClient.JSONResponseKeys.Session] as? [String:AnyObject], let account = results?[UdacityClient.JSONResponseKeys.Account] as? [String:AnyObject] {
                    
                    let sessionID = session[UdacityClient.JSONResponseKeys.SessionID] as? String
                    let uniqueKey = account[UdacityClient.JSONResponseKeys.UniqueKey] as? String
                
                    completionHandlerForSession(true, sessionID, uniqueKey, nil)
                } else {
                    completionHandlerForSession(false, nil, nil, NSError(domain: "postSessionID", code: 0, userInfo: [NSLocalizedDescriptionKey: "Login Failure sessionID"]))
                }
            }
        }
    }
    
    // MARK: Public User Data (GET) Method
    func getPublicUserData(_ completionHandlerForGetPublicUserData: @escaping (_ result: UdacityStudent?, _ error: NSError?) -> Void) {
        
        let parameters = [String:AnyObject]()
        
        var mutableMethod: String = Methods.GetUsers
        mutableMethod = substituteKeyInMethod(mutableMethod, key: UdacityClient.URLKeys.UserID, value: ParseClient.sharedInstance().userID!)!
        
        let _ = taskForGETMethod(mutableMethod, parameters: parameters) { ( results, error) in
            
            if let error = error {
                print("getPublicUserData \(error)")
                completionHandlerForGetPublicUserData(nil, error)
            } else {
                if let results = results?[UdacityClient.JSONResponseKeys.UserResult] as? [String:AnyObject] {
                    let student = UdacityStudent.studentFromResults(results)
                    completionHandlerForGetPublicUserData(student, nil)
                } else {
                    completionHandlerForGetPublicUserData(nil, NSError(domain: "get User Data", code: 0, userInfo: [NSLocalizedDescriptionKey: "could not parse getUserInfo"]))
                }
            }
        }
    }
    
     // MARK: Logout User
    func logout(_ completionHandlerForLogout: @escaping (_ success: Bool, _ error: NSError?) -> Void) {
        self.deleteSessionId { (success, sessionID, errorString) in
            
            if success {
                // Remove shared sessionID
                ParseClient.sharedInstance().sessionID = nil
                completionHandlerForLogout(success, nil)
            } else {
                completionHandlerForLogout(false, NSError(domain: "Logout", code: 0, userInfo: [NSLocalizedDescriptionKey: "Logout Failure"]))
            }
        }
    }
    
     // MARK: Delete User Session
    func deleteSessionId(_ completionHandlerForDELETESession: @escaping (_ success: Bool, _ sessionID: String?,_ error: NSError?) -> Void) {
        
        let parameters = [String:AnyObject]()
        
        let _ = taskForDELETEMethod(Methods.Session, parameters: parameters as [String:AnyObject]) { (results, error) in
            
            if let error = error {
                completionHandlerForDELETESession(false, nil, error)
            } else if let session = results?[UdacityClient.JSONResponseKeys.Session] as? [String:AnyObject] {
                let sessionID = session[UdacityClient.JSONResponseKeys.SessionID] as? String
                completionHandlerForDELETESession(true, sessionID, nil)
            } else {
                print("Could not find \(UdacityClient.JSONResponseKeys.SessionID) in \(results!)")
                completionHandlerForDELETESession(false, nil, NSError(domain: "Logout", code: 0, userInfo: [NSLocalizedDescriptionKey: "Logout Failure (Session ID)"]))
            }
        }
    }
}
