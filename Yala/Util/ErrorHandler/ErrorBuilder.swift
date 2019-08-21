//
//  ErrorBuilder.swift
//  Yala
//
//  Created by Ankita on 07/08/18.
//  Copyright © 2018 Yala. All rights reserved.
//

import Foundation

/**
    This struct contains error codes being used to create Error objects and error identification at places
 */

struct ErrorCodes {
    static let errorIsNeverLoggedIn = 667
    static let `default` = 666
}

/**
    This struct contains some common error messages
 */
struct ErrorMessages {
    static let apiError = "API Error"
    static let error = "Error"
    static let unknownError = "Unknown Error"
    static let defaultError = "Something went wrong, please try again later."
}

/**
    This struct contains some common error domains
 */
struct ErrorDomain {
    static let `default` = "com.Yala.error"
}

/**
    This class builds CustomError object with the help of mentioned properties
 */

class ErrorBuilder {
    
    var title: String?
    var message: String = ErrorMessages.error
    var domain: String = ErrorDomain.default
    var code: Int = ErrorCodes.default
    
    init() {
        
    }
    
    init(withTitle title: String?, message: String = ErrorMessages.defaultError) {
        self.title = title
        self.message = message
    }
    
    init(withTitle title: String?, message: String = ErrorMessages.defaultError, code: Int) {
        self.title = title
        self.message = message
        self.code = code
    }
    
    func build() -> CustomError {
        return CustomError.init(title: title, message: message, domain: domain, code: code)
    }
}
