//
//  RegisteredCatStorage.swift
//  ApplaudoChallenge
//
//  Created by Gabriel Rico on 25/6/26.
//

import Foundation

enum RegisteredCatStorageError: LocalizedError {
    case encodingFailed
    case decodingFailed

    var errorDescription: String? {
        switch self {
        case .encodingFailed:
            return "Unable to save the cat entry."
        case .decodingFailed:
            return "Unable to load saved cat entries."
        }
    }
}

protocol RegisteredCatStorageType {
    func save(_ cat: RegisteredCat) throws
    func fetchAll() -> [RegisteredCat]
}

struct UserDefaultsRegisteredCatStorage: RegisteredCatStorageType {

    private let storageKey = "registered_cats"
    private let userDefaults: UserDefaults
    private let encoder: JSONEncoder
    private let decoder: JSONDecoder

    init(
        userDefaults: UserDefaults = .standard,
        encoder: JSONEncoder = JSONEncoder(),
        decoder: JSONDecoder = JSONDecoder()
    ) {
        self.userDefaults = userDefaults
        self.encoder = encoder
        self.decoder = decoder
    }

    func save(_ cat: RegisteredCat) throws {
        var cats = fetchAll()
        cats.append(cat)

        guard let data = try? encoder.encode(cats) else {
            throw RegisteredCatStorageError.encodingFailed
        }

        userDefaults.set(data, forKey: storageKey)
    }

    func fetchAll() -> [RegisteredCat] {
        guard
            let data = userDefaults.data(forKey: storageKey),
            let cats = try? decoder.decode([RegisteredCat].self, from: data)
        else {
            return []
        }

        return cats
    }
}
