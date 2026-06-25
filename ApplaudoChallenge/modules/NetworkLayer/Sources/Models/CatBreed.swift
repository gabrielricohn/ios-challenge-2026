//
//  CatBreed.swift
//  ApplaudoChallenge
//
//  Created by Gabriel Rico on 25/6/26.
//


import Foundation

// MARK: - CatBreed
public struct CatBreed: Codable, Identifiable, Hashable {
    public let weight: Weight
    public let id, name: String
    public let breedGroup: String?
    public let cfaURL: String?
    public let vetstreetURL: String?
    public let vcahospitalsURL: String?
    public let temperament, origin, countryCodes, countryCode: String
    public let description, lifeSpan: String
    public let indoor: Int
    public let lap: Int?
    public let altNames: String?
    public let adaptability, affectionLevel, childFriendly, dogFriendly: Int
    public let energyLevel, grooming, healthIssues, intelligence: Int
    public let sheddingLevel, socialNeeds, strangerFriendly, vocalisation: Int
    public let experimental, hairless, natural, rare: Int
    public let rex, suppressedTail, shortLegs: Int
    public let wikipediaURL: String?
    public let hypoallergenic: Int
    public let referenceImageID: String?
    public let catFriendly, bidability: Int?

    public static func == (lhs: CatBreed, rhs: CatBreed) -> Bool {
        lhs.id == rhs.id
    }

    public func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }

    enum CodingKeys: String, CodingKey {
        case weight, id, name
        case breedGroup = "breed_group"
        case cfaURL = "cfa_url"
        case vetstreetURL = "vetstreet_url"
        case vcahospitalsURL = "vcahospitals_url"
        case temperament, origin
        case countryCodes = "country_codes"
        case countryCode = "country_code"
        case description
        case lifeSpan = "life_span"
        case indoor, lap
        case altNames = "alt_names"
        case adaptability
        case affectionLevel = "affection_level"
        case childFriendly = "child_friendly"
        case dogFriendly = "dog_friendly"
        case energyLevel = "energy_level"
        case grooming
        case healthIssues = "health_issues"
        case intelligence
        case sheddingLevel = "shedding_level"
        case socialNeeds = "social_needs"
        case strangerFriendly = "stranger_friendly"
        case vocalisation, experimental, hairless, natural, rare, rex
        case suppressedTail = "suppressed_tail"
        case shortLegs = "short_legs"
        case wikipediaURL = "wikipedia_url"
        case hypoallergenic
        case referenceImageID = "reference_image_id"
        case catFriendly = "cat_friendly"
        case bidability
    }
}

// MARK: - Weight
public struct Weight: Codable {
    public let imperial, metric: String
}

public typealias CatBreeds = [CatBreed]

// MARK: - Encode/decode helpers

class JSONNull: Codable, Hashable {

    public static func == (lhs: JSONNull, rhs: JSONNull) -> Bool {
            return true
    }

    public var hashValue: Int {
            return 0
    }

    public init() {}

    public required init(from decoder: Decoder) throws {
            let container = try decoder.singleValueContainer()
            if !container.decodeNil() {
                    throw DecodingError.typeMismatch(JSONNull.self, DecodingError.Context(codingPath: decoder.codingPath, debugDescription: "Wrong type for JSONNull"))
            }
    }

    public func encode(to encoder: Encoder) throws {
            var container = encoder.singleValueContainer()
            try container.encodeNil()
    }
}