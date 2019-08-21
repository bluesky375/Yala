//
//  UserService.swift
//  Yala
//
//  Created by Ankita on 09/10/18.
//  Copyright © 2018 Yala. All rights reserved.
//

import Foundation
import AlamofireObjectMapper
import Alamofire

class UserService {
    
    var lastDeviceLatitude: String?
    var lastDeviceLongitude: String?
    var friends: [Friend]?
    var feeds : [FeedItem]?
    var comments : [CommentItem]?
    
    static let shared = UserService()
    
    func updateProfileWithImage(_ user: User, completionHandler:((_ success: Bool, _ error: CustomError?, _ user: User?) ->())?) {
        let profileRequest = UserProfileAPIRequests.init(requestType: ProfileEndpoints.updateProfile(user))
        
        let URL = profileRequest.baseUrl + "/" + profileRequest.path
        
        let headers: HTTPHeaders = [
            "Content-type": "multipart/form-data"
        ]
        
        let params = ["token_key" : UserAccountManager.shared.getAuthorisationToken(),
                      "first_name": user.firstName,
                      "last_name": user.lastName,
                      "user_name": user.username,
                      "user_email": user.email,
                      "gender": user.gender,
                      "dob" : user.dob,
                      "user_decription" : user.aboutYou,
                      "job": user.job,
                      "college": user.college,
                      "country": user.country,
                      "address": user.address,
                      "mobileno": user.mobile]
        
        Alamofire.upload(multipartFormData: { (multipartFormData) in
            for (key, value) in params {
                multipartFormData.append("\(value)".data(using: String.Encoding.utf8)!, withName: key as String)
            }
            
            if let data = user.imageAsset?.dataFromFile() {
                multipartFormData.append(data, withName: "profile_image", fileName: "profile.png", mimeType: "image/png")
            }
        }, usingThreshold: UInt64.init(), to: URL, method: .post, headers: headers) { (encodingResult) in
            switch encodingResult {
            case .success(let upload, _, _):
                
                upload.responseData { response in
                    print(response)
                    
                    if let json = response.result.value {
                        print("JSON: \(json)")
                    }
                }
                upload.responseJSON {
                    response in
                    
                    guard let json = response.result.value else {
                        let error = ErrorBuilder.init(withTitle: nil,
                                                      message: "No JSON response").build()
                        if completionHandler != nil {
                            completionHandler!(false, error, nil)
                        }
                        return
                    }
                    
                    DispatchQueue.global().async {
                        let decoder = APIBaseClient.jsonDecoder()
                        
                        var parsedObject: User?
                        
                        do {
                            parsedObject  = try! decoder.decode(User.self, from: json as! Data)
                        } catch let error {
                            
                        }
                        
                        DispatchQueue.main.async {
                            if completionHandler != nil {
                                completionHandler!(true, nil, parsedObject)
                            }
                        }
                    }
                }
            case .failure(let encodingError):
                print(encodingError)
                let error = ErrorBuilder.init(withTitle: "",
                                              message:encodingError.localizedDescription, code: 400).build()
                if completionHandler != nil {
                    completionHandler!(false, error, nil)
                }
            }
        }
    }
    
    func updateProfile(_ user: User, completionHandler:((_ success: Bool, _ error: CustomError?, _ user: User?) ->())?) {
        
        APIManager.shared.request(UserProfileAPIRequests.init(requestType: ProfileEndpoints.updateProfile(user))) { (success, user: User?, _, _, error) in
            if completionHandler != nil {
                completionHandler!(success, error, user)
            }
        }
        
    }
    
    func getFeedbacks(_ user: User, completionHandler:((_ success: Bool, _ error: CustomError?, _ feeds: [FeedItem]?) ->())?) {
        APIManager.shared.request(GetFeedbackAPIRequests.init(requestType: GETFeedbackAPIEndpoint.fetchFeeds(user))) { (success, feedResponse: FeedResponse?, _, _, error) in
            if success {
                self.feeds = feedResponse?.result
            }
            if completionHandler != nil {
                completionHandler!(success, error, feedResponse?.result)
            }
        }
    }
    
    func getStateNewInvite(_ user: User, completionHandler:((_ success: Bool, _ error: CustomError?, _ status: String?) ->())?) {
        APIManager.shared.request(GetStateNewInviteAPIRequests.init(requestType: GetStateNewInviteAPIEndpoint.setUser(user))) { (success, Response: InviteStatusResponse?, _, _, error) in
            if success {
               // self.feeds = feedResponse?.result
            }
            if completionHandler != nil {
                completionHandler!(success, error, Response?.result)
            }
        }
    }
    
    
    
    
    func addLikeToEvent(_ eventId: String, completionHandler:((_ success: Bool, _ error: CustomError?, _ feeds: [FeedItem]?) ->())?) {
        APIManager.shared.request(AddLikeAPIRequests.init(requestType: AddLikeAPIEndpoint.addLike(eventId))) { (success, feedResponse: FeedResponse?, _, _, error) in
            if success {
                self.feeds = feedResponse?.result
            }
            if completionHandler != nil {
                completionHandler!(success, error, feedResponse?.result)
            }
        }
    }
    
