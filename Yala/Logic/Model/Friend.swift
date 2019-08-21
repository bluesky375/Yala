//
//  Friend.swift
//  Yala
//
//  Created by Ankita on 09/10/18.
//  Copyright © 2018 Yala. All rights reserved.
//

import Foundation

class Friend: NSObject, Codable {
    
    var firstName: String?
    var lastName: String?
    var mobile: String?
    var email: String?
    var profileImage: String?
    var facebookId: String?
    var friendType: String?
    var yalaUser: String?
    var address: String?
    var gender: String?
    var dob: String?
    var job: String?
    var company: String?
    var country: String?
    var college: String?
    var aboutYou: String?
    var latitude: String?
    var longitude: String?
    
    override init() {
        
    }
    
    enum CodingKeys: String, CodingKey {
        case firstName = "first_name"
        case lastName = "last_name"
        case mobile = "mobile_no"
        case profileImage = "profile_img"
        case email = "email"
        case friendType = "friendType"
        case yalaUser = "yala_user"
        case facebookId = "facebookid"
        case address = "address"
        case gender = "gender"
        case dob = "dob"
        case job = "job"
        case company = "company"
        case country = "country"
        case college = "college"
        case aboutYou = "description"
        case latitude = "latitude"
        case longitude = "longitude"
    }
    
    func isYalaUser() -> Bool {
        return yalaUser == "true"
    }
    
    func displayName() -> String {
        var name = ""
        if firstName != nil {
            name = firstName!
        }
        if lastName != nil {
            name = name + " " + lastName!
        }
        return name
    }
}

class FriendResponse: Codable {
    var status: Int?
    var error: Bool?
    var message: String?
    var result: [Friend]?
}
