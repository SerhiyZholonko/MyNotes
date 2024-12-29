//
//  TagCell.swift
//  MyNotes
//
//  Created by apple on 30.11.2024.
//

import SwiftUI

struct TagCell: View {
    var tag: TagModel
    @Binding var selectedTags: Set<TagModel>
    
    var body: some View {
        HStack {
            Text("# ")
            Text(tag.name)
        }
        .padding()
        .background(
            selectedTags.contains(tag) ? Color.green.opacity(0.2) : Color.clear,
            in: .capsule
        )
        .onTapGesture {
            if selectedTags.contains(tag) {
                selectedTags.remove(tag)  // Remove tag if already selected
            } else {
                selectedTags.insert(tag)  // Add tag if not selected
            }
        }
    }
}
