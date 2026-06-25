//
//  RegisteredCatStorageTests.swift
//  ApplaudoChallengeTests
//
//  Created by Gabriel Rico on 25/6/26.
//

import Foundation
import Testing
@testable import ApplaudoChallenge

struct RegisteredCatStorageTests {

    private func makeStorage() -> UserDefaultsRegisteredCatStorage {
        let suiteName = "RegisteredCatStorageTests.\(UUID().uuidString)"
        let userDefaults = UserDefaults(suiteName: suiteName)!
        return UserDefaultsRegisteredCatStorage(userDefaults: userDefaults)
    }

    @Test func fetchAllReturnsEmptyArrayWhenNothingIsSaved() {
        let storage = makeStorage()

        #expect(storage.fetchAll().isEmpty)
    }

    @Test func savePersistsCatEntry() throws {
        let storage = makeStorage()
        let cat = AddCatTestFixtures.sampleCat

        try storage.save(cat)

        let savedCats = storage.fetchAll()
        #expect(savedCats.count == 1)
        #expect(savedCats.first == cat)
    }

    @Test func saveAppendsMultipleEntries() throws {
        let storage = makeStorage()

        try storage.save(AddCatTestFixtures.sampleCat)
        try storage.save(AddCatTestFixtures.secondCat)

        let savedCats = storage.fetchAll()
        #expect(savedCats.count == 2)
        #expect(savedCats == [AddCatTestFixtures.sampleCat, AddCatTestFixtures.secondCat])
    }

    @Test func savedEntriesSurviveNewStorageInstance() throws {
        let suiteName = "RegisteredCatStorageTests.persistence.\(UUID().uuidString)"
        let userDefaults = UserDefaults(suiteName: suiteName)!
        let cat = AddCatTestFixtures.sampleCat

        let writingStorage = UserDefaultsRegisteredCatStorage(userDefaults: userDefaults)
        try writingStorage.save(cat)

        let readingStorage = UserDefaultsRegisteredCatStorage(userDefaults: userDefaults)
        #expect(readingStorage.fetchAll() == [cat])
    }
}
