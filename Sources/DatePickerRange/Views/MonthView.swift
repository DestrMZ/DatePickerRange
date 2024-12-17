//
//  MonthView.swift
//  CustomDatePickerRange
//
//  Created by Ivan Maslennikov on 09.12.2024.
//


import SwiftUI

/// A view displaying a calendar month.
struct MonthView: View {
    
    @EnvironmentObject var calendarManager: CalendarManager
    
    let monthOffset: Int
    
    let daysPerWeek = 7
    let cellWidth = CGFloat(32)
    
    /// A set of date components used to extract year, month, and day components.
    let calendarUnitYMD: Set<Calendar.Component> = [.year, .month, .day]
    
    var monthsArray: [[Date]] {
        monthArray()  // Array of dates for the month, created using the monthArray method.
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text(getMonthHeader())
                .font(calendarManager.fonts.monthHeaderFont)
                .foregroundColor(calendarManager.colors.monthHeaderColor)
                .padding(.leading)
            
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
        minimumDate: Date().addingTimeInterval(-60 * 60 * 24 * 30 * 2),  // Two months ago
        maximumDate: Date().addingTimeInterval(60 * 60 * 24 * 30 * 2),  // Two months ahead
        isFutureSelectionEnabled: false
    )
    
    MonthView(monthOffset: 0)
        .environmentObject(calendarManager)
}

extension MonthView {
    
    /// Displays a cell for a given date.
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
                .foregroundColor(isDateEnabled ? .primary : .gray)
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
    
    // Checks if the given date is in the current month.
    func isThisMonth(date: Date) -> Bool {
        return calendarManager.calendar.isDate(date, equalTo: firstOfMonthOffset(), toGranularity: .month)
    }
    
    // Returns the first date of the current month.
    func firstDateMonth() -> Date {
        var components = calendarManager.calendar.dateComponents(calendarUnitYMD, from: calendarManager.minimumDate)
        components.day = 1  // Set the day to the 1st
        return calendarManager.calendar.date(from: components)!
    }
    
    // Returns the first date of the month with the given offset.
    func firstOfMonthOffset() -> Date {
        var offset = DateComponents()
        offset.month = monthOffset  // Apply the month offset
        return calendarManager.calendar.date(byAdding: offset, to: firstDateMonth())!
    }
    
    // Formats the date, excluding the day, to get only the year and month.
    func formatDate(date: Date) -> Date {
        let components = calendarManager.calendar.dateComponents(calendarUnitYMD, from: date)
        return calendarManager.calendar.date(from: components)!
    }
    
    // Compares the given date with a reference date.
    func formatAndCompareDate(date: Date, referenceDate: Date) -> Bool {
        let refDate = formatDate(date: referenceDate)
        let clampedDate = formatDate(date: date)
        return refDate == clampedDate
    }
    
    // Returns the number of days in the month for the given offset.
    func numberOfDays(offset: Int) -> Int {
        let firstOfMonth = firstOfMonthOffset()  // Get the first date of the month
        let rangeOfWeeks = calendarManager.calendar.range(of: .weekOfMonth, in: .month, for: firstOfMonth)  // Get the month’s week range
        return (rangeOfWeeks?.count)! * daysPerWeek  // Return the number of days in the month
    }
    
    // Checks if the date is the start of the selected range.
    func isStartDate(date: Date) -> Bool {
        if calendarManager.startDate == nil {
            return false
        }
        return formatAndCompareDate(date: date, referenceDate: calendarManager.startDate ?? Date())
    }
    
    // Checks if the date is the end of the selected range.
    func isEndDate(date: Date) -> Bool {
        if calendarManager.endDate == nil {
            return false
        }
        return formatAndCompareDate(date: date, referenceDate: calendarManager.endDate ?? Date())
    }
    
    // Checks if the date is between the start and end of the selected range.
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
    
