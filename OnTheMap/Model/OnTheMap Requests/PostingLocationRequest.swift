//
//  PostingLocationRequest.swift
//  OnTheMap
//
//  Created by Tabassum Tamanna on 1/28/21.
//

import Foundation

// MARK: - Posting Location Request
struct PostingLocationRequest: Codable {
    
    let uniqueKey: String
    let firstName: String
    let lastName: String
    let mapString: String
    let mediaURL: String
    let latitude: Float
    let longitude: Float
}
