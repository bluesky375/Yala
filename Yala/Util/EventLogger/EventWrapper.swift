//
//  EventWrapper.swift
//  Yala
//
//  Created by Ankita on 07/08/18.
//  Copyright © 2018 Yala. All rights reserved.
//

import Foundation
import Firebase

/**
    This class provides facility to log events on firebase analytics. It can be modifed for any other analytics for event logging
 */

class EventWrapper {
    
    static let shared = EventWrapper()
    
    func fireEvent(_ eventName: String) {
        fireEvent(eventName, nil)
    }
    
    func fireEvent(_ eventName: String, _ params: [String: Int]?) {
        Analytics.logEvent(eventName, parameters: params)
    }
}
