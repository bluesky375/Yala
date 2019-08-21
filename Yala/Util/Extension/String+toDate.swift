//
//  String+toDate.swift
//  SaviSchools
//
//  Created by Ankita Porwal on 27/09/17.
//  Copyright © 2017 Savitroday. All rights reserved.
//

import Foundation

extension String {
    
    func toDate() -> Date? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS"
        var date = dateFormatter.date(from: self)

        if date == nil {
            dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
            date = dateFormatter.date(from: self)
        }
        
        if date == nil {
            dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
            date = dateFormatter.date(from: self)
        }
        if date == nil {
            dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
            date = dateFormatter.date(from: self)
        }
        if date == nil {
            dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
            date = dateFormatter.date(from: self)
        }
        if date == nil {
            dateFormatter.dateFormat = "yyyy-MM-dd hh:mm"
            date = dateFormatter.date(from: self)
        }
        if date == nil {
            dateFormatter.dateFormat = "yyyy-dd-MM"
            date = dateFormatter.date(from: self)
        }
        
        if date == nil {
            dateFormatter.dateFormat = "HH:mm:ss.SSSSSSS"
            date = dateFormatter.date(from: self)
        }
        
        if date == nil {
            dateFormatter.dateFormat = "HH:mm:ss"
            date = dateFormatter.date(from: self)
        }
        
        if date == nil {
            dateFormatter.dateFormat = "dd-MM-yyyy hh:mm a Z"
            date = dateFormatter.date(from: self)
        }
        
        if date == nil {
            dateFormatter.dateFormat = "dd MMM yyyy h:mm a"
            date = dateFormatter.date(from: self)
        }
        
        if date == nil {
            dateFormatter.dateFormat = "dd MMM yyyy hh a"
            date = dateFormatter.date(from: self)
        }
    
        return date
    }
    
    func toDateWithoutTimezone() -> Date? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
        var date = dateFormatter.date(from: self)
        if date == nil {
            date = self.toDate()
        }
        return date
    }
}