    func addCommentToEvent(_ eventId: String, _ comment: String, completionHandler:((_ success: Bool, _ error: CustomError?, _ comments: [CommentItem]?) ->())?) {
        APIManager.shared.request(AddCommentAPIRequests.init(requestType: AddCommentAPIEndpoint.addComment(eventId, comment))) { (success, commentsResponse: CommentsResponse?, _, _, error) in
            if success {
                self.comments = commentsResponse?.result
            }
            if completionHandler != nil {
                completionHandler!(success, error, commentsResponse?.result)
            }
        }
    }
    
    
    func getFriends(_ user: User, completionHandler:((_ success: Bool, _ error: CustomError?, _ friends: [Friend]?) ->())?) {
        APIManager.shared.request(GetFriendsAPIRequests.init(requestType: GETFriendsAPIEndpoint.fetchFriends(user))) { (success, friendResponse: FriendResponse?, _, _, error) in
            if success {
                self.friends = friendResponse?.result
            }
            if completionHandler != nil {
                completionHandler!(success, error, friendResponse?.result)
            }
        }
    }
    
    
    func syncFriends(_ user: User, _ friends: [Friend], completionHandler:((_ success: Bool, _ error: CustomError?) ->())?) {
        APIManager.shared.request(POSTFriendsAPIRequests.init(requestType: POSTFriendsAPIEndpoint.postFriends(friends))) { (success, genericResponse: FriendResponse?, _, _, error) in
            if completionHandler != nil {
                completionHandler!(success, error)
            }
        }
    }
    
    func forgotPassword(_ email: String, completionHandler:((_ success: Bool, _ error: CustomError?, _ response: ForgotPassword?) ->())?) {
        
        APIManager.shared.request(ForgotPasswordRequest.init(requestType: ForgotPasswordEndpoint.sentOtp(email))) { (success, forgotPass: ForgotPassword?, _, _, error) in
            if completionHandler != nil {
                completionHandler!(success, error, forgotPass)
            }
        }
    }
    
    func updatePassword(_ email: String, _ otp: Int, _ newPass: String, completionHandler:((_ success: Bool, _ error: CustomError?) ->())?) {
        
        APIManager.shared.request(ForgotPasswordRequest.init(requestType: ForgotPasswordEndpoint.changePassword(email, otp, newPass))) { (success, response: GenericResponse?, _, _, error) in
            if completionHandler != nil {
                completionHandler!(success, error)
            }
        }
    }
    
    func createInvite(_ invite: Invite, completionHandler:((_ success: Bool, _ response: InviteResponse?, _ error: CustomError?) ->())?) {
        APIManager.shared.request(CreateInviteAPIRequests.init(requestType: CreateInviteAPIEndpoint.createInvite(invite))) { (success, response: InviteResponse?, _, _, error) in
            if completionHandler != nil {
                completionHandler!(success, response, error)
            }
        }
    }
    
    func acceptInvite(_ notification: YalaNotification, completionHandler:((_ success: Bool, _ error: CustomError?, _ response: AcceptInviteResponse?) ->())?) {
        
        APIManager.shared.request(AcceptInviteAPIRequests.init(requestType: AcceptInviteAPIEndpoints.acceptInvite(notification))) { (success, response: AcceptInviteResponse?, _, _, error) in
            if completionHandler != nil {
                completionHandler!(success, error, response)
            }
        }
    }
    
    func declineInvite(_ notification: YalaNotification, completionHandler:((_ success: Bool, _ error: CustomError?, _ response: AcceptInviteResponse?) ->())?) {
        
        APIManager.shared.request(AcceptInviteAPIRequests.init(requestType: AcceptInviteAPIEndpoints.declineInvite(notification))) { (success, response: AcceptInviteResponse?, _, _, error) in
            if completionHandler != nil {
                completionHandler!(success, error, response)
            }
        }
    }
    
    func updateToken(completionHandler:((_ success: Bool, _ error: CustomError?) ->())?) {
        
        APIManager.shared.request(UpdateTokenAPIRequests.init(requestType: UpdateTokenAPIEndpoint.updateToken())) { (success, response: GenericResponse?, _, _, error) in
            if completionHandler != nil {
                completionHandler!(success, error)
            }
        }
    }
}
