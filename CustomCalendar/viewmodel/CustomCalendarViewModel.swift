//
//  CalendarViewModel.swift
//  CustomCalendar
//
//  Created by Syed Ammar on 20/01/2025.
//

import Foundation

class CustomCalendarViewModel: ObservableObject {
    @Published var days: [Day] = []
    @Published var selectedDay: Day?
    
    private let calendar = Calendar.current
    
    private var earliestDate: Date
    private var latestDate: Date
    
    private let chunkSize = 30
    
    init() {
        let today = Date()
        earliestDate = today
        latestDate   = calendar.date(byAdding: .day, value: chunkSize, to: today) ?? today
        
        days = generateDays(from: earliestDate, to: latestDate)
        
        if let middleIndex = days.firstIndex(where: { $0.isSameDay(as: Day(date: today)) }) {
            selectedDay = days[middleIndex]
        } else {
            selectedDay = days[days.count / 2]
        }
    }
    
    private func generateDays(from start: Date, to end: Date) -> [Day] {
        var tempDays: [Day] = []
        
        guard start <= end else { return tempDays }
        
        var current = start
        while current <= end {
            tempDays.append(Day(date: current))
            if let next = calendar.date(byAdding: .day, value: 1, to: current) {
                current = next
            } else {
                break
            }
        }
        
        return tempDays
    }
    
    func loadNextChunkIfNeeded(currentDay: Day) {
        guard days.last != nil else { return }
        
        let threshold = calendar.date(byAdding: .day, value: -5, to: latestDate) ?? latestDate
        if currentDay.date >= threshold {
            appendMoreDays()
        }
    }
    
    private func appendMoreDays() {
        let newLatest = calendar.date(byAdding: .day, value: chunkSize, to: latestDate) ?? latestDate
        let newDays = generateDays(from: calendar.date(byAdding: .day, value: 1, to: latestDate)!, to: newLatest)
        
        days.append(contentsOf: newDays)
        latestDate = newLatest
    }
    
    func select(_ day: Day) {
        selectedDay = day
    }
}
