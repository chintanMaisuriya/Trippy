//
//  Date+Ext.swift
//  Trippy_MVCExample
//
//  Created by Chintan Maisuriya on 01/08/20.
//  Copyright © 2020 Chintan. All rights reserved.
//

import UIKit


extension Date
{
    func toString24Set() -> String
    {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH:mm:ss"
        let dateFromString = dateFormatter.string(from: self as Date)
        return dateFromString
    }
    
    func dateString(_ format: String = "MMM-dd-YYYY, hh:mm a") -> String
    {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        return dateFormatter.string(from: self)
    }
    
    func dateByAddingYears(_ dYears: Int) -> Date
    {
        var dateComponents = DateComponents()
        dateComponents.year = dYears
        return Calendar.current.date(byAdding: dateComponents, to: self)!
    }
    
    func formatRelativeString() -> String
    {
        let dateFormatter = DateFormatter()
        dateFormatter.doesRelativeDateFormatting = true
        dateFormatter.amSymbol = "am"
        dateFormatter.pmSymbol = "pm"
        
        let calendar = Calendar(identifier: .gregorian)
        
        if calendar.isDateInToday(self)
        {
            dateFormatter.timeStyle = .short
            dateFormatter.dateStyle = .none
        }
        else if calendar.isDateInYesterday(self)
        {
            dateFormatter.timeStyle = .none
            dateFormatter.dateStyle = .medium
        }
        else if calendar.compare(Date(), to: self, toGranularity: .weekOfYear) == .orderedSame
        {
            let weekday = calendar.dateComponents([.weekday], from: self).weekday ?? 0
            return dateFormatter.weekdaySymbols[weekday-1]
        }
        else
        {
            dateFormatter.timeStyle = .none
            dateFormatter.dateStyle = .short
        }
        
        return dateFormatter.string(from: self)
    }
    
    
    var isPastDate: Bool {
        return self < Date()
    }
    
    func isYesterday() -> Bool {
        return Calendar.autoupdatingCurrent.isDateInYesterday(self)
    }
    
    func isToday() -> Bool {
        return Calendar.autoupdatingCurrent.isDateInToday(self)
    }
    
    func isTomorrow() -> Bool {
        return Calendar.autoupdatingCurrent.isDateInTomorrow(self)
    }
    
    
    static var yesterday                    : Date { return Date().dayBefore }
    static var tomorrow                     :  Date { return Date().dayAfter }
    static var nextOneYearDateFormToday     : Date { return Date().dayAfterOneYear }
    
    var dayBefore: Date {
        return Calendar.current.date(byAdding: .day, value: -1, to: noon)!
    }
    
    var dayAfter: Date {
        return Calendar.current.date(byAdding: .day, value: 1, to: noon)!
    }
    
    var dayAfterOneYear: Date {
        return Calendar.current.date(byAdding: .year, value: 1, to: Date())!
    }
    
    var noon: Date {
        return Calendar.current.date(bySettingHour: 12, minute: 0, second: 0, of: self)!
    }
    
    var month: Int {
        return Calendar.current.component(.month,  from: self)
    }
    
    var isLastDayOfMonth: Bool {
        return dayAfter.month != month
    }
}
