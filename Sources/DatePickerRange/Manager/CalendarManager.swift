//
//  CalendarManager.swift
//  CustomDatePickerRange
//
//  Created by Ivan Maslennikov on 07.12.2024.
//

import Foundation

/// `CalendarManager` is a class responsible for managing calendar state and configurations
/// to facilitate custom date range selection.
public class CalendarManager: ObservableObject {
    
    // MARK: - Published Properties
    
    @Published public var startDate: Date? /// The start date of the selected range.
    @Published public var endDate: Date? /// The end date of the selected range.
    @Published public var selectedDates: [Date] = [] /// An array of selected dates within the range.
    @Published public var minimumDate: Date /// The earliest selectable date in the calendar.
    @Published public var maximumDate: Date /// The latest selectable date in the calendar.
    @Published var todayDate: Date? = Date() /// The current date, typically set to today's date.
    @Published var disabledDates: [Date] = [] /// A list of specific dates that are disabled and cannot be selected.
    @Published var calendar: Calendar = .current /// The calendar object used for date calculations (default is the current calendar).
    @Published var colors: ColorSettings = ColorSettings() /// Configurations for calendar colors.
    @Published var fonts: FontSettings = FontSettings() /// Configurations for calendar colors.
    public var isFutureSelectionEnabled: Bool /// Controls whether future dates can be selected (true) or past dates (false).
    
    // MARK: - Initialization
    
    /// Initializes a new instance of `CalendarManager`.
    /// - Parameters:
    ///   - calendar: The calendar object for date calculations (default is the current calendar).
    ///   - minimumDate: The earliest selectable date.
    ///   - maximumDate: The latest selectable date.
    ///   - selectedDates: An optional array of initially selected dates.
    ///   - isFutureSelectionEnabled: A Boolean value determining whether future or past dates are selectable.
    public init(
        calendar: Calendar = .current,
        minimumDate: Date,
        maximumDate: Date,
        selectedDates: [Date] = [],
        isFutureSelectionEnabled: Bool
    ) {
        self.calendar = calendar
        self.minimumDate = minimumDate
        self.maximumDate = maximumDate
        self.isFutureSelectionEnabled = isFutureSelectionEnabled
        self.updateRange()
    }
    
    // MARK: - Methods
    
    /// Checks whether a given date is disabled for selection.
    /// - Parameter date: The date to check.
    /// - Returns: `true` if the date is disabled; otherwise, `false`.
    public func isSelectedDateDisabled(date: Date) -> Bool {
        if self.disabledDates.contains(where: { calendar.isDate($0, inSameDayAs: date) }) {
            return true
        }
        return false
    }

    /// Generates a month header string based on an offset from the minimum date.
    /// - Parameter monthOffset: The number of months offset from the minimum date.
    /// - Returns: A formatted string representing the month and year (e.g., "December 2024").
    public func monthHeader(forMonthOffset monthOffset: Int) -> String {
        if let date = firstDateForMonthOffset(monthOffset) {
            return Helper.getMonthHeader(date: date)
        } else {
            return ""
        }
    }
    
    /// Calculates the first date of the month based on a given offset.
    /// - Parameter offset: The number of months to offset from the minimum date.
    /// - Returns: The first date of the resulting month.
    public func firstDateForMonthOffset(_ offset: Int) -> Date? {
        var offsetComponents = DateComponents()
        offsetComponents.month = offset
        return calendar.date(byAdding: offsetComponents, to: firstDateOfMonth())
    }
    
    /// Calculates the first date of the month based on the minimum selectable date.
    /// - Returns: The first date of the current month.
    public func firstDateOfMonth() -> Date {
        var components = calendar.dateComponents([.year, .month, .day], from: minimumDate)
        components.day = 1
        return calendar.date(from: components) ?? Date()
    }
    
    /// Updates the minimum and maximum selectable date ranges based on whether
    /// future selection is enabled or not.
    public func updateRange() {
        if isFutureSelectionEnabled {
            minimumDate = Date()
            maximumDate = calendar.date(byAdding: .year, value: 1, to: Date()) ?? Date()
        } else {
            minimumDate = calendar.date(byAdding: .year, value: -1, to: Date()) ?? Date()
            maximumDate = Date()
        }
    }
    
    /// Normalizes a given date to a consistent format, preserving only the year, month, and day components,
    /// and adjusting the time to 12:00 PM in the current time zone.
    ///
    /// This method is useful when working with dates where only the day matters (e.g., in calendars),
    /// avoiding issues caused by time zone differences or time-specific components.
    public func normalizeDate(date: Date) -> Date {
        var components = calendar.dateComponents([.year, .month, .day], from: date)
        components.timeZone = TimeZone.current
        components.hour = 12
        return calendar.date(from: components) ?? Date()
    }
}
