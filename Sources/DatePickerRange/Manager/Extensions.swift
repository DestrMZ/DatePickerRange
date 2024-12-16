//
//  Extensions.swift
//  CustomDatePickerRange
//
//  Created by Ivan Maslennikov on 06.12.2024.
//

import SwiftUI


/// Класс настроек цветов для отображения элементов в календаре.
class ColorSettings: ObservableObject {
    // Цвет текста
    var textColor: Color = Color.primary
    var todayColor: Color = Color.red
    var selectedColor: Color = Color.white
    var disabledColor: Color = Color.gray
    var betweenStartAndEndColor: Color = Color.white
    // Цвет фона текста
    var textBackColor: Color = Color.clear
    var todayBackColor: Color = Color.gray
    var selectedBackColor: Color = Color.red
    var disabledBackColor: Color = Color.clear
    var betweenStartAndEndBackColor: Color = Color.blue
    // Цвет текста заголовка
    var weekdayHeaderColor: Color = Color.primary
    var monthHeaderColor: Color = Color.primary
    // Фон заголовка
    var weekdayHeaderBackColor: Color = Color.clear
    var monthBackColor: Color = Color.clear
}

/// Класс настроек шрифтов для различных элементов в календаре.
class FontSettings: ObservableObject {
    // Шрифт для заголовка месяца.
    var monthHeaderFont: Font = Font.body.bold()
    // Шрифт для заголовка недели.
    var weekdayHeaderFont: Font = Font.caption
    // Шрифт для ячеек, не выбранных пользователем.
    var cellUnselectedFont: Font = Font.body
    // Шрифт для недоступных ячеек.
    var cellDisabledFont: Font = Font.body.weight(.light)
    // Шрифт для выбранных ячеек.
    var cellSelectedFont: Font = Font.body.bold()
    // Шрифт для сегодняшнего дня.
    var cellTodayFont: Font = Font.body.bold()
    // Шрифт для дат между началом и концом диапазона.
    var cellBetweenStartAndEndFont: Font = Font.body.bold()
}


/// Вспомогательные функции для работы с датами и календарем.
class Helper {
    
    /// Получает сокращенные наименования дней недели для текущего календаря.
    static func getWeekdayHeaders(calendar: Calendar) -> [String] {
        let weekdays = calendar.shortStandaloneWeekdaySymbols
        let firstWeekdayIndex = calendar.firstWeekday - 1
        let adjustedWeekdays = Array(weekdays[firstWeekdayIndex...] + weekdays[..<firstWeekdayIndex])
        
        return adjustedWeekdays
    }
    
    /// Извлекает номер месяца из переданной даты (от 1 до 12).
    static func getMonthDayFromDate(date: Date) -> Int {
        let calendar = Calendar.current
        let components = calendar.dateComponents([.month], from: date)
        return components.month! - 1
    }
    
    /// Возвращает количество месяцев между двумя датами.
    static func numberOfMonth(_ minDate: Date, _ maxDate: Date) -> Int {
        let components = Calendar.current.dateComponents([.month], from: minDate, to: maxDate)
        return components.month! + 1
    }
    
    /// Находит последний день месяца для заданной даты.
    static func lastDayOfMonth(date: Date, calendar: Calendar = .current) -> Date {
        var components = calendar.dateComponents([.year, .month], from: date)
        
        components.setValue(1, for: .day)
        
        guard let startMonth = calendar.date(from: components) else {
            fatalError("Invalid date components!")
        }
        return calendar.date(byAdding: .month, value: -1, to: startMonth)?.addingTimeInterval(-86500) ?? startMonth
    }
    
    static func getMonthOffsetForCurrent(calendar: CalendarManager, date: Date) -> Int {
        let currentYear = Calendar.current.component(.year, from: date)
        let currentMonth = Calendar.current.component(.month, from: date)
        
        let startYear = Calendar.current.component(.year, from: calendar.minimumDate)
        let startMonth = Calendar.current.component(.month, from: calendar.minimumDate)
        let monthOffset = (currentYear - startYear) * 12 + (currentMonth - startMonth)
        return monthOffset
    }
    
    static func dateFormatter() -> DateFormatter {
        let formatter = DateFormatter()
        formatter.dateFormat = "d MMMM"
        return formatter
    }
    
    static func formattedDate(_ date: Date?) -> String {
        guard let date = date else {
            return "Not selected"
        }
        return dateFormatter().string(from: date)
    }
    
    /// Возвращает строку с наименованием месяца и года для заголовка.
    static func getMonthHeader(date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "LLLL yyyy"
        return dateFormatter.string(from: date).capitalized
    }
}
