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

enum MarkNotificationAsReadAPIEndPoint {
    case markAsRead([String])
}

class MarkNotificationAsReadAPIRequests: APIBaseRequest {
    
    private var requestType: MarkNotificationAsReadAPIEndPoint
    
    init(requestType: MarkNotificationAsReadAPIEndPoint) {
        self.requestType = requestType
    }
    
    override var cacheResponse: Bool {
        return false
    }
    
    override var method: HTTPMethod {
        return .post
    }
    
    override var path: String {
        return "markNotificationAsReadAPI"
    }
    
    override var encoding: Alamofire.ParameterEncoding? {
        return JSONEncoding.default
    }
    
    override var authType: AuthType {
        return AuthType.noAuth
    }
    
    override var parameters: APIParams {
        switch requestType {
        case .markAsRead(let ids):
            let params = ["notification_id": ids as AnyObject]
            return params
        }
    }
    
    override var responseType: ResponseType {
        return .object()
    }
}
