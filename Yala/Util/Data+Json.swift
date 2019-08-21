//
//  Data+Json.swift
//  Yala
//
//  Created by Ankita on 06/08/18.
//  Copyright © 2018 Yala. All rights reserved.
//

import Foundation

/**
    This extension provdies helper method to covert JSON Data into any object
 */

extension Data {
    
    func toJSON() -> AnyObject? {
        do {
            return try JSONSerialization.jsonObject(with: self, options: .mutableContainers) as AnyObject
        } catch let error {
            debugPrint(error)
        }
        return nil
    }
}
