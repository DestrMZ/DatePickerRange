//
//  RangeCalendar.swift
//  CustomDatePickerRange
//
//  Created by Ivan Maslennikov on 09.12.2024.
//

import SwiftUI

/// A calendar picker view that displays a range of selectable months and dates.
/// The view includes a date header, weekday headers, and a scrollable list of months.
struct CalendarPicker: View {
    
    /// Access to the shared `CalendarManager` environment object.
    @EnvironmentObject var calendarManager: CalendarManager
    
    /// Computes the total number of months to display based on the minimum and maximum date range.
    var numberOfMonths: Int {
        Helper.numberOfMonth(calendarManager.minimumDate, calendarManager.maximumDate)
    }
    
    var body: some View {
        VStack(spacing: 0) {
            /// Displays the header for date selection, showing selected start and end dates.
            HeaderDateSelect()
            
            /// Displays the header with the abbreviated weekday names.
            WeekDayHeader()
            
            /// Provides scrollable navigation for months.
            ScrollViewReader { reader in
                ScrollView(.vertical, showsIndicators: false) {
                    LazyVStack(spacing: 32) {
                        /// Generates a view for each month in the specified range.
                        ForEach(0..<numberOfMonths, id: \.self) { index in
                            /// Displays the month's calendar view with the appropriate offset.
                            MonthView(calendarManager: self._calendarManager, monthOffset: index)
                        }
                    }
                    .padding()
                }
                /// Automatically scrolls to the current month on the initial load.
                .onAppear {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                        if let date = calendarManager.todayDate {
                            let monthOffset = Helper.getMonthOffsetForCurrent(calendar: calendarManager, date: date)
                            reader.scrollTo(monthOffset, anchor: .center)  // Scrolls to the current month
                        }
                    }
                }
            }
        }
        /// Sets the background color for the entire view.
        .background(calendarManager.colors.textBackColor.ignoresSafeArea())
    }
}

#Preview {
    /// Example preview for `CalendarPicker` with a defined date range.
    let calendarManager = CalendarManager(
        minimumDate: Date().addingTimeInterval(-60 * 60 * 24 * 30 * 2),  // 2 months ago
        maximumDate: Date().addingTimeInterval(60 * 60 * 24 * 30 * 2),   // 2 months ahead
        isFutureSelectionEnabled: false
    )
    
    CalendarPicker()
        .environmentObject(calendarManager)
}
