//
//  DellCell.swift
//  CustomDatePickerRange
//
//  Created by Ivan Maslennikov on 07.12.2024.
//

import Foundation
import SwiftUI

/// Отображает ячейку календаря с учетом стилей и состояния.
struct DayCell: View {
    
    var calendarDate: CalendarDate
    var cellWidth: CGFloat
    
    /// Радиус закругления углов ячейки.
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
                    maximumDate: Date().addingTimeInterval(60 * 60 * 24 * 365),
                    isFutureSelectionEnabled: false
                ),
                isDisabled: false,
                isToday: false,
                isSelected: false,
                isBetweenStartAndEnd: false
            ),
            cellWidth: 32
        )
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


