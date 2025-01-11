//
//  Extensions.swift
//  CustomDatePickerRange
//
//  Created by Ivan Maslennikov on 06.12.2024.
//

import SwiftUI

/// Class containing color settings for customizing the appearance of the calendar elements.
public class ColorSettings: ObservableObject {
    // Сolor text
    var textColor: Color = Color.primary
    var todayColor: Color = Color.red
    var selectedColor: Color = Color.white
    var disabledColor: Color = Color.gray
    var betweenStartAndEndColor: Color = Color.white
    
    // Color background text
    var textBackColor: Color = Color.clear
    var todayBackColor: Color = Color.gray
    var selectedBackColor: Color = Color.red
    var disabledBackColor: Color = Color.clear
    var betweenStartAndEndBackColor: Color = Color.blue
    
    // Color text header
    var weekdayHeaderColor: Color = Color.primary
    var monthHeaderColor: Color = Color.primary
    var weekdayHeaderBackColor: Color = Color.clear
    
    // Color background header
    var monthBackColor: Color = Color.clear
}

/// Class containing font settings for customizing text appearance in the calendar.
public class FontSettings: ObservableObject {
    var monthHeaderFont: Font = Font.body.bold() /// Font for the month header.
    var weekdayHeaderFont: Font = Font.caption /// Font for the weekday header.
    var cellUnselectedFont: Font = Font.body /// Font for unselected cells.
    var cellDisabledFont: Font = Font.body.weight(.light) /// Font for disabled cells.
    var cellSelectedFont: Font = Font.body.bold() /// Font for selected cells.
    var cellTodayFont: Font = Font.body.bold() /// Font for today's date.
    var cellBetweenStartAndEndFont: Font = Font.body.bold() /// Font for dates between the start and end range.
}

/// Helper class containing utility functions for working with dates and calendar components.
class Helper {
    
    /// Retrieves abbreviated weekday names for the current calendar, adjusting for the first weekday.
    /// - Parameter calendar: The calendar instance.
    /// - Returns: An array of abbreviated weekday names in the correct order.
    static func getWeekdayHeaders(calendar: Calendar) -> [String] {
        let weekdays = calendar.shortStandaloneWeekdaySymbols
        let firstWeekdayIndex = calendar.firstWeekday - 1
        let adjustedWeekdays = Array(weekdays[firstWeekdayIndex...] + weekdays[..<firstWeekdayIndex])
        
        return adjustedWeekdays
    }
    
    /// Extracts the month number (1 to 12) from the provided date.
    /// - Parameter date: The date instance.
    /// - Returns: An integer representing the month (zero-based index).
    static func getMonthDayFromDate(date: Date) -> Int {
        let calendar = Calendar.current
        let components = calendar.dateComponents([.month], from: date)
        return components.month! - 1
    }
    
    /// Calculates the number of months between two dates.
    /// - Parameters:
    ///   - minDate: The start date.
    ///   - maxDate: The end date.
    /// - Returns: The number of months between the dates.
    static func numberOfMonth(_ minDate: Date, _ maxDate: Date) -> Int {
        let components = Calendar.current.dateComponents([.month], from: minDate, to: maxDate)
        return components.month! + 1
    }
    
    /// Finds the last day of the month for a given date.
    /// - Parameters:
    ///   - date: The reference date.
    ///   - calendar: The calendar to use (default is `.current`).
    /// - Returns: The last day of the month.
    static func lastDayOfMonth(date: Date, calendar: Calendar = .current) -> Date {
        var components = calendar.dateComponents([.year, .month], from: date)
        components.setValue(1, for: .day)
        
        guard let startMonth = calendar.date(from: components) else {
            fatalError("Invalid date components!")
        }
        
        return calendar.date(byAdding: .month, value: -1, to: startMonth)?.addingTimeInterval(-86500) ?? startMonth
    }
    
    /// Calculates the month offset between a date and the calendar's minimum date.
    /// - Parameters:
    ///   - calendar: The calendar manager instance.
    ///   - date: The reference date.
    /// - Returns: The month offset as an integer.
    static func getMonthOffsetForCurrent(calendar: CalendarManager, date: Date) -> Int {
        let currentYear = Calendar.current.component(.year, from: date)
        let currentMonth = Calendar.current.component(.month, from: date)
        
        let startYear = Calendar.current.component(.year, from: calendar.minimumDate)
        let startMonth = Calendar.current.component(.month, from: calendar.minimumDate)
        let monthOffset = (currentYear - startYear) * 12 + (currentMonth - startMonth)
        
        return monthOffset
    }
    
    /// Creates a date formatter for displaying day and month (e.g., "5 December").
    /// - Returns: A configured `DateFormatter` instance.
    static func dateFormatter() -> DateFormatter {
        let formatter = DateFormatter()
        formatter.dateFormat = "d MMMM"
        return formatter
    }
    
    /// Formats a date into a human-readable string.
    /// - Parameter date: The optional date to format.
    /// - Returns: A formatted string or "Not selected" if the date is nil.
    static func formattedDate(_ date: Date?) -> String {
        guard let date = date else {
            return NSLocalizedString("Not selected", comment: "")
        }
        return dateFormatter().string(from: date)
    }
    
    /// Retrieves a formatted string for the month and year header (e.g., "December 2024").
    /// - Parameter date: The date for which the header is generated.
    /// - Returns: A capitalized string with the month and year.
    static func getMonthHeader(date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "LLLL yyyy"
        return dateFormatter.string(from: date).capitalized
    }
}
