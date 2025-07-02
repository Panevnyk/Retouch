//
//  KeychainService.swift
//  RetouchDesignSystem
//
//  Created by Vladyslav Panevnyk on 12.11.2020.
//

import UIKit
import Security

public actor KeychainService {
    static var userAccount: NSString { "AuthenticatedUser" }
    static var kSecClassGenericPasswordValue: NSString { NSString(format: kSecClassGenericPassword) }
    static var kSecClassValue: NSString { NSString(format: kSecClass) }
    static var kSecAttrSynchronizableValue: NSString { NSString(format: kSecAttrSynchronizable) }
    static var kSecAttrAccountValue: NSString { NSString(format: kSecAttrAccount) }
    static var kSecValueDataValue: NSString { NSString(format: kSecValueData) }
    static var kSecAttrServiceValue: NSString { NSString(format: kSecAttrService) }
    static var kSecMatchLimitValue: NSString { NSString(format: kSecMatchLimit) }
    static var kSecReturnDataValue: NSString { NSString(format: kSecReturnData) }
    static var kSecMatchLimitOneValue: NSString { NSString(format: kSecMatchLimitOne) }
    
    /// Remove value from Keychain by key is synchronizable
    /// - Parameters:
    ///   - key: key for value
    ///   - synchronizable: is value shared cross iTunes connected devices
    public static func remove(key: String, synchronizable: Bool = false) {
        guard let data = "".data(using: .utf8) else {
            return
        }

        let dataFromString = NSData(data: data)
        // Instantiate a new default keychain query
        let keychainQuery: NSMutableDictionary = NSMutableDictionary(objects: [kSecClassGenericPasswordValue,
                                                                               key,
                                                                               userAccount,
                                                                               (synchronizable ? kCFBooleanTrue : kCFBooleanFalse) as Any,
                                                                               dataFromString],
                                                                     forKeys: [kSecClassValue,
                                                                               kSecAttrServiceValue,
                                                                               kSecAttrAccountValue,
                                                                               kSecAttrSynchronizableValue,
                                                                               kSecValueDataValue])

        // Delete any existing items
        SecItemDelete(keychainQuery as CFDictionary)
    }
    
    /// Save value to Keychain by key is synchronizable
    /// - Parameters:
    ///   - key: key for value
    ///   - value: String
    ///   - synchronizable: is value shared cross iTunes connected devices
    public static func save(key: String, value: String, synchronizable: Bool = false) {
        guard let data = value.data(using: .utf8) else {
            return
        }
        let dataFromString = NSData(data: data)

        // Instantiate a new default keychain query
        let keychainQuery: NSMutableDictionary = NSMutableDictionary(objects: [kSecClassGenericPasswordValue,
                                                                               key,
                                                                               userAccount,
                                                                               (synchronizable ? kCFBooleanTrue : kCFBooleanFalse) as Any,
                                                                               dataFromString],
                                                                     forKeys: [kSecClassValue,
                                                                               kSecAttrServiceValue,
                                                                               kSecAttrAccountValue,
                                                                               kSecAttrSynchronizableValue,
                                                                               kSecValueDataValue])

        // Delete any existing items
        SecItemDelete(keychainQuery as CFDictionary)

        // Add the new keychain item
        SecItemAdd(keychainQuery as CFDictionary, nil)
    }
    
    /// Load value from Keychain by key is synchronizable
    /// - Parameters:
    ///   - key: key for object
    ///   - synchronizable: is value shared cross iTunes connected devices
    /// - Returns: value with type String?
    public static func load(key: String, synchronizable: Bool = false) -> String? {
        let key = NSString(string: key)
        // Instantiate a new default keychain query
        // Tell the query to return a result
        // Limit our results to one item
        let keychainQuery: NSMutableDictionary = NSMutableDictionary(objects: [kSecClassGenericPasswordValue,
                                                                               key,
                                                                               userAccount,
                                                                               (synchronizable ? kCFBooleanTrue : kCFBooleanFalse) as Any,
                                                                               kCFBooleanTrue as Any,
                                                                               kSecMatchLimitOneValue],
                                                                     forKeys: [kSecClassValue,
                                                                               kSecAttrServiceValue,
                                                                               kSecAttrAccountValue,
                                                                               kSecAttrSynchronizableValue,
                                                                               kSecReturnDataValue,
                                                                               kSecMatchLimitValue])

        var dataTypeRef: AnyObject?

        // Search for the keychain items
        let status: OSStatus = SecItemCopyMatching(keychainQuery, &dataTypeRef)
        var contentsOfKeychain: String? = nil

        if status == errSecSuccess {
            if let retrievedData = dataTypeRef as? Data {
                contentsOfKeychain = NSString(data: retrievedData, encoding: String.Encoding.utf8.rawValue) as String?
            }
        } else {
            print("Nothing was retrieved from the keychain. Status code \(status)")
        }

        return contentsOfKeychain
    }
}
