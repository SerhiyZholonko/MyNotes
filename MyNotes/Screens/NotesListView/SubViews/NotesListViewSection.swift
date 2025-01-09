//
//  NotesListViewSection.swift
//  MyNotes
//
//  Created by apple on 30.11.2024.
//

import Foundation


import SwiftUI

struct NotesListViewSection: View {
    @Binding var notes: [NoteModel]
    @Binding var selectedNote: NoteModel?
    var deleteAction: (IndexSet, [NoteModel]) -> Void
    
    var body: some View {
        List {
            ForEach(notes) { note in
                VStack(alignment: .leading) {
                    Text(note.date.toString())
                        .font(.headline)
                        .frame(maxWidth: .infinity, alignment: .leading)
                    Text(note.title)
                        .font(.headline)
                        .frame(maxWidth: .infinity, alignment: .leading)

                    Text(note.noteText.plainText)
                        .font(.body)
                        .multilineTextAlignment(.leading)
                        .lineLimit(nil)
                        .fixedSize(horizontal: false, vertical: true)
                }
                .background(Color.white)  // Ensure the tappable area is visible
                .contentShape(Rectangle())  // Make the whole area tappable
                .onTapGesture {
                    selectedNote = note  // Set the selected note
                }
            }
            .onDelete { indexSet in
                deleteAction(indexSet, notes)
            }
        }
    }
}
