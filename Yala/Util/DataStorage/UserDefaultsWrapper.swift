//
//  UserDefaultsWrapper.swift
//  Yala
//
//  Created by Ankita on 07/08/18.
//  Copyright © 2018 Yala. All rights reserved.
//

import Foundation

/**
    This class is responsible to store and retrive some value for key in UserDefaults
 */

let deviceIDKey = "YalaRegisteredDeviceID"

class UserDefaultsWrapper {
    
    static let shared = UserDefaultsWrapper()
    private let userData = UserDefaults.standard
    
    func save(value: Any?, forKey key: String) {
        userData.set(value, forKey: key)
        userData.synchronize()
    }
    
    func retrieveValue(forKey key: String) -> Any? {
        return userData.object(forKey: key)
    }
    
    func removeObject(forKey key: String) {
        userData.removeObject(forKey: key)
    }
}
