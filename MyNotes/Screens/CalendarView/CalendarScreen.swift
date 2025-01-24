//
//  CalendarScreen.swift
//  MyNotes
//
//  Created by apple on 28.12.2024.
//
import SwiftUI
import SwiftData
struct CalendarScreen: View {
//    @EnvironmentObject var viewModel: MainTabViewViewModel
    @Query private var notes: [NoteModel]
    @State private var monthDate = Date.now
    @State private var years: [Int] = []
    @State private var selectedMonth = Date.now.monthInt
    @State private var selectedYear = Date.now.yearInt
    let months = Date.fullMonthNames
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading) {
                HStack {
                    Picker("", selection: $selectedYear) {
                        ForEach(years, id: \.self) { year in
                            Text(String(year))
                        }
                    }
                    
                    Picker("", selection: $selectedMonth) {
                        ForEach(months.indices, id: \.self) { index in
                            Text(months[index]).tag(index + 1)
                        }
                    }
                }
                .padding()
                .buttonStyle(.bordered)
                
                CalendarView(date: monthDate, notes: notes)
                //                    .environmentObject(viewModel)
                    .navigationTitle("Calendar")
                    .gesture(
                        DragGesture()
                            .onEnded { value in
                                if value.translation.width < 0 {
                                    // Swipe left -> move to next month
                                    withAnimation {
                                        moveToNextMonth()
                                    }
                                } else if value.translation.width > 0 {
                                    // Swipe right -> move to previous month
                                    withAnimation {
                                        moveToPreviousMonth()
                                    }
                                }
                            }
                    )
                NoteCell()
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                Spacer()
            }
                .frame(maxWidth: .infinity)

        }
//            .background(viewModel.getThemeBackgroundColor())
        }
        .onAppear {
            years = Array(Set(notes.map { $0.date.yearInt }.sorted()))
        }
        .onChange(of: selectedYear) {
            updateDate()
        }
        .onChange(of: selectedMonth) {
            updateDate()
        }
    }

    func moveToNextMonth() {
        if selectedMonth == 12 {
            selectedMonth = 1
            selectedYear += 1
        } else {
            selectedMonth += 1
        }
        updateDate()
    }

    func moveToPreviousMonth() {
        if selectedMonth == 1 {
            selectedMonth = 12
            selectedYear -= 1
        } else {
            selectedMonth -= 1
        }
        updateDate()
    }

    func updateDate() {
        monthDate = Calendar.current.date(from: DateComponents(year: selectedYear, month: selectedMonth, day: 1))!
    }
}
