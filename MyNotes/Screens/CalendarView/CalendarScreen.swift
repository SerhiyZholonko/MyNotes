//
//  CalendarScreen.swift
//  MyNotes
//
//  Created by apple on 28.12.2024.
//
import SwiftUI
import SwiftData
struct CalendarScreen: View {
    @Environment(\.modelContext) private var modelContext
    @EnvironmentObject var noteViewModel: NoteViewModel
    @EnvironmentObject var notesListViewModel: NotesListViewModel

    @Query private var notes: [NoteModel]
    @Binding var isAddViewPresented: Bool
    @State private var monthDate = Date.now
    @State private var years: [Int] = []
    @State private var selectedMonth = Date.now.monthInt
    @State private var selectedYear = Date.now.yearInt
    @State private var selectedDay: Date? = Date()
    
    var noteForSelectedDay: NoteModel? {
        if let selectedDay = selectedDay {
            return notes.first { $0.date.startOfDay == selectedDay.startOfDay }
        }
        return nil
    }
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

                    CalendarView(date: monthDate, notes: notes, selectedDay: $selectedDay) // Pass binding
//                        .gesture(
//                            DragGesture()
//                                .onEnded { value in
//                                    if value.translation.width < 0 {
//                                        withAnimation {
//                                            moveToNextMonth()
//                                        }
//                                    } else if value.translation.width > 0 {
//                                        withAnimation {
//                                            moveToPreviousMonth()
//                                        }
//                                    }
//                                }
//                        )
                    NavigationLink {
                        if let note = notes.note(for: selectedDay) {
                            NoteDetailView {
                                notesListViewModel.fetchNotes(offset: 0, reset: true, modelContext: modelContext)
                            }
                            .environmentObject(noteViewModel)
                            .onAppear {
                                noteViewModel.originalNote = note
                                noteViewModel.note = note
                                noteViewModel.tags = note.tags
                                isAddViewPresented = false
                            }
                        }
                    } label: {
                        NoteCell(
                            selectedDay: Binding(
                                get: { selectedDay ?? monthDate },
                                set: { self.selectedDay = $0 }
                            ),
                            notes: notes
                        )
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                    }
                    .disabled(notes.note(for: selectedDay) == nil)

               
                       
                    Spacer()
                }
                .frame(maxWidth: .infinity)
            }
            .onAppear {
                withAnimation {
                    isAddViewPresented = true
                }
            }
            .navigationTitle("Calendar")
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
