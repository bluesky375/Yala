//
//  PhoneContacts.swift
//  UBiCA
//
//  Created by Ankita on 26/07/18.
//  Copyright © 2018 TechEversion Inc. All rights reserved.
//

import Foundation
import ContactsUI

class PhoneContacts {
    
    class func getContactFriends() -> [Friend] {
        var friends = [Friend]()
        
        let contactStore = CNContactStore()
        let keysToFetch = [
            CNContactFormatter.descriptorForRequiredKeys(for: .fullName),
            CNContactPhoneNumbersKey, CNContactEmailAddressesKey] as [Any]
        
        let request = CNContactFetchRequest(keysToFetch: keysToFetch as! [CNKeyDescriptor])
        
        do {
            try contactStore.enumerateContacts(with: request) { (contact, stop) in
                let friend = Friend()
                friend.firstName = contact.givenName
                friend.lastName = contact.familyName
                friend.friendType = "3"
                
                if contact.emailAddresses.count > 0 {
                    friend.email = contact.emailAddresses[0].value as String
                }
                
                if contact.phoneNumbers.count > 0 {
                    let mobile = contact.phoneNumbers[0].value.stringValue
                    friend.mobile = mobile.removeCharacters(characters: "(-) ")
                    friends.append(friend)
                }
            }
        } catch {
            print(error.localizedDescription)
        }
        
        return friends
    }
    
    
}
