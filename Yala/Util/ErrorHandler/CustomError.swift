//
//  CustomError.swift
//  Yala
//
//  Created by Ankita on 10/08/18.
//  Copyright © 2018 Yala. All rights reserved.
//

import Foundation

class CustomError {
    
    var title: String?
    var message: String
    var code: Int
    var domain: String
    
    init(title: String?, message: String, domain: String = "com.myproject.error", code: Int) {
        self.title = title
        self.domain = domain
        self.message = message
        self.code = code
    }
}

extension CustomError: Error {
    
}
