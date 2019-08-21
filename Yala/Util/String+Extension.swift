//
//  String+Extension.swift
//  FamilyTies
//
//  Created by Ankita on 22/12/18.
//  Copyright © 2018 w3 ondemand. All rights reserved.
//

import Foundation

extension String
{
    func removeCharacters(characters: String) -> String {
        let characterSet = CharacterSet(charactersIn: characters)
        let components = self.components(separatedBy: characterSet)
        let result = components.joined(separator: "")
        return result
    }
    
    func trim() -> String {
        return self.trimmingCharacters(in: CharacterSet.whitespaces)
    }
}
