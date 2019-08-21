//
//  App.swift
//  Yala
//
//  Created by Ankita on 07/08/18.
//  Copyright © 2018 Yala. All rights reserved.
//

import Foundation

/**
    This enum provides current running application services for theme and config. Services are provided based on bundle identifier of running application. 
 */

enum App: String {
    
    case myProjectRelease = "com.yalam.yalaiOS"
    case myProjectDebug = "com.yalam.yalaiOS.debug"
    case myProjectStaging = "com.yalam.yalaiOS.staging"
    
    static var currentApp: App {
        return App(rawValue: Bundle.main.bundleIdentifier!)!
    }
    
    var themeService: ThemeService.Type {
        switch self {
        case .myProjectDebug: fallthrough
        case .myProjectRelease: fallthrough
        case .myProjectStaging:
            return YalaThemeService.self
        default: preconditionFailure("App could not determine any bundle identifier.")
        }
    }
    
    var configService: ConfigService.Type {
        switch self {
        case .myProjectDebug: fallthrough
        case .myProjectRelease: fallthrough
        case .myProjectStaging:
            return YalaConfigService.self
        default: preconditionFailure("App could not determine any bundle identifier.")
        }
    }
}
