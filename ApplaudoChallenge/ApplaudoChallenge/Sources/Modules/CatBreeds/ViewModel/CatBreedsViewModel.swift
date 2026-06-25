//
//  CatBreedsViewModel.swift
//  NetworkLayer
//
//  Created by Gabriel Rico on 25/6/26.
//

import Combine
import Foundation
import NetworkLayer

@MainActor
final class CatBreedsViewModel: ObservableObject {

    // MARK: - Published State
    @Published var breeds: [CatBreed] = []
    @Published var isLoading = false
    @Published var errorMessage: String?

    var isEmpty: Bool {
        !isLoading && errorMessage == nil && breeds.isEmpty
    }

    // MARK: - Dependencies
    private let service: CatInformationServiceType
    private var cancellables = Set<AnyCancellable>()

    // MARK: - Initializer
    init(service: CatInformationServiceType = CatInformationService()) {
        self.service = service
    }

    // MARK: - Actions
    func fetchCatBreeds() {
        isLoading = true
        errorMessage = nil

        service.getCatBreeds()
            .receive(on: DispatchQueue.main)
            .sink { [weak self] completion in
                guard let self else { return }

                self.isLoading = false

                if case .failure(let error) = completion {
                    self.errorMessage = error.localizedDescription
                }
            } receiveValue: { [weak self] breeds in
                self?.breeds = breeds
            }
            .store(in: &cancellables)
    }
}
