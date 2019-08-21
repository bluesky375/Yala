//
//  NMIConfigService.swift
//  Yala
//
//  Created by Ankita on 07/08/18.
//  Copyright © 2018 Yala. All rights reserved.
//

import Foundation

let kOAuthToken = "Basic YXV0b21hdG9yX2FwcDphdXRvbWF0b3JfYXBwX2FjY2Vzcw=="
let kAcceptHeader = "application/vnd.myproject.api.v"

//#if DEBUG
//let kApiBaseURL = "http://dev.w3ondemand.com/yala/Wooapi/ssyymcddUFopjn"
//let kContactUsURL = "https://myproject.com/contactUs"
//let kAboutUsURL = "https://myproject.com/aboutUs"
//let kFAQsURL = "https://myproject.com/FAQs"
//let kTermsURL = "https://myproject.com/terms"
//
//#elseif STAGING
//let kApiBaseURL = "http://dev.w3ondemand.com/yala/Wooapi/ssyymcddUFopjn"
//let kContactUsURL = "https://myproject.com/contactUs"
//let kAboutUsURL = "https://myproject.com/aboutUs"
//let kFAQsURL = "https://myproject.com/FAQs"
//let kTermsURL = "https://myproject.com/terms"
//
//#elseif RELEASE
//let kApiBaseURL = "http://192.169.226.171/yala/index.php/Wooapi/ssyymcddUFopjn"
let kApiBaseURL = "http://maryschwartz.com/index.php/Wooapi/ssyymcddUFopjn"
let kContactUsURL = "https://myproject.com/contactUs"
let kAboutUsURL = "https://myproject.com/aboutUs"
let kFAQsURL = "https://myproject.com/FAQs"
let kTermsURL = "https://myproject.com/terms"
    
//#endif

/**
    This struct implements all functions of ConfigService and provide their respective values
 */

struct YalaConfigService: ConfigService {
    
    static func serverBaseURL() -> String {
        return kApiBaseURL
    }
    
    static func apiVersion() -> String {
        return "1.1"
    }
    
    static func oAuthToken() -> String {
        return kOAuthToken
    }
    
    static func acceptHeader() -> String {
        return kAcceptHeader
    }
    
    static func contactUsURL() -> String {
        return kContactUsURL
    }
    
    static func aboutUsURL() -> String {
        return kAboutUsURL
    }
    
    static func faqsURL() -> String {
        return kFAQsURL
    }
    
    static func termsAndConditionsURL() -> String {
        return kTermsURL
    }
}
