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
    @EnvironmentObject var viewModel: AddNoteListViewModel
    @Query(sort: \TagModel.name) var tags: [TagModel]
    @Binding var selectedTags: Set<TagModel>
    var isAddTags: Binding<Bool>? = nil // Optional Binding with default value

    let columns = [
        GridItem(.flexible()), // Adjust spacing between columns
        GridItem(.flexible()),
        GridItem(.flexible())

    ]

    var body: some View {
        NavigationStack {
            VStack {
                if tags.isEmpty {
                    Text("No tags added yet.")
                        .foregroundColor(.secondary)
                } else {
                    ScrollView(.horizontal, showsIndicators: false) {
                        LazyVGrid(columns: columns, alignment: .leading, spacing: 8) { // Spacing between rows
                            ForEach(tags) { tag in
                                TagCell(tag: tag, selectedTags: $selectedTags)
                                    .frame(width: 150, alignment: .leading)
//                                    .padding(.horizontal, 4)
                            }
                        }
                        .padding()
                    }
                }
                Spacer()
            }
            .navigationTitle("Tags")
            .navigationBarItems(
                leading:
                    Button(action: {
                        viewModel.actionSheetPresentation = .showAlert
}, label: {
Image(systemName: "plus")

}),
                trailing:
                                    Button(action: {
                dismiss()
            }, label: {
                Image(systemName: "checkmark")

            })
           
                                   )
            
        }
       
    }
}



