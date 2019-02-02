//
//  MapVC.swift
//  onthemap
//
//  Created by carloshenrique.carmo on 27/01/19.
//  Copyright © 2019 carloshpdoc. All rights reserved.
//

import Foundation
import UIKit
import MapKit

class MapVC: UIViewController {
    
    // MARK: Properties
    var annotations = [MKPointAnnotation]()
    
    // MARK: Outlets
    @IBOutlet weak var mapView: MKMapView!
    
    
    // MARK: Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        mapView.delegate = self
    }
    
    // Removes all annotations from map
    func removeAnnotations() {
        mapView.removeAnnotations(annotations)
        annotations.removeAll()
    }
    
    // Adds annotations to MapView
    func addAnnotationsToMapView(locations: [StudentData]) {
        
        // Remove annotations from map view if previously loaded
        removeAnnotations()
        
        for location in locations {
            
            let lat = CLLocationDegrees(location.latitude)
            let long = CLLocationDegrees(location.longitude)
            
            // The lat and long are used to create a CLLocationCoordinates2D instance.
            let coordinate = CLLocationCoordinate2D(latitude: lat, longitude: long)
            
            // Student name returns nil because Udacity user data is now anonymous and randomized
            //            let first = location.firstName!
            //            let last = location.lastName!
            let mediaURL = location.mediaURL
            
            // Creates annotation and sets the coordiates, title, and subtitle properties
            let annotation = MKPointAnnotation()
            annotation.coordinate = coordinate
            // Student name returns nil because Udacity user data is now anonymous and randomized
            annotation.title = "\("FirstName") \("LastName")"
            annotation.subtitle = mediaURL
            
            // Place annotations in an array of annotations
            annotations.append(annotation)
        }
        // Add annotations to map
        mapView.addAnnotations(annotations)
    }
}

// MARK: - MKMapViewDelegate

extension MapVC: MKMapViewDelegate {
    
    // Creates a view with the "right callout accessory view"
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        
        let reuseId = "pin"
        
        var pinView = mapView.dequeueReusableAnnotationView(withIdentifier: reuseId) as? MKPinAnnotationView
        
        if pinView == nil {
            pinView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: reuseId)
            pinView!.canShowCallout = true
            pinView!.pinTintColor = .red
            pinView!.rightCalloutAccessoryView = UIButton(type: .detailDisclosure)
        } else {
            pinView!.annotation = annotation
        }
        return pinView
    }
    
    // This delegate method is implemented to respond to taps. It opens the system browser
    // to the URL specified in the annotationViews subtitle property.
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        if control == view.rightCalloutAccessoryView {
            let app = UIApplication.shared
            if let url = view.annotation?.subtitle! {
                app.open(URL(string:url)!, options: [:], completionHandler: { (success) in
                    if !success {
                        self.dispatchAlert("Invalid URL", message: "Could not open URL")
                    }
                })
            }
        }
    }
}





