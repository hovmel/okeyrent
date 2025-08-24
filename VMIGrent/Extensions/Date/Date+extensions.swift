//
//  Date+extensions.swift
//  VMIGrent
//
//  Created by Mikhail Koroteev on 26.06.2022.
//

import Foundation

extension DateFormatter {
    
    static let full: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        formatter.calendar = Calendar(identifier: .iso8601)
        formatter.timeZone = TimeZone.current
        formatter.locale = Locale.current
        return formatter
    }()
    
    //    static let full: DateFormatter = {
    //        let formatter = DateFormatter()
    //        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZZZZZ"
    //        formatter.calendar = Calendar(identifier: .iso8601)
    //        formatter.timeZone = TimeZone(secondsFromGMT: 0)
    //        formatter.locale = Locale(identifier: "en_US_POSIX")
    //        return formatter
    //    }()
    
    static let yyyy: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy"
        formatter.calendar = Calendar(identifier: .iso8601)
        formatter.timeZone = TimeZone.current//TimeZone(secondsFromGMT: 0)
        formatter.locale = Locale.current
        return formatter
    }()
    
    static let yyyyMMdd: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        formatter.calendar = Calendar(identifier: .iso8601)
        formatter.timeZone = TimeZone.current//TimeZone(secondsFromGMT: 0)
        formatter.locale = Locale.current
        return formatter
    }()
    
    static let hoursAndMnutes: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm"
        formatter.locale = Locale.current
        formatter.timeZone = TimeZone.current//TimeZone(abbreviation: "UTC")
        return formatter
    }()
    
    static let hoursAndMnutesAndSeconds: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm:ss"
        formatter.locale = Locale.current
        formatter.timeZone = TimeZone.current//TimeZone(abbreviation: "UTC")
        return formatter
    }()
    
    
    static let ddMMM: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd MMMM"
        formatter.calendar = Calendar(identifier: .iso8601)
        formatter.timeZone = TimeZone.current//TimeZone(secondsFromGMT: 0)
        formatter.locale = Locale.current
        return formatter
    }()
    
    static let ddMM: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd.MM"
        formatter.calendar = Calendar(identifier: .iso8601)
        formatter.timeZone = TimeZone.current//TimeZone(secondsFromGMT: 0)
        formatter.locale = Locale(identifier: "ru_RU")
        return formatter
    }()
    
    static let ddMMMyyyy: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd MMMM yyyy "
        formatter.calendar = Calendar(identifier: .iso8601)
        formatter.timeZone = TimeZone.current//TimeZone(secondsFromGMT: 0)
        formatter.locale = Locale.current
        return formatter
    }()
    
    static let MMMyyyy: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMM yyyy"
        formatter.calendar = Calendar(identifier: .iso8601)
        formatter.timeZone = TimeZone.current//TimeZone(secondsFromGMT: 0)
        formatter.locale = Locale(identifier: "ru_RU")
        return formatter
    }()
    
    static let MMMMyyyy: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMMM yyyy"
        formatter.calendar = Calendar(identifier: .iso8601)
        formatter.timeZone = TimeZone.current//TimeZone(secondsFromGMT: 0)
        formatter.locale = Locale(identifier: "ru_RU")
        return formatter
    }()
    
    static let LLLLyyyy: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "LLLL yyyy"
        formatter.calendar = Calendar(identifier: .iso8601)
        formatter.timeZone = TimeZone.current//TimeZone(secondsFromGMT: 0)
        formatter.locale = Locale.current
        return formatter
    }()
    
    static let MMM: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMM"
        formatter.calendar = Calendar(identifier: .iso8601)
        formatter.timeZone = TimeZone.current//TimeZone(secondsFromGMT: 0)
        formatter.locale = Locale.current
        return formatter
    }()
    
    static let relativeDate: DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale.current // Using system locale
        dateFormatter.doesRelativeDateFormatting = true // Enabling relative date formatting
        dateFormatter.timeStyle = .none
        dateFormatter.dateStyle = .medium
        return dateFormatter
    }()
    
    static let ddMMMMhhmm: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd MMMM, HH:mm"
        formatter.calendar = Calendar(identifier: .iso8601)
        formatter.timeZone = TimeZone.current//TimeZone(secondsFromGMT: 0)
        formatter.locale = Locale.current
        return formatter
    }()
    
    static let ddMMMMyyyyhhmm: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd MMMM yyyy, HH:mm"
        formatter.calendar = Calendar(identifier: .iso8601)
        formatter.timeZone = TimeZone.current//TimeZone(secondsFromGMT: 0)
        formatter.locale = Locale.current
        return formatter
    }()
    
    static let hours: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "HH"
        formatter.calendar = Calendar(identifier: .iso8601)
        formatter.timeZone = TimeZone.current//TimeZone(secondsFromGMT: 0)
        formatter.locale = Locale.current
        return formatter
    }()
    
    static let weekdayDay: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "EEEE, MMMM dd"
        formatter.calendar = Calendar(identifier: .iso8601)
        formatter.timeZone = TimeZone.current//TimeZone(secondsFromGMT: 0)
        formatter.locale = Locale.current
        return formatter
    }()
}

extension Date {
    func startOfMonth() -> Date {
        return Calendar.current.date(from: Calendar.current.dateComponents([.year, .month], from: Calendar.current.startOfDay(for: self)))!
    }
    
    func endOfMonth() -> Date {
        return Calendar.current.date(byAdding: DateComponents(month: 1, day: -1), to: self.startOfMonth())!
    }
}

extension Date {
    func get(_ components: Calendar.Component..., calendar: Calendar = Calendar.current) -> DateComponents {
        return calendar.dateComponents(Set(components), from: self)
    }

    func get(_ component: Calendar.Component, calendar: Calendar = Calendar.current) -> Int {
        return calendar.component(component, from: self)
    }
}
