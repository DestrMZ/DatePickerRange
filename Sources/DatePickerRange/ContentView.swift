//
//  ContentView.swift
//  CustomDatePickerRange
//
//  Created by Ivan Maslennikov on 06.12.2024.
//

import SwiftUI

// MARK: Example of implementation

/// A SwiftUI view demonstrating the usage of two date pickers: one with future dates enabled and one with past dates enabled.
struct ContentView: View {
    
    // State variables to control the presentation of the date picker modals.
    @State var isPresentedFuture: Bool = false
    @State var isPresentedPast: Bool = false
    
    // Calendar manager for the date picker with future date selection enabled.
    var calendarManangerFuture = CalendarManager(
        minimumDate: Date(),
        maximumDate: Date().addingTimeInterval(60*60*24*365),
        isFutureSelectionEnabled: true)
    
    // Calendar manager for the date picker with future date selection disabled (only past dates can be selected).
    var calendarManangerPast = CalendarManager(
        minimumDate: Date(),
        maximumDate: Date().addingTimeInterval(60*60*24*365),
        isFutureSelectionEnabled: false)
    
    var body: some View {
        VStack(spacing: 40) {
            
            Button(action: {
                isPresentedFuture = true
            }) {
                Text("Calendar with future dates 📅")
            }
            .sheet(isPresented: $isPresentedFuture) {
                DPViewController(calendarManager: calendarManangerFuture)
                    .withToolbar()
            }
            
            Button(action: {
                isPresentedPast = true
            }) {
                Text("Calendar with dates of the past 📅")
            }
            .sheet(isPresented: $isPresentedPast) {
                DPViewController(calendarManager: calendarManangerPast)
                    .withToolbar()
            }
        }
    }
}



#Preview {
    ContentView()
}
