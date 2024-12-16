//
//  CalendarDate.swift
//  CustomDatePickerRange
//
//  Created by Ivan Maslennikov on 07.12.2024.


import SwiftUI


struct CalendarDate {
    
    var date: Date /// Дата, связанная с этой ячейкой календаря.
    var calendarManager: CalendarManager /// Менеджер календаря, предоставляющий конфигурацию и состояние.
    
    var isDisabled: Bool = false /// Указывает, является ли дата недоступной для выбора.
    var isToday: Bool = false /// Указывает, является ли дата сегодняшней.
    var isSelected: Bool = false /// Указывает, выбрана ли эта дата.
    var isBetweenStartAndEnd: Bool = false /// Указывает, находится ли дата между начальной и конечной датами диапазона.

    
    init(
        date: Date,
        manager: CalendarManager,
        isDisabled: Bool = false,
        isToday: Bool = false,
        isSelected: Bool = false,
        isBetweenStartAndEnd: Bool = false
    ) {
        self.date = date
        self.calendarManager = manager
        self.isDisabled = isDisabled
        self.isToday = isToday
        self.isSelected = isSelected
        self.isBetweenStartAndEnd = isBetweenStartAndEnd
    }
    
    /// Возвращает текстовое представление даты.
    func getText() -> String {
        formatDate(date: date)
    }
    
    /// Определяет цвет текста в зависимости от состояния даты.
    func getTextColor() -> Color {
        if isDisabled {
            return calendarManager.colors.disabledColor
        } else if isSelected {
            return calendarManager.colors.selectedColor
        } else if isToday {
            return calendarManager.colors.todayColor
        } else if isBetweenStartAndEnd {
            return calendarManager.colors.betweenStartAndEndColor //
        }
        return calendarManager.colors.textColor
    }

    /// Определяет цвет фона в зависимости от состояния даты.
    func getBackgroundColor() -> Color {
        if isBetweenStartAndEnd {
            return calendarManager.colors.betweenStartAndEndBackColor
        } else if isDisabled {
            return calendarManager.colors.disabledBackColor
        } else if isSelected {
            return calendarManager.colors.selectedBackColor
        }
        return calendarManager.colors.textBackColor
    }
    
    /// Определяет шрифт в зависимости от состояния даты.
    var font: Font {
        if isDisabled {
            return calendarManager.fonts.cellDisabledFont
        } else if isSelected {
            return calendarManager.fonts.cellSelectedFont
        } else if isToday {
            return calendarManager.fonts.cellTodayFont
        } else if isBetweenStartAndEnd {
            return calendarManager.fonts.cellBetweenStartAndEndFont
        }
        return calendarManager.fonts.cellUnselectedFont
    }

    func stringFormatDate(date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .medium
        dateFormatter.timeStyle = .none
        return dateFormatter.string(from: date)
    }

    func formatDate(date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "d"
        return dateFormatter.string(from: date)
    }
}
