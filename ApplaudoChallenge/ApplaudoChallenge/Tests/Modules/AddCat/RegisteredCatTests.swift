//
//  RegisteredCatTests.swift
//  ApplaudoChallengeTests
//
//  Created by Gabriel Rico on 25/6/26.
//

import Foundation
import Testing
@testable import ApplaudoChallenge

struct RegisteredCatTests {

    @Test func encodesAndDecodesSuccessfully() throws {
        let cat = AddCatTestFixtures.sampleCat
        let data = try JSONEncoder().encode(cat)
        let decoded = try JSONDecoder().decode(RegisteredCat.self, from: data)

        #expect(decoded == cat)
    }

    @Test func equalityUsesAllStoredProperties() {
        let cat = AddCatTestFixtures.sampleCat
        let matchingCat = RegisteredCat(
            id: cat.id,
            name: cat.name,
            breed: cat.breed,
            age: cat.age,
            description: cat.description,
            createdAt: cat.createdAt
        )
        let differentCat = RegisteredCat(
            name: cat.name,
            breed: cat.breed,
            age: cat.age,
            description: cat.description
        )

        #expect(cat == matchingCat)
        #expect(cat != differentCat)
    }
}
