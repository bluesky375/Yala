//
//  APIMessages.swift
//  Yala
//
//  Created by Ankita on 07/08/18.
//  Copyright © 2018 Yala. All rights reserved.
//

import UIKit

/**
    This class contains different api error messages. It is created to cosolidate all api errors at one place
 */

class APIMessages {
    
    internal var standardError: String
    internal var timeoutError: String
    internal var unknownError: String
    internal var oauthError: String
    internal var authenticationError: String

    init() {
        self.standardError = "Unable to connect\n The app cannot connect to the server. Please wait a few minutes and try again."
        self.timeoutError = "App could not connect to the server. Please try again later."
        self.unknownError = "App could not connect to the server. Please try again later. \ncode: UN"
        self.oauthError = "The User ID / Password you entered does not match our records. Please try again."
        self.authenticationError = "Unable to Authenticate\n Please wait a few minutes and try again."
    }
}
