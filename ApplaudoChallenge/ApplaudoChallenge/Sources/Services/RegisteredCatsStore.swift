//
//  RegisteredCatsStore.swift
//  ApplaudoChallenge
//
//  Created by Gabriel Rico on 25/6/26.
//

import Combine
import Foundation

@MainActor
final class RegisteredCatsStore: ObservableObject {

    @Published private(set) var cats: [RegisteredCat] = []

    private let storage: RegisteredCatStorageType

    init(storage: RegisteredCatStorageType = UserDefaultsRegisteredCatStorage()) {
        self.storage = storage
        refresh()
    }

    func refresh() {
        cats = storage.fetchAll()
    }
}
