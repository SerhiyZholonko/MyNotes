//
//  NoteCell.swift
//  MyNotes
//
//  Created by apple on 19.01.2025.
//

import SwiftUI

struct NoteCell: View {
    @EnvironmentObject var noteViewModel: NoteViewModel
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
//                RichTextEditor(attributedText: note.title.plainText, selectedTextColor: $noteViewModel.selectedTextColor, selectedRange: $noteViewModel.noteTextSelectedRange, textSize: $textSize, selectedFontName: $selectedFontName, selectedListStyle: .constant(.none), height: .constant(40), isScrollEnabled: true)

                Text(note.title.plainText) // Use the plain text of the title
                Text(note.noteText.plainText) // Use the plain text of the noteText
            } else {
                VStack(alignment: .center){
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
                .padding()
                .frame(maxWidth: .infinity, maxHeight: .infinity)
            }
        }
        .padding()
        .frame(maxWidth: .infinity, alignment: .leading)
        .foregroundStyle(Color(UIColor.label))
        
        .background(Color(uiColor: .systemBackground))
    
        .cornerRadius(10)
        .padding()
    }
}
