//
//  AppVersion.swift
//  Yala
//
//  Created by Ankita on 01/08/18.
//  Copyright © 2018 Yala. All rights reserved.
//

import Foundation

/**
    This class provdies helper method to get unique device ID. It creates device id using UUID + timeinterval and stores it in keychain and user defaults both.
    The reason behind storing this in userdefaults is to get the same generated key on different app sessions.
    The reason behing storing this in keychain is to get the same key even after application is reinstalled.
 */

class DeviceUtil {
    
    private static var deviceId: String?
    
    static func getDeviceId() -> String {
        if DeviceUtil.deviceId != nil {
            return DeviceUtil.deviceId!
        }
        
        if let deviceId = UserDefaultsWrapper.shared.retrieveValue(forKey: deviceIDKey) as? String {
            DeviceUtil.deviceId = deviceId
        } else {
            DeviceUtil.deviceId = DeviceUtil.getRegisteredDeviceId()
            UserDefaultsWrapper.shared.save(value: DeviceUtil.deviceId, forKey: deviceIDKey)
        }
        
        return DeviceUtil.deviceId!
    }
    
    static private func getRegisteredDeviceId() -> String {
        let keychain = KeychainWrapper.shared
        
        if let deviceId = keychain.retrieveValue(forKey: deviceIDKey) {
            return deviceId
        }
        let deviceId = DeviceUtil.generateDeviceId()
        keychain.save(value: deviceId, forKey: deviceIDKey)
        return deviceId
    }
    
    static private func generateDeviceId() -> String {
        return UUID().uuidString + String(Date().timeIntervalSince1970.rounded())
    }
}
