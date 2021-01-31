//
//  LoginViewController.swift
//  OnTheMap
//
//  Created by Tabassum Tamanna on 1/24/21.
//

import UIKit

// MARK: - Login View Controller
class LoginViewController: UIViewController, UITextFieldDelegate{

    // MARK: -  Outlet
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var SignupViaWebsiteButton: UIButton!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    // MARK: - View Did Load
    override func viewDidLoad() {
        super.viewDidLoad()
        
        emailTextField.delegate = self
        passwordTextField.delegate = self
        
    }
    
    // MARK: - View Will Appear
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.emailTextField.text = ""
        self.passwordTextField.text = ""
        subscribeToKeyboardNotifications()
    }
    
    // MARK: - View Will Disappear
    override func viewWillDisappear(_ animated: Bool) {

        super.viewWillDisappear(animated)
        unsubscribeFromKeyboardNotifications()
    }
    
    // MARK: - Login Tapped
    @IBAction func loginTapped(_ sender: UIButton) {
        
        //set activity indicator and disable the inputs
        setLoggingIn(true)
        
        //authenticate login the user with email and password and handle the login response
        OnTheMapUser.login(username: emailTextField.text ?? "", password: passwordTextField.text ?? "", completion: handleLoginResponse(success:error:))
    }
    
    // MARK: - Signup Via Websie Tapped
    @IBAction func SignupViaWebsiteTapped() {
        
        //set activity indicator and disable the inputs
        setLoggingIn(true)
        
        //open the signup page in web view.
        UIApplication.shared.open(OnTheMapUser.Endpoints.signup.url, options: [:], completionHandler: handleWebsiteResponse(success:))
    }
    
    // MARK: - Handle Website Response
    func handleWebsiteResponse(success: Bool){
        //reset activity indicator and enable the inputs
       setLoggingIn(false)
    }
    
    // MARK: - Handle Login Response
    func handleLoginResponse(success: Bool, error: Error?){
        //reset activity indicator and enable the inputs
        setLoggingIn(false)
        if success{
            //after login done segue to the Map and Table Tabbed View.
            performSegue(withIdentifier: "completeLogin", sender: nil)
            
        } else {
            //when login faild show the error message
            showFailureMessage(title: "Login Failed", message: error?.localizedDescription ?? "")
        }
    }
    
    // MARK: - Set Loggin In
    func setLoggingIn(_ loggingIn: Bool) {
        
        if loggingIn {
            activityIndicator.startAnimating()
        } else {
            activityIndicator.stopAnimating()
        }
        emailTextField.isEnabled    = !loggingIn
        passwordTextField.isEnabled = !loggingIn
        loginButton.isEnabled       = !loggingIn
        SignupViaWebsiteButton.isEnabled = !loggingIn
    }
    
    // MARK: - Keyboard Will Show
    @objc func keyboardWillShow(_ notification: Notification){
        if(view.frame.origin.y == 0 ){
            view.frame.origin.y = -getKeyboardHight(notification)
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

