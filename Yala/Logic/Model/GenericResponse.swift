//
//  GenericResponse.swift
//  Yala
//
//  Created by Ankita on 07/09/18.
//  Copyright © 2018 Yala. All rights reserved.
//

import Foundation

class GenericResponse: Codable {
    
    var status: String?
    var error: Bool?
    var message: String?
}
