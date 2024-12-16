//
//  ContentView.swift
//  CustomDatePickerRange
//
//  Created by Ivan Maslennikov on 06.12.2024.
//

import SwiftUI

struct ContentView: View {
    
    @State var isPresentedFuture: Bool = false
    @State var isPresentedPast: Bool = false
    
    var calendarManangerFuture = CalendarManager(minimumDate: Date(), maximumDate: Date().addingTimeInterval(60*60*24*365), isFutureSelectionEnabled: true)
    
    var calendarManangerPast = CalendarManager(minimumDate: Date(), maximumDate: Date().addingTimeInterval(60*60*24*365), isFutureSelectionEnabled: false)
    
    var body: some View {
        VStack(spacing: 40) {
            
            Button(action: {
                isPresentedFuture = true
            }) {
                Text("Calendar with future dates 📅")
            }
            .sheet(isPresented: $isPresentedFuture) {
                DPViewController(calendarManager: calendarManangerFuture)
            }
            
            Button(action: {
                isPresentedPast = true
            }) {
                Text("Calendar with dates of the past 📅")
            }
            .sheet(isPresented: $isPresentedPast) {
                DPViewController(calendarManager: calendarManangerPast)
            }
        }
    }
}

#Preview {
    ContentView()
}
