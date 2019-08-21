//
//  OAuthAPIRequest.swift
//  Yala
//
//  Created by Ankita on 08/08/18.
//  Copyright © 2018 Yala. All rights reserved.
//

import Foundation
import Alamofire
import ObjectMapper

enum AcceptInviteAPIEndpoints {
    case acceptInvite(YalaNotification)
    case declineInvite(YalaNotification)
}

class AcceptInviteAPIRequests: APIBaseRequest {
    
    private var requestType: AcceptInviteAPIEndpoints
    
    init(requestType: AcceptInviteAPIEndpoints) {
        self.requestType = requestType
    }
    
    override var cacheResponse: Bool {
        return false
    }
    
    override var method: HTTPMethod {
        return .post
    }
    
    override var path: String {
        return "accepteuserEvent"
    }
    
    override var encoding: Alamofire.ParameterEncoding? {
        return URLEncoding(destination: .methodDependent)
    }
    
    override var authType: AuthType {
        return AuthType.noAuth
    }
    
    override var parameters: APIParams {
        switch requestType {
        case .acceptInvite(let notification):
            let params = ["token_key" : UserAccountManager.shared.getAuthorisationToken() as AnyObject,
                          "event_id": Int(notification.event!) as AnyObject,
                          "invite_status" : 1 as AnyObject]
            return params
        case .declineInvite(let notification):
            let params = ["token_key" : UserAccountManager.shared.getAuthorisationToken() as AnyObject,
                          "event_id": Int(notification.event!) as AnyObject,
                          "invite_status" : 2 as AnyObject]
            return params
        }
    }
    
    override var responseType: ResponseType {
        return .object()
    }
}
