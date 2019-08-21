//
//  GetFeedbackApiRequest.swift
//  Yala
//
//  Created by Admin on 3/29/19.
//  Copyright © 2019 Yala. All rights reserved.
//

import Foundation
//
//  OAuthAPIRequest.swift
//  Yala
//
//  Created by Ankita on 08/08/18.
//  Copyright © 2018 Yala. All rights reserved.
//

import Foundation
import Alamofire

enum GETFeedbackAPIEndpoint {
    case fetchFeeds(User)
}

class GetFeedbackAPIRequests: APIBaseRequest {
    
    private var requestType: GETFeedbackAPIEndpoint
    
    init(requestType: GETFeedbackAPIEndpoint) {
        self.requestType = requestType
    }
    
    override var cacheResponse: Bool {
        return false
    }
    
    override var method: HTTPMethod {
        return .post
    }
    
    override var path: String {
        return "getFeedbacks"
    
    }
    
    override var encoding: Alamofire.ParameterEncoding? {
        return URLEncoding(destination: .methodDependent)
    }
    
    override var authType: AuthType {
        return AuthType.noAuth
    }
    
    override var parameters: APIParams {
        switch requestType {
        case .fetchFeeds(let user):
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
