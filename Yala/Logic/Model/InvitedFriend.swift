//
//  InvitedFriend.swift
//  Yala
//
//  Created by Ankita on 10/12/18.
//  Copyright © 2018 Yala. All rights reserved.
//

import Foundation

class InvitedFriend: NSObject, Codable {
    
    var firstName: String?
    var lastName: String?
    var mobile: String?
    var email: String?
    var facebookId: String?
    var status: String?
    
    override init() {
        
    }
    
    enum CodingKeys: String, CodingKey {
        case firstName = "firstname"
        case lastName = "lastname"
        case mobile = "mobileno"
        case email = "emailid"
        case facebookId = "facebookid"
        case status = "status"
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
    
    func displayStatus() -> String {
        if status == "1" {
            return "Accepted"
        } else if status == "2" {
            return "Declined"
        } else {
             return "Pending"
        }
    }
}
