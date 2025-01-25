//
//  NoteCell.swift
//  MyNotes
//
//  Created by apple on 19.01.2025.
//

import SwiftUI

struct NoteCell: View {
    @Binding var selectedDay: Date? // Change to optional
    var notes: [NoteModel]
    var body: some View {
        VStack(alignment: .leading) {
            if let note = notes.note(for: selectedDay) {
                HStack {
                    Text(selectedDay?.toString(format: "dd") ?? "N/A")
                        .font(.largeTitle)
                    VStack(alignment: .leading) {
                        Text(note.date.toString(format: "EEEE"))
                        Text(note.date.toString(format: "MMMM, yyyy"))
                    }
                }
                Text(note.title.plainText) // Use the plain text of the title
                Text(note.noteText.plainText) // Use the plain text of the noteText
            } else {
                VStack {
                    Image(systemName: "square.and.pencil") // Add a relevant SF Symbol
                        .resizable()
                        .scaledToFit()
                        .frame(width: 50, height: 50)
                        .foregroundColor(.gray)
                        .padding(.bottom, 10)
                    
                    Text("No notes available for the selected day")
                        .font(.headline)
                        .foregroundColor(.gray)
                        .multilineTextAlignment(.center)
                    
                }
                .padding()            }
        }
        .padding(.horizontal)
        .frame(maxWidth: .infinity, alignment: .leading)
    }
}
