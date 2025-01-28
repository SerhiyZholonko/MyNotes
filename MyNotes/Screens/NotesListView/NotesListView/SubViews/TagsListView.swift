//
//  TagsListView.swift
//  MyNotes
//
//  Created by apple on 30.11.2024.
//


import SwiftUI
import SwiftData

struct TagsListView: View {
    @Query(sort: \TagModel.name) var tags: [TagModel]
    @Binding var selectedTags: Set<TagModel>
    var isAddTags: Binding<Bool>? = nil  // Optional Binding with default value
    
    var body: some View {

            if tags.isEmpty {
                Text("No tags added yet.")
                    .foregroundColor(.secondary)
            } else {
                
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 8) { // Adjust spacing between tags
                        ForEach(tags) { tag in
                            TagCell(tag: tag, selectedTags: $selectedTags)
                                .padding(.vertical, 4) // Add vertical padding for each tag
                        }
                    }
                    .padding(.horizontal) // Add padding to the entire HStack
                }
              
            }

    }
}
