//
//  CatInformationTarget.swift
//  ApplaudoChallenge
//
//  Created by Christian Rivera on 25/3/26.
//

import Foundation
import Moya

// MARK: - Cat Information Target
/// Sample target — use this as a reference when building new service targets.
///
/// Each case represents a distinct API operation. To add a new endpoint,
/// declare a new case here and handle it in every computed property below.
enum CatInformationTarget {
    /// Fetches a random cat image from the API.
    case getCatImage
    case getCatBreeds
    case getCatBreedImage(referenceImageId: String)
}

// MARK: - NetworkingTargetType Conformance
extension CatInformationTarget: NetworkingTargetType {
    var requestBaseURL: URL {
        switch self {
        case .getCatBreedImage:
            return NetworkConfiguration.imageBaseURL
        default:
            return NetworkConfiguration.apiBaseURL
        }
    }

    /// The path component appended to the base URL for each endpoint.
    var requestPath: String {
        switch self {
        case .getCatImage:
            return "images/search" // Full URL: https://api.thecatapi.com/v1/images/search
        case .getCatBreeds:
            return "breeds"
        case .getCatBreedImage(let referenceImageId):
            return "\(referenceImageId).jpg"
        }
    }

    /// The HTTP method used for each endpoint.
    var requestMethod: RequestMethod {
        switch self {
        case .getCatImage, .getCatBreeds, .getCatBreedImage:
            return .get
        }
    }

    /// The Moya task that describes the request body or query parameters for each endpoint.
    var task: Moya.Task {
        switch self {
        case .getCatImage, .getCatBreeds, .getCatBreedImage:
            return .requestPlain
        }
    }
}
