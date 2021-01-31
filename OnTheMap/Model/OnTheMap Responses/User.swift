//
//  User.swift
//  OnTheMap
//
//  Created by Tabassum Tamanna on 1/28/21.
//

import Foundation

// MARK: - User
struct User: Codable {
    
    let firstName: String
    let lastName: String
    
    enum CodingKeys: String, CodingKey {
        case firstName = "first_name"
        case lastName = "last_name"
    }
}

