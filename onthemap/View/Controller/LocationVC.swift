//
//  LocationVC.swift
//  onthemap
//
//  Created by carloshenrique.carmo on 27/01/19.
//  Copyright © 2019 carloshpdoc. All rights reserved.
//

import Foundation
import UIKit
import MapKit

class LocationVC: UIViewController {
    
    //MARK: Properties
    var geocoder: CLGeocoder?
    var objectID: String?
    
    var userLocationString: String?
    var mediaURL: String?
    var lat: CLLocationDegrees?
    var long: CLLocationDegrees?
    var message: String?
    var createdAt: String?
    var updatedAt: String?
    
    var activityIndicator:UIActivityIndicatorView = UIActivityIndicatorView()
    
    // MARK: Messages
    struct Messages {
        // Messages to display successes and errors
        static let PutStudentLocationSuccess = "Your location updated successfully!"
        static let PostStudentLocationSuccess = "Your location was added successfully!"
        static let PutStudentLocationError = "Error: Your location update failed."
        static let PostStudentLocationError = "Error: Your location was not saved."
    }
    
    // MARK: Outlets
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var doneButton: UIButton!
    
    // MARK: Actions
    @IBAction func doneButtonPressed(_ sender: Any) {
        
        doneButton.isEnabled = false
        
        // Activity indicator
        startActivityIndicator(for: self, activityIndicator, .whiteLarge)
        
        // Get student's public data
        UdacityClient.sharedInstance().getPublicUserData { (student, error) in
            
            if let student = student {
                
                let studentDict: [String:AnyObject] = [
                    "uniqueKey": student.userID as AnyObject,
                    "mapString": self.userLocationString as AnyObject,
                    "mediaURL": self.mediaURL as AnyObject,
                    "latitude": self.lat as AnyObject,
                    "longitude": self.long as AnyObject,
                    "createdAt": self.createdAt as AnyObject,
                    "updatedAt": self.updatedAt as AnyObject
                ]
                
                if let objectID = self.objectID, !objectID.isEmpty {
                    
                    self.putToExistingLocation(objectID: objectID, dictionary: studentDict)
                    
                } else {
                    
                    self.postNewLocation(dictionary: studentDict)
                }
                
            } else if error != nil {
                self.dispatchAlert(nil, message: "No Internet Connection")
            }
        }
    }
    
    // Function to Update an Existing Location
    func putToExistingLocation(objectID: String, dictionary: [String:AnyObject]) {
        ParseClient.sharedInstance().putStudentLocation(objectID, dictionary, { (success, error) in
            if success {
                self.message = Messages.PutStudentLocationSuccess
            } else {
                self.message = Messages.PutStudentLocationError
            }
            self.updateUI(self.message!)
        })
    }
    
    // Function to Post a New Location
    func postNewLocation(dictionary: [String:AnyObject]) {
        ParseClient.sharedInstance().postStudentLocation(dictionary, { (success, error) in
            if success {
                self.message = Messages.PostStudentLocationSuccess
            } else {
                self.message = Messages.PostStudentLocationError
            }
            self.updateUI(self.message!)
        })
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        mapView.delegate = self
        
        // Shows location when lat and long are verfied
        doneButton.isHidden = true
        
        // Geacoding function
        lookupGeocoding()
    }
    
    // MARK: Forward Geocoding to get latitude and longitude based on user entry.
    func lookupGeocoding() {
        
        // Activity indicator
        startActivityIndicator(for: self, activityIndicator, .whiteLarge)
        
        if geocoder == nil {
            geocoder = CLGeocoder()
        }
        
        geocoder?.geocodeAddressString(userLocationString!, completionHandler: { (placemarks, error) in
            let placemark = placemarks?.first
            let lat = placemark?.location?.coordinate.latitude
            let long = placemark?.location?.coordinate.longitude
            
            if let lat = lat, let long = long {
                self.lat = lat
                self.long = long
                self.doneButton.isHidden = false
                self.reverseGeocoding(latitude: lat, longitude: long)
            } else {
                // Show Alert
                self.dispatchAlert(nil, message: "Geocoding has failed!")
            }
        })
    }

    func reverseGeocoding(latitude: CLLocationDegrees, longitude: CLLocationDegrees) {
        
        let location = CLLocation(latitude: latitude, longitude: longitude)
        geocoder?.reverseGeocodeLocation(location, completionHandler: { (placemarks, error) in
            
            let placemark = placemarks?.first
            let city = placemark?.locality
            let state = placemark?.administrativeArea
            let zip = placemark?.postalCode
            let country = placemark?.isoCountryCode
            
            var address: String? = ""
            let comma: String = ", "
            let space: String = " "
            
            func appendAddress(_ optionalString: String?, _ seprator: String) {
                if let optionalString = optionalString {
                    address?.append("\(optionalString)\(seprator)")
                }
            }
            
            appendAddress(city, comma)
            appendAddress(state, space)
            appendAddress(zip, comma )
            appendAddress(country, "")

            self.renderMapWithPinView(latitude: latitude, longitude: longitude, title: address!)
        })
    }
    
    func renderMapWithPinView(latitude: CLLocationDegrees, longitude: CLLocationDegrees, title: String) {
        let annotation = MKPointAnnotation()
        let coordinate = CLLocationCoordinate2DMake(latitude, longitude)
        let regionRadius: CLLocationDistance  = 250
        
        annotation.coordinate = coordinate
        annotation.title = title
        
        performUIUpdatesOnMain {
            self.mapView.addAnnotation(annotation)
            self.mapView.setRegion(MKCoordinateRegion(center: coordinate, latitudinalMeters: regionRadius, longitudinalMeters: regionRadius), animated: true)
        }
        self.stopActivityIndicator(for: self, self.activityIndicator)
    }

    func startOver() {
        navigationController?.dismiss(animated: true, completion: nil)
        doneButton.isEnabled = true
    }
}

// MARK: Update UI
private extension LocationVC {

    func updateUI(_ message: String) {
        performUIUpdatesOnMain {
            self.stopActivityIndicator(for: self, self.activityIndicator)
            self.dispatchAlert(nil, message: self.message!, handler: {
                self.startOver()
            })
        }
    }
}

// MARK: MKMapViewDelegate

extension LocationVC: MKMapViewDelegate {
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        
        let reuseId = "pin"
        var pinAnnotationView = mapView.dequeueReusableAnnotationView(withIdentifier: reuseId) as? MKPinAnnotationView
        
        if pinAnnotationView == nil {
            pinAnnotationView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: reuseId)
            pinAnnotationView!.canShowCallout = true
            pinAnnotationView!.pinTintColor = .red
        } else {
            pinAnnotationView?.annotation = annotation
        }
        return pinAnnotationView
    }
}

