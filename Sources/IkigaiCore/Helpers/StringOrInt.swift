//
//  StringOrInt.swift
//  IkigaiAPI
//
//  Created by Vince Davis on 2/26/25.
//


/// A wrapper that can decode either an Int or a String and converts it to a String.
public struct StringOrInt: Codable {
    public let value: String

    public init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        // Try to decode as Int first.
        if let intValue = try? container.decode(Int.self) {
            value = String(intValue)
        } else if let stringValue = try? container.decode(String.self) {
            value = stringValue
        } else {
            throw DecodingError.typeMismatch(
                String.self,
                DecodingError.Context(codingPath: decoder.codingPath,
                                      debugDescription: "Expected String or Int for dataId")
            )
        }
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        // If the value can be converted back to an Int, encode as Int.
        if let intValue = Int(value) {
            try container.encode(intValue)
        } else {
            try container.encode(value)
        }
    }
}