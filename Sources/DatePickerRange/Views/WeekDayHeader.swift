//
//  WeekDayHeader.swift
//  CustomDatePickerRange
//
//  Created by Ivan Maslennikov on 09.12.2024.
//

import SwiftUI

/// A view displaying the weekday header for the calendar.
struct WeekDayHeader: View {
    
    // Environment object for managing the calendar settings.
    @EnvironmentObject var calendarManager: CalendarManager
    
    var body: some View {
        VStack(spacing: 8) {
            WeekdayHeaderView()
                .padding(.horizontal)
                .padding(.top)
            
            Divider()
        }
    }
}

#Preview {
    let calendarManager = CalendarManager(
        minimumDate: Date().addingTimeInterval(-60 * 60 * 24 * 30 * 2), // Two months ago.
        maximumDate: Date().addingTimeInterval(60 * 60 * 24 * 30 * 2), // Two months ahead.
        isFutureSelectionEnabled: false
    )
    
    WeekDayHeader()
        .environmentObject(calendarManager)
}
