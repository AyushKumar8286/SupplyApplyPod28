//
//  DateTimeHelper.swift
//  Deponet-Options
//
//  Created by SunTec on 17/01/19.
//  Copyright © 2019 Mac6. All rights reserved.
//

import Foundation

class DateTimeHelper {
    class func getDefaultFormatedDateForUI(dateString : String)-> String{
        let dateStr = dateString.prefix(19)
        let isoFormatter = ISO8601DateFormatter()
        let mDate = isoFormatter.date(from: "\(dateStr)Z")!
       
        let dateFormatterGet = DateFormatter()
        dateFormatterGet.dateFormat = "dd/MM/yyyy" // date format that needed
        return dateFormatterGet.string(from: mDate)
    }
    
    class func getDefaultFormatedTimeForUI(dateString : String)-> String{
           let dateStr = dateString.prefix(19)
           let isoFormatter = ISO8601DateFormatter()
           let mDate = isoFormatter.date(from: "\(dateStr)Z")!
          
           let dateFormatterGet = DateFormatter()
           dateFormatterGet.dateFormat = "HH:mm" // date format that needed
           return dateFormatterGet.string(from: mDate)
       }
    
    class func getDateFromString(dateString : String)->Date{
        let dateStr = dateString.prefix(19)
        let isoFormatter = ISO8601DateFormatter() //received date format
        let mDate = isoFormatter.date(from: "\(dateStr)Z")!
        return mDate
    }
    
    class func getStringFromDate(date : Date) -> String{
        let isoFormatter = ISO8601DateFormatter() //received date format
        let mDate = isoFormatter.string(from: date)
        return mDate
    }
    
}
