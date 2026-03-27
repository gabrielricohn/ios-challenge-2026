//
//  RequestMethod.swift
//  ApplaudoChallenge
//
//  Created by Christian Rivera on 25/3/26.
//

// MARK: - Request Methods
/// HTTP methods supported by the networking layer.
/// Add a new case here and handle it in the `method` computed property of `NetworkingTargetType` if the API requires it.
enum RequestMethod: String {
    case get
    case post
    case put
    case patch
    case delete
}
