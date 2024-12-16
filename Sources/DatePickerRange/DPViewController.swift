//
//  CustomDatePickerRange.swift
//  CustomDatePickerRange
//
//  Created by Ivan Maslennikov on 15.12.2024.
//

import SwiftUI

public struct DPViewController: View {
    
    @ObservedObject var calendarManager: CalendarManager
    @Environment(\.presentationMode) var presentationMode
    
    public var body: some View {
        Group {
            NavigationView {
                CalendarPicker()
                    .environmentObject(calendarManager)
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
}

