//
//  DateConverter.swift
//  MySchollKinect
//
//  Created by Admin on 07/04/20.
//  Copyright © 2020 Admin. All rights reserved.
//

import Foundation

extension Date
{
    func ConvertDate() -> String?
    {
        let dateFormatter = DateFormatter.init()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        return dateFormatter.string(from: self)
    }
    
    func ConvertTime() -> String?
    {
        let dateFormatter = DateFormatter.init()
        dateFormatter.dateFormat = "hh:mm a"
        return dateFormatter.string(from: self)
    }
    
    func ConvertToDate(date:String) -> Date?
    {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        dateFormatter.dateFormat = "yyyy-MM-dd"
        return dateFormatter.date(from: date)
    }
    
    func ConvertToDateInnServerTime(date:String) -> Date?
    {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
        dateFormatter.timeZone = NSTimeZone(name: "UTC") as TimeZone?
        //let date1 = dateFormatter.date(from: date.components(separatedBy: ".").first ?? "")
        return dateFormatter.date(from: date.components(separatedBy: ".").first ?? "")
    }
    
    
    func convertDate() -> String?
    {
        let dateFormatter = DateFormatter.init()
        dateFormatter.dateFormat = "yyyy-MM-dd" //[{"key":"date_of_birth","value":"1996-04-21","description":"yyyy-mm-dd","type":"text"}]
        return dateFormatter.string(from: self)
    }
    
    
    
    
    
    
    func timeAgoSinceDate() -> String {
        
        // From Time
        let fromDate = self
        
        // To Time
        let toDate = Date()
        
        // Estimation
        // Year
        if let interval = Calendar.current.dateComponents([.year], from: fromDate, to: toDate).year, interval > 0  {
            return interval == 1 ? "\(interval)" + " " + "year ago" : "\(interval)" + " " + "years ago"
        }
        
        // Month
        if let interval = Calendar.current.dateComponents([.month], from: fromDate, to: toDate).month, interval > 0  {
            return interval == 1 ? "\(interval)" + " " + "month ago" : "\(interval)" + " " + "months ago"
        }
        
        // Day
        if let interval = Calendar.current.dateComponents([.day], from: fromDate, to: toDate).day, interval > 0  {
            
            return interval == 1 ? "\(interval)" + " " + "day ago" : "\(interval)" + " " + "days ago"
        }
        
        // Hours
        if let interval = Calendar.current.dateComponents([.hour], from: fromDate, to: toDate).hour, interval > 0 {
            
            return interval == 1 ? "an hour ago" : "\(interval)" + " " + "hours ago"
        }
        
        // Minute
        if let interval = Calendar.current.dateComponents([.minute], from: fromDate, to: toDate).minute, interval > 0 {
            
            return interval == 1 ?  "Just now" : "\(interval)" + " " + "minutes ago"
        }
        
        return "Just now"
    }
    
    
    
}



extension DateComponentsFormatter {
    func difference(from fromDate: Date, to toDate: Date) -> String? {
        self.allowedUnits = [.year,.month,.weekOfMonth,.day]
        self.maximumUnitCount = 1
        self.unitsStyle = .full
        return self.string(from: fromDate, to: toDate)
    }
}

extension Double {

    func truncate(places: Int) -> Double {

        let multiplier = pow(10, Double(places))
        let newDecimal = multiplier * self // move the decimal right
        let truncated = Double(Int(newDecimal)) // drop the fraction
        let originalDecimal = truncated / multiplier // move the decimal back
        return originalDecimal

    }

}

func formatNumber(_ n: Int) -> String {

    let num = abs(Double(n))
    let sign = (n < 0) ? "-" : ""

    switch num {

    case 1_000_000_000...:
        var formatted = num / 1_000_000_000
        formatted = formatted.truncate(places: 1)
        return "\(sign)\(formatted)B"

    case 1_000_000...:
        var formatted = num / 1_000_000
        formatted = formatted.truncate(places: 1)
        return "\(sign)\(formatted)M"

    case 1_000...:
        var formatted = num / 1_000
        formatted = formatted.truncate(places: 1)
        return "\(sign)\(formatted)K"

    case 0...:
        return "\(n)"

    default:
        return "\(sign)\(n)"

    }

}
extension String {
    func ConvertToDate() -> Date?
    {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
        let string = "2015-06-30T17:30:36.000Z"
        return dateFormatter.date(from: string)
    }
    func ConvertToDate(stringDate:String) -> String?
    {
        let dateFormatter = DateFormatter()
        //dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let finalDate = dateFormatter.date(from:   stringDate)
        dateFormatter.dateFormat = "MM/dd/yyyy"
        let finalstringDate = dateFormatter.string(from: finalDate ?? Date())
        return finalstringDate
        
    }
    
    func ConvertToDate1(stringDate:String) -> String?
    {
        
        if stringDate == ""{
            return ""
        }
        
        let dateFormatter = DateFormatter()
        //dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let finalDate = dateFormatter.date(from:   stringDate)
        dateFormatter.dateFormat = "MM-dd-yyyy"
        let finalstringDate = dateFormatter.string(from: finalDate ?? Date())
        return finalstringDate
        
    }
    
    func ConvertTostingDate(stringDate:String) -> Date?
       {
           let dateFormatter = DateFormatter()
           //dateFormatter.locale = Locale(identifier: "en_US_POSIX")
           dateFormatter.dateFormat = "yyyy-MM-dd"
           let finalDate = dateFormatter.date(from:   stringDate)
           return finalDate
           
       }
    
    
    func ConvertToStirgDate(stringDate:String) -> Date?
    {
        let dateFormatter = DateFormatter()
        //dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let finalDate = dateFormatter.date(from:stringDate)
        return finalDate
        
    }
    
    func ConvertTotime(stringtime:String) -> String?
    {
        let dateFormatter = DateFormatter()
        //dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        dateFormatter.dateFormat = "HH:mm:ss"
        let finalDate = dateFormatter.date(from:stringtime)
        dateFormatter.dateFormat = "hh:mm a"
        let time = dateFormatter.string(from: finalDate ?? Date())
        return time
        
    }
}
