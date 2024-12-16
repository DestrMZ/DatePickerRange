//
//  WeekDayHeader.swift
//  CustomDatePickerRange
//
//  Created by Ivan Maslennikov on 09.12.2024.
//

import SwiftUI

struct WeekDayHeader: View {
    
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
        minimumDate: Date().addingTimeInterval(-60 * 60 * 24 * 30 * 2),
        maximumDate: Date().addingTimeInterval(60 * 60 * 24 * 30 * 2),
        isFutureSelectionEnabled: false
    )
    
    WeekDayHeader()
        .environmentObject(calendarManager)
}
