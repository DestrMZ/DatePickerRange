//
//  MonthView.swift
//  CustomDatePickerRange
//
//  Created by Ivan Maslennikov on 09.12.2024.
//


import SwiftUI

struct MonthView: View {
    
    @EnvironmentObject var calendarManager: CalendarManager
    
    let monthOffset: Int
    
    let daysPerWeek = 7
    let cellWidth = CGFloat(32)
    
    /// Набор компонентов для извлечения компонентов даты (год, месяц, день)
    let calendarUnitYMD: Set<Calendar.Component> = [.year, .month, .day]
    
     var monthsArray: [[Date]] {
        monthArray()  // Массив дат для месяца, создается с помощью метода monthArray
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            // Header month
            Text(getMonthHeader())
                .font(calendarManager.fonts.monthHeaderFont)
                .foregroundColor(calendarManager.colors.monthHeaderColor)
                .padding(.leading)
            
            // Ячейки календаря
            VStack(alignment: .leading, spacing: 5) {
                ForEach(monthsArray, id: \.self) { row in
                    HStack(spacing: 0) {
                        ForEach(row, id: \.self) { date in
                            cellView(for: date)
                        }
                    }
                }
            }
        }
        .background(calendarManager.colors.monthBackColor)
    }
}

#Preview {
    let calendarManager = CalendarManager(
        minimumDate: Date().addingTimeInterval(-60 * 60 * 24 * 30 * 2),  // Два месяца назад
        maximumDate: Date().addingTimeInterval(60 * 60 * 24 * 30 * 2),  // Два месяца вперед
        isFutureSelectionEnabled: false
    )
    
    MonthView(monthOffset: 0)
        .environmentObject(calendarManager)
}

extension MonthView {
    
    /// Отображает ячейку для указанной даты
    func cellView(for date: Date) -> some View {
        if isThisMonth(date: date) {
            let isDateEnabled = isEnabled(date: date)
            return AnyView(
                DayCell(
                    calendarDate: CalendarDate(
                        date: date,
                        manager: calendarManager,
                        isDisabled: !isDateEnabled,
                        isToday: isToday(date: date),
                        isSelected: isSpecialDate(date: date),
                        isBetweenStartAndEnd: isBeetweenStartAndEnd(date: date)
                    ),
                    cellWidth: cellWidth
                )
                .foregroundColor(isDateEnabled ? .primary : .gray) // Выделение недоступных дат
                .onTapGesture {
                    if isDateEnabled {
                        dateTapped(date: date)
                    }
                }
            )
        } else {
            return AnyView(
                Text("")
                    .frame(maxWidth: .infinity, alignment: .center)
            )
        }
    }
    
    // Проверяет, является ли текущая дата месяцем
    func isThisMonth(date: Date) -> Bool {
        return calendarManager.calendar.isDate(date, equalTo: firstOfMonthOffset(), toGranularity: .month)
    }
    
    // Получает первую дату месяца
    func firstDateMonth() -> Date {
        var components = calendarManager.calendar.dateComponents(calendarUnitYMD, from: calendarManager.minimumDate)
        components.day = 1  // Устанавливаем первый день месяца
        return calendarManager.calendar.date(from: components)!
    }
    
    // Получает первую дату месяца с учетом смещения
    func firstOfMonthOffset() -> Date {
        var offset = DateComponents()
        offset.month = monthOffset  // Применяем смещение для текущего месяца
        return calendarManager.calendar.date(byAdding: offset, to: firstDateMonth())!
    }
    
    // Форматирует дату, исключая день, чтобы получить только год и месяц
    func formatDate(date: Date) -> Date {
        let components = calendarManager.calendar.dateComponents(calendarUnitYMD, from: date)
        return calendarManager.calendar.date(from: components)!
    }
    
    // Сравнивает дату с эталонной
    func formatAndCompareDate(date: Date, referenceDate: Date) -> Bool {
        let refDate = formatDate(date: referenceDate)
        let clampedDate = formatDate(date: date)
        return refDate == clampedDate
    }
    
    // Возвращает количество дней в месяцах между двумя датами
    func numberOfDays(offset: Int) -> Int {
        let firstOfMonth = firstOfMonthOffset() // Получаем первую дату месяца с учетом смещения
        let rangeOfWeeks = calendarManager.calendar.range(of: .weekOfMonth, in: .month, for: firstOfMonth)  // Определяем диапазон недель месяца
        return (rangeOfWeeks?.count)! * daysPerWeek // Возвращаем количество дней в месяце
    }
    
    // Проверяет, является ли дата началом выбранного диапазона
    func isStartDate(date: Date) -> Bool {
        if calendarManager.startDate == nil {
            return false
        }
        return formatAndCompareDate(date: date, referenceDate: calendarManager.startDate ?? Date())
    }
    
    // Проверяет, является ли дата концом выбранного диапазона
    func isEndDate(date: Date) -> Bool {
        if calendarManager.endDate == nil {
            return false
        }
        return formatAndCompareDate(date: date, referenceDate: calendarManager.endDate ?? Date())
    }
    
