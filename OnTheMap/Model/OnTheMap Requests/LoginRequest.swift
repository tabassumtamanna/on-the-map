//
//  LoginRequest.swift
//  OnTheMap
//
//  Created by Tabassum Tamanna on 1/25/21.
//

import Foundation

// MARK: - Login Request
struct LoginRequest: Codable {
    let udacity: Udacity
    
    init(username: String, password: String) {
        self.udacity = Udacity(username: username, password: password)
    }
}

// MARK: - Udacity user & password
struct Udacity: Codable {
    let username: String
    let password: String
    
    init(username: String, password: String) {
       self.username = username
       self.password = password
    }
}
