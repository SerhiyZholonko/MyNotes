//
//  EditNoteDetailCellView.swift
//  MyNotes
//
//  Created by apple on 30.11.2024.
//


import SwiftUI
import PhotosUI
import SwiftData

struct EditNoteDetailCellView: View {
    @Query(sort: \TagModel.name) var tags: [TagModel]
    @Environment(\.modelContext) private var modelContext  // Access the ModelContext
    @Environment(\.modelContext) private var context
    @EnvironmentObject var viewModel: NoteDetailViewModel
    @Binding var isEditMode: Bool
    @State private var selectedCover: [PhotosPickerItem] = []
    @State private var selectedCoverData: [Data] = []
    @State private var isEditingImages: Bool = false  // Track if edit mode is active for images
    @State private var isAddTags: Bool = false
    
    var body: some View {
        VStack(alignment: .leading) {
      
            VStack {
                TextField("Title", text: $viewModel.title)
                    .textFieldStyle(.plain)
                    .padding(.vertical)
                ResizableTextEditor(text: $viewModel.note, placeholder: "Note")
                    .lineLimit(2)
            }
            .textFieldStyle(.roundedBorder)
            TagsListView(selectedTags: $viewModel.selectedTags, isAddTags: $isAddTags)

            .padding(.vertical)
            HStack {
                PhotosPicker(selection: $selectedCover, matching: .images, photoLibrary: .shared()) {
                        Image(uiImage: UIImage(systemName: "plus.rectangle.fill")! )
                            .resizable()
                            .frame(width: 30, height: 30)
                }

                VStack {
                                    if !selectedCoverData.isEmpty {
                                        ScrollView(.horizontal) {
                                            HStack(spacing: 20) {
                                                ForEach(selectedCoverData, id: \.self) { imageData in
                                                    ZStack(alignment: .topTrailing) {
                                                        Image(uiImage: UIImage(data: imageData) ?? UIImage(systemName: "photo")!)
                                                            .resizable()
                                                           
                                                            .frame(width: 100, height: 100)
                                                            .scaledToFill()
                                                            .cornerRadius(20)
                                                            .onLongPressGesture {
                                                                withAnimation {
                                                                    isEditingImages.toggle()  // Toggle edit mode
                                                                }
                                                            }
                                                        
                                                        if isEditingImages {

                                                                ZStack{
                                                                    Color.white
                                                                        .frame(width: 30, height: 30)
                                                                        .cornerRadius(15)

                                                                    Image(systemName: "trash.fill")
                                                                        .resizable()
                                                                        .frame(width: 24, height: 24)
                                                                        .foregroundColor(.red)
                                                                        .onTapGesture {
                                                                            if let index = selectedCoverData.firstIndex(of: imageData) {
                                                                                selectedCoverData.remove(at: index)
                                                                                viewModel.imagesData.remove(at: index)  // Update viewModel
                                                                            }
                                                                        }
                                                                }
                                    
                                                                .offset(x: -5, y: 70)  // Adjust position to place in the middle of the top edge
                                                            
                                                                                                                                                                           
                                                        }
                                                    }
                                                }
                                            }
                                        }
                                    } else {
                                        Text("No Images")
                                    }
                                }
                            
        }
        }
        .onTapGesture {
            if isEditingImages {
                isEditingImages = false
            }
        }
        .sheet(isPresented: $isAddTags, content: {
            VStack(spacing: 20) {
                Text("Enter new tag")
                    .font(.headline)
                TextField("Tag name", text: $viewModel.newTag)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding()
                HStack {
                    Button("Cancel") {
                        isAddTags.toggle()
                    }
                    .foregroundColor(.red)
                    Spacer()
                    Button("Add Tag") {
                        print("New Tag: \(viewModel.newTag)")
                        viewModel.saveNewTag(in: context)
                        isAddTags.toggle()

//                        viewModel.actionSheetPresentation = nil
                    }
                }
                .padding()
            }
            .presentationDetents([.fraction(0.3), .medium, .large])
        })
        .onAppear {
            selectedCoverData = viewModel.imagesData
        }
        .task(id: selectedCover) {
            for item in selectedCover {
                if let data = try? await item.loadTransferable(type: Data.self) {
                    selectedCoverData.append(data)
                    viewModel.imagesData.append(data)
                }
            }
        }
    }
}

