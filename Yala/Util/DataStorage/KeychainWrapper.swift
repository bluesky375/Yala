//
//  KeychainWrapper.swift
//  Yala
//
//  Created by Ankita on 07/08/18.
//  Copyright © 2018 Yala. All rights reserved.
//

import Foundation
import KeychainSwift

/**
    This class is responsible to store and retrive some value for key from Keychain. Should be used for all secured items in the application like tokens and passwords
 */

class KeychainWrapper {
    
    static var shared = KeychainWrapper()
    let keychain = KeychainSwift()
    
    func save(value: String, forKey key: String) {
        keychain.set(value, forKey: key, withAccess: .accessibleAfterFirstUnlock)
    }
    
    func retrieveValue(forKey key: String) -> String? {
       return keychain.get(key)
    }
    
    func removeKey(_ key: String) {
        keychain.delete(key)
    }
}
