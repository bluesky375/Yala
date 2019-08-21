//
//  Validations.swift
//  Yala
//
//  Created by Bhavna on 11/12/18.
//  Copyright © 2018 Yala. All rights reserved.
//

import UIKit

class Validations {
    
    // TODO: Swift3 test
    static func isValidEmail(_ testStr:String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"

        
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailTest.evaluate(with: testStr)
    }
    
    static func isValidFullName(_ testStr: String) -> Bool {
        let nameRegEx = "^([A-Za-z])+ ([A-Za-z!?;:(),.'-]+ ?)+$"
        
        let nameTest = NSPredicate(format:"SELF MATCHES %@", nameRegEx)
        return nameTest.evaluate(with: testStr)
    }
    
    static func isValidPhoneNumber(_ testStr: String) -> Bool {
        let phoneRegEx = "^[1-9]{1}[0-9]{9}$"
        let phoneTest = NSPredicate(format:"SELF MATCHES %@", phoneRegEx)
        return phoneTest.evaluate(with: testStr)
    }
    
    static func isValidNumber(_ testStr: String) -> Bool {
        let phoneRegEx = "^[0-9]{2,}"
        let phoneTest = NSPredicate(format:"SELF MATCHES %@", phoneRegEx)
        return phoneTest.evaluate(with: testStr)
    }

}

