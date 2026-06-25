//
//  AddCatTestMocks.swift
//  ApplaudoChallengeTests
//
//  Created by Gabriel Rico on 25/6/26.
//

import Combine
import Foundation
import NetworkLayer
@testable import ApplaudoChallenge

enum AddCatTestFixtures {

    static let sampleCat = RegisteredCat(
        id: UUID(uuidString: "00000000-0000-0000-0000-000000000001")!,
        name: "Luna",
        breed: "Persian",
        age: 3,
        description: "A calm and affectionate cat.",
        createdAt: Date(timeIntervalSince1970: 1_700_000_000)
    )

    static let secondCat = RegisteredCat(
        id: UUID(uuidString: "00000000-0000-0000-0000-000000000002")!,
        name: "Milo",
        breed: "Siamese",
        age: 2,
        description: "Very vocal and playful.",
        createdAt: Date(timeIntervalSince1970: 1_700_000_100)
    )

    static var persianBreed: CatBreed {
        decodeBreed(named: "Persian", id: "pers")
    }

    static var siameseBreed: CatBreed {
        decodeBreed(named: "Siamese", id: "siam")
    }

    static var abyssinianBreed: CatBreed {
        decodeBreed(named: "Abyssinian", id: "abys")
    }

    private static func decodeBreed(named name: String, id: String) -> CatBreed {
        let json = """
        {
          "weight": { "imperial": "7 - 10", "metric": "3 - 5" },
          "id": "\(id)",
          "name": "\(name)",
          "temperament": "Active",
          "origin": "Ethiopia",
          "country_codes": "ET",
          "country_code": "ET",
          "description": "An active breed.",
          "life_span": "9 - 15",
          "indoor": 0,
          "adaptability": 5,
          "affection_level": 5,
          "child_friendly": 4,
          "dog_friendly": 4,
          "energy_level": 5,
          "grooming": 1,
          "health_issues": 2,
          "intelligence": 5,
          "shedding_level": 2,
          "social_needs": 5,
          "stranger_friendly": 5,
          "vocalisation": 2,
          "experimental": 0,
          "hairless": 0,
          "natural": 1,
          "rare": 0,
          "rex": 0,
          "suppressed_tail": 0,
          "short_legs": 0,
          "hypoallergenic": 0
        }
        """

        let data = Data(json.utf8)
        return try! JSONDecoder().decode(CatBreed.self, from: data)
    }
}

final class MockRegisteredCatStorage: RegisteredCatStorageType {

    var savedCats: [RegisteredCat] = []
    var saveError: Error?

    func save(_ cat: RegisteredCat) throws {
        if let saveError {
            throw saveError
        }

        savedCats.append(cat)
    }

    func fetchAll() -> [RegisteredCat] {
        savedCats
    }
}

final class MockCatInformationService: CatInformationServiceType {

    var breedsResult: Result<CatBreeds, NetworkError> = .success([])

    func getCatBreeds() -> AnyPublisher<CatBreeds, NetworkError> {
        switch breedsResult {
        case .success(let breeds):
            return Just(breeds)
                .setFailureType(to: NetworkError.self)
                .eraseToAnyPublisher()
        case .failure(let error):
            return Fail(error: error)
                .eraseToAnyPublisher()
        }
    }

    func breedImageURL(for referenceImageID: String?) -> URL? {
        nil
    }
}
