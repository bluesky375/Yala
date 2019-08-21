//
//  OAuthAPIRequest.swift
//  Yala
//
//  Created by Ankita on 08/08/18.
//  Copyright © 2018 Yala. All rights reserved.
//

import Foundation
import Alamofire

enum UpdateTokenAPIEndpoint {
    case updateToken()
}

class UpdateTokenAPIRequests: APIBaseRequest {
    
    private var requestType: UpdateTokenAPIEndpoint
    
    init(requestType: UpdateTokenAPIEndpoint) {
        self.requestType = requestType
    }
    
    override var cacheResponse: Bool {
        return false
    }
    
    override var method: HTTPMethod {
        return .post
    }
    
    override var path: String {
        return "updateToken"
    }
    
    override var encoding: Alamofire.ParameterEncoding? {
        return URLEncoding(destination: .methodDependent)
    }
    
    override var authType: AuthType {
        return AuthType.noAuth
    }
    
    override var parameters: APIParams {
        let appdelegate = UIApplication.shared.delegate as! AppDelegate
        switch requestType {
        case .updateToken():
            return ["token_key": UserAccountManager.shared.getAuthorisationToken() as AnyObject,
                    "new_token_key" : appdelegate.pushToken as AnyObject]
        }
    }
    
    override var responseType: ResponseType {
        return .object()
    }
}
