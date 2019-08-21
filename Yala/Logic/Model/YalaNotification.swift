//
//  Friend.swift
//  Yala
//
//  Created by Ankita on 09/10/18.
//  Copyright © 2018 Yala. All rights reserved.
//

import Foundation

class YalaNotification: NSObject, Codable {
    
    var id: String?
    var message: String?
    var senddate: String?
    var event: String?
    var eventType: String?
    var lat: String?
    var long: String?
    var profileImage: String?
    var status: String?
    var inviteLocation: String?
    
    override init() {
        
    }
    
    enum CodingKeys: String, CodingKey {
        case id = "notification_id"
        case message = "message"
        case senddate = "senddate"
        case event = "event"
        case eventType = "event_type"
        case lat = "lat"
        case long = "long"
        case profileImage = "profileImage"
        case status = "status"
        case inviteLocation = "location"

    }
    
    func isNotificationCreateInviteType() -> Bool {
        return eventType == "createInvite"
    }
    
    func isNotificationRead() -> Bool {
        return status == "Read"
    }
}

class YalaNotificationResponse: Codable {
    var status: Int?
    var error: Bool?
    var message: String?
    var result: [YalaNotification]?
}
