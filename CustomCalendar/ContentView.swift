//
//  ContentView.swift
//  CustomCalendar
//
//  Created by Syed Ammar on 20/01/2025.
//

import SwiftUI

struct ContentView: View {
    @StateObject private var viewModel = CustomCalendarViewModel()
    
    var body: some View {
        VStack() {
            CustomCalendarView(viewModel: viewModel)
            if let selected = viewModel.selectedDay {
                Text("Selected Day: \(selected.date.formatted(date: .long, time: .omitted))")
                    .padding()
            }
        }
        .frame(maxHeight: .infinity, alignment: .top)
    }
}

struct CustomCalendarView: View {
    @ObservedObject var viewModel: CustomCalendarViewModel
    
    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            LazyHStack(spacing: 16) {
                ForEach(viewModel.days) { day in
                    DayPillView(day: day,
                                isSelected: viewModel.selectedDay?.isSameDay(as: day) == true)
                    .onTapGesture {
                        viewModel.select(day)
                    }
                    .onAppear {
                        if day.id == viewModel.days.last?.id {
                            viewModel.loadNextChunkIfNeeded(currentDay: day)
                        }
                    }
                    .padding(.vertical, 16)
                }
            }
            .padding(.horizontal)
        }
        .fixedSize(horizontal: false, vertical: true)
    }
}

struct DayPillView: View {
    let day: Day
    let isSelected: Bool
    
    var body: some View {
        VStack(spacing: 4) {
            Text(day.dayName)
                .font(.subheadline).fontWeight(.medium)
            Text(day.dayNumber)
                .font(.title2).fontWeight(.bold)
            Text(day.monthName)
                .font(.subheadline).fontWeight(.medium)
            Text(day.yearString)
                .font(.subheadline).fontWeight(.medium)
        }
        .foregroundColor(isSelected ? .white : .black)
        .padding(.vertical, 10)
        .padding(.horizontal, 16)
        .background(isSelected ? .black : .white)
        .clipShape(RoundedRectangle(cornerRadius: 20))
        .overlay(
            RoundedRectangle(cornerRadius: 20)
                .stroke(Color.gray.opacity(0.5), lineWidth: isSelected ? 0 : 1)
        )
        .shadow(color: Color.gray.opacity(0.4), radius: 4, x: 0, y: 2)
        .animation(.easeInOut, value: isSelected)
    }
}

#Preview {
    ContentView()
}
