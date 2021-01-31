//
//  StudentInfo.swift
//  OnTheMap
//
//  Created by Tabassum Tamanna on 1/25/21.
//

import Foundation

// MARK: - Student Info
struct StudentInfo: Codable {
    
    let createdAt: String
    let firstName: String
    let lastName: String
    let latitude: Float
    let longitude: Float
    let mapString: String
    let mediaURL: String
    let objectId: String
    let uniqueKey: String
    let updatedAt: String
}
