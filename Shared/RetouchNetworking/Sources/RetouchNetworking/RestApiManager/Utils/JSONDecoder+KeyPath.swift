//
//  JSONDecoder+KeyPath.swift
//  RestApiManager
//
//  Created by Panevnyk Vlad on 3/2/18.
//  Copyright © 2018 Panevnyk Vlad. All rights reserved.
//

import Foundation

public extension JSONDecoder {
    /// Decode value at the keypath of the given type from the given JSON representation
    ///
    /// - Parameters:
    ///   - type: The type of the value to decode.
    ///   - data: The data to decode from.
    ///   - keyPath: The JSON keypath
    ///   - keyPathSeparator: Nested keypath separator
    /// - Returns: A value of the requested type.
    /// - Throws: An error if any value throws an error during decoding.
    func decode<T>(_ type: T.Type,
                   from data: Data,
                   keyPath: String?,
                   keyPathSeparator separator: String = ".") throws -> T where T : Decodable {
        if let keyPath = keyPath, !keyPath.isEmpty {
            userInfo[keyPathUserInfoKey] = keyPath.components(separatedBy: separator)
            return try decode(KeyPathWrapper<T>.self, from: data).object
        } else {
            return try decode(T.self, from: data)
        }
    }
}

/// The keypath key in the `userInfo`
private let keyPathUserInfoKey = CodingUserInfoKey(rawValue: "keyPathUserInfoKey")!

/// Object which is representing value
private final class KeyPathWrapper<T: Decodable>: Decodable {
    enum KeyPathError: Error {
        case `internal`
    }
    
    /// Naive coding key implementation
    struct Key: CodingKey {
        init?(intValue: Int) {
            self.intValue = intValue
            stringValue = String(intValue)
        }
        
        init?(stringValue: String) {
            self.stringValue = stringValue
            intValue = nil
        }
        
        let intValue: Int?
        let stringValue: String
    }
    
    typealias KeyedContainer = KeyedDecodingContainer<KeyPathWrapper<T>.Key>
    
    init(from decoder: Decoder) throws {
        guard let keyPath = decoder.userInfo[keyPathUserInfoKey] as? [String],
            !keyPath.isEmpty
            else { throw KeyPathError.internal }
        
        // Creates a `Key` from the first keypath element
        func getKey(from keyPath: [String]) throws -> Key {
            guard let first = keyPath.first,
                let key = Key(stringValue: first)
                else { throw KeyPathError.internal }
            return key
        }
        
        // Finds nested container and returns it and the key for object
        func objectContainer(for keyPath: [String],
                             in currentContainer: KeyedContainer,
                             key currentKey: Key) throws -> (KeyedContainer, Key) {
            guard !keyPath.isEmpty else { return (currentContainer, currentKey) }
            let container = try currentContainer.nestedContainer(keyedBy: Key.self, forKey: currentKey)
            let key = try getKey(from: keyPath)
            return try objectContainer(for: Array(keyPath.dropFirst()), in: container, key: key)
        }
        
        let rootKey = try getKey(from: keyPath)
        let rooTContainer = try decoder.container(keyedBy: Key.self)
        let (keyedContainer, key) = try objectContainer(for: Array(keyPath.dropFirst()), in: rooTContainer, key: rootKey)
        object = try keyedContainer.decode(T.self, forKey: key)
    }
    
    let object: T
}
