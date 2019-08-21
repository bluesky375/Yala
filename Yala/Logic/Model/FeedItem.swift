//
//  FeedItem.swift
//  Yala
//
//  Created by Admin on 3/29/19.
//  Copyright © 2019 Yala. All rights reserved.
//

import Foundation
//
//  Friend.swift
//  Yala
//
//  Created by Ankita on 09/10/18.
//  Copyright © 2018 Yala. All rights reserved.
//

import Foundation

class FeedItem: NSObject, Codable {
    
    var eventname: String? = ""
    var id: String? = "-1"
    var location: String? = ""
    var likes: String? = ""
    var firstname: String? = ""
    var lastname: String? = ""
    var profileimage: String? = ""
    override init() {
        
    }
    enum CodingKeys: String, CodingKey {
        case eventname = "eventname"
        case id = "id"
        case location = "location"
        case likes = "likes"
        case firstname = "firstname"
        case lastname = "lastname"
        case profileimage = "profileimage"
    }
    
    func displayName() -> String {
        var name = ""
        if firstname != nil {
            name = firstname!
        }
        if lastname != nil {
            name = name + " " + lastname!
        }
        name += " " + eventname!
        return name
    }
  
}

class FeedResponse: Codable {
    var status: Int?
    var error: Bool?
    var message: String?
    var result: [FeedItem]?
}

class InviteStatusResponse : Codable {
    var status: Int?
    var error: Bool?
    var message: String?
    var result: String?
}
