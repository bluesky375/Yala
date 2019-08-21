//
//  OAuthAPIManager.swift
//  Yala
//
//  Created by Ankita on 07/08/18.
//  Copyright © 2018 Yala. All rights reserved.
//

import Foundation
import Alamofire
import AlamofireObjectMapper

/**
    This class provides method to make an api request. It handles token refreshing when expired and handle api calls.
 */

class APIManager {
    
    static var shared = APIManager()
    private let apiClient: APIBaseClient
    private let apiMessages = APIMessages.init()
    
    private let configuration: URLSessionConfiguration = {
        let configuration = URLSessionConfiguration.default
        configuration.timeoutIntervalForRequest = 15
        configuration.requestCachePolicy = .returnCacheDataElseLoad
        configuration.urlCache = URLCache.shared
        
        return configuration
    }()
    
    init() {
        apiClient = APIBaseClient.init(apiMessages, configuration: configuration)
    }

    // MARK: API call
    
    func request<T:Codable>(_ request: APIBaseRequest, completionHandler: ((_ success: Bool, _ responseObject: T?, _ responseArray: [T]?, _ anyResponse: Any? , _ error: CustomError?) -> Void)?) {
        
        apiClient.request(request) { [weak self] (success, responseObject: T?, responseArray: [T]?, anyResponse, error) in
            if error != nil && error?.code == 401 && request.authType != .oAuth {
                self?.refreshTokens(request.authType, completionHandler: { success in
                    if success {
                        self?.request(request, completionHandler: completionHandler)
                    } else {
                        // logout
                    }
                })
            } else if completionHandler != nil {
                completionHandler!(success, responseObject, responseArray, anyResponse, error)
            }
        }
    }
    
    // MARK: Refresh token
    
    func refreshTokens(_ authType: AuthType, completionHandler: ((_ success: Bool) -> Void)?) {
        
        apiClient.request(OAuthAPIRequest.init(requestType: .refreshAccessToken(authType))) { (success, credentials: OAuthCredentials?, _, _, _) in
            if success && credentials != nil {
                switch authType {
                case .user:
                    UserAccountManager.shared.saveCredentials(credentials!)
                case .client:
                    UserAccountManager.shared.saveNonAuthenticatedAPIToken((credentials?.accessToken)!)
                default:
                    debugPrint("OAUTH SUCCESS: AuthType can not be other than user and client")
                }
               
                if completionHandler != nil {
                    completionHandler!(true)
                }
            } else if completionHandler != nil {
                completionHandler!(false)
            }
        }
    }
}
