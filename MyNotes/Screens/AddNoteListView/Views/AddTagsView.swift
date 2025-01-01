//
//  AddTagsView.swift
//  MyNotes
//
//  Created by apple on 01.01.2025.
//

import SwiftUI
import SwiftData


struct AddTagsView: View {
    @Environment(\.dismiss) private var dismiss

    @Query(sort: \TagModel.name) var tags: [TagModel]
    @Binding var selectedTags: Set<TagModel>
    var isAddTags: Binding<Bool>? = nil // Optional Binding with default value

    let columns = [
        GridItem(.flexible(), spacing: 16), // Adjust spacing between columns
        GridItem(.flexible(), spacing: 16)
    ]

    var body: some View {
        NavigationStack {
            VStack {
                if tags.isEmpty {
                    Text("No tags added yet.")
                        .foregroundColor(.secondary)
                } else {
                    ScrollView(.vertical, showsIndicators: false) {
                        LazyVGrid(columns: columns, alignment: .leading, spacing: 8) { // Spacing between rows
                            ForEach(tags) { tag in
                                TagCell(tag: tag, selectedTags: $selectedTags)
                                    .padding(.horizontal, 4)
                            }
                        }
                        .padding()
                    }
                }
            }
            .navigationTitle("Tags")
            .navigationBarItems(trailing:
                                    Button(action: {
                dismiss()
            }, label: {
                Image(systemName: "checkmark")

            })
                                   )
            
        }
       
    }
}



