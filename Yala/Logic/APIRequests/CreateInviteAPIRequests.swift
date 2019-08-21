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

enum CreateInviteAPIEndpoint {
    case createInvite(Invite)
}

class CreateInviteAPIRequests: APIBaseRequest {
    
    private var requestType: CreateInviteAPIEndpoint
    
    init(requestType: CreateInviteAPIEndpoint) {
        self.requestType = requestType
    }
    
    override var cacheResponse: Bool {
        return false
    }
    
    override var method: HTTPMethod {
        return .post
    }
    
    override var path: String {
        return "addInviteFriends"
    }
    
    override var encoding: Alamofire.ParameterEncoding? {
        return JSONEncoding.default
    }
    
    override var authType: AuthType {
        return AuthType.noAuth
    }
    
    override var parameters: APIParams {
        switch requestType {
        case .createInvite(let invite):
            var friendDict: [String: Any]
            var friendArray = [[String: Any]]()
            
            for item in invite.friends! {
                let date = DateWrapper.getStringFromDate(date: invite.dateTime!)
                friendDict = ["mobile_no" : item.mobile ?? "" as AnyObject,
                              "emailid" : item.email ?? "" as AnyObject,
                              "facebookid": item.facebookId ?? "" as AnyObject ,
                              "location": invite.selectedPlace?.name as AnyObject,
                              "address": invite.selectedPlace?.address as AnyObject,
                              "invitedate" : date as AnyObject,
                              "latitude" : "\((invite.selectedPlace?.getCLLOcation().latitude)!)" as AnyObject,
                              "longitude" : "\((invite.selectedPlace?.getCLLOcation().longitude)!)" as AnyObject,
                              "eventname" : ""]
                
                friendArray.append(friendDict)
            }
            
            let params = ["token_key" : UserAccountManager.shared.getAuthorisationToken() as AnyObject,
                          "inviteFriends": friendArray as AnyObject,
                          ]
            return params
        }
    }
    
    override var responseType: ResponseType {
        return .object()
    }
}
