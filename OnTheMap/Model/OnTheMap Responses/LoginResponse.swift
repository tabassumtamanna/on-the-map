//
//  LoginResponse.swift
//  OnTheMap
//
//  Created by Tabassum Tamanna on 1/25/21.
//

import Foundation

struct LoginResponse: Codable {
    let account: Account
    let session: Session
}

struct Account: Codable {
    let registered: Bool
    let key: String
}

struct Session: Codable {
    let id: String
    let expiration: String
}
