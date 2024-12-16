//
//  WeekdayHeaderView.swift
//  CustomDatePickerRange
//
//  Created by Ivan Maslennikov on 08.12.2024.
//

import SwiftUI

/// A view displaying the header for weekdays in a calendar.
struct WeekdayHeaderView: View {
    
    /// The calendar manager providing configuration for the calendar.
    @EnvironmentObject var calendarManager: CalendarManager
    
    /// An array of localized weekday names (e.g., "Mon", "Tue").
    var weekdays: [String] {
        Helper.getWeekdayHeaders(calendar: calendarManager.calendar)  // Получаем локализованные названия дней недели
    }
    
    var body: some View {
        HStack(alignment: .center) {
            // Рендерим каждый день недели как текстовый элемент, равномерно распределяя их по ширине
            ForEach(weekdays, id: \.self) { weekday in
                Text(weekday)
                    .font(calendarManager.fonts.weekdayHeaderFont)  // Применяем кастомный шрифт для заголовков дней недели
                    .frame(maxWidth: .infinity)  // Равномерно распределяем каждый день по ширине
            }
        }
        .foregroundColor(calendarManager.colors.weekdayHeaderColor)  // Применяем цвет текста
        .background(calendarManager.colors.weekdayHeaderBackColor)  // Применяем фоновый цвет для заголовка
    }
}

#Preview {
    let calendarManager = CalendarManager(
        minimumDate: Date().addingTimeInterval(-60 * 60 * 24 * 30 * 2),
        maximumDate: Date().addingTimeInterval(60 * 60 * 24 * 30 * 2),
        isFutureSelectionEnabled: false
    )
    // Превью для WeekdayHeaderView с использованием календаря по умолчанию
    WeekdayHeaderView()
        .environmentObject(calendarManager)
}

