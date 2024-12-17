//
//  CalendarDate.swift
//  CustomDatePickerRange
//
//  Created by Ivan Maslennikov on 07.12.2024.
//

import SwiftUI

/// Represents a single calendar cell (date) with its associated properties and appearance configurations.
struct CalendarDate {
    
    // MARK: - Properties
    
    var date: Date /// The date associated with this calendar cell.
    var calendarManager: CalendarManager /// The calendar manager providing configurations and state for the calendar.
    var isDisabled: Bool = false /// Indicates whether the date is disabled and cannot be selected.
    var isToday: Bool = false /// Indicates whether the date is today's date.
    var isSelected: Bool = false /// Indicates whether the date is selected.
    var isBetweenStartAndEnd: Bool = false /// Indicates whether the date lies between the start and end dates of the range.
    
    // MARK: - Initialization
    
    /// Initializes a `CalendarDate` instance with specific state properties.
    /// - Parameters:
    ///   - date: The date represented by this calendar cell.
    ///   - manager: The `CalendarManager` instance managing configurations and state.
    ///   - isDisabled: A Boolean indicating whether the date is disabled. Default is `false`.
    ///   - isToday: A Boolean indicating whether the date is today's date. Default is `false`.
    ///   - isSelected: A Boolean indicating whether the date is selected. Default is `false`.
    ///   - isBetweenStartAndEnd: A Boolean indicating whether the date is part of the selected range. Default is `false`.
    init(
        date: Date,
        manager: CalendarManager,
        isDisabled: Bool = false,
        isToday: Bool = false,
        isSelected: Bool = false,
        isBetweenStartAndEnd: Bool = false
    ) {
        self.date = date
        self.calendarManager = manager
        self.isDisabled = isDisabled
        self.isToday = isToday
        self.isSelected = isSelected
        self.isBetweenStartAndEnd = isBetweenStartAndEnd
    }
    
    // MARK: - Methods
    
    /// Returns a formatted text representation of the date (day of the month).
    /// - Returns: A `String` representing the day of the month.
    func getText() -> String {
        formatDate(date: date)
    }
    
    /// Determines the text color based on the date's state.
    /// - Returns: A `Color` representing the text color.
    func getTextColor() -> Color {
        if isDisabled {
            return calendarManager.colors.disabledColor
        } else if isSelected {
            return calendarManager.colors.selectedColor
        } else if isToday {
            return calendarManager.colors.todayColor
        } else if isBetweenStartAndEnd {
            return calendarManager.colors.betweenStartAndEndColor
        }
        return calendarManager.colors.textColor
    }

    /// Determines the background color based on the date's state.
    /// - Returns: A `Color` representing the background color.
    func getBackgroundColor() -> Color {
        if isBetweenStartAndEnd {
            return calendarManager.colors.betweenStartAndEndBackColor
        } else if isDisabled {
            return calendarManager.colors.disabledBackColor
        } else if isSelected {
            return calendarManager.colors.selectedBackColor
        }
        return calendarManager.colors.textBackColor
    }
    
    /// Determines the font style based on the date's state.
    /// - Returns: A `Font` representing the text font.
    var font: Font {
        if isDisabled {
            return calendarManager.fonts.cellDisabledFont
        } else if isSelected {
            return calendarManager.fonts.cellSelectedFont
        } else if isToday {
            return calendarManager.fonts.cellTodayFont
        } else if isBetweenStartAndEnd {
            return calendarManager.fonts.cellBetweenStartAndEndFont
        }
        return calendarManager.fonts.cellUnselectedFont
    }
    
    /// Formats the given date into a string representation with medium style (e.g., Dec 7, 2024).
    /// - Parameter date: The date to format.
    /// - Returns: A `String` representation of the formatted date.
    func stringFormatDate(date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .medium
        dateFormatter.timeStyle = .none
        return dateFormatter.string(from: date)
    }

    /// Formats the given date to display only the day of the month.
    /// - Parameter date: The date to format.
    /// - Returns: A `String` representing the day of the month.
    func formatDate(date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "d"
        return dateFormatter.string(from: date)
    }
}
