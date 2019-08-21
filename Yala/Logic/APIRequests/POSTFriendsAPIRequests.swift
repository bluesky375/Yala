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

enum POSTFriendsAPIEndpoint {
    case postFriends([Friend])
}

class POSTFriendsAPIRequests: APIBaseRequest {
    
    private var requestType: POSTFriendsAPIEndpoint
    
    init(requestType: POSTFriendsAPIEndpoint) {
        self.requestType = requestType
    }
    
    override var cacheResponse: Bool {
        return false
    }
    
    override var method: HTTPMethod {
        return .post
    }
    
    override var path: String {
        return "addSyncFriends"
    }
    
    override var encoding: Alamofire.ParameterEncoding? {
        return JSONEncoding.default
    }
    
    override var authType: AuthType {
        return AuthType.noAuth
    }
    
    override var parameters: APIParams {
        switch requestType {
        case .postFriends(let friends):
            var friendDict: [String: Any]
            var friendArray = [[String: Any]]()
            
            for item in friends {
                friendDict = ["first_name" : item.firstName as AnyObject,
                              "last_name": item.lastName as AnyObject,
                              "email" : item.email as AnyObject,
                              "profile_image" : item.profileImage as AnyObject,
                              "facebook_id" : item.facebookId as AnyObject,
                              "mobile_no": item.mobile as AnyObject,
                              "type" :  item.friendType as AnyObject]
                
                friendArray.append(friendDict)
            }
            
            let params = ["access_token" : UserAccountManager.shared.getAuthorisationToken() as AnyObject,
                          "friendList": friendArray as AnyObject]
            return params
        }
    }
    
    override var responseType: ResponseType {
        return .object()
    }
}
