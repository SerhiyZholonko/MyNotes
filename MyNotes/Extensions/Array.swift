//
//  Array.swift
//  MyNotes
//
//  Created by apple on 25.01.2025.
//

import Foundation
extension Array where Element == NoteModel {
    func note(for selectedDay: Date?) -> NoteModel? {
        guard let selectedDay = selectedDay else { return nil }
        
        // Use Calendar to match only the year, month, and day components
        let calendar = Calendar.current
        return self.first {
            calendar.isDate($0.date, inSameDayAs: selectedDay)
        }
    }
}
