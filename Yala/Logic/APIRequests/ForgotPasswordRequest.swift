//
//  OAuthAPIRequest.swift
//  Yala
//
//  Created by Ankita on 08/08/18.
//  Copyright © 2018 Yala. All rights reserved.
//

import Foundation
import Alamofire

enum ForgotPasswordEndpoint {
    case sentOtp(String)
    case changePassword(String, Int, String)
}

class ForgotPasswordRequest: APIBaseRequest {
    
    private var requestType: ForgotPasswordEndpoint
    
    init(requestType: ForgotPasswordEndpoint) {
        self.requestType = requestType
    }
    
    override var cacheResponse: Bool {
        return false
    }
    
    override var method: HTTPMethod {
        return .post
    }
    
    override var path: String {
        return "forgotPassword"
    }
    
    override var encoding: Alamofire.ParameterEncoding? {
        return URLEncoding(destination: .methodDependent)
    }
    
    override var authType: AuthType {
        return AuthType.noAuth
    }
    
    override var parameters: APIParams {
        switch requestType {
        case .sentOtp(let email):
            return ["email_id": email as AnyObject]
        case .changePassword(let email, let otp, let newPass):
            return ["email_id": email as AnyObject,
                    "otp_code" : otp as AnyObject,
                    "new_password" : newPass as AnyObject]
        }
    }
    
    override var responseType: ResponseType {
        return .object()
    }
}
