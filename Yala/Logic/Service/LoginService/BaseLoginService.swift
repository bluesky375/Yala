//
//  BaseLoginService.swift
//  OAuthTestApp
//
//  Created by Samiksha on 20/08/18.
//  Copyright © 2018 Metacube. All rights reserved.
//

import Foundation

class BaseLoginService {
    
    private var apiManager: APIManager!
    
    init(_ apiManager: APIManager) {
        self.apiManager = apiManager
    }
    
    func loginUser(requestType: OAuthAPIRequest, completionHandler:((_ success: Bool, _ error: CustomError?) -> Void)?) {
        APIManager.shared.request(requestType) { (success, oAuthCredentials: OAuthCredentials?, _, _, error) in
            if success && oAuthCredentials != nil {
                UserAccountManager.shared.saveCredentials(oAuthCredentials!)
                completionHandler!(true, nil)
            } else if error != nil {
                completionHandler!(false, error)
            }
        }
    }
}
