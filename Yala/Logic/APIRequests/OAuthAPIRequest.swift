//
//  OAuthAPIRequest.swift
//  Yala
//
//  Created by Ankita on 08/08/18.
//  Copyright © 2018 Yala. All rights reserved.
//

import Foundation
import Alamofire

enum OAuthRequestType {
    case refreshAccessToken(AuthType)
    case loginUser(String, String)
    case socialLogin(User)
    case logoutUser()
}

class OAuthAPIRequest: APIBaseRequest {
    
    private var requestType: OAuthRequestType
    
    init(requestType: OAuthRequestType) {
        self.requestType = requestType
    }
    
    override var cacheResponse: Bool {
        return false
    }
    
    override var method: HTTPMethod {
        switch requestType {
        default:
            return .post
        }
    }
    
    override var path: String {
        switch requestType {
        case .logoutUser:
            return "logout"
        default:
            return "userSignin"
        }
    }
    
    override var encoding: Alamofire.ParameterEncoding? {
        switch requestType {
        default:
            return URLEncoding(destination: .methodDependent)
        }
    }
    
    override var authType: AuthType {
        switch requestType {
        case .logoutUser:
            return AuthType.user
        default:
            return AuthType.noAuth
        }
    }
    
    override var parameters: APIParams {
        let appdelegate = UIApplication.shared.delegate as! AppDelegate
        switch requestType {
        case .loginUser(let email, let password):
            return ["emailid": email as AnyObject, "password": password as AnyObject, "loginstatus": "s" as AnyObject,
                    "deviceid": appdelegate.pushToken as AnyObject,
                    "deviceno": UUID().uuidString as AnyObject,
            ]
        case .socialLogin(let user):
            let params = ["firstname": user.firstName as AnyObject,
                    "lastname": user.lastName as AnyObject,
                    "emailid": user.email as AnyObject,
                    "mobileno": user.mobile as AnyObject,
                    "deviceid": appdelegate.pushToken as AnyObject,
                    "deviceno": UUID().uuidString as AnyObject,
                    "address": user.address as AnyObject,
                    "gender": user.gender as AnyObject,
                    "profileimage": user.profileimage as AnyObject,
                    "facebookid": user.facebookid as AnyObject,
                    "devicetype": "1" as AnyObject,
            ]
            
            return params
        case .refreshAccessToken(let authType):
            switch authType {
            case .user:
                return ["grant_type": "refresh_token" as AnyObject, "refresh_token": UserAccountManager.shared.getRefreshToken() as AnyObject]
            case .client:
                return ["grant_type": "client_credentials" as AnyObject]
            default:
                return nil
            }
        case .logoutUser:
            return nil
        }
    }
    
    override var responseType: ResponseType {
        return .object()
    }
}
