//
//  OAuthAPIRequest.swift
//  Yala
//
//  Created by Ankita on 08/08/18.
//  Copyright © 2018 Yala. All rights reserved.
//

import Foundation
import Alamofire

enum UpdateUserStatusEndPoint {
    case updateStatus(String)
}

class UpdateUserStatusAPIRequest: APIBaseRequest {
    
    private var requestType: UpdateUserStatusEndPoint
    
    init(requestType: UpdateUserStatusEndPoint) {
        self.requestType = requestType
    }
    
    override var cacheResponse: Bool {
        return false
    }
    
    override var method: HTTPMethod {
        return .post
    }
    
    override var path: String {
        return "userstatusMessage"
    }
    
    override var encoding: Alamofire.ParameterEncoding? {
        return URLEncoding(destination: .methodDependent)
    }
    
    override var authType: AuthType {
        return AuthType.noAuth
    }
    
    override var parameters: APIParams {
        switch requestType {
        case .updateStatus(let status):
            return ["access_token": UserAccountManager.shared.getAuthorisationToken() as AnyObject,
                   "status_id" : status as AnyObject]
        }
    }
    
    override var responseType: ResponseType {
        return .object()
    }
}
