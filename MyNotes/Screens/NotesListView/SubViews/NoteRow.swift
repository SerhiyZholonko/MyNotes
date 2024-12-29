//
//  NoteRow.swift
//  MyNotes
//
//  Created by apple on 14.12.2024.
//

import SwiftUI

struct NoteRow: View {
    let note: NoteModel // Pass the NoteModel instance

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Text(note.title) // Replace with your actual property
                    .font(.headline)
                Spacer()
                Text("\(note.emoji.emoji)")
                    .font(.system(size: 40))
                ZStack {
                    Rectangle()
                        .fill(Color.fromHex(note.energy.color ?? ""))
                        .frame(width: 40, height: 40)
                        .cornerRadius(20)
                    Image(systemName: note.energy.sfSymbol)
                        .resizable()
                        .frame(width: 25, height: 25)
                        .foregroundColor(.white)
                }
                
            }
           
            Text(note.noteText) // Replace with your actual property
                .font(.subheadline)
                .foregroundColor(.secondary)
            Text(note.date, style: .date) // Display the date
                .font(.caption)
                .foregroundColor(.gray)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(.horizontal)
        .background(Color(.secondarySystemBackground))
        .cornerRadius(8)
        .shadow(color: .black.opacity(0.1), radius: 4, x: 0, y: 2)
    }
}
