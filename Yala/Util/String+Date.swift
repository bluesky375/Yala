//
//  String+Date.swift
//  RxAppoint
//
//  Created by Ankita Porwal on 28/12/16.
//  Copyright © 2016 TechEversion. All rights reserved.
//

import Foundation

let yearFirstFormat = "yyyy-MM-dd"
let dayFirstFormat = "dd MMM yyyy"
let timeFormat = "hh:mm a"
let invoiceDateFormat = "dd, MMM YYYY"

extension Date {
    func toString(inFormat format: String) -> String? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = DateFormatter.Style.medium
        dateFormatter.timeStyle = DateFormatter.Style.none
        dateFormatter.dateFormat = format
        return dateFormatter.string(from: self)
    }
    
    var millisecondsSince1970: Int {
        return Int((self.timeIntervalSince1970 * 1000.0).rounded())
    }
    
    init(milliseconds:Int) {
        self = Date(timeIntervalSince1970: TimeInterval(milliseconds / 1000))
    }
}

extension String {
    func toDate(fromFormat format: String) -> Date? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        return dateFormatter.date(from: self)
    }
    
    func toTime(fromFormat format: String) -> String? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        let date = dateFormatter.date(from: self)
        if date != nil {
            let calendar = Calendar.current
            let comp = calendar.dateComponents([.hour, .minute], from: date!)
            let hour = comp.hour
            let minute = comp.minute
            return String(hour!) +  String(minute!)
        }
        return ""
    }
}
