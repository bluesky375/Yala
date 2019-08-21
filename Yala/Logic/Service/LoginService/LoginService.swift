//
//  LoginService.swift
//  OAuthTestApp
//
//  Created by Samiksha on 20/08/18.
//  Copyright © 2018 Metacube. All rights reserved.
//

import Foundation

class LoginService {
    
    private let baseLoginService = BaseLoginService.init(APIManager.shared)
    
    func loginUser(username: String, password: String, completionHandler:((_ success: Bool, _ error: CustomError?) -> Void)?) {
        
        baseLoginService.loginUser(requestType: OAuthAPIRequest.init(requestType: .loginUser(username, password))) { success, error in
            if completionHandler != nil {
                completionHandler!(success, error)
            } 
        }
    }
}
