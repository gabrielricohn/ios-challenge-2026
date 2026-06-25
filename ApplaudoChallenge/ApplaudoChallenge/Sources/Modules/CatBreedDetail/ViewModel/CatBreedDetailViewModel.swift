//
//  CatBreedDetailViewModel.swift
//  ApplaudoChallenge
//
//  Created by Gabriel Rico on 25/6/26.
//

import Combine
import Foundation
import NetworkLayer

@MainActor
final class CatBreedDetailViewModel: ObservableObject {

    let breed: CatBreed
    private let service: CatInformationServiceType

    init(
        breed: CatBreed,
        service: CatInformationServiceType = CatInformationService()
    ) {
        self.breed = breed
        self.service = service
    }

    var imageURL: URL? {
        service.breedImageURL(for: breed.referenceImageID)
    }

    var formattedLifeSpan: String {
        "\(breed.lifeSpan) years"
    }
}
