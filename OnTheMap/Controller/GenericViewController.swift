//
//  GenericViewController.swift
//  OnTheMap
//
//  Created by Tabassum Tamanna on 1/29/21.
//

import UIKit

class GenericViewController: UIViewController{
    
    func showFailureMessage(title: String, message: String) {
        let alertVC = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alertVC.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(alertVC, animated: true, completion: nil)
    }
}
