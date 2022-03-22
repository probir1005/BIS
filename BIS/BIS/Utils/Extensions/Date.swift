//
//  Date.swift
//
//  Created by Mukesh Yadav on 02/08/17.
//  Copyright © 2017 Mukesh Yadav. All rights reserved.
//

import Foundation
import UIKit

extension DateFormatter {
    
    static let serverDateFormat: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter
    }()
    
    ///This will habdle the case when device is set to 24 hour format
    func setLocal() {
        var identifier = self.locale.identifier
        if !identifier.hasSuffix("_POSIX") {
            identifier += "_POSIX"
            let locale = NSLocale(localeIdentifier: identifier)
            self.locale = locale as Locale
        }
    }
}

extension Date {

    static var currentYear: Int {
        let year = Calendar.current.component(.year, from: Date())
        return year
    }

    static var currentMonth: Int {
        let month = Calendar.current.component(.month, from: Date())
        return month
    }

    static var currentWeek: Int {
        let week = Calendar.current.component(.weekOfMonth, from: Date())
        return week
    }

    static var currentWeekOfYear: Int {
        let week = Calendar.current.component(.weekOfYear, from: Date())
        return week
    }

    static var currentDate: Date {

       let nowUTC = Date()
        let timeZoneOffset = Double(TimeZone.current.secondsFromGMT(for: nowUTC))
        guard let localDate = Calendar.current.date(byAdding: .second, value: Int(timeZoneOffset), to: nowUTC) else {return Date()}

        return localDate
    }

    static var currentDay: Int {
        var calendar = Calendar.current
        calendar.timeZone = TimeZone.current
        let day = Calendar.current.component(.day, from: currentDate)
        return day
    }

    static var currentMonthList: [String] {
        let monthList = Calendar.current.shortMonthSymbols
        return monthList
    }

    func getLocalDate() -> Date {
        let nowUTC = self
        let timeZoneOffset = Double(TimeZone.current.secondsFromGMT(for: nowUTC))
        guard let localDate = Calendar.current.date(byAdding: .second, value: Int(timeZoneOffset), to: nowUTC) else {return self}

        return localDate
    }

    func numberOfDaysInWeek(month: Int, year: Int) -> [Date] {
        let calendar = Calendar.current

        var components = calendar.dateComponents([.month, .year], from: self)
        components.month = month
        components.year = year
        let dayOfWeek = calendar.component(.weekday, from: self)
        let weekdays = calendar.range(of: .weekday, in: .weekOfMonth, for: self)!
        let days = (weekdays.lowerBound ..< weekdays.upperBound)
            .compactMap { calendar.date(byAdding: .day, value: $0 - dayOfWeek, to: self) }

        print(days.filter { calendar.date($0, matchesComponents: components) == true })
        return days.filter { calendar.date($0, matchesComponents: components) == true }
    }

    func numberOfWeeks() -> Int {
        let calendar = Calendar.current

        let numberOfWeeks = calendar.range(of: .weekOfMonth, in: .month, for: self)
        return numberOfWeeks?.count ?? 0
    }

    /// Prints a string representation for the date with the given formatter
    func string(with format: DateFormatter) -> String {
        return format.string(from: self)
    }
    
    /// Creates an `Date` from the given string and formatter. Nil if the string couldn't be parsed
    init?(string: String?, formatter: DateFormatter) {
        guard let date = formatter.date(from: string ?? "") else { return nil }
        self.init(timeIntervalSince1970: date.timeIntervalSince1970)
    }

    static var dateDefaultDecoder: JSONDecoder.DateDecodingStrategy {
        return .custom({ decoder in
            let container = try decoder.singleValueContainer()
            let dateString = try container.decode(String.self)

            let f1 = DateFormatter()
            f1.dateFormat = "yyyy-MM-dd"

            if let date = f1.date(from: dateString) {
                return date
            } else {
                throw DebugError(message: "No sutable date formatter.")
            }
        })
    }
}

class Time: Comparable, Equatable {
    init(_ date: Date) {
        //get the current calender
        let calendar = Calendar.current
        
        //get just the minute and the hour of the day passed to it
        let dateComponents = calendar.dateComponents([.hour, .minute], from: date)
        
        //calculate the seconds since the beggining of the day for comparisions
        let dateSeconds = dateComponents.hour! * 3600 + dateComponents.minute! * 60
        
        //set the varibles
        secondsSinceBeginningOfDay = dateSeconds
        hour = dateComponents.hour!
        minute = dateComponents.minute!
    }
    
    init(_ hour: Int, _ minute: Int) {
        //calculate the seconds since the beggining of the day for comparisions
        let dateSeconds = hour * 3600 + minute * 60
        
        //set the varibles
        secondsSinceBeginningOfDay = dateSeconds
        self.hour = hour
        self.minute = minute
    }
    
    var hour: Int
    var minute: Int
    
    var date: Date {
        //get the current calender
        let calendar = Calendar.current
        
        //create a new date components.
        var dateComponents = DateComponents()
        
        dateComponents.hour = hour
        dateComponents.minute = minute
        
        return calendar.date(byAdding: dateComponents, to: Date())!
    }
    
    /// the number or seconds since the beggining of the day, this is used for comparisions
    private let secondsSinceBeginningOfDay: Int
    
    //comparisions so you can compare times
    static func == (lhs: Time, rhs: Time) -> Bool {
        return lhs.secondsSinceBeginningOfDay == rhs.secondsSinceBeginningOfDay
    }
    
    static func < (lhs: Time, rhs: Time) -> Bool {
        return lhs.secondsSinceBeginningOfDay < rhs.secondsSinceBeginningOfDay
    }
    
    static func <= (lhs: Time, rhs: Time) -> Bool {
        return lhs.secondsSinceBeginningOfDay <= rhs.secondsSinceBeginningOfDay
    }

    static func >= (lhs: Time, rhs: Time) -> Bool {
        return lhs.secondsSinceBeginningOfDay >= rhs.secondsSinceBeginningOfDay
    }

    static func > (lhs: Time, rhs: Time) -> Bool {
        return lhs.secondsSinceBeginningOfDay > rhs.secondsSinceBeginningOfDay
    }
}
