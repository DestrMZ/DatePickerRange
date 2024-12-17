# DatePickerRange 📅

A beautiful and fully customizable date picker for selecting date ranges, with the ability to choose both past and future periods. This SwiftUI component is designed for seamless integration into any iOS 14.0+ app, offering a smooth and intuitive user experience when selecting start and end dates.

## Features

- **Customizable Date Range**: Easily select dates from both past and future periods through a user-friendly interface.
- **Auto-Scroll to Current Date**: The picker automatically scrolls to the current date when loaded.
- **Human-Readable Date Formatting**: Display selected dates in a clean and intuitive format (e.g., "4 December").
- **Responsive & Lightweight**: Built with SwiftUI, optimized for iOS 14+ with smooth animations and minimal memory usage.
- **Clear UI**: Clearly displays the selected start and end dates in the header for easy reference.

## 🌅 Dark/Light mode
![image](https://github.com/user-attachments/assets/e3614218-e7cd-4ce7-944c-08a6aa03d854)

## Installation

### Swift Package Manager (SPM)

To integrate `DatePickerRange` into your project using Swift Package Manager, follow these steps:

1. Open your Xcode project.
2. Navigate to **File** -> **Add Packages**.
3. Paste the following repository URL: [https://github.com/DestrMZ/DatePickerRange.git](https://github.com/DestrMZ/DatePickerRange.git).
4. Select the desired version and add it to your project.

## Usage

Import the package into your SwiftUI view:

```swift
import DatePickerRange
```

To start working with CalendarManager, you need to create an instance of it with the required parameters:
```
@StateObject var calendarManager = CalendarManager(
    minimumDate: Date(), // Set the minimum selectable date
    maximumDate: Date().addingTimeInterval(60 * 60 * 24 * 365), // Set the maximum selectable date (1 year from today)
    isFutureSelectionEnabled: false // Allow future dates? Set to true if needed
)
```

## Track Selected Dates
Using CalendarManager, you can get and update selected dates, for example, in your view.
Example:
```
@State var startDate: Date? = nil
@State var endDate: Date? = nil
```
You can subscribe to changes to these dates using .onChange(of:) to automatically update the values ​​in your view:
```
DPViewController(calendarManager: calendarManager)
    .onChange(of: calendarManager.startDate) { newStartDate in
        startDate = newStartDate
    }
    .onChange(of: calendarManager.endDate) { newEndDate in
        endDate = newEndDate
    }
```

## Full example
Here’s a full example using the package with bindings to your view:
```
import SwiftUI
import DatePickerRange

struct SelectDateView: View {
    
    @StateObject var calendarManager = CalendarManager(
        minimumDate: Date(), 
        maximumDate: Date().addingTimeInterval(60*60*24*365), 
        isFutureSelectionEnabled: false
    )
    
    @State var startDate: Date? = nil
    @State var endDate: Date? = nil

    var body: some View {
        Group {
            DPViewController(calendarManager: calendarManager)
                .onChange(of: calendarManager.startDate) { newStartDate in
                    startDate = newStartDate
                }
                .onChange(of: calendarManager.endDate) { newEndDate in
                    endDate = newEndDate
                }
        }
    }
}

#Preview {
    SelectDateView()
}
```
