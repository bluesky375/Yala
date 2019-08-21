//
//  OAuthCredentials.swift
//  Yala
//
//  Created by Ankita on 03/08/18.
//  Copyright © 2018 Yala. All rights reserved.
//

import Foundation

class OAuthCredentials: Codable {
    
    var refresToken: String?
    var accessToken: String?
    
    init() {
    }
    
    enum CodingKeys: String, CodingKey {
        case accessToken = "access_token"
        case refresToken = "refresToken"
    }
}
