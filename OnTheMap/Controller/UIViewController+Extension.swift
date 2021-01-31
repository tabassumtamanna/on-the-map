//
//  UIViewController+Extension.swift
//  OnTheMap
//
//  Created by Tabassum Tamanna on 1/29/21.
//

import UIKit

extension  UIViewController {

    // MARK: - Logout Tapped
    @IBAction func logoutTapped(_ sender: UIBarButtonItem) {
        OnTheMapUser.logout{
            
            DispatchQueue.main.async {
               
                self.dismiss(animated: true, completion: nil)
            }
        }
        
    }
    
    // MARK: -  Show Failure Message
    func showFailureMessage(title: String, message: String) {
        let alertVC = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alertVC.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(alertVC, animated: true, completion: nil)
    }

    // MARK: - Validate URL
    func validateUrl(urlString: String?) -> Bool {
        let urlRegEx = "(http|https)://((\\w)*|([0-9]*)|([-|_])*)+([\\.|/]((\\w)*|([0-9]*)|([-|_])*))+"
        return NSPredicate(format: "SELF MATCHES %@", urlRegEx).evaluate(with: urlString)
    }
}
