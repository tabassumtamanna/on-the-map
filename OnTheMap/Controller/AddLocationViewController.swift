//
//  AddLocationViewController.swift
//  OnTheMap
//
//  Created by Tabassum Tamanna on 1/26/21.
//

import UIKit
import CoreLocation

// MARK: -  Add Location View Controller
class AddLocationViewController: UIViewController, UITextFieldDelegate {

    // MARK: - Outlet
    @IBOutlet weak var locationTextField: UITextField!
    @IBOutlet weak var mediaLinkTextField: UITextField!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var findLocationButton: UIButton!
    
    var latitude: Float = 0.0
    var longitude: Float = 0.0
    
    // MARK: - View Did Load
    override func viewDidLoad() {
        super.viewDidLoad()
        
        locationTextField.delegate = self
        mediaLinkTextField.delegate = self
    }
    
    // MARK: - View Will Appear
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        subscribeToKeyboardNotifications()
    }
    
    // MARK: - View Will Disappear
    override func viewWillDisappear(_ animated: Bool) {

        super.viewWillDisappear(animated)
        unsubscribeFromKeyboardNotifications()
    }

    // MARK: - Find Location
    @IBAction func findLocation(_ sender: Any) {
        //activity indicator is displayed and disable the input fields
        self.setIndicator(true)
        
        //check the required fields is empty
        if(locationTextField.text!.isEmpty || mediaLinkTextField.text!.isEmpty){
            
            //show failure message
            showFailureMessage(title: "Information Missing", message: "Please fill the location and the link information.")
            
            //stop the activity indicator and enable the input fields
            self.setIndicator(false)
        } else {
            
            //Find the geocode of the given location
            let geocoder = CLGeocoder()
            geocoder.geocodeAddressString(locationTextField.text ?? ""){ (placemark, error) in
                
                //handle the response of geocodeAddressString
                self.handleLocationResponse(placemark: placemark, error: error)
                
            }
        }
    }
    
    
    // MARK: - Cancle Add Location
    @IBAction func cancleAddLocation(_ sender: Any) {
        //dismiss the Information Posting View
        self.dismiss(animated: true, completion: nil)
    }
    
    // MARK: -  Handle Location Response
    func handleLocationResponse(placemark: [CLPlacemark]?, error: Error?){
        
        //stop the activity indicator and enable the input fields
        setIndicator(false)
        
        //set the latitude and longitude
        if let placemark = placemark, placemark.count > 0 {
            
            let location = (placemark.first?.location)! as CLLocation
            let cordinate = location.coordinate
            self.latitude = Float(cordinate.latitude)
            self.longitude = Float(cordinate.longitude)
            
            //show the geocoded response on map view by location confirmation view controller
            self.locationConfirmation()
            
        } else {
            showFailureMessage(title: "Location Not Found", message: "This is not a valid location")
           
        }
    }
    
    // MARK: - Location Confirmation
    func locationConfirmation(){
        
        //create the instance of location confirmation view controller
        let locationConfirmationingVC = self.storyboard!.instantiateViewController(withIdentifier: "LocationConfirmationViewController") as! LocationConfirmationViewController
        
        //set the variables of the view controller
        locationConfirmationingVC.latitude = self.latitude
        locationConfirmationingVC.longitude = self.longitude
        locationConfirmationingVC.location = self.locationTextField.text!
        locationConfirmationingVC.mediaURL = self.mediaLinkTextField.text!
        locationConfirmationingVC.title  = "Add Location"
        
        //push the view controller
        self.navigationController?.pushViewController(locationConfirmationingVC, animated: true)
    }
    
    // MARK: - Set Indicator
    func setIndicator(_ isFindLocation: Bool) {
        
        //reset the fields
        if isFindLocation {
            self.activityIndicator.startAnimating()
        } else {
            self.activityIndicator.stopAnimating()
        }
        self.locationTextField.isEnabled = !isFindLocation
        self.mediaLinkTextField.isEnabled = !isFindLocation
        self.findLocationButton.isEnabled  = !isFindLocation
    }
    
    // MARK: - Text Field Should Return
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        view.endEditing(true)
        return true
    }
    
    // MARK: - Keyboard Will Show
    @objc func keyboardWillShow(_ notification: Notification){
        if(view.frame.origin.y == 0 ){
            view.frame.origin.y = -getKeyboardHight(notification) + 95
        }
    }
    
    // MARK: - Keyboard Will Hide
    @objc func keyboardWillHide(_ notification: Notification){
        view.frame.origin.y = 0
    }
    
    // MARK: - Get Keyboard Hight
    func  getKeyboardHight(_ notification: Notification) -> CGFloat{
        
        let userInfo = notification.userInfo
        let keyboredSize =  userInfo![UIResponder.keyboardFrameEndUserInfoKey] as! NSValue
        
        return keyboredSize.cgRectValue.height
    }
    
    // MARK: - Subscribe TO keyboard Notifications
    func subscribeToKeyboardNotifications() {

        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }

    // MARK: - Unsubscribe TO keyboard Notifications
    func unsubscribeFromKeyboardNotifications() {

        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
    }
        
}
