//
//  AcceptInvite.swift
//  Yala
//
//  Created by Admin on 4/3/19.
//  Copyright © 2019 Yala. All rights reserved.
//

import Foundation
import Alamofire
import ObjectMapper

enum AcceptInviteAPIEndpoint {
    case acceptInvite(String)
}

class AcceptInviteAPIRequests: APIBaseRequest {
    
    private var requestType: AcceptInviteAPIRequests
    
    init(requestType: AcceptInviteAPIRequests) {
        self.requestType = requestType
    }
    
    override var cacheResponse: Bool {
        return false
    }
    
    override var method: HTTPMethod {
        return .post
    }
    
    override var path: String {
        return "acceptInvite"
    }
    
    override var encoding: Alamofire.ParameterEncoding? {
        return URLEncoding(destination: .methodDependent)
    }
    
    override var authType: AuthType {
        return AuthType.noAuth
    }
    
    
    override var parameters: APIParams {
        switch requestType {
        case .acceptInvite(let inviteId):
            return ["token_key" : UserAccountManager.shared.getAuthorisationToken() as AnyObject, "inviteId": inviteId as AnyObject]
        }
    }
    
    override var responseType: ResponseType {
        return .object()
    }
}


