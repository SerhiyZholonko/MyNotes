//
//  NoteCell.swift
//  MyNotes
//
//  Created by apple on 19.01.2025.
//

import SwiftUI

struct NoteCell: View {
    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                Text(Date.now.toString(format: "dd"))
                    .font(.largeTitle)
                VStack(alignment: .leading) {
                    Text(Date.now.toString(format: "EEEE"))
                    Text(Date.now.toString(format: "MMMM, yyyy"))
                }
            }
            Text("Title")
            Text("Body text..")
        }
        .padding(.horizontal)
        .frame(maxWidth: .infinity, alignment: .leading) // Align the VStack to the left
    }
}
#Preview {
    NoteCell()
}