    // Проверяет, лежит ли дата между началом и концом выбранного диапазона
    func isBeetweenStartAndEnd(date: Date) -> Bool {
        if calendarManager.startDate == nil || calendarManager.endDate == nil {
            return false
        } else if calendarManager.calendar.compare(date, to: calendarManager.startDate ?? Date(), toGranularity: .day) == .orderedAscending {
            return false
        } else if calendarManager.calendar.compare(date, to: calendarManager.endDate ?? Date(), toGranularity: .day) == .orderedDescending {
            return false
        }
        return true
    }
    
    // Проверяет, доступна ли дата для выбора (не меньше минимальной и не больше максимальной)
    func isEnabled(date: Date) -> Bool {
        let clampedDate = formatDate(date: date)
        let today = Date()

        // Проверка, что дата находится в пределах разрешённого диапазона
        if calendarManager.calendar.compare(clampedDate, to: calendarManager.minimumDate, toGranularity: .day) == .orderedAscending ||
            calendarManager.calendar.compare(clampedDate, to: calendarManager.maximumDate, toGranularity: .day) == .orderedDescending {
            return false
        }

        // Проверка на будущее или прошлое в зависимости от флага
        if calendarManager.isFutureSelectionEnabled {
            return calendarManager.calendar.compare(clampedDate, to: today, toGranularity: .day) != .orderedAscending
        } else {
            return calendarManager.calendar.compare(clampedDate, to: today, toGranularity: .day) != .orderedDescending
        }
    }
    
    // Проверяет, является ли дата недоступной
    func isOneOfDisabledDates(date: Date) -> Bool {
        return self.calendarManager.isSelectedDateDisabled(date: date) // Проверяем с помощью менеджера, доступна ли дата
    }
    
    // Проверяет, если дата начала находится после даты конца, то возвращает false
    func isStartDateAfterEndDate() -> Bool {
        if calendarManager.startDate == nil || calendarManager.endDate == nil {
            return false
        } else if calendarManager.calendar.compare(calendarManager.endDate ?? Date(), to: calendarManager.startDate ?? Date(), toGranularity: .day) == .orderedDescending {
            return false
        }
        return true
    }
    
    // Проверяет, является ли дата сегодняшним днем
    func isToday(date: Date) -> Bool {
        formatAndCompareDate(date: date, referenceDate: Date())  // Сравниваем с сегодняшней датой
    }
    
    // Проверяет, является ли дата специальной (например, выбранной пользователем)
    func isSpecialDate(date: Date) -> Bool {
        return isSelectedDate(date: date) || isStartDate(date: date) || isEndDate(date: date) // Проверяем, выбрана ли эта дата
    }
    
    // Проверяет, является ли дата выбранной пользователем
    func isSelectedDate(date: Date) -> Bool {
        if calendarManager.startDate == nil {
            return false
        }
        return formatAndCompareDate(date: date, referenceDate: calendarManager.startDate ?? Date())
    }
    
    // Обрабатывает событие нажатия на дату
    func dateTapped(date: Date) {
        if isEnabled(date: date) {
            // Если и начальная, и конечная дата выбраны — сбросить их
            if calendarManager.startDate != nil && calendarManager.endDate != nil {
                calendarManager.startDate = nil
                calendarManager.endDate = nil
            }
            
            // Если начальная дата не выбрана, установить её
            if calendarManager.startDate == nil {
                calendarManager.startDate = date
                calendarManager.endDate = nil
            } else {
                // Установить конечную дату
                calendarManager.endDate = date
                
                // Если начальная дата больше конечной, сбросить обе
                if isStartDateAfterEndDate() {
                    calendarManager.startDate = nil
                    calendarManager.endDate = nil
                }
            }
        }
    }

    // Возвращает дату для конкретного индекса в месяце
    func getDateAtIndex(index: Int) -> Date {
        let firstOfMonth = firstOfMonthOffset()  // Получаем первую дату месяца
        let weekday = calendarManager.calendar.component(.weekday, from: firstOfMonth)
        var startOffset = weekday - calendarManager.calendar.firstWeekday
        startOffset += startOffset >= 0 ? 0 : daysPerWeek
        
        var dateComponents = DateComponents()
        dateComponents.day = index - startOffset  // Вычисляем смещение для текущей даты
        
        return calendarManager.calendar.date(byAdding: dateComponents, to: firstOfMonth)!  // Возвращаем полученную дату
    }
    
    // Создает и возвращает массив дат для всего месяца
    func monthArray() -> [[Date]] {
        var rowArray = [[Date]]()  // Массив строк, каждая строка — это неделя
        
    
        for row in 0..<(numberOfDays(offset: monthOffset) / 7) {
            var columbArray: [Date] = []  // Массив для одной недели
            for column in 0...6 {
                let index = (row * 7) + column
                if index >= numberOfDays(offset: monthOffset) {
                    break  // Прерываем, если индекс выходит за пределы месяца
                }
                let date = self.getDateAtIndex(index: index)
                columbArray.append(date)  // Добавляем в текущую неделю
            }
            if !columbArray.isEmpty {
                rowArray.append(columbArray)  // Добавляем неделю в месяц, если она не пуста
            }
        }
        return rowArray
    }
    
    // Получает строку заголовка месяца
    func getMonthHeader() -> String {
        Helper.getMonthHeader(date: firstOfMonthOffset())  // Используем вспомогательную функцию для получения строки месяца
    }
    
}
