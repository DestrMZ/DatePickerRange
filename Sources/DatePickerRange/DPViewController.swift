//
//  CustomDatePickerRange.swift
//  CustomDatePickerRange
//
//  Created by Ivan Maslennikov on 15.12.2024.
//

import SwiftUI

/// A SwiftUI view controller that presents a date picker, allowing the user to select a range of dates.
public struct DPViewController: View {
    
    // The calendar manager that controls the date selection logic.
    @ObservedObject var calendarManager: CalendarManager
    @Environment(\.presentationMode) var presentationMode
    
    // Initializer for the DPViewController.
    public init(calendarManager: CalendarManager) {
        self.calendarManager = calendarManager
    }
    
    public var body: some View {
        CalendarPicker()
            .environmentObject(calendarManager)
    }
}

extension DPViewController { // For preview

    /// Adds a toolbar with "Done" and "Cancel" buttons for managing the presentation.
    func withToolbar() -> some View {
        NavigationView {
            self
                .navigationBarTitleDisplayMode(.inline)
                .toolbar {
                    ToolbarItem(placement: .confirmationAction) {
                        Button("Done") {
                            presentationMode.wrappedValue.dismiss()
                        }
                        .font(.system(size: 17, weight: .semibold))
                    }
                    
                    ToolbarItem(placement: .principal) {
                        Text("Select Dates")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                            .bold()
                    }
                    
                    ToolbarItem(placement: .cancellationAction) {
                        Button("Cancel") {
                            presentationMode.wrappedValue.dismiss()
                        }
                        .font(.system(size: 17, weight: .semibold))
                    }
                }
        }
    }
}
