//
//  SharedData.swift
//  onthemap
//
//  Created by carloshenrique.carmo on 27/01/19.
//  Copyright © 2019 carloshpdoc. All rights reserved.
//

import Foundation

class SharedDataStudent {
    
    static let sharedInstance = SharedDataStudent()
    var students: [StudentData] = []
    var currentUser: StudentData?
    
    private init() {
        
    }
}
