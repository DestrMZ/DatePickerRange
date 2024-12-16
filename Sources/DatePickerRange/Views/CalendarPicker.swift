//
//  RangeCalendar.swift
//  CustomDatePickerRange
//
//  Created by Ivan Maslennikov on 09.12.2024.
//

import SwiftUI

struct CalendarPicker: View {
    
    @EnvironmentObject var calendarManager: CalendarManager
    
    // Вычисляет общее количество месяцев для отображения на основе диапазона дат
    var numberOfMonths: Int {
        Helper.numberOfMonth(calendarManager.minimumDate, calendarManager.maximumDate)
    }
    
    var body: some View {
        VStack(spacing: 0) {
            HeaderDateSelect()
            // Заголовок с днями недели
            WeekDayHeader()
            
            ScrollViewReader { reader in
                // Вертикальная прокручиваемая область для навигации по месяцам
                ScrollView(.vertical, showsIndicators: false) {
                    LazyVStack(spacing: 32) {
                        // Генерируем представление для каждого месяца в диапазоне
                        ForEach(0..<numberOfMonths, id: \.self) { index in
                            // Каждый месяц отображается с помощью компонента MonthView
                            MonthView(calendarManager: self._calendarManager, monthOffset: index)
                        }
                    }
                    .padding()
                }
                .onAppear {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                       if let date = calendarManager.todayDate {
                           let monthOffset = Helper.getMonthOffsetForCurrent(calendar: calendarManager, date: date)
                           reader.scrollTo(monthOffset, anchor: .center)  // Прокручиваем к нужному месяцу
                       }
                   }
               }
            }
        }
        .background(calendarManager.colors.textBackColor.ignoresSafeArea())
    }
}

#Preview {
    let calendarManager = CalendarManager(
        minimumDate: Date().addingTimeInterval(-60 * 60 * 24 * 30 * 2),
        maximumDate: Date().addingTimeInterval(60 * 60 * 24 * 30 * 2),
        isFutureSelectionEnabled: false
    )
    
    CalendarPicker()
        .environmentObject(calendarManager)
}

 
