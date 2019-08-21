//
//  OAuthAPIRequest.swift
//  Yala
//
//  Created by Ankita on 08/08/18.
//  Copyright © 2018 Yala. All rights reserved.
//

import Foundation
import Alamofire

enum UpdateGPSLocationEndPoint {
    case updateGPS(String, String)
}

class UpdateGPSLocationAPIRequest: APIBaseRequest {
    
    private var requestType: UpdateGPSLocationEndPoint
    
    init(requestType: UpdateGPSLocationEndPoint) {
        self.requestType = requestType
    }
    
    override var cacheResponse: Bool {
        return false
    }
    
    override var method: HTTPMethod {
        return .post
    }
    
    override var path: String {
        return "getGpsLocation"
    }
    
    override var encoding: Alamofire.ParameterEncoding? {
        return URLEncoding(destination: .methodDependent)
    }
    
    override var authType: AuthType {
        return AuthType.noAuth
    }
    
    override var parameters: APIParams {
        switch requestType {
        case .updateGPS(let lat, let long):
            let params = ["token_key": UserAccountManager.shared.getAuthorisationToken() as AnyObject,
                    "latitude" : lat as AnyObject,
                    "longitude" : long as AnyObject,]
            return params
        }
    }
    
    override var responseType: ResponseType {
        return .object()
    }
}
