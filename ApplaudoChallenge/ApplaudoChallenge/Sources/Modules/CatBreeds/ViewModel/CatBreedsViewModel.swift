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
    @Published var isLoadingMore = false
    @Published var errorMessage: String?

    var isEmpty: Bool {
        !isLoading && errorMessage == nil && breeds.isEmpty
    }

    // MARK: - Pagination
    private let pageSize = 10
    private var currentPage = 0
    private var hasMorePages = true

    // MARK: - Dependencies
    private let service: CatInformationServiceType
    private var cancellables = Set<AnyCancellable>()

    // MARK: - Initializer
    init(service: CatInformationServiceType = CatInformationService()) {
        self.service = service
    }

    // MARK: - Actions
    func fetchCatBreeds() {
        resetPagination()
        loadPage(isInitialLoad: true)
    }

    func loadMoreIfNeeded(for breed: CatBreed) {
        guard breed.id == breeds.last?.id else { return }
        guard hasMorePages, !isLoading, !isLoadingMore else { return }

        loadPage(isInitialLoad: false)
    }

    // MARK: - Private
    private func resetPagination() {
        currentPage = 0
        hasMorePages = true
        breeds = []
        errorMessage = nil
        isLoadingMore = false
    }

    private func loadPage(isInitialLoad: Bool) {
        if isInitialLoad {
            isLoading = true
        } else {
            isLoadingMore = true
        }

        let page = currentPage

        service.getCatBreeds(page: page, limit: pageSize)
            .receive(on: DispatchQueue.main)
            .sink { [weak self] completion in
                guard let self else { return }

                self.isLoading = false
                self.isLoadingMore = false

                if case .failure(let error) = completion, isInitialLoad {
                    self.errorMessage = error.localizedDescription
                }
            } receiveValue: { [weak self] newBreeds in
                guard let self else { return }

                self.breeds.append(contentsOf: newBreeds)
                self.hasMorePages = newBreeds.count >= self.pageSize
                self.currentPage = page + 1
            }
            .store(in: &cancellables)
    }
}
