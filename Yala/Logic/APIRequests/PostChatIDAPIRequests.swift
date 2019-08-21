//
//  OAuthAPIRequest.swift
//  Yala
//
//  Created by Ankita on 08/08/18.
//  Copyright © 2018 Yala. All rights reserved.
//

import Foundation
import Alamofire

enum PostChatIDEndpoint {
    case sentId(Int)
}

class PostChatIDAPIRequest: APIBaseRequest {
    
    private var requestType: PostChatIDEndpoint
    
    init(requestType: PostChatIDEndpoint) {
        self.requestType = requestType
    }
    
    override var cacheResponse: Bool {
        return false
    }
    
    override var method: HTTPMethod {
        return .post
    }
    
    override var path: String {
        return "addBlog_id"
    }
    
    override var encoding: Alamofire.ParameterEncoding? {
        return URLEncoding(destination: .methodDependent)
    }
    
    override var authType: AuthType {
        return AuthType.noAuth
    }
    
    override var parameters: APIParams {
        switch requestType {
        case .sentId(let id):
            return ["blog_id": id as AnyObject,
                    "token": UserAccountManager.shared.getAuthorisationToken() as AnyObject]
        }
    }
    
    override var responseType: ResponseType {
        return .object()
    }
}
