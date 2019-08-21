//
//  OAuthAPIRequest.swift
//  Yala
//
//  Created by Ankita on 08/08/18.
//  Copyright © 2018 Yala. All rights reserved.
//

import Foundation
import Alamofire

enum GETFriendsAPIEndpoint {
    case fetchFriends(User)
}

class GetFriendsAPIRequests: APIBaseRequest {
    
    private var requestType: GETFriendsAPIEndpoint
    
    init(requestType: GETFriendsAPIEndpoint) {
        self.requestType = requestType
    }
    
    override var cacheResponse: Bool {
        return false
    }
    
    override var method: HTTPMethod {
        return .post
    }
    
    override var path: String {
        return "getSyncFriends"
    }
    
    override var encoding: Alamofire.ParameterEncoding? {
        return URLEncoding(destination: .methodDependent)
    }
    
    override var authType: AuthType {
        return AuthType.noAuth
    }
    
    override var parameters: APIParams {
        switch requestType {
        case .fetchFriends(let user):
            return ["token_key" : UserAccountManager.shared.getAuthorisationToken() as AnyObject,
                   // "limit": user.firstName as AnyObject,
                   // "offset": user.lastName as AnyObject
            ]
        }
    }
    
    override var responseType: ResponseType {
        return .object()
    }
}
