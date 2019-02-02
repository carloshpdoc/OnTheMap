//
//  TextField.swift
//  onthemap
//
//  Created by carloshenrique.carmo on 27/01/19.
//  Copyright © 2019 carloshpdoc. All rights reserved.
//

import Foundation
import UIKit

class TextField: NSObject, UITextFieldDelegate {
    
    // Hide Keyboard
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
}
