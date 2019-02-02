//
//  TableViewVC.swift
//  onthemap
//
//  Created by carloshenrique.carmo on 27/01/19.
//  Copyright © 2019 carloshpdoc. All rights reserved.
//

import Foundation
import UIKit

class TableViewVC: UIViewController {

    // MARK: Outlets
    @IBOutlet weak var studentsTableView: UITableView!


    // MARK: Life cycle
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        refreshTableView()
    }
}

// MARK: ListViewController: UITableViewDataSource, UITableViewDelegate

extension TableViewVC: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return SharedDataStudent.sharedInstance.students.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let student = SharedDataStudent.sharedInstance.students[(indexPath as NSIndexPath).row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "LocationCell")!
        
        cell.textLabel!.text = "\(student.firstName ?? "FirstName") \(student.lastName ?? "LastName")"
        cell.detailTextLabel!.text = student.mediaURL
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let student = SharedDataStudent.sharedInstance.students[(indexPath as NSIndexPath).row]
        
        if let urlString = student.mediaURL {
            if let url = URL(string: urlString) {
                
                if UIApplication.shared.canOpenURL(url) {
                    UIApplication.shared.open(url, options: [:], completionHandler: nil)
                } else {
                    alertUser(nil, message: "Invalid Link!")
                }
            }
        }
    }
    
    // Refresh Table Data
    func refreshTableView() {
        if let studentsTableView = studentsTableView {
            studentsTableView.reloadData()
        }
    }
}

private extension TableViewVC {
    
    func alertUser(_ title: String?, message: String) -> Void {
        
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
        let action = UIAlertAction(title: "Dismiss", style: .default, handler: nil)
        
        alert.addAction(action)
        self.present(alert, animated: true, completion: nil)
    }
}
