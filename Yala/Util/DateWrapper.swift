//
//  DateWrapper.swift
//  TWGiOS
//
//  Created by Samiksha on 17/07/17.
//  Copyright © 2017 the warranty group. All rights reserved.
//

import Foundation
import DateToolsSwift

enum PeriodOfTheDay {
    case morning, afternoon, evening
}

class DateWrapper {
    
    static func getPeriodOfTheDay() -> PeriodOfTheDay {
        let now: Date = Date()
        let calendar = Calendar.current
        let hour = calendar.component(.hour, from: now)
        switch hour {
        case 0 ... 12:
            return .morning
        case 13 ... 14:
            return .afternoon
        default:
            return .evening
        }
    }
    
    static func interval(fromDate date: String) -> Int {
        
        let currentCalendar = Calendar.current
        let currentDate = Date()
        let dateString = DateWrapper.getStringFromDate(date: currentDate)
        let startDate = DateWrapper.getDateFromString(dateString: date)
        let endDate = DateWrapper.getDateFromString(dateString: dateString)
        let components = currentCalendar.dateComponents([.day], from: startDate, to: endDate)
        return components.day!
    }
    
    static func getDateFromString(dateString: String) -> Date {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        return dateFormatter.date(from: dateString)!
    }
    
    static func getStringFromDate(date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        return dateFormatter.string(from: date)
    }
    
    static func convertDateFormater(_ date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd MMM yyyy"
        return  dateFormatter.string(from: date)
    }
    
    static func getMonth(_ date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMM"
         return dateFormatter.string(from: date)
    }
    
    static func getYear(_ date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy"
        return dateFormatter.string(from: date)
    }
    
    static func getDay(_ date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd"
        let abcd = dateFormatter.string(from: date)
        return abcd
    }
    
    static func getWeekDay(_ date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "EEEE"
        return dateFormatter.string(from: date)
    }
    
    static func getTime(_ date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.timeStyle = .short
        return dateFormatter.string(from: date)
    }
    
    static func timeAgo(fromDate date: Date) -> String {
        let yearsAgo = date.yearsAgo
        let monthsAgo = date.monthsAgo
        let weekAgo = date.weeksAgo
        let daysAgo = date.daysAgo
        let hoursAgo = date.hoursAgo
        let minutesAgo = date.minutesAgo
        
        if yearsAgo >= 1 {
            return yearsAgo > 1 ? String(yearsAgo) + " years Ago" : String(yearsAgo) + " year Ago"
        } else if monthsAgo >= 1 {
            return monthsAgo > 1 ? String(monthsAgo) + " months Ago" : String(monthsAgo) + " month Ago"
        } else if weekAgo >= 1 {
            return weekAgo > 1 ? String(weekAgo) + " weeks Ago" : String(weekAgo) + " week Ago"
        } else if daysAgo >= 1 {
            return String(daysAgo) + (daysAgo > 1 ? " d Ago" : " d Ago")
        } else if hoursAgo >= 1 {
            return String(hoursAgo) + (hoursAgo > 1 ? " h Ago" : " h Ago")
        } else if minutesAgo >= 1 {
            return String(minutesAgo) + (minutesAgo > 1 ? " mins Ago" : " min Ago")
        } else {
           return "Just Now"
        }
    }
    
    static func UTCToLocal(date:String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        dateFormatter.timeZone = TimeZone(abbreviation: "UTC")
        
        let dt = dateFormatter.date(from: date)
        dateFormatter.timeZone = TimeZone.current
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        
        return dateFormatter.string(from: dt!)
    }
}
