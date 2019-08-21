//
//  OAuthAPIRequest.swift
//  Yala
//
//  Created by Ankita on 08/08/18.
//  Copyright © 2018 Yala. All rights reserved.
//

import Foundation
import Alamofire

enum ProfileEndpoints {
    case updateProfile(User)
}

class UserProfileAPIRequests: APIBaseRequest {
    
    private var requestType: ProfileEndpoints
    
    init(requestType: ProfileEndpoints) {
        self.requestType = requestType
    }
    
    override var cacheResponse: Bool {
        return false
    }
    
    override var method: HTTPMethod {
        return .post
    }
    
    override var path: String {
        return "editProfile"
    }
    
    override var encoding: Alamofire.ParameterEncoding? {
        return URLEncoding(destination: .methodDependent)
    }
    
    override var authType: AuthType {
        return AuthType.noAuth
    }
    
    override var parameters: APIParams {
        switch requestType {
        case .updateProfile(let user):
            let params = ["token_key" : UserAccountManager.shared.getAuthorisationToken() as AnyObject,
                    "first_name": user.firstName as AnyObject,
                    "last_name": user.lastName as AnyObject,
                    "user_name": user.username as AnyObject,
                    "user_email": user.email as AnyObject,
                    "gender": user.gender as AnyObject,
                    "dob" : user.dob as AnyObject,
                    "user_decription" : user.aboutYou as AnyObject,
                    "job": user.job as AnyObject,
                     "college": user.college as AnyObject,
                     "country": user.country as AnyObject,
                     "address": user.address as AnyObject,
                     "mobileno": user.mobile as AnyObject,
                     "profile_image" :  user.imageAsset?.base64String() as AnyObject]
            print(user.imageAsset?.base64String())
            return params
        }
    }
    
    override var responseType: ResponseType {
        return .object()
    }
}
