//
//  OAuthAPIRequest.swift
//  Yala
//
//  Created by Ankita on 08/08/18.
//  Copyright © 2018 Yala. All rights reserved.
//

import Foundation
import Alamofire

enum ForgotPasswordAPIEndPoint {
    case forgotPassword(String)
    case updatePassword(String, String, String)
}

class ForgotPasswordAPIRequest: APIBaseRequest {
    
    private var requestType: ForgotPasswordAPIEndPoint
    
    init(requestType: ForgotPasswordAPIEndPoint) {
        self.requestType = requestType
    }
    
    override var cacheResponse: Bool {
        return false
    }
    
    override var method: HTTPMethod {
        return .post
    }
    
    override var path: String {
        switch requestType {
        case .forgotPassword(_):
            return "forgotPassword"
        case .updatePassword(_, _, _):
            return "updatePassword"
        }
    }
    
    override var encoding: Alamofire.ParameterEncoding? {
        return URLEncoding(destination: .methodDependent)
    }
    
    override var authType: AuthType {
        return AuthType.noAuth
    }
    
    override var parameters: APIParams {
        switch requestType {
        case .forgotPassword(let email) :
            return ["email_id" : email as AnyObject]
        case .updatePassword(let email, let otp, let password):
            return ["email_id": email as AnyObject,
                    "otp_code" : otp as AnyObject,
                    "new_password": password as AnyObject]
        }
    }
    
    override var responseType: ResponseType {
        return .object()
    }
}
