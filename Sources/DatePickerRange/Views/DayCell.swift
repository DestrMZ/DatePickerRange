//
//  DellCell.swift
//  CustomDatePickerRange
//
//  Created by Ivan Maslennikov on 07.12.2024.
//

import Foundation
import SwiftUI

/// A view that represents a single calendar day cell with styles and states based on the provided date attributes.
///
/// This view is used to display a day in the calendar with different styling based on whether the date is selected, today, disabled, or part of a date range.
struct DayCell: View {
    
    /// The `CalendarDate` object representing the date for this cell.
    var calendarDate: CalendarDate
    
    /// The width of the cell, typically used to define its size.
    var cellWidth: CGFloat
    
    /// The corner radius for rounding the edges of the cell. Default is 32.
    var radius: CGFloat = 32
    
    var body: some View {
        Text(calendarDate.getText())
            .font(calendarDate.font)
            .foregroundColor(calendarDate.getTextColor())
            .frame(width: cellWidth, height: cellWidth)
            .background(
                RoundedRectangle(cornerRadius: radius)
                    .fill(calendarDate.getBackgroundColor())
            )
            .frame(maxWidth: .infinity, alignment: .center)
    }
}

#Preview {
    Group {
        DayCell(
            calendarDate: CalendarDate(
                date: Date(),
                manager: CalendarManager(
                    calendar: Calendar.current,
                    minimumDate: Date(),
                    maximumDate: Date().addingTimeInterval(60 * 60 * 24 * 365),  // One year from now
                    isFutureSelectionEnabled: false
                ),
                isDisabled: false,
                isToday: false,
                isSelected: false,
                isBetweenStartAndEnd: false
            ),
            cellWidth: 32
        )
        
        /// A preview of the DayCell for today's date
        DayCell(
            calendarDate: CalendarDate(
                date: Date(),
                manager: CalendarManager(
                    calendar: Calendar.current,
                    minimumDate: Date(),
                    maximumDate: Date().addingTimeInterval(60 * 60 * 24 * 365),
                    isFutureSelectionEnabled: false
                ),
                isDisabled: false,
                isToday: true,
                isSelected: false,
                isBetweenStartAndEnd: false
            ),
            cellWidth: 32
        )
    }
}
