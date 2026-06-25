//
//  RegisteredCat.swift
//  ApplaudoChallenge
//
//  Created by Gabriel Rico on 25/6/26.
//

import Foundation

struct RegisteredCat: Codable, Identifiable, Equatable, Hashable {
    let id: UUID
    let name: String
    let breed: String
    let age: Int
    let description: String
    let createdAt: Date

    init(
        id: UUID = UUID(),
        name: String,
        breed: String,
        age: Int,
        description: String,
        createdAt: Date = Date()
    ) {
        self.id = id
        self.name = name
        self.breed = breed
        self.age = age
        self.description = description
        self.createdAt = createdAt
    }
}
