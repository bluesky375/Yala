//
//  CommentItem.swift
//  Yala
//
//  Created by Admin on 3/30/19.
//  Copyright © 2019 Yala. All rights reserved.
//

import Foundation

class CommentItem: NSObject, Codable {
    
    var _id: String? = "-1"
    var user_id: String? = ""
    var comment: String? = ""
    var event_id: String? = ""
    var firstname : String? = ""
    var lastname : String? = ""
    var profileimage : String? = ""
    override init() {
        
    }
    enum CodingKeys: String, CodingKey {
        case _id = "_id"
        case user_id = "user_id"
        case comment = "comment"
        case event_id = "event_id"
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
        return name
    }
}

class CommentsResponse: Codable {
    var status: Int?
    var error: Bool?
    var message: String?
    var result: [CommentItem]?
}
