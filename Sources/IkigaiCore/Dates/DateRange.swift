//
//  DateRange.swift
//  IkigaiAPI
//
//  Created by Vince Davis on 2/26/25.
//


import Foundation

/// An enumeration representing various common date ranges.
public enum DateRange {
    case today
    case yesterday
    case thisWeek
    case last7Days
    case lastDays(Int)
    case thisMonth
    case lastMonth
    case thisYear
    case lastYear
    case custom(start: Date, end: Date)
    
    /// A computed property that returns a tuple containing the start and end dates corresponding to the date range.
    public var range: (start: Date, end: Date) {
        let calendar = Calendar.current
        let now = Date()
        
        switch self {
        case .today:
            let startOfDay = calendar.startOfDay(for: now)
            guard let endOfDay = calendar.date(byAdding: DateComponents(day: 1, second: -1), to: startOfDay) else {
                fatalError("Could not compute end of day")
            }
            return (start: startOfDay, end: endOfDay)
            
        case .yesterday:
            guard let yesterday = calendar.date(byAdding: .day, value: -1, to: now) else {
                fatalError("Could not compute yesterday")
            }
            let startOfDay = calendar.startOfDay(for: yesterday)
            guard let endOfDay = calendar.date(byAdding: DateComponents(day: 1, second: -1), to: startOfDay) else {
                fatalError("Could not compute end of yesterday")
            }
            return (start: startOfDay, end: endOfDay)
            
        case .thisWeek:
            // Calculate the start of the week according to the current calendar.
            guard let weekInterval = calendar.dateInterval(of: .weekOfYear, for: now) else {
                fatalError("Could not compute start of week")
            }
            // End is 7 days from the start, minus one second.
            guard let endOfWeek = calendar.date(byAdding: DateComponents(day: 7, second: -1), to: weekInterval.start) else {
                fatalError("Could not compute end of week")
            }
            return (start: weekInterval.start, end: endOfWeek)
            
        case .last7Days:
            // To include today in the 7-day range, subtract 6 days.
            guard let startDate = calendar.date(byAdding: .day, value: -6, to: now) else {
                fatalError("Could not compute start date for last7Days")
            }
            let startOfDay = calendar.startOfDay(for: startDate)
            // End is set to the end of today.
            let todayStart = calendar.startOfDay(for: now)
            guard let endOfDay = calendar.date(byAdding: DateComponents(day: 1, second: -1), to: todayStart) else {
                fatalError("Could not compute end of today")
            }
            return (start: startOfDay, end: endOfDay)
            
        case .lastDays(let days):
            // To include today in the range, subtract (days - 1) from today.
            guard days > 0 else {
                fatalError("Days must be greater than 0")
            }
            guard let startDate = calendar.date(byAdding: .day, value: -(days - 1), to: now) else {
                fatalError("Could not compute start date for lastDays")
            }
            let startOfDay = calendar.startOfDay(for: startDate)
            let todayStart = calendar.startOfDay(for: now)
            guard let endOfDay = calendar.date(byAdding: DateComponents(day: 1, second: -1), to: todayStart) else {
                fatalError("Could not compute end of today")
            }
            return (start: startOfDay, end: endOfDay)
            
        case .thisMonth:
            let components = calendar.dateComponents([.year, .month], from: now)
            guard let startOfMonth = calendar.date(from: components) else {
                fatalError("Could not compute start of month")
            }
            var monthComponent = DateComponents(month: 1, second: -1)
            guard let endOfMonth = calendar.date(byAdding: monthComponent, to: startOfMonth) else {
                fatalError("Could not compute end of month")
            }
            return (start: startOfMonth, end: endOfMonth)
            
        case .lastMonth:
            let components = calendar.dateComponents([.year, .month], from: now)
            guard let startOfThisMonth = calendar.date(from: components),
                  let startOfLastMonth = calendar.date(byAdding: .month, value: -1, to: startOfThisMonth) else {
                fatalError("Could not compute start of last month")
            }
            var monthComponent = DateComponents(month: 1, second: -1)
            guard let endOfLastMonth = calendar.date(byAdding: monthComponent, to: startOfLastMonth) else {
                fatalError("Could not compute end of last month")
            }
            return (start: startOfLastMonth, end: endOfLastMonth)
            
        case .thisYear:
            let components = calendar.dateComponents([.year], from: now)
            guard let startOfYear = calendar.date(from: components) else {
                fatalError("Could not compute start of year")
            }
            var yearComponent = DateComponents(year: 1, second: -1)
            guard let endOfYear = calendar.date(byAdding: yearComponent, to: startOfYear) else {
                fatalError("Could not compute end of year")
            }
            return (start: startOfYear, end: endOfYear)
            
        case .lastYear:
            let components = calendar.dateComponents([.year], from: now)
            guard let startOfThisYear = calendar.date(from: components),
                  let startOfLastYear = calendar.date(byAdding: .year, value: -1, to: startOfThisYear) else {
                fatalError("Could not compute start of last year")
            }
            var yearComponent = DateComponents(year: 1, second: -1)
            guard let endOfLastYear = calendar.date(byAdding: yearComponent, to: startOfLastYear) else {
                fatalError("Could not compute end of last year")
            }
            return (start: startOfLastYear, end: endOfLastYear)
            
        case .custom(let start, let end):
            return (start: start, end: end)
        }
    }
    
    /// A computed property that returns a user-friendly name for the date range.
    public var name: String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .medium
        
        switch self {
        case .today:
            return "Today"
        case .yesterday:
            return "Yesterday"
        case .thisWeek:
            return "This Week"
        case .last7Days:
            return "Last 7 Days"
        case .lastDays(let days):
            return "Last \(days) Days"
        case .thisMonth:
            return "This Month"
        case .lastMonth:
            return "Last Month"
        case .thisYear:
            return "This Year"
        case .lastYear:
            return "Last Year"
        case .custom(let start, let end):
            let startStr = dateFormatter.string(from: start)
            let endStr = dateFormatter.string(from: end)
            return "Custom (\(startStr) - \(endStr))"
        }
    }
}
