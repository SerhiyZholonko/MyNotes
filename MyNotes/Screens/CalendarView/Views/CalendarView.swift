//
//  CalendarView.swift
//  MyNotes
//
//  Created by apple on 28.12.2024.
//

import SwiftUI

struct CalendarView: View {
    let date: Date
    let notes: [NoteModel]
    let daysOfWeek = Date.capitalizedFirstLettersOfWeekdays
    let columns = Array(repeating: GridItem(.flexible()), count: 7)

    @State private var days: [Date] = []
    @Binding var selectedDay: Date? // Use binding for selectedDay

    var body: some View {
//        Section(header: Text("Calendar")) {
        VStack {
            HStack {
                ForEach(daysOfWeek.indices, id: \.self) { index in
                    Text(daysOfWeek[index])
                        .fontWeight(.black)
                        .foregroundStyle(.blue)
                        .frame(maxWidth: .infinity)
                }
            }
            LazyVGrid(columns: columns) {
                ForEach(days, id: \.self) { day in
                    if day.monthInt != date.monthInt {
                        Text("")
                    } else {
                        ZStack {
                            Text(day.formatted(.dateTime.day()))
                                .fontWeight(.bold)
                                .foregroundStyle(.secondary)
                                .frame(maxWidth: .infinity, minHeight: 40)
                                .background(
                                    Circle()
                                        .foregroundStyle(getBackgroundColor(for: day))
                                        .foregroundStyle(.red.opacity(0.1))
                                )
                                .onTapGesture {
                                    selectedDay = day // Update the selected day
                                }
                            if let emoji = getFeelingEmoji(for: day) {
                                Text(emoji)
                                    .frame(width: 22, height: 22)
                                    .foregroundStyle(.red)
                                    .offset(x: 15, y: -15)
                            }
                        }
                    }
                }
            }
            Spacer()
        }
        .padding()
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color(uiColor: .systemBackground))
        .cornerRadius(10)

//    }
        .padding()
        .onAppear {
            days = date.calendarDisplayDays
        }
        .onChange(of: date) { _, _ in
            days = date.calendarDisplayDays
        }
    }
    
    func getBackgroundColor(for day: Date) -> Color {
        if let note = notes.first(where: { $0.date.startOfDay == day.startOfDay }) {
            return Color.fromHex(note.energy.color ?? "#00FF00")
        } else if selectedDay == day {
            return .green
        } else if Date.now.startOfDay == day.startOfDay {
            return .blue.opacity(0.3)
        } else {
            return .blue.opacity(0.6)
        }
    }

    func getFeelingEmoji(for day: Date) -> String? {
        if let note = notes.first(where: { $0.date.startOfDay == day.startOfDay }) {
            return note.emoji.emoji
        }
        return nil
    }
}
