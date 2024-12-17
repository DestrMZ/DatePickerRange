//
//  HeaderDateSelect.swift
//  CustomDatePickerRange
//
//  Created by Ivan Maslennikov on 14.12.2024.
//

import SwiftUI

/// A view that displays the start and end dates, along with a visual indicator for the date range selection.
///
/// This component is part of the custom date picker range UI, showing the selected start and end dates,
/// and a visual bar indicating the range selected by the user.
struct HeaderDateSelect: View {

    /// An environment object representing the calendar manager that handles the logic for date selection.
    @EnvironmentObject var calendarMananger: CalendarManager
    
    var body: some View {
        GeometryReader { geometry in
            VStack(spacing: 5) {
                HStack {
                    VStack {
                        Text("Start date")
                            .foregroundColor(.secondary)
                            .font(.subheadline)
                        
                        Text("\(Helper.formattedDate(calendarMananger.startDate))")
                            .font(.headline)
                    }
                    Spacer()
                    
                    VStack {
                        Text("End date")
                            .foregroundColor(.secondary)
                            .font(.subheadline)
                        
                        Text("\(Helper.formattedDate(calendarMananger.endDate))")
                            .font(.headline)
                    }
                }
                .padding(.horizontal, 40)
                
                ZStack(alignment: .leading) {
                    
                    Color.gray.opacity(0.2)
                        .frame(height: 4)
                        .cornerRadius(2)
                    
                    Color.blue
                        .frame(width: calendarMananger.startDate == nil ? geometry.size.width * 0.5 : geometry.size.width * 0.5, height: 4)
                        .cornerRadius(2)
                        .offset(
                            x: calendarMananger.startDate == nil ? 0 : geometry.size.width * 0.5
                        )
                        .animation(.easeInOut, value: calendarMananger.startDate)
                }
                .frame(height: 4)
            }
        }
        .frame(height: 50)
    }
}

#Preview {
    let calendarManager = CalendarManager(
        minimumDate: Date().addingTimeInterval(-60 * 60 * 24 * 30 * 2),  // Two months ago
        maximumDate: Date().addingTimeInterval(60 * 60 * 24 * 30 * 2),  // Two months ahead
        isFutureSelectionEnabled: false
    )
    
    HeaderDateSelect()
        .environmentObject(calendarManager)
}
