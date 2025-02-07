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
    @State private var showAlert = false
    @State private var alertMessage = ""
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
                        viewModel.saveOrUpdateNote(in: modelContext) { result in
                            switch result {
                            case .success:
                                updateNoteList?()
                                isEditMode.toggle()
                                dismiss()
                            case .failure(let error):
                                alertMessage = error.localizedDescription
                                                        showAlert = true
                            }
                            
                        }
                    } else {
                        isEditMode.toggle()
                    }
                } label: {
                    Image(systemName: isEditMode ? "checkmark" : "square.and.pencil")
                }
                .alert("Error", isPresented: $showAlert) {
                    Button("OK", role: .cancel) {}
                } message: {
                    Text(alertMessage)
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
        .tint(Color(uiColor: .label))
    }
}
