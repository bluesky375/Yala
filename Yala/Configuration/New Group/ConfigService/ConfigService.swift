//
//  ConfigService.swift
//  Yala
//
//  Created by Ankita on 07/08/18.
//  Copyright © 2018 Yala. All rights reserved.
//

import Foundation

/**
    This protocol defines static functions for aplication config being used at places. Application should implement this protocol to provide their values.
 */

protocol ConfigService {
    
    static func serverBaseURL() -> String
    static func oAuthToken() -> String
    static func acceptHeader() -> String
    static func apiVersion() -> String

    static func contactUsURL() -> String
    static func aboutUsURL() -> String
    static func faqsURL() -> String
    static func termsAndConditionsURL() -> String
}
