//
//  UdacityConstants.swift
//  onthemap
//
//  Created by carloshenrique.carmo on 20/01/19.
//  Copyright © 2019 carloshpdoc. All rights reserved.
//

import Foundation

extension UdacityClient {
    
    // MARK: Constants
    struct Constants {
    
        // MARK: URLs
        static let ApiScheme = "https"
        static let ApiHost = "onthemap-api.udacity.com"
        static let ApiPath = "/v1"
        static let AccountSignUp = "https://www.udacity.com/account/auth#!/signup"
    }
    
    // MARK: Methods
    struct Methods {

        // MARK: Authentication
        static let Session = "/session"
        static let GetUsers = "/users/{id}"
        
    }
    
    // MARK: URL Keys
    struct URLKeys {
        static let UserID = "id"
    }
    
    // MARK: Parameter Keys
    struct ParameterKeys {
        static let SessionID = "session_id"
    }
    
    // MARK: JSON Body Keys
    struct JSONBodyKeys {
        static let UserName = "username"
        static let Password = "password"
        static let AccessToken = "access_token"
    }
    
    // MARK: JSON Response Keys
    struct JSONResponseKeys {
        
        // MARK: General
        static let StatusMessage = "status_message"
        static let StatusCode = "status_code"
        
        // MARK: Account
        static let Account = "account"
        static let Session = "session"
        static let SessionID = "id"
        
        static let UniqueKey = "key"
        static let FirstName = "first_name"
        static let LastName = "last_name"
        static let UserResult = "user"
    }
    
    struct UdacityStudent {
        
        let userID: String
        
        // MARK: Initializers
        init(dictionary: [String:AnyObject]) {
            userID = dictionary[UdacityClient.JSONResponseKeys.UniqueKey] as! String
        }
        
        static func studentFromResults(_ result: [String:AnyObject]) -> UdacityStudent {
            let student: UdacityStudent
            student = UdacityStudent(dictionary: result)
            return student
        }
    }
}
