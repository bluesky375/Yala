//
//  CrashlyticsHelper.swift
//  TheHelm
//
//  Created by Ankita Porwal on 19/03/18.
//  Copyright © 2018 the warranty group. All rights reserved.
//

import Foundation
import Crashlytics

class CrashlyticsHelper {
    
    static func logUserDetailInCrashlytics(_ email: String, _ fullname: String, _ userId: String) {
        Crashlytics.sharedInstance().setUserEmail(email)
        Crashlytics.sharedInstance().setUserName(fullname)
        Crashlytics.sharedInstance().setUserIdentifier(userId)
    }
    
    static func log(message: String) {
        CLSNSLogv("Message: %@", getVaList([message]))
    }
    
    static func log(error: Error) {
        CLSNSLogv("Error description: %@", getVaList([error.localizedDescription]))
    }
    
    static func log(dictionary: Dictionary<AnyHashable, Any>) {
        CLSNSLogv("Data: %@", getVaList([dictionary.debugDescription]))
    }
}
