//
//  SendInfo.swift
//  onthemap
//
//  Created by carloshenrique.carmo on 27/01/19.
//  Copyright © 2019 carloshpdoc. All rights reserved.
//

import Foundation
import UIKit

class SendInfoVC: UIViewController {
    
    // MARK: Outlets
    @IBOutlet weak var locationTextField: UITextField!
    @IBOutlet weak var websiteTextField: UITextField!
    @IBOutlet weak var scrollView: UIScrollView!
    
    // MARK: Actions
    @IBAction func cancelButton(_ sender: Any) {
        
        self.dismiss(animated: true, completion: nil)
    }
    
    // MARK: Life Cycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        locationTextField.delegate = self
        websiteTextField.delegate = self
    }
    
    // MARK: Prepare for Segue
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "sendLocationSegue" {
            let controller = segue.destination as! LocationVC
            controller.userLocationString = locationTextField.text
            controller.mediaURL = websiteTextField.text
            
            // If student location exists
            if let student = SharedDataStudent.sharedInstance.currentUser {
                controller.objectID = student.objectID
                print("ObjectID being passed to LocationViewController \(student.objectID!)")
            }
        }
    }
    
    // MARK: Shoud Perform Segue with identifier
    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
        if identifier == "sendLocationSegue" {
            guard let locationString = locationTextField.text, !locationString.isEmpty  else {
                dispatchAlert("Location Not Found", message: "Please enter a location.")
                return false
            }
            guard let url = websiteTextField.text, !url.isEmpty else {
                dispatchAlert("Location Not Found", message: "Please enter a website.")
                return false
            }
            if (!url.contains("https://")) {
                dispatchAlert("Website Not Found", message: "Website must include \"https://\"")
                return false
            }
        }
        return true
    }
}

// MARK: - UITextFieldDelegate

extension SendInfoVC: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        var y = 0
        if textField == websiteTextField {
            y = 120
        } else if textField == locationTextField {
            y = 60
        }
        
        if UIDevice.current.orientation.isLandscape {
            scrollView.setContentOffset(CGPoint(x:0,y:y), animated: true)
        }
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if UIDevice.current.orientation.isLandscape {
            scrollView.setContentOffset(CGPoint(x:0,y:0), animated: true)
        }
    }
}
