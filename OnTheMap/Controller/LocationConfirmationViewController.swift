//
//  LocationConfirmationViewController.swift
//  OnTheMap
//
//  Created by Tabassum Tamanna on 1/27/21.
//

import UIKit
import MapKit

// MARK: - Location Confirmation View Controller
class LocationConfirmationViewController: UIViewController, MKMapViewDelegate {

    // MARK: - Outlet
    @IBOutlet weak var mapView: MKMapView!
    
    // MARK: - variables
    var latitude: Float = 0.0
    var longitude: Float = 0.0
    var location: String = ""
    var mediaURL: String = ""
    var firstName: String = ""
    var lastName: String = ""
    
    // MARK: - View Did Load
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.mapView.delegate = self
        
        //show the location annotation on the map
        showMapAnnotation()
        
    }
    
    // MARK: - Center Map On Location
    func centerMapOnLocation(_ coordinate: CLLocationCoordinate2D) {
        
        self.mapView.setCenter(coordinate, animated: true)
        let regionRadius: CLLocationDistance = 1000
        let region = MKCoordinateRegion(center: coordinate, latitudinalMeters: regionRadius * 2.0, longitudinalMeters: regionRadius * 2.0)
        self.mapView.setRegion(region, animated: true)
    }
    
    // MARK: - Show Map Annotation
    func showMapAnnotation(){
        
        //set the latitude and longitude
        let lat = CLLocationDegrees(self.latitude)
        let long = CLLocationDegrees(self.longitude)
        let coordinate = CLLocationCoordinate2D(latitude: lat, longitude: long)
        
        let annotation = MKPointAnnotation()
        annotation.coordinate = coordinate
        annotation.title = self.location
        
        self.mapView.addAnnotation(annotation)
        self.mapView.selectAnnotation(annotation, animated: true)
        
        //zooms the map into the location region
        centerMapOnLocation(coordinate)
        
    }
    
    // MARK: - MapView View For Annotation
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
         
        let reuseId = "pin"
        
        var pinView = mapView.dequeueReusableAnnotationView(withIdentifier: reuseId) as? MKPinAnnotationView

        if pinView == nil {
            pinView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: reuseId)
            pinView!.canShowCallout = true
            pinView!.pinTintColor = .red
            
        }
        else {
            pinView!.annotation = annotation
        }
        
        return pinView
    }
    
    // MARK: - Add Location
    @IBAction func addLocation(_ sender: Any){
        //getting public user data
        OnTheMapUser.getPublicUserData(completion: handleUserDataResponse(firstName:lastName:error:))
    }
     
    // MARK: - Handle User Data Response
    func handleUserDataResponse(firstName: String?, lastName: String?, error: Error?){
        if(error == nil){
            
            self.firstName = firstName!
            self.lastName = lastName!
            
            //posting Student location
            OnTheMapUser.postingStudentLocation(firstName: firstName!, lastName: lastName!, mapString: self.location, mediaURL: self.mediaURL, latitude: self.latitude, longitude: self.longitude, completion: handlePostingLocationResponse(success:error:))
            
        } else {
            //show error message when posting location is failed
            showFailureMessage(title: "Posting Failure", message: error?.localizedDescription ?? "")
        }
        
    }
    
    // MARK: - Handle Posting Location Response
    func handlePostingLocationResponse(success: Bool, error: Error?){
        
        if success {
            //dismiss the view
            self.navigationController?.dismiss(animated: true, completion: nil)
        } else {
            showFailureMessage(title: "Posting Failure", message: error?.localizedDescription ?? "")
        }
        
    }
}




