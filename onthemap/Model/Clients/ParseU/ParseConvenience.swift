//
//  ParseConvenience.swift
//  onthemap
//
//  Created by carloshenrique.carmo on 20/01/19.
//  Copyright © 2019 carloshpdoc. All rights reserved.
//

import Foundation


extension ParseClient {
    
    // MARK: GET Convenience Methods
    
    // Students Locations
    func getStudentsLocations(_ completionHandlerForStudenstLocations: @escaping (_ result: [StudentData]?, _ error: NSError?) -> Void) {
        
        let parametersWithKeys = [ParameterKeys.Limit: ParameterValues.Limit,
                                  ParameterKeys.Order: ParameterValues.Order] as [String : AnyObject]
        
        let _ = taskForGETMethod(Methods.GetStudentLocation, parameters: parametersWithKeys) { (results, error) in
            
            if let error = error {
                completionHandlerForStudenstLocations(nil, error)
            } else {
                
                if let results = results?[ParseClient.JSONResponseKeys.StudentResults] as? [[String:AnyObject]] {
                    
                    let studentsResult = StudentData.studentsFromResults(results)
                    completionHandlerForStudenstLocations(studentsResult, nil)
                    
                } else {
                    completionHandlerForStudenstLocations(nil, NSError(domain: "getStudentsLocations", code: 0, userInfo: [NSLocalizedDescriptionKey: "Failure methods getStudentsLocations"]))
                }
            }
        }
    }
    
    // Student location
    func getStudentLocation(_ userID: String, _ completionHandlerForStudentLocation: @escaping (_ result: StudentData?, _ error: NSError?) -> Void) {
        
        var parametersWithKeys = [String:AnyObject]()
        parametersWithKeys[ParameterKeys.Where] = "{\"uniqueKey\":\"\(userID)\"}" as AnyObject?
        
        let _ = taskForGETMethod(Methods.GetStudentLocation, parameters: parametersWithKeys) { (results, error) in
            
            if let error = error {
                completionHandlerForStudentLocation(nil, error)
            } else {
                
                if let results = results?[ParseClient.JSONResponseKeys.StudentResults] as? [[String:AnyObject]] {
                    
                    // selects first location if multiple records are found for a user
                    if results.isEmpty {
                        print("No Location for user!")
                        completionHandlerForStudentLocation(nil, nil)
                        
                    } else if let result = results.first {
                        let studentResult = StudentData.studentFromResults(result)
                        completionHandlerForStudentLocation(studentResult, nil)
                    }
                } else {
                    completionHandlerForStudentLocation(nil, NSError(domain: "getStudentLocation", code: 0, userInfo: [NSLocalizedDescriptionKey: "Failure for methods getStudentLocation"]))
                }
            }
        }
    }
    
    // MARK: POST Convenience Method
    func postStudentLocation(_ student: [String:AnyObject], _ completionHandlerForLocationPost: @escaping (_ success: Bool, _ error: NSError?) -> Void) {
        
        let parameters = [String:AnyObject]()
        
        let jsonBody = convertDictionaryToJSONString(dictionary: student)!
        
        // Make the request
        let _ = taskForPOSTMethod(Methods.PostStudentLocation, parameters: parameters, jsonBody: jsonBody) { (results, error) in
            
            if let error = error {
                completionHandlerForLocationPost(false, error)
            } else {
                if let _ = results?[ParseClient.JSONResponseKeys.StudentObjectId] as? String {
                    completionHandlerForLocationPost(true, nil)
                } else {
                    completionHandlerForLocationPost(false, NSError(domain: "postStudentLocation", code: 0, userInfo: [NSLocalizedDescriptionKey: "Failure for methods postStudentLocation"]))
                }
            }
        }
    }
    
    // MARK: PUT Convenience Method
    
    func putStudentLocation(_ objectID: String, _ student: [String:AnyObject], _ completionHandlerForLocationPut: @escaping (_ success: Bool, _ error: NSError?) -> Void) {
        
        let parameters = [String:AnyObject]()
        
        let jsonBody = convertDictionaryToJSONString(dictionary: student)!
        
        var mutableMethod: String = Methods.PutStudentLocation
        mutableMethod = substituteKeyInMethod(mutableMethod, key: ParseClient.URLKeys.ObjectID, value: objectID)!
        
        // Make the request
        let _ = taskForPUTMethod(mutableMethod, parameters: parameters as [String:AnyObject], jsonBody: jsonBody) { (results, error) in
            if let error = error {
                completionHandlerForLocationPut(false, error)
            } else {
                if let _ = results?[ParseClient.JSONResponseKeys.StudentUpdatedAt] as? String {
                    completionHandlerForLocationPut(true, nil)
                } else {
                    completionHandlerForLocationPut(false, NSError(domain: "putStudentLocation", code: 0, userInfo: [NSLocalizedDescriptionKey: "Failure for methods putStudentLocation"]))
                }
            }
        }
    }
}
