//
//  ErrorModel.swift
//  Yala
//
//  Created by Ankita on 06/08/18.
//  Copyright © 2018 Yala. All rights reserved.
//

import Foundation

open class ErrorModel: Decodable {
    
    var errorType: String?
    var errorMessage: String?
    
    convenience init(errorMessage:String) {
        self.init()
        self.errorMessage = errorMessage
    }
    
    func getErrorMessage() -> String {
        if let msg:String = self.errorMessage {
            return msg
        }
        
        return ""
    }
}

open class OAuthErrorModel: Decodable {
    
    var error: String?
    var errorDescription: String?
    
    convenience init(errorDescription:String) {
        self.init()
        self.errorDescription = errorDescription
    }
    
    enum CodingKeys: String, CodingKey {
        case error = "error"
        case errorDescription = "error_description"
    }
    
    func getErrorMessage() -> String {
        if let msg:String = self.error {
            switch msg {
            case "unauthorized", "invalid_grant":
                return "UnAuthorized"
            case "invalid_token":
                return "Invalid Access Token"
            default:
                debugPrint()
            }
        }
        
        return "Authentication Error"
    }
}
