//
//  InviteModel.swift
//  Yala
//
//  Created by Ankita on 16/10/18.
//  Copyright © 2018 Yala. All rights reserved.
//

import Foundation

class Invite: Codable {
    
    var selectedPlace: GooglePlaceItem?
    var dateTime: Date?
    
    var id: String? = ""
    var friends: [Friend]? = []
    var invitedFriends: [InvitedFriend]? = [] // coming from api
    var name: String? = ""
    var locationName: String? = ""
    var inviteDateString: String? = ""
    var address: String? = ""
    var lat: String? = ""
    var long: String? = ""
    var isCreatedByMe: Bool? = false
    var invitingFriendName: String? = ""
    var invitingFriendEmail: String? = ""
    var status: String? = ""
    var phoneNumber : String? = ""
    
    
    enum CodingKeys: String, CodingKey {
        case id = "id"
        case invitedFriends = "friendlist"
        case name = "eventname"
        case locationName = "location"
        case inviteDateString = "invitedate"
        case address = "address"
        case long = "longitude"
        case lat = "latitude"
        case invitingFriendName = "firstname"
        case invitingFriendEmail = "emailid"
        case status = "status"
        case phoneNumber = "mobileno"
    }
    
    func inviteTime() -> String {
        if dateTime == nil, inviteDateString != nil, !(inviteDateString?.isEmpty)! {
            dateTime = inviteDateString?.toDate()
        }
        
        if dateTime != nil {
            return DateWrapper.getTime(dateTime!)
        }
        return ""
    }
    
    func inviteDate() -> String {
        if dateTime == nil, inviteDateString != nil, !(inviteDateString?.isEmpty)! {
            dateTime = inviteDateString?.toDate()
        }
        
        if dateTime != nil {
            return DateWrapper.getDay(dateTime!) + " " + DateWrapper.getMonth(dateTime!)
        }
        return ""
    }
    
    func invitationMessage() -> String {
        let user = User.loadCurrentUser()
        return user!.displayName() + " has invited you at " + (selectedPlace?.name)! + " at " + inviteTime() + " on " + inviteDate() + " via Yala App. Please download Yala from https://itunes.apple.com/app/id1436412394."
    }
    
    func containsNonYalaFriends() -> Bool {
        var containsNonYalaFriends = false
        for user in friends! {
            if !user.isYalaUser() {
                containsNonYalaFriends = true
                break
            }
        }
        return containsNonYalaFriends
    }
    
    func containsYalaFriends() -> Bool {
        var containsYalaFriends = false
        for user in friends! {
            if user.isYalaUser() {
                containsYalaFriends = true
                break
            }
        }
        return containsYalaFriends
    }
}



class InviteResponse: Codable {
    var status: Int?
    var error: Bool?
    var message: String?
}

class AcceptInviteResponse: Codable {
    var eventid: String?
    var inviteStatus: String?
    var status: Int?
    var error: Bool?
    var message: String?
}

class InviteListResponse: Codable {
    var status: Int?
    var error: Bool?
    var data: [Invite]?
    var result: [Invite]?
}
