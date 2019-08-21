//
//  OAuthCredentials.swift
//  Yala
//
//  Created by Ankita on 03/08/18.
//  Copyright © 2018 Yala. All rights reserved.
//

import Foundation

class ForgotPassword: Codable {
    
    var status: String?
    var error: String?
    var message: String?
    var otpCode: Int?
    var emailid: String?
    
    init() {
    }
}
