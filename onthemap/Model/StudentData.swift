//
//  StudentData.swift
//  onthemap
//
//  Created by carloshenrique.carmo on 27/01/19.
//  Copyright © 2019 carloshpdoc. All rights reserved.
//

import Foundation

struct StudentData {
    
    // MARK: Properties
    let objectID: String?
    let userID: String?
    let firstName: String?
    let lastName: String?
    let mapString: String?
    let mediaURL: String?
    let latitude: Double
    let longitude: Double
    let createdAt: String?
    let updatedAt: String?

    init(dictionary: [String:AnyObject]) {
        objectID = dictionary[ParseClient.JSONResponseKeys.StudentObjectId] as? String
        userID = dictionary[ParseClient.JSONResponseKeys.UniqueKey] as? String
        firstName = dictionary[ParseClient.JSONResponseKeys.StudentFirstName] as? String
        lastName = dictionary[ParseClient.JSONResponseKeys.StudentLastName] as? String
        mapString = dictionary[ParseClient.JSONResponseKeys.StudentMapString] as? String
        mediaURL = dictionary[ParseClient.JSONResponseKeys.StudentMediaURL] as? String
        latitude = dictionary[ParseClient.JSONResponseKeys.StudentLatitude] as! Double
        longitude = dictionary[ParseClient.JSONResponseKeys.StudentLongitude] as! Double
        createdAt = dictionary[ParseClient.JSONResponseKeys.StudentCreatedAt] as? String
        updatedAt = dictionary[ParseClient.JSONResponseKeys.StudentUpdatedAt] as? String
    }

    static func studentsFromResults(_ results: [[String:AnyObject]]) -> [StudentData] {
        
        var students = [StudentData]()
        
        for result in results {
            if let _ = result["latitude"] as? Double, let _ = result["longitude"] as? Double {
                students.append(StudentData(dictionary: result))
            }
        }
        return students
    }

    static func studentFromResults(_ results: [String:AnyObject]) -> StudentData {
        return StudentData(dictionary: results)
    }
}
