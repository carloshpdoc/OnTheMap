//
//  HelpersController.swift
//  onthemap
//
//  Created by carloshenrique.carmo on 27/01/19.
//  Copyright © 2019 carloshpdoc. All rights reserved.
//

import Foundation
import UIKit

extension UIViewController {
    
    // MARK: Alerts
    func dispatchAlert(_ title: String?, message: String, handler: @escaping() -> Void = {}) {
        
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
        let dismissAction = UIAlertAction(title: "Dismiss", style: .default, handler: { (action) -> Void in
            handler()
        })
        
        alert.addAction(dismissAction)
        self.present(alert, animated: true, completion: nil)
    }
    
    func askToContinueAlert(_ title: String?, message: String, _ completionHandler: @escaping (_ : Bool) -> Void) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
        
        // Overwrite Button
        let overwriteAction = UIAlertAction(title: "Overwrite", style: .default, handler: { (action) -> Void in
            completionHandler(true)
        })
        
        // Cancel Button
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: { (action) -> Void in
            completionHandler(false)
        })
        
        //Add Overwrite and Cancel button to dialog message
        alert.addAction(overwriteAction)
        alert.addAction(cancelAction)
        
        // Present dialog message to user
        self.present(alert, animated: true, completion: nil)
    }
    
    // MARK: Activity Indicator
    
    // Start Activity Indicator
    func startActivityIndicator(for controller: UIViewController, _ activityIndicator: UIActivityIndicatorView, _ style: UIActivityIndicatorView.Style) {
        activityIndicator.center = controller.view.center
        activityIndicator.hidesWhenStopped = true
        activityIndicator.style = style
        
        if style == .whiteLarge || style == .white {
            for subview in controller.view.subviews {
                subview.alpha = 0.7
            }
            controller.view.backgroundColor = UIColor.darkGray
        }
        controller.view.addSubview(activityIndicator)
        activityIndicator.alpha = 1.0
        activityIndicator.startAnimating()
    }
    
    // Stop Activity Indicator
    func stopActivityIndicator(for controller: UIViewController, _ activityIndicator: UIActivityIndicatorView) {
        guard activityIndicator.isAnimating else {
            return
        }
        if (activityIndicator.style == .whiteLarge || activityIndicator.style == .white) {
            controller.view.backgroundColor = UIColor.white
            for subview in controller.view.subviews {
                subview.alpha = 1.0
            }
        }
        activityIndicator.stopAnimating()
    }
}
