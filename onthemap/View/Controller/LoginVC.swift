//
//  ViewController.swift
//  onthemap
//
//  Created by carloshenrique.carmo on 01/01/19.
//  Copyright © 2019 carloshpdoc. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    @IBOutlet weak var userLabel: UITextField!
    @IBOutlet weak var passwordLabel: UITextField!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var signupButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    @IBAction func loginPressed(_ sender: Any) {
        if validateTextField() {
            dispatchAlert(nil, message: "Check your login was completed correctly.")
        } else {
            UdacityClient.sharedInstance().authenticateWithLogin(userLabel.text!, passwordLabel.text!) { (success, errorString) in
                performUIUpdatesOnMain {
                    if success {
                        self.completeLogin()
                    } else {
                        self.dispatchAlert(nil, message: errorString!)
                    }
                }
            }
        }
    }
    
    private func completeLogin() {
        performUIUpdatesOnMain {
            let controller = self.storyboard!.instantiateViewController(withIdentifier: "MainNavigationController") as! UINavigationController
            self.present(controller, animated: true, completion: nil)
        }
    }
    
    // Validates username and password textFields
    private func validateTextField() -> Bool {
        if userLabel.text!.isEmpty || passwordLabel.text!.isEmpty {
            return true
            
        } else {
            return false
        }
    }
    
    func displayError(_ errorString: String?) {
        if let errorString = errorString {
            dispatchAlert("Error", message: errorString)
        }
    }
    
    @IBAction func signupButtonPressed(_ sender: Any) {
        
        let urlString = UdacityClient.Constants.AccountSignUp
        let url = URL(string: urlString)
        
        if UIApplication.shared.canOpenURL(url!) {
            UIApplication.shared.open(url!, options: [:], completionHandler: nil)
        }
    }

}

