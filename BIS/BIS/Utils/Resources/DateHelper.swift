//
//  DateHelper.swift
//  BIS
//
//  Created by TSSIOS on 05/07/20.
//  Copyright © 2020 TSSIOS. All rights reserved.
//

import Foundation

class DateHelper {
    static var filterYearArray: [(String, Bool)] {
        var arr = [(String, Bool)]()
        for case let index: Int in (Date.currentYear - 5)..<(Date.currentYear + 6) {
            arr.append(("\(index)", false))
        }
        return arr
    }

    static var filterMonthArray: [(String, Bool)] {
        return Date.currentMonthList.map {($0, false)}
    }

    class func filterDaysArray (year: Int, month: Int, week: Int) -> [(String, Bool)] {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let weekOfYear = getWeekOfYearFromMonth(weekNumber: week, month: month, year: year)
        let strDate = getFirstDay(WeekNumber: weekOfYear, CurrentYear: year)
        let date = Date.init(string: strDate, formatter: dateFormatter)?.getLocalDate()

        return date!.numberOfDaysInWeek(month: month, year: year).map {("\($0)", false)}
    }

    class func filterWeekArray (year: Int, month: Int) -> [(String, Bool)] {
        let calendar = Calendar.current
        let dateComponents = DateComponents(year: year, month: month, day: 10)
        let date = calendar.date(from: dateComponents)!

        var arr = [(String, Bool)]()
        for case let index: Int in 1..<(date.numberOfWeeks() + 1) {
            arr.append(("\(index)", false))
        }
        return arr
    }

    class func getWeekOfYearFromMonth(weekNumber: Int, month: Int, year: Int) -> Int {
        let calendar = NSCalendar(calendarIdentifier: .gregorian)!
        var dayComponent = DateComponents()
        dayComponent.weekOfMonth = weekNumber
        dayComponent.month = month
        dayComponent.weekday = 1
        dayComponent.yearForWeekOfYear = year
        var date = calendar.date(from: dayComponent)
        if calendar.component(.weekOfYear, from: date!) == 1 && month != 1 {
            dayComponent.weekOfMonth = weekNumber - 1
            date = calendar.date(from: dayComponent)
            return calendar.component(.weekOfYear, from: date!) + 1
        }
        return calendar.component(.weekOfYear, from: date!)
    }

    class func getFirstDay(WeekNumber weekNumber: Int, CurrentYear currentYear: Int) -> String? {
        let Calendar = NSCalendar(calendarIdentifier: .gregorian)!
        var dayComponent = DateComponents()
        dayComponent.weekOfYear = weekNumber
        dayComponent.weekday = 1
        dayComponent.year = currentYear
        var date = Calendar.date(from: dayComponent)

        if weekNumber == 1 && Calendar.components(.month, from: date!).month != 1 {
            //print(Calendar.components(.month, from: date!).month)
            dayComponent.year = currentYear - 1
            date = Calendar.date(from: dayComponent)
        }
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        return String(dateFormatter.string(from: date!))
    }
}
