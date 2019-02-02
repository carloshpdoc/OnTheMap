//
//  BottomNavBar.swift
//  onthemap
//
//  Created by carloshenrique.carmo on 27/01/19.
//  Copyright © 2019 carloshpdoc. All rights reserved.
//

import Foundation
import UIKit

class BottomNavBar: UITabBarController {
    
    @IBAction func refreshPressed(_ sender: Any) {
        refreshData()
    }
    
    @IBAction func addPressed(_ sender: Any) {
        
        if let currentUser = SharedDataStudent.sharedInstance.currentUser {
            
            // Existing location
            askToContinueAlert(nil, message: "User \(currentUser.userID!) has already posted a location. Would you like to overwrite with a new Location?", { (overwrite) in
                if overwrite {
                    self.performSegue(withIdentifier: "SendInfoSegue", sender: sender)
                }
            })
        } else {
            // No location
            performSegue(withIdentifier: "SendInfoSegue", sender: sender)
        }
    }
    
    @IBAction func logoutPressed(_ sender: Any) {
        
        // Logout and dismiss view
        UdacityClient.sharedInstance().logout{ (success, errorString) in
            performUIUpdatesOnMain {
                if success {
                    self.dismiss(animated: true, completion: nil)
                } else {
                    self.dispatchAlert("Logout Failed", message: "\(errorString!)")
                }
            }
        }
    }
    
    // MARK : Life Cycle Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let userID = ParseClient.sharedInstance().userID!
        
        // Get student location
        ParseClient.sharedInstance().getStudentLocation(userID, { (studentLocation, error) in
            if let studentLocation = studentLocation {
                SharedDataStudent.sharedInstance.currentUser = studentLocation
            }
        })
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        refreshData()
    }
    
    // MARK: Refresh or load data
    
    func refreshData() {
        
        let mapVC = self.viewControllers?[0] as! MapVC
        let tableViewVC = self.viewControllers?[1] as! TableViewVC
        
        ParseClient.sharedInstance().getStudentsLocations{ (students, error) in
            if let students = students {
                SharedDataStudent.sharedInstance.students = students
                
                performUIUpdatesOnMain {
                    // Add Annotations to MapView and refresh data
                    mapVC.addAnnotationsToMapView(locations: students)
                    tableViewVC.refreshTableView()
                }
            } else {
                performUIUpdatesOnMain {
                    // Show alert
                    self.dispatchAlert("No Data Found", message: (error?.localizedDescription)!)
                }
            }
        }
    }
    
    // MARK: Prepare for Segue
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "SendInfoSegue" {
            if let studentLocation = SharedDataStudent.sharedInstance.currentUser {
                let navController = segue.destination as! UINavigationController
                _ = navController.viewControllers.first as! SendInfoVC
                
                // Pass student data to PostInfoViewController
                SharedDataStudent.sharedInstance.currentUser = studentLocation
            }
        }
    }
}
