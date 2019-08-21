//
//  AddCommentAPIRequest.swift
//  Yala
//
//  Created by Admin on 3/30/19.
//  Copyright © 2019 Yala. All rights reserved.
//

import Foundation
import Alamofire
import ObjectMapper

enum AddCommentAPIEndpoint {
    case addComment(String, String)
}

class AddCommentAPIRequests: APIBaseRequest {
    
    private var requestType: AddCommentAPIEndpoint
    
    init(requestType: AddCommentAPIEndpoint) {
        self.requestType = requestType
    }
    
    override var cacheResponse: Bool {
        return false
    }
    
    override var method: HTTPMethod {
        return .post
    }
    
    override var path: String {
        return "addCommentToEvent"
    }
    
    override var encoding: Alamofire.ParameterEncoding? {
        return URLEncoding(destination: .methodDependent)
    }
    
    override var authType: AuthType {
        return AuthType.noAuth
    }
    
    
    override var parameters: APIParams {
        switch requestType {
        case .addComment(let eventId , let comment):
            return ["token_key" : UserAccountManager.shared.getAuthorisationToken() as AnyObject, "eventId": eventId as AnyObject, "comment": comment as AnyObject]
        }
    }
    
    override var responseType: ResponseType {
        return .object()
    }
}


