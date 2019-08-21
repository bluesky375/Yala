//
//  APIUtil.swift
//  Yala
//
//  Created by Ankita on 08/08/18.
//  Copyright © 2018 Yala. All rights reserved.
//

import Foundation

/**
    This class provides current app version using build settings keys
 */

class APIUtil {
    
    private static var appVersion: String?
    
    static func version() -> String {
        if let appVersion = APIUtil.appVersion {
            return appVersion
        } else {
            let dictionary = Bundle.main.infoDictionary!
            let version = dictionary["CFBundleShortVersionString"] as? String
            let build = dictionary["CFBundleVersion"] as? String
            
            if version != nil && build != nil {
                APIUtil.appVersion = "v\((version)!) b\((build)!)"
            } else {
                APIUtil.appVersion = ""
            }
            
            return APIUtil.appVersion!
        }
    }
    
}
