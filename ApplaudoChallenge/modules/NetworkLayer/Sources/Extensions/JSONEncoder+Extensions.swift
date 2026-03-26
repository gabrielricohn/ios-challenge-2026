//
//  JSONEncoder+Extensions.swift
//  ApplaudoChallenge
//
//  Created by Christian Rivera on 25/3/26.
//

import Foundation

// MARK: - JSONEncoder Extension
public extension JSONEncoder {
    // MARK: - Encode as Dictionary
    /// Helper function that helps transform an `Encodable` object into a `[String: Any]` dictionary.
    ///
    /// - `Properties:
    ///   - `encode`: Generic object that we want to transform into a dictionary and that needs to conform to Encodable.
    ///
    /// - Returns: A `[String: Any]`optional  dictionary.
    func encodeAsDictionary<T: Encodable>(_ encode: T) -> [String: Any]? {
        guard let data = try? self.encode(encode) else {
            return nil
        }

        guard let dictionary = try? JSONSerialization.jsonObject(with: data, options: .allowFragments) as? [String: Any] else {
            return nil
        }

        return dictionary
    }
}
