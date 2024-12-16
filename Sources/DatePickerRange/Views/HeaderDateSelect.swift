//
//  HeaderDateSelect.swift
//  CustomDatePickerRange
//
//  Created by Ivan Maslennikov on 14.12.2024.
//

import SwiftUI

struct HeaderDateSelect: View {

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
//            .padding(.top, 10)
        }
        .frame(height: 50)
    }
}

#Preview {
    let calendarManager = CalendarManager(
        minimumDate: Date().addingTimeInterval(-60 * 60 * 24 * 30 * 2),  // Два месяца назад
        maximumDate: Date().addingTimeInterval(60 * 60 * 24 * 30 * 2),  // Два месяца вперед
        isFutureSelectionEnabled: false
    )
    
    HeaderDateSelect()
        .environmentObject(calendarManager)
}
