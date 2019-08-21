//
//  OAuthAPIRequest.swift
//  Yala
//
//  Created by Ankita on 08/08/18.
//  Copyright © 2018 Yala. All rights reserved.
//

import Foundation
import Alamofire

enum RegisterEndpoint {
    case emailRegistration(User)
}

class RegisterAPIRequest: APIBaseRequest {
    
    private var requestType: RegisterEndpoint
    
    init(requestType: RegisterEndpoint) {
        self.requestType = requestType
    }
    
    override var cacheResponse: Bool {
        return false
    }
    
    override var method: HTTPMethod {
        return .post
    }
    
    override var path: String {
        return "userSignup"
    }
    
    override var encoding: Alamofire.ParameterEncoding? {
        return URLEncoding(destination: .methodDependent)
    }
    
    override var authType: AuthType {
        return AuthType.noAuth
    }
    
    override var parameters: APIParams {
        switch requestType {
        case .emailRegistration(let user):
            let appdelegate = UIApplication.shared.delegate as! AppDelegate
            let params  = ["first_name" : user.firstName as AnyObject,
                    "last_name" : user.lastName as AnyObject,
                    "username" : user.email as AnyObject,
                    "emailid": user.email as AnyObject,
                    "password": user.password as AnyObject,
                    "mobileno": user.mobile as AnyObject,
                    "deviceid": appdelegate.pushToken as AnyObject,
                    "deviceno": UUID().uuidString as AnyObject,
                    "devicetype" : "1" as AnyObject]
            
            return params
        }
    }
    
    override var responseType: ResponseType {
        return .object()
    }
}
