//
//  LocalizableStringProvider.swift
//  Yala
//
//  Created by Ankita on 07/08/18.
//  Copyright © 2018 Yala. All rights reserved.
//

import Foundation

/**
    This enum contains all localised keys being used in localisation file. This is to keep track of localisable keys at one place and provide ease of search and value updation.
 */

enum LocalizableKeys: String {
    
    // MARK: Buttons
    case appNameTitle = "Yala"
    
    var localizedString: String {
        switch self {
        default:
            return NSLocalizedString(self.rawValue, comment: "")
        }
    }
}
