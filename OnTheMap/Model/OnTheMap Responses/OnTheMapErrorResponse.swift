//
//  OnTheMapErrorResponse.swift
//  OnTheMap
//
//  Created by Tabassum Tamanna on 1/30/21.
//

import Foundation

struct OnTheMapErrorResponse: Codable, Error {
    let status: Int
    let error: String
    
}

extension OnTheMapErrorResponse: LocalizedError {
    var errorDescription: String? {
        return error
    }
}
