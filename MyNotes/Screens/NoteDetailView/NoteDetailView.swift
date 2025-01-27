//
//  NoteDetailView.swift
//  MyNotes
//
//  Created by apple on 30.11.2024.
//

//NoteDetailViewModel

import SwiftUI
import SwiftData




struct NoteDetailView: View {
    @State var isEditMode: Bool = false
    @EnvironmentObject var viewModel: NoteViewModel  // Correct ObservedObject usage
    @Environment(\.modelContext) private var modelContext  // Access the ModelContext
    @Environment(\.dismiss) private var dismiss
    var updateNoteList: (() -> Void)?
    
    var body: some View {
        VStack {
            if isEditMode {
                EditNoteDetailCellView(isEditMode: $isEditMode)
                    .environmentObject(viewModel)  // Pass viewModel as EnvironmentObject
            } else {
                NoEditNoteDetailCellView(isEditMode: $isEditMode)
                    .environmentObject(viewModel)  // Pass viewModel as EnvironmentObject
            }
            Spacer()
        }
        .padding()
        .navigationTitle("Book Details")
        .navigationBarBackButtonHidden()
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button {
                    if isEditMode {
                        viewModel.saveOrUpdateNote(in: modelContext) {
                            updateNoteList?()
                            isEditMode.toggle()
                            dismiss()
                        }
                    } else {
                        isEditMode.toggle()
                    }
                } label: {
                    Image(systemName: isEditMode ? "checkmark" : "square.and.pencil")
                }
            }
            ToolbarItem(placement: .navigationBarLeading) {
                Button {
                    dismiss()
                } label: {
                    Image(systemName: "chevron.left")
                        .fontWeight(.bold)
                }
            }
        }
    }
}
