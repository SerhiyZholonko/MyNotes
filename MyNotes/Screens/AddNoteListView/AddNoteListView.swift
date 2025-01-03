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
    @Binding var isAddViewPresented: Bool

    @Environment(\.modelContext) private var context
    @Environment(\.dismiss) private var dismiss
    var fetchNote: (() -> Void)
    @State var showPhotoPicker: Bool = false
    @Binding var tags: [TagModel]  // Use a Binding

    
    
    init(tags: Binding<[TagModel]>, isAddViewPresented: Binding<Bool>, fetchNote: @escaping (() -> Void)) {
        self._tags = tags
        self._isAddViewPresented = isAddViewPresented
        self.fetchNote = fetchNote // Initialize fetchNote first
    }
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .center) {
                    
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
                    HStack( spacing: 8) {
                        
                        ForEach(Array(viewModel.selectedTags), id: \.id) { tag in
                            Text("#\(tag.name)")
                        }
                        Spacer()
                    }
                    Spacer()
                        
                    
                }
                .padding()
            }
            VStack {
                TextEditView(showPhotoPicker: $showPhotoPicker)
                    .environmentObject(viewModel)
                    .photosPicker(
                        isPresented: $showPhotoPicker,
                             selection: $viewModel.selectedCover,
                             matching: .images,
                             photoLibrary: .shared()
                         )
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
                        viewModel.saveNote(in: context) {
                            fetchNote()
                            dismiss()
                        }
                    }) {
                        Text("Save")
                    }
                }
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
                                viewModel.actionSheetPresentation = .showTags
                            }
                            .foregroundColor(.red)
                            Spacer()
                            Button("Add Tag") {
                                print("New Tag: \(viewModel.newTag)")
                                viewModel.saveNewTag(in: context)
                                viewModel.actionSheetPresentation = .showTags
                            }
                        }
                        .padding()
                    }
                    .presentationDetents([.fraction(0.3), .medium, .large])
                case .showTags:
                    AddTagsView(selectedTags: $viewModel.selectedTags)

                        .presentationDetents([.fraction(0.5), .medium, .large])
                        .environmentObject(viewModel)
                        
                case .showTextEditor:
                    //Text("showTextEditor")
                    FontView()
                        .environmentObject(viewModel)   
                        .presentationDetents([.fraction(0.5), .medium, .large])

                }
            }
           
            .onAppear {
                isAddViewPresented = false
            }
            
        }
        .toolbar(.hidden, for: .tabBar) // Hides TabBar

    }
    private func handleDeleteAction(for data: Data) {
        if let index = viewModel.selectedCoverDataList.firstIndex(of: data) {
            viewModel.selectedCoverDataList.remove(at: index) // Update viewModel

        }
    }
}
#Preview {
    AddNoteListView(tags: .constant([]), isAddViewPresented: .constant(true)) {
        
    }
}

enum ActionSheetPresentation: Identifiable {
    case smile
    case feeling
    case showAlert
    case showTags
//    case showPhotoLibrary
    case showTextEditor
    // Provide a unique ID for each case
    var id: String {
        switch self {
        case .smile:
            return "smile"
        case .feeling:
            return "feeling"
        case .showAlert:
            return "showAlert"
        case .showTags:
            return "showTags"
//        case .showPhotoLibrary:
//            return "showPhotoLibrary"
        case .showTextEditor:
            return "showTextEditor"
        }
    }
}


