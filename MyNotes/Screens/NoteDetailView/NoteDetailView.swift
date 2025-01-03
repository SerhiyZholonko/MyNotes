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
    @Binding var isAddViewPresented: Bool

    @State var isEditMode: Bool = false
    @ObservedObject var viewMModel: NoteDetailViewModel
    @Environment(\.modelContext) private var modelContext  // Access the ModelContext
    @Environment(\.dismiss) private var dismiss
    var updateNoteList: (() -> Void)
    init(isAddViewPresented: Binding<Bool>, note: NoteModel, updateNoteList: @escaping (() -> Void)) {
        _isAddViewPresented = isAddViewPresented
        self.updateNoteList = updateNoteList
        self._viewMModel = ObservedObject(wrappedValue: NoteDetailViewModel(note: note, allTags: note.tags))
    }
    
   // EditNoteDetailCellView
    var body: some View {
        VStack {
            if isEditMode {
                EditNoteDetailCellView(isEditMode: $isEditMode)
                    .environmentObject(viewMModel)
            } else {
                NoEditNoteDetailCellView(isEditMode: $isEditMode)
                    .environmentObject(viewMModel)
            }
            Spacer()
        }
        .padding()

        .navigationTitle("Book Details")
        .navigationBarBackButtonHidden()
        .toolbar{
            ToolbarItem(placement: .navigationBarTrailing) {
                Button {
                    if isEditMode {
                        viewMModel.updateNote(in: modelContext)
                        isEditMode.toggle()
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
        .onAppear {
            isAddViewPresented = false
        }
    }
}
