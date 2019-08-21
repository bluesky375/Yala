//
//  OAuthAPIRequest.swift
//  Yala
//
//  Created by Ankita on 08/08/18.
//  Copyright © 2018 Yala. All rights reserved.
//

import Foundation
import Alamofire

enum InviteAPIRequestEndpoint {
    case receivedInites(Int)
    case sentInvites(Int)
}

class InviteAPIRequest: APIBaseRequest {
    
    private var requestType: InviteAPIRequestEndpoint
    
    init(requestType: InviteAPIRequestEndpoint) {
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
        case .receivedInites(let page):
           return "getInvitedEventList"
        case .sentInvites(let page):
           return "get_event_list"
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
        case .receivedInites(let page):
            return ["token_key" : UserAccountManager.shared.getAuthorisationToken() as AnyObject,
                    "limit": "50" as AnyObject,
                    "offset": page as AnyObject
            ]
        case .sentInvites(let page):
            return ["token_key" : UserAccountManager.shared.getAuthorisationToken() as AnyObject,
                    "limit": "50" as AnyObject,
                    "offset": page as AnyObject
            ]
        }
    }
    
    override var responseType: ResponseType {
        return .object()
    }
}
