//
//  CatInformationService.swift
//  NetworkLayer
//
//  Created by Gabriel Rico on 25/6/26.
//

import Foundation
import Combine
import Moya

// MARK: - Cat Information Service Type
public protocol CatInformationServiceType {
    func getCatBreeds() -> AnyPublisher<CatBreeds, NetworkError>
}

// MARK: - Cat Information Service
public struct CatInformationService: CatInformationServiceType {
    // MARK: - Properties
    private let requester: NetworkingRequesterType

    // MARK: - Initializer
    public init() {
        self.requester = NetworkingRequester(provider: .networkingProvider())
    }

    init(requester: NetworkingRequesterType) {
        self.requester = requester
    }

    // MARK: - Functionality
    public func getCatBreeds() -> AnyPublisher<CatBreeds, NetworkError> {
        requester.execute(request: CatInformationTarget.getCatBreeds)
    }
}
