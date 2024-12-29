//
//  AddNoteListView.swift
//  MyNotes
//
//  Created by apple on 30.11.2024.
//

import Foundation

import SwiftUI
import SwiftData
import PhotosUI




struct AddNoteListView: View {
    @StateObject private var viewModel = AddNoteListViewModel()
    @State private var selectedCoverData: [Data] = []
    @State private var isEditingImages: Bool = false  // Track if edit mode is active for images
    
    @Environment(\.modelContext) private var context
    @Environment(\.dismiss) private var dismiss
    var fetchNote: (() -> Void)
    
//    private var tags: [TagModel] = []
    @Binding var tags: [TagModel]  // Use a Binding

    
    
    init(tags: Binding<[TagModel]>, fetchNote: @escaping (() -> Void)) {
        self._tags = tags
        self.fetchNote = fetchNote // Initialize fetchNote first
    }
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading) {
                    
                    VStack {
                        HStack {
                            TextField("Title", text: $viewModel.title)
                            Text(viewModel.selectedFeeling.emoji)
                                .font(.system(size: 40))
                                .onTapGesture {
                                    viewModel.actionSheetPresentation = .smile // Show smile sheet
                                }
                            ZStack {
                                
                                Color.fromHex(viewModel.selectedEnergy.color ?? "#FFFFFFFF").fontWeight(.bold)
                                    .frame(width: 40, height: 40)
                                    .cornerRadius(20)
                                    .onTapGesture {
                                        viewModel.actionSheetPresentation = .feeling // Show feeling sheet
                                    }
                                Image(systemName: viewModel.selectedEnergy.sfSymbol)
                                    .resizable()
                                    .frame(width: 30, height: 30)
                                
                            }
                        }
                        .padding(.trailing)
                        ResizableTextEditor(text: $viewModel.noteText, placeholder: "Note")
                    }
                    TagsListView(selectedTags: $viewModel.selectedTags)
                    HStack {
                        PhotosPicker(
                            selection: $viewModel.selectedCover,
                            matching: .images,
                            photoLibrary: .shared()
                        ) {
                            Label("Add Images", systemImage: "photo.on.rectangle.angled")
                        }
                        .padding(.vertical)
                        Spacer()
                    }
                                ScrollView(.horizontal) {
                                    HStack {
                                        ForEach(viewModel.selectedCoverDataList, id: \.self) { data in
                                            if let image = UIImage(data: data) {
                                                ZStack(alignment: .topTrailing) {
                                                    Image(uiImage: image)
                                                        .resizable()
                                                      
                                                        .clipShape(RoundedRectangle(cornerRadius: 10))
                                                        .frame(width: 100, height: 100)
                                                        .scaledToFill()
                                                        .cornerRadius(20)
                                                        .onLongPressGesture {
                                                            isEditingImages.toggle()
                                                        }
                                                    if isEditingImages {
                                                        Button {
                                                            if let index = viewModel.selectedCoverDataList.firstIndex(of: data) {
                                                                viewModel.selectedCoverDataList.remove(at: index)
                                                            }
                                                        } label: {
                                                            ZStack {
                                                                // Background Circle
                                                                Color.white
                                                                    .frame(width: 30, height: 30)
                                                                    .cornerRadius(15)

                                                                // Trash Icon
                                                                Image(systemName: "trash.fill")
                                                                    .resizable()
                                                                    .frame(width: 24, height: 24)
                                                                    .foregroundColor(.red)
                                                                    .onTapGesture {
                                                                        handleDeleteAction(for: data)
                                                                    }
                                                            }                                                        }
                                                        .offset(x: -5, y: 70)
                                                    }
                                                }
                                            } else {
                                                Image(systemName: "photo.on.rectangle")
                                                    .resizable()
                                                    .frame(width: 100, height: 100)
                                                    .scaledToFill()
                                                    .cornerRadius(20)
                                            }
                                        }
                                    }
                                }
                    Button {
                        viewModel.saveNote(in: context) {
                            fetchNote()
                            
                            dismiss()
                        }
                    } label: {
                        Text("Save")
                    }
                    .buttonStyle(.bordered)
                    Spacer()
                }
                .padding()
            }
            .task(id: viewModel.selectedCover) {
                for item in viewModel.selectedCover {
                    if let data = try? await item.loadTransferable(type: Data.self) {
                        viewModel.selectedCoverDataList.append(data)
                    }
                }
            }
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: {
                        dismiss()
                    }) {
                        Image(systemName: "xmark")
                    }
                }
//                ToolbarItem(placement: .navigationBarLeading) {
//                    Button(action: {
//                        viewModel.actionSheetPresentation = .showAlert // Show alert sheet
//                    }) {
//                        Text("Add tag")
//                    }
//                }
            }
            .sheet(item: $viewModel.actionSheetPresentation) { item in
                // Switch to handle different views
                switch item {
                case .smile:
                    EmojiView(actionSheetPresentation: $viewModel.actionSheetPresentation)
                        .environmentObject(viewModel)
                        .presentationDetents([.medium]) // Set the size to medium
                    
                case .feeling:
                    EnergyView(actionSheetPresentation:  $viewModel.actionSheetPresentation)
                        .environmentObject(viewModel)
                        .presentationDetents([.medium]) // Set the size to medium
                case .showAlert:
                    VStack(spacing: 20) {
                        Text("Enter new tag")
                            .font(.headline)
                        TextField("Tag name", text: $viewModel.newTag)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                            .padding()
                        HStack {
                            Button("Cancel") {
                                viewModel.actionSheetPresentation = nil
                            }
                            .foregroundColor(.red)
                            Spacer()
                            Button("Add Tag") {
                                print("New Tag: \(viewModel.newTag)")
                                viewModel.saveNewTag(in: context)
                                viewModel.actionSheetPresentation = nil
                            }
                        }
                        .padding()
                    }
                    .presentationDetents([.fraction(0.3), .medium, .large])
                }
            }
        }
    }
    private func handleDeleteAction(for data: Data) {
        if let index = viewModel.selectedCoverDataList.firstIndex(of: data) {
            viewModel.selectedCoverDataList.remove(at: index) // Update viewModel

        }
    }
}


enum ActionSheetPresentation: Identifiable {
    case smile
    case feeling
    case showAlert
    
    // Provide a unique ID for each case
    var id: String {
        switch self {
        case .smile:
            return "smile"
        case .feeling:
            return "feeling"
        case .showAlert:
            return "showAlert"
        }
    }
}
