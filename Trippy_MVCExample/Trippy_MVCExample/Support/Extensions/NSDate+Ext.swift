//
//  NSDate+Ext.swift
//  Trippy_MVCExample
//
//  Created by Chintan Maisuriya on 01/08/20.
//  Copyright © 2020 Chintan. All rights reserved.
//

import Foundation


extension NSDate
{
    func toStringDate() -> String
    {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd MMM yyyy" // "yyyy-MM-dd"
        let dateFromString = dateFormatter.string(from: self as Date)
        return dateFromString
    }
    
    func toString24hourTime() -> String
    {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH:mm:ss"
        let dateFromString = dateFormatter.string(from: self as Date)
        return dateFromString
    }
    
    func toString12hourTime() -> String
    {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "hh:mm a"
        let dateFromString = dateFormatter.string(from: self as Date)
        return dateFromString
    }
    
    func toString24hourwithSecond() -> String
    {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH:mm:ss"
        let dateFromString = dateFormatter.string(from: self as Date)
        return dateFromString
    }
    
    func toStringFullMnthDate() -> String
    {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd-MMMM-yyyy"
        let dateFromString = dateFormatter.string(from: self as Date)
        return dateFromString
    }
    
    func getElapsedInterval() -> String
    {
        let formatter = DateComponentsFormatter()
        formatter.allowedUnits = [.minute, .hour, .day, .month, .year]
        formatter.unitsStyle = .abbreviated
        formatter.zeroFormattingBehavior = .dropAll
        formatter.maximumUnitCount = 1
        
        var dateString: String?
        
        if self.timeIntervalSince(Date()) > -60*5
        {
            dateString = NSLocalizedString("now", comment: "")
        }
        else
        {
            dateString = String.init(format: NSLocalizedString("%@ ago", comment: ""), locale: .current, formatter.string(from: self as Date, to: Date())!)
        }
        
        return dateString ?? ""
    }
    
    func getPastTime() -> String {
        
        var secondsAgo = Int(Date().timeIntervalSince(self as Date))
        if secondsAgo < 0 {
            secondsAgo = secondsAgo * (-1)
        }
        
        let minute = 60
        let hour = 60 * minute
        let day = 24 * hour
        let week = 7 * day
        
        if secondsAgo < minute  {
            if secondsAgo < 2{
                return "just now"
            }else{
                return "\(secondsAgo) secs ago"
            }
        } else if secondsAgo < hour {
            let min = secondsAgo/minute
            if min == 1{
                return "\(min) min ago"
            }else{
                return "\(min) mins ago"
            }
        } else if secondsAgo < day {
            let hr = secondsAgo/hour
            if hr == 1{
                return "\(hr) hr ago"
            } else {
                return "\(hr) hrs ago"
            }
        } else if secondsAgo < week {
            let day = secondsAgo/day
            if day == 1{
                return "\(day) day ago"
            }else{
                return "\(day) days ago"
            }
        } else {
            let formatter = DateFormatter()
            formatter.dateFormat = "E, MMM d, h:mm a"
            formatter.locale = Locale(identifier: "en_US")
            let strDate: String = formatter.string(from: self as Date)
            return strDate
        }
    }
    
}
