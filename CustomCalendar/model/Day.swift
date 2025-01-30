//
//  Day.swift
//  CustomCalendar
//
//  Created by Syed Ammar on 20/01/2025.
//

import Foundation
import SwiftUI

struct Day: Identifiable, Equatable {
    let id: UUID = UUID()
    let date: Date
    
    let dayName: String
    let dayNumber: String
    let monthName: String
    let yearString: String
    
    init(date: Date) {
        self.date = date
        dayName = date.formatted(.dateTime.weekday(.abbreviated))
        dayNumber = date.formatted(.dateTime.day())
        monthName = date.formatted(.dateTime.month(.abbreviated))
        yearString = date.formatted(.dateTime.year(.defaultDigits))
    }
    
    func isSameDay(as other: Day) -> Bool {
        Calendar.current.isDate(self.date, inSameDayAs: other.date)
    }
}
