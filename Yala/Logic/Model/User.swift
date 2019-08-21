//
//  User.swift
//  Yala
//
//  Created by Ankita on 03/08/18.
//  Copyright © 2018 Yala. All rights reserved.
//

import Foundation

class User: NSObject, Codable, NSCoding {
    
    static let DocumentsDirectory = FileManager().urls(for: .documentDirectory, in: .userDomainMask).first!
    static let ArchiveURL = DocumentsDirectory.appendingPathComponent("User")
   
    var email: String?
    var firstName: String?
    var lastName: String?
    var password: String?
    var mobile: String?
    var username: String?
    var address: String?
    var gender: String?
    var dob: String?
    var job: String?
    var company: String?
    var country: String?
    var college: String?
    var aboutYou: String?
    var profileimage: String?
    var facebookid: String?
    var devicetype: String?
    var token: String?
    var error: Bool?
    var message: String?
    var imageAsset: ImageAsset?
    
    var isNewInvite : String?
    
    override init() {
        
    }
    
    enum CodingKeys: String, CodingKey {
        case email = "emailid"
        case firstName = "firstname"
        case lastName = "lastname"
        case mobile = "mobileno"
        case username = "username"
        case address = "address"
        case gender = "gender"
        case dob = "dob"
        case job = "job"
        case company = "company"
        case country = "country"
        case college = "college"
        case aboutYou = "description"
        case profileimage = "profileimage"
        case facebookid = "facebookid"
        case token = "access_token"
        case error = "error"
        case message = "message"
        case isNewInvite = "isNewInvite"
    }
    
    required init?(coder decoder: NSCoder) {
        email = decoder.decodeObject(forKey: "email") as? String
        firstName = decoder.decodeObject(forKey: "firstName") as? String
        lastName = decoder.decodeObject(forKey: "lastName") as? String
        devicetype = decoder.decodeObject(forKey: "devicetype") as? String
        mobile = decoder.decodeObject(forKey: "mobile") as? String
        profileimage = decoder.decodeObject(forKey: "profileimage") as? String
        username = decoder.decodeObject(forKey: "username") as? String
        address = decoder.decodeObject(forKey: "address") as? String
        facebookid = decoder.decodeObject(forKey: "facebookid") as? String
        gender = decoder.decodeObject(forKey: "gender") as? String
        dob = decoder.decodeObject(forKey: "dob") as? String
        job = decoder.decodeObject(forKey: "job") as? String
        company = decoder.decodeObject(forKey: "company") as? String
        country = decoder.decodeObject(forKey: "country") as? String
        college = decoder.decodeObject(forKey: "college") as? String
        aboutYou = decoder.decodeObject(forKey: "aboutYou") as? String
   
        isNewInvite = decoder.decodeObject(forKey: "isNewInvite") as? String
        
    }
    
    func encode(with coder: NSCoder) {
        coder.encode(email, forKey: "email")
        coder.encode(firstName, forKey: "firstName")
        coder.encode(lastName, forKey: "lastName")
        coder.encode(devicetype, forKey: "devicetype")
        coder.encode(mobile, forKey: "mobile")
        coder.encode(profileimage, forKey: "profileimage")
        coder.encode(username, forKey: "username")
        coder.encode(address, forKey: "address")
        coder.encode(facebookid, forKey: "facebookid")
        coder.encode(gender, forKey: "gender")
        coder.encode(dob, forKey: "dob")
        coder.encode(job, forKey: "job")
        coder.encode(company, forKey: "company")
        coder.encode(country, forKey: "country")
        coder.encode(college, forKey: "college")
        coder.encode(aboutYou, forKey: "aboutYou")
        coder.encode(isNewInvite, forKey: "isNewInvite")
    }
    
    class func saveUser(user: User) {
        NSKeyedArchiver.archiveRootObject(user, toFile: User.ArchiveURL.path)
    }
    
    class func loadCurrentUser() -> User? {
        return NSKeyedUnarchiver.unarchiveObject(withFile: User.ArchiveURL.path) as? User
    }
    
    class func removeCurrentUser() {
        do {
            try FileManager.default.removeItem(atPath: User.ArchiveURL.path)
        } catch {
            
        }
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
    
    func displayGenderValue() -> String? {
        if gender == "F" || (gender?.caseInsensitiveCompare("Female") == ComparisonResult.orderedSame) {
            return "Female"
        } else if gender == "M" || (gender?.caseInsensitiveCompare("Male") == ComparisonResult.orderedSame) {
            return "Male"
        } else {
            return nil
        }
    }
}
