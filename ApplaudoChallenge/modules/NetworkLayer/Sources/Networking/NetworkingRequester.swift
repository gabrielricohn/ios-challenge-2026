//
//  NetworkingRequester.swift
//  ApplaudoChallenge
//
//  Created by Christian Rivera on 25/3/26.
//

import Foundation
import Moya
import Combine

// MARK: - Network Error
/// Lightweight domain error type that wraps common networking failures.
/// Candidates can extend this enum with additional cases as needed.
enum NetworkError: Error, LocalizedError {
    /// The server returned an unexpected status code.
    case serverError(statusCode: Int, data: Data)
    /// The response data could not be decoded into the expected type.
    case decodingFailed(underlying: Error)
    /// A generic/unknown failure.
    case unknown(underlying: Error)

    var errorDescription: String? {
        switch self {
        case .serverError(let code, _):
            return "Server returned status code \(code)."
        case .decodingFailed(let error):
            return "Decoding failed: \(error.localizedDescription)"
        case .unknown(let error):
            return error.localizedDescription
        }
    }
}

// MARK: - Networking Requester Type
/// NetworkingRequesterType protocol,
/// is the main build block for the Networking Requester,
/// all classes or structures that will be defined as Networking Requesters need to implement this main protocol.
///
/// - `Protocol Functions`:
///   -`execute`: Main and only function of the protocol,
///   here needs to be implemented all the logic of the networking framework to make the connection to the API.
protocol NetworkingRequesterType {
    /// - `Function Properties`:
    ///  - `request`: Custom `NetworkingTargetType` object
    ///  that will have all the information of the endpoints that will be executed.
    /// - `Returns`: Either a `NetworkError` or the raw response `Data`.
    func execute(request: NetworkingTargetType) -> AnyPublisher<Data, NetworkError>
}

// MARK: - Networking Requester
/// Implementation of the `NetworkingRequesterType` protocol.
///
/// -  `Dependencies Needed`:
///   - `provider`: Custom `MoyaProvider` that has all the configurations for the current session.
struct NetworkingRequester: NetworkingRequesterType {
    // MARK: - Properties
    private let provider: MoyaProvider<MultiTarget>

    // MARK: - Initializer
    init(
        provider: MoyaProvider<MultiTarget>
    ) {
        self.provider = provider
    }

    func execute(request: NetworkingTargetType) -> AnyPublisher<Data, NetworkError> {
        var task: Moya.Cancellable?
        let provider = provider

        return Deferred { Future { seal in
            task = provider.request(MultiTarget(request)) { result in
                switch result {
                case .success(let response):
                    let statusCode = response.statusCode
                    
                    guard (200...299).contains(statusCode) else {
                        seal(.failure(.serverError(statusCode: statusCode, data: response.data)))
                        return
                    }

                    seal(.success(response.data))
                case .failure(let error):
                    seal(.failure(.unknown(underlying: error)))
                }
            }
        }}
        .handleEvents(receiveCancel: { task?.cancel() })
        .eraseToAnyPublisher()
    }
}

// MARK: - Default Implementation
/// Default Implementation of `NetworkingRequesterType` protocol.
/// This default implementation just calls the `execute` implementation
/// inside our `NetworkingRequester` and then decodes the data into the Generic Decodable object.
extension NetworkingRequesterType {
    /// - `Function Properties`:
    ///  - `request`: Custom `NetworkingTargetType` object that will have all the information
    ///  of the endpoints that will be executed.
    ///  - `decoder`: JSONDecoder that will be used to decode the data.
    /// - `Returns`: Either a `NetworkError` or a decoded `T` object.
    func execute<T: Decodable>(
        request: NetworkingTargetType,
        using decoder: JSONDecoder = .init()
    ) -> AnyPublisher<T, NetworkError> {
        execute(request: request)
            .decode(type: T.self, decoder: decoder)
            .mapError { error in
                if let networkError = error as? NetworkError {
                    return networkError
                }

                return .decodingFailed(underlying: error)
            }
            .eraseToAnyPublisher()
    }
}

