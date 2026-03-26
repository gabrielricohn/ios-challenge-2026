//
//  NetworkingTargetType.swift
//  ApplaudoChallenge
//
//  Created by Christian Rivera on 25/3/26.
//

import Foundation
import Moya

// MARK: - Networking Target Type
/// Networking Target main protocol. This protocol describes the necessary variables for the target to work.
///
/// - `Protocol Variables:
///   - `requestBaseURL`: Base URL of the API.
///   - `requestPath`: Custom path for the specific endpoint.
///   - `requestHeaders`: Headers for the request.
///   - `requestMethod`: HTTP method of the request.
///   - `requestSampleData`: Sample data that facilitates unit testing.
protocol NetworkingTargetType: TargetType {
    var requestBaseURL: URL { get }
    var requestPath: String { get }
    var requestHeaders: [String: String]? { get }
    var requestMethod: RequestMethod { get }
    var requestSampleData: Data { get }
    var cachePolicy: URLRequest.CachePolicy { get }
}

// MARK: - Networking Target Type Default Configuration
/// Default implementation of our custom Networking Target protocol.
/// Here we define some common values that all our requests will have.
///
/// - `Default Variables:
///   - `requestBaseURL`: Base URL of the API should be the same for all
///   or at least most of the endpoints, so we define it here.
///   - `requestHeaders`: Headers for the request should be common among all the requests,
///   so we can define all those common headers here..
///   - `requestSampleData`: Default Sample data for al request.
extension NetworkingTargetType {

    // MARK: - Request Base URL
    var requestBaseURL: URL {
        return URL(string: "www.apple.com")!
    }

    // MARK: - Request Headers
    var requestHeaders: [String: String]? {
        ["Content-Type": "application/json"]
    }

    // MARK: - Request Sample Data
    var requestSampleData: Data {
        Data()
    }
}

// MARK: - Networking Library Configuration
/// Moya Library Implementation.
/// In this block of code we add all the implementation needed for the Moya library to work.
///
/// Moya needs several variables to be defined, and each of them has a specific functionality:
///
/// - `Moya Variables:
///   - `baseURL`: Base URL of the API.
///   - `path`: Custom path for the specific endpoint.
///   - `headers`: Headers for the request.
///   - `method`: HTTP method of the request.
///   - `sampleData`: Sample data that facilitates unit testing.
///   - `validationType`: HTTP status codes that will be taken as success
///   (default is `.successCodes`, this includes all the 2XX HTTP status codes)
extension NetworkingTargetType {
    // MARK: - Moya Base URL
    var baseURL: URL {
        requestBaseURL
    }

    // MARK: - Moya Path
    var path: String {
        requestPath
    }

    // MARK: - Moya Headers
    var headers: [String: String]? {
        requestHeaders
    }

    // MARK: - Moya Method
    var method: Moya.Method {
        switch requestMethod {
        case .get: return .get
        case .patch: return .patch
        case .post: return .post
        case .put: return .put
        case .delete: return .delete
        }
    }

    // MARK: - Moya Sample Data
    var sampleData: Data {
        requestSampleData
    }

    var validationType: ValidationType {
        .successCodes
    }

    var cachePolicy: URLRequest.CachePolicy {
        .reloadIgnoringLocalCacheData
    }
}

// MARK: - Parameters Functions
/// Helper function that allows the transformation of
/// `Encodable Objects` into `[Sring: Any]` dictionaries so they can be easely injected in to the endpoint task.
extension NetworkingTargetType {
    func parametersAsDictionary<T: Encodable>(_ parameters: T,
                                              with encoder: JSONEncoder = JSONEncoder()) -> [String: Any] {
        encoder.encodeAsDictionary(parameters) ?? [:]
    }
}
