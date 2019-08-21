//
//  AddLikeAndGetFeedbacks.swift
//  Yala
//
//  Created by Admin on 3/30/19.
//  Copyright © 2019 Yala. All rights reserved.
//

import Foundation
import Alamofire
import ObjectMapper

enum AddLikeAPIEndpoint {
    case addLike(String)
}

class AddLikeAPIRequests: APIBaseRequest {
    
    private var requestType: AddLikeAPIEndpoint
    
    init(requestType: AddLikeAPIEndpoint) {
        self.requestType = requestType
    }
    
    override var cacheResponse: Bool {
        return false
    }
    
    override var method: HTTPMethod {
        return .post
    }
    
    override var path: String {
        return "addLikeToEvent"
    }
    
    override var encoding: Alamofire.ParameterEncoding? {
        return URLEncoding(destination: .methodDependent)
    }
    
    override var authType: AuthType {
        return AuthType.noAuth
    }
    
  
    override var parameters: APIParams {
        switch requestType {
        case .addLike(let eventId):
           
             return ["token_key" : UserAccountManager.shared.getAuthorisationToken() as AnyObject, "eventId": eventId as AnyObject]
        }
    }
    
    override var responseType: ResponseType {
        return .object()
    }
}