    // Checks if the date is enabled (within the allowed range and respecting future/past selection).
    func isEnabled(date: Date) -> Bool {
        let clampedDate = formatDate(date: date)
        let today = Date()

        // Check if the date is within the allowed range
        if calendarManager.calendar.compare(clampedDate, to: calendarManager.minimumDate, toGranularity: .day) == .orderedAscending ||
            calendarManager.calendar.compare(clampedDate, to: calendarManager.maximumDate, toGranularity: .day) == .orderedDescending {
            return false
        }

        // Check if future or past selection is enabled
        if calendarManager.isFutureSelectionEnabled {
            return calendarManager.calendar.compare(clampedDate, to: today, toGranularity: .day) != .orderedAscending
        } else {
            return calendarManager.calendar.compare(clampedDate, to: today, toGranularity: .day) != .orderedDescending
        }
    }
    
    // Checks if the date is one of the disabled dates.
    func isOneOfDisabledDates(date: Date) -> Bool {
        return self.calendarManager.isSelectedDateDisabled(date: date) // Check if the date is disabled using the manager
    }
    
    // Checks if the start date is after the end date.
    func isStartDateAfterEndDate() -> Bool {
        if calendarManager.startDate == nil || calendarManager.endDate == nil {
            return false
        } else if calendarManager.calendar.compare(calendarManager.endDate ?? Date(), to: calendarManager.startDate ?? Date(), toGranularity: .day) == .orderedDescending {
            return false
        }
        return true
    }
    
    // Checks if the date is today.
    func isToday(date: Date) -> Bool {
        formatAndCompareDate(date: date, referenceDate: Date())  // Compare with today's date
    }
    
    // Checks if the date is special (e.g., selected by the user).
    func isSpecialDate(date: Date) -> Bool {
        return isSelectedDate(date: date) || isStartDate(date: date) || isEndDate(date: date) // Check if the date is selected
    }
    
    // Checks if the date is selected by the user.
    func isSelectedDate(date: Date) -> Bool {
        if calendarManager.startDate == nil {
            return false
        }
        return formatAndCompareDate(date: date, referenceDate: calendarManager.startDate ?? Date())
    }
    
    // Handles the date tap event.
    func dateTapped(date: Date) {
        if isEnabled(date: date) {
            // If both start and end dates are selected, reset them
            if calendarManager.startDate != nil && calendarManager.endDate != nil {
                calendarManager.startDate = nil
                calendarManager.endDate = nil
            }
            
            // If the start date is not set, set it
            if calendarManager.startDate == nil {
                calendarManager.startDate = date
                calendarManager.endDate = nil
            } else {
                // Set the end date
                calendarManager.endDate = date
                
                // If the start date is later than the end date, reset both
                if isStartDateAfterEndDate() {
                    calendarManager.startDate = nil
                    calendarManager.endDate = nil
                }
            }
        }
    }

    // Returns the date at a specific index in the month.
    func getDateAtIndex(index: Int) -> Date {
        let firstOfMonth = firstOfMonthOffset() 
        let weekday = calendarManager.calendar.component(.weekday, from: firstOfMonth)
        var startOffset = weekday - calendarManager.calendar.firstWeekday
        startOffset += startOffset >= 0 ? 0 : daysPerWeek
        
        var dateComponents = DateComponents()
        dateComponents.day = index - startOffset
        
        return calendarManager.calendar.date(byAdding: dateComponents, to: firstOfMonth)!  // Return the calculated date
    }
    
    // Creates and returns an array of dates for the entire month.
    func monthArray() -> [[Date]] {
        var rowArray = [[Date]]()
        
        for row in 0..<(numberOfDays(offset: monthOffset) / 7) {
            var columbArray: [Date] = []
            for column in 0...6 {
                let index = (row * 7) + column
                if index >= numberOfDays(offset: monthOffset) {
                    break
                }
                let date = self.getDateAtIndex(index: index)
                columbArray.append(date)
            }
            if !columbArray.isEmpty {
                rowArray.append(columbArray)
            }
        }
        return rowArray
    }
    
    // Gets the header string for the month.
    func getMonthHeader() -> String {
        Helper.getMonthHeader(date: firstOfMonthOffset())  // Use a helper function to get the month header string
    }
    
}
