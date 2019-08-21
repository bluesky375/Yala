//
//  UIViewController+FacebookLogin.swift
//  Yala
//
//  Created by Ankita on 07/09/18.
//  Copyright © 2018 Yala. All rights reserved.
//

import Foundation
import UIKit
import FacebookLogin
import FacebookCore
import SVProgressHUD
import Kingfisher

extension UIViewController {
    
    func signInWithFacebook(onComplete: ((_ success: Bool, _ error: Error?)->())?) {
        
        let loginManager = LoginManager()
        loginManager.logOut()
        
        loginManager.logIn(readPermissions: [.publicProfile, .email/*, .userFriends, .userGender*/], viewController: self) { [weak self] (loginResult) in
            switch loginResult {
            case .failed(let error):
                print(error)
            case .cancelled:
                print("User cancelled login.")
            case .success(let grantedPermissions, let declinedPermissions, let accessToken):
                print("Logged in!")
                print(grantedPermissions)
                print(declinedPermissions)
                self?.fetchFacebookUserData(onComplete: onComplete)
            }
        }
    }
    
    func fetchFacebookUserData(onComplete: ((_ success: Bool, _ error: Error?)->())?) {
        if AccessToken.current != nil {
            SpinnerWrapper.showSpinner()
            let params = ["fields" : "id, picture.type(large), email, first_name, last_name, gender"]
            GraphRequest.init(graphPath: "me", parameters: params, accessToken: AccessToken.current, httpMethod: .GET, apiVersion: .defaultVersion).start { (response, result) in
                switch result {
                case .success(let graphResponse):
                    if let fields = graphResponse.dictionaryValue,
                        let firstName = fields["first_name"] as? String,
                        let lastName = fields["last_name"] as? String,
                        var imageURL = ((fields["picture"] as? [String: Any])?["data"] as? [String: Any])?["url"] as? String,
                        let id = fields["id"] as? String,
                        let email = fields["email"] as? String {
                        
                        let apiCall = {
                            let user = User()
                            user.firstName = firstName
                            user.lastName = lastName
                            user.email = email
                            user.profileimage = imageURL
                            user.facebookid = id
                            
                            APIManager.shared.request(OAuthAPIRequest.init(requestType: OAuthRequestType.socialLogin(user)), completionHandler: { (success, user: User?, _, anyJSON, error) in
                                if user?.token != nil {
                                    let credentials = OAuthCredentials.init()
                                    credentials.accessToken = user?.token
                                    UserAccountManager.shared.saveCredentials(credentials)
                                    
                                    User.saveUser(user: user!)
                                    
                                    onComplete!(true, nil)
                                } else  {
                                    onComplete!(false, nil)
                                }
                            })
                        }
                        
                        if !imageURL.isEmpty {
                            ImageDownloader.shared.downloadImage(from: URL.init(string: imageURL)!, completion: { (data, response, error) in
                                if data != nil {
                                    imageURL = data?.base64EncodedString() ?? ""
                                }
                                apiCall()
                            })
                        } else {
                            apiCall()
                        }
                    } else  {
                        onComplete!(false, nil)
                    }
                case .failed(let error):
                    onComplete!(false, error)
                }
            }
        }
    }
    
    func fetchFBFriendList(_ completion: ((_ frienkds: [Friend]?) -> ())?) {
        checkUserFriendAccess { (granted) in
            let params = ["fields": "id, first_name, last_name, name, email, picture.type(large)"]
            
            SpinnerWrapper.showSpinner()
            GraphRequest.init(graphPath: "/me/friends", parameters: params, accessToken: AccessToken.current, httpMethod: .GET, apiVersion: .defaultVersion).start { (response, result) in
                switch result {
                case .success(let graphResponse):
                    var friends = [Friend]()
                    if let responseDictionary = graphResponse.dictionaryValue {
                        if let data = responseDictionary["data"] as? [[String: Any]] {
                            print(data)
                            for item in data {
                                let friend = Friend()
                                
                                let fname = item["first_name"] as? String
                                let lname = item["last_name"] as? String
                                let id = item["id"] as? String
                                friend.firstName = fname
                                friend.lastName = lname
                                friend.facebookId = id
                                friend.friendType = "1"
                                
                                if let imageURL = ((item["picture"] as? [String: Any])?["data"] as? [String: Any])?["url"] as? String {
                                    friend.profileImage = imageURL
                                }
                                
                                friends.append(friend)
                            }
                        }
                    }
                    if completion != nil {
                        completion!(friends)
                    }
                case .failed(let error):
                    print(error)
                    if completion != nil {
                        completion!(nil)
                    }
                }
            }
        }
    }
    
    func checkUserFriendAccess(_ completion: ((_ granted: Bool)->())?) {
        if AccessToken.current == nil {
            signInWithFacebook { [weak self] (success, error) in
                self?.checkUserFriendAccess(completion)
            }
        } else if let grantedPermissions = AccessToken.current?.grantedPermissions,
            !(grantedPermissions.contains("user_friends")) {
            
            let loginManager = LoginManager()
            
            loginManager.logIn(readPermissions: [.userFriends], viewController: self) { (loginResult) in
                switch loginResult {
                case .success(let grantedPermissions, _, _):
                    if (grantedPermissions.contains("user_friends")) {
                        if completion != nil {
                            completion!(true)
                        }
                    }
                case .cancelled:
                    if completion != nil {
                        completion!(false)
                    }
                case .failed(_):
                    if completion != nil {
                        completion!(false)
                    }
                }
            }
        } else if completion != nil {
            completion!(true)
        }
    }
}

