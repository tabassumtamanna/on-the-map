//
//  StudentMapViewController.swift
//  OnTheMap
//
//  Created by Tabassum Tamanna on 1/26/21.
//

import UIKit
import MapKit

// MARK: - Student Map View Controller
class StudentMapViewController: UIViewController, MKMapViewDelegate {
    
    // MARK: - Outlet
    @IBOutlet weak var mapView: MKMapView!
    
    // MARK: - View Will Appear
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        //get the student locations
        getStudentLocations()
    }
    
    // MARK: - View Did Load
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    // MARK: - Refresh Map
    @IBAction func refreshMap(_ sender: Any) {
        //get the locations and reload the map
        getStudentLocations()
    }
    
    // MARK: - Get Student Locations
    func getStudentLocations(){
        //get the student locations
        OnTheMapUser.getStudentLocations(completion: handleStudentInfoResponse(studentInfo:error:))
    }
    
    // MARK: - Handle Student Info Response
    func handleStudentInfoResponse(studentInfo: [StudentInfo], error: Error?){
        
        if error == nil {
            //
            StudentInfoModel.studentInfo = studentInfo
            showMapAnnotations(studentInfo)
        } else {
            showFailureMessage(title: "Get Student Locations Failed", message: error?.localizedDescription ?? "")
        }
    }
    
    // MARK: - Show Map Annotations
    func showMapAnnotations(_ studentInfo: [StudentInfo]){
        
        var annotations = [MKPointAnnotation]()
        
        for dictionary in studentInfo {
            
            let lat = CLLocationDegrees(dictionary.latitude)
            let long = CLLocationDegrees(dictionary.longitude)
            
            let coordinate = CLLocationCoordinate2D(latitude: lat, longitude: long)
            
            let first = dictionary.firstName
            let last = dictionary.lastName
            let mediaURL = dictionary.mediaURL
            
            let annotation = MKPointAnnotation()
            annotation.coordinate = coordinate
            annotation.title = "\(first) \(last)"
            annotation.subtitle = mediaURL
            
            annotations.append(annotation)
        }
        
        self.mapView.addAnnotations(annotations)
    }
    
    // MARK: - MapView View For Annotation
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
         
        let reuseId = "pin"
        
        var pinView = mapView.dequeueReusableAnnotationView(withIdentifier: reuseId) as? MKPinAnnotationView

        if pinView == nil {
            pinView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: reuseId)
            pinView!.canShowCallout = true
            pinView!.pinTintColor = .red
            pinView!.rightCalloutAccessoryView = UIButton(type: .detailDisclosure)
        }
        else {
            pinView!.annotation = annotation
        }
        
        return pinView
    }
    
    // MARK: - MapView AnnotationView
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        
        if control == view.rightCalloutAccessoryView {
            
            if let toOpen = view.annotation?.subtitle!, validateUrl(urlString: toOpen) {
                
                UIApplication.shared.open(URL(string: toOpen)!, options: [:], completionHandler: nil)
            } else {
                showFailureMessage(title: "Invalid Link", message: "Can not open the link")
            }
            
        }
    }
    
    
}


