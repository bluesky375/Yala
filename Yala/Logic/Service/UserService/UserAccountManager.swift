//
//  UserAccountManagerService.swift
//  Yala
//
//  Created by Ankita on 03/08/18.
//  Copyright © 2018 Yala. All rights reserved.
//

import Foundation

/**
    This class is responsible for managing user account in the application. It contains methods to save/retreive user credentials, tokens and account information
 */
let kUserRefreshToken = "UserRefreshToken"
let kUserAccessToken = "UserAccessToken"
let kNonAuthenticatedAPIToken = "NonAuthenticatedAPIToken"

class UserAccountManager {
    
    static var shared = UserAccountManager()
    private var userAccount: UserAccount?
    private var nonAuthenticatedAPIToken: String?
    
    // MARK: Save helpers
    
    func saveCredentials(_ credentials: OAuthCredentials) {
        let keyChain = KeychainWrapper()
        
        if credentials.refresToken != nil {
            keyChain.save(value: credentials.refresToken!, forKey: kUserRefreshToken)
        }
        
        if credentials.accessToken != nil {
            keyChain.save(value: credentials.accessToken!, forKey: kUserAccessToken)
        }
        
        if userAccount == nil {
            userAccount = UserAccount()
        }
        
        userAccount?.oAuthCredentials = credentials
    }
    
    func saveNonAuthenticatedAPIToken(_ token: String) {
        let keyChain = KeychainWrapper()
        keyChain.save(value: token, forKey: kNonAuthenticatedAPIToken)
        
        nonAuthenticatedAPIToken = token
    }
    
    // MARK: Retreival helpers
    
    func getAuthorisationToken() -> String {
        if let token = userAccount?.oAuthCredentials?.accessToken {
            return token
        } else {
            let keychain = KeychainWrapper.shared
            
            guard let token = keychain.retrieveValue(forKey: kUserAccessToken)else {
                return ""
            }
            
            if userAccount == nil {
                userAccount = UserAccount()
                
            }
            
            let credentials = OAuthCredentials()
            credentials.accessToken = token
            userAccount?.oAuthCredentials = credentials
            
            return token
        }
    }
    
    func getRefreshToken() -> String {
        if let token = userAccount?.oAuthCredentials?.refresToken {
            return token
        } else {
            let keychain = KeychainWrapper.shared
            
            guard let token = keychain.retrieveValue(forKey: kUserRefreshToken)else {
                return ""
            }
            
            if userAccount == nil {
                userAccount = UserAccount()
                
            }
            
            let credentials = OAuthCredentials()
            credentials.accessToken = token
            userAccount?.oAuthCredentials = credentials
            
            return token
        }
    }
    
    func getNonAuthenticatedAPIToken() -> String {
        if let token = nonAuthenticatedAPIToken {
            return token
        } else {
            let keychain = KeychainWrapper.shared
            
            guard let token = keychain.retrieveValue(forKey: kNonAuthenticatedAPIToken)else {
                return ""
            }
            
            nonAuthenticatedAPIToken = token
            return token
        }
    }
    
    func removeTokens() {
        userAccount = nil
        nonAuthenticatedAPIToken = nil
        
        let keychain = KeychainWrapper.shared
        keychain.removeKey(kUserRefreshToken)
        keychain.removeKey(kUserAccessToken)
        keychain.removeKey(kNonAuthenticatedAPIToken)
    }
}
