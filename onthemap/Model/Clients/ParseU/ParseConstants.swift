//
//  ParseConstants.swift
//  onthemap
//
//  Created by carloshenrique.carmo on 20/01/19.
//  Copyright © 2019 carloshpdoc. All rights reserved.
//

import Foundation

extension ParseClient {
    
    // MARK: Constants
    struct Constants {
        
        // MARK: API Key
        static let APIKey = "QuWThTdiRmTux3YaDseUSEpUKo7aBYM737yKd4gY"
        static let ApplicationID = "QrX47CA9cyuGewLdsL7o5Eb8iug6Em8ye0dnAbIr"
        // MARK: URLs
        static let ApiScheme = "https"
        static let ApiHost = "parse.udacity.com"
        static let ApiPath = "/parse"
    }
    
    // MARK: Methods
    struct Methods {
        
        // MARK: Student Location
        static let GetStudentLocation = "/classes/StudentLocation"
        static let PostStudentLocation = "/classes/StudentLocation"
        static let PutStudentLocation = "/StudentLocation/{objectId}"

    }
    
    // MARK: URL Keys
    struct URLKeys {
        static let UniqueKey = "uniqueKey"
        static let ObjectID = "objectId"
    }
    
    // MARK: Parameter Keys
    struct ParameterKeys {
        static let ApiKey = "X-Parse-REST-API-Key"
        static let ApplicationID = "X-Parse-Application-Id"
        static let SessionID = "session_id"
        static let RequestToken = "request_token"
        static let Limit = "limit"
        static let Skip = "skip"
        static let Order = "order"
        static let Where = "where"
    }
    
    // MARK: Parameter Values
    struct ParameterValues {
        
        static let Limit = "100"
        static let Order = "-updatedAt"
    }
    
    // MARK: JSON Body Keys
    struct JSONBodyKeys {
        static let UniqueKey = "uniqueKey"
        static let FirstName = "firstName"
        static let LastName = "lastName"
        static let MapString = "mapString"
        static let MediaURL = "mediaURL"
        static let Latitude = "latitude"
        static let Longitude = "longitude"
    }
    
    // MARK: JSON Response Keys
    struct JSONResponseKeys {
        
        // MARK: General
        static let StatusMessage = "status_message"
        static let StatusCode = "status_code"
        
        // MARK: UniqueKey
        static let UniqueKey = "uniqueKey"
        
        // MARK: Students
        static let StudentObjectId = "objectId"
        static let StudentUniqueKey = "uniqueKey"
        static let StudentFirstName = "firstName"
        static let StudentLastName = "lastName"
        static let StudentMapString = "mapString"
        static let StudentMediaURL = "mediaURL"
        static let StudentLatitude = "latitude"
        static let StudentLongitude = "longitude"
        static let StudentCreatedAt = "createdAt"
        static let StudentUpdatedAt = "updatedAt"
        static let StudentResults = "results"
    }
}
