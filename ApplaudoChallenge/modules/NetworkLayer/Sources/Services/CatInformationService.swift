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
    func getCatBreeds(page: Int, limit: Int) -> AnyPublisher<CatBreeds, NetworkError>
    func breedImageURL(for referenceImageID: String?) -> URL?
}

public extension CatInformationServiceType {
    func getCatBreeds() -> AnyPublisher<CatBreeds, NetworkError> {
        getCatBreeds(page: 0, limit: 100)
    }
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
    public func getCatBreeds(page: Int, limit: Int) -> AnyPublisher<CatBreeds, NetworkError> {
        requester.execute(request: CatInformationTarget.getCatBreeds(page: page, limit: limit))
    }

    public func breedImageURL(for referenceImageID: String?) -> URL? {
        guard let referenceImageID, !referenceImageID.isEmpty else { return nil }

        return CatInformationTarget
            .getCatBreedImage(referenceImageId: referenceImageID)
            .requestURL
    }
}
