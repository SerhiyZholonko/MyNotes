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
    @EnvironmentObject var viewModel: NoteViewModel
    @Binding var isEditMode: Bool
    @State private var selectedCover: [PhotosPickerItem] = []
    @State private var selectedCoverData: [Data] = []
    @State private var isEditingImages: Bool = false  // Track if edit mode is active for images
    @State private var isAddTags: Bool = false
    @State var showPhotoPicker: Bool = false
    @State private var isNumberedList: SelectedList = .numbered

    @State var textEditorHeight: CGFloat = 200
    @State private var selectedFontName: FontName? = .bold


    var body: some View {
        VStack(alignment: .leading) {
            ScrollView {
            VStack {
                HStack {
//                    TextField("Title", text: $viewModel.title)
//                        .textFieldStyle(.plain)
                    RichTextEditor(
                        attributedText: $viewModel.title,
                        selectedTextColor: $viewModel.selectedTextColor,
                        selectedRange: $viewModel.titleSelectedRange,
                        textSize: Binding<CGFloat>(
                            get: { viewModel.selectedFontSize.fontValue },
                            set: { newSize in
                                // Update the view model when the editor changes the size
                                if let newFontSize = FontSize.allCases.first(where: { $0.fontValue == newSize }) {
                                    viewModel.selectedFontSize = newFontSize
                                }
                            }
                        ), selectedFontName: Binding<FontName?>(
                            get: { viewModel.selectedFontName },
                            set: { newSize in
                                // Update the view model when the editor changes the size
                                if let newFontSize = FontName.allCases.first(where: { $0 == newSize }) {
                                    viewModel.selectedFontName = newFontSize
                                }
                            }
                        ), selectedListStyle: .constant(.none),
                        isEditable: true
                    )
                        .frame(height: 40)
                    Spacer()
                    EnergyAndFeelingView(isEditMode: $isEditMode)
                        .environmentObject(viewModel)
                }
                
                    .padding(.vertical)

                RichTextEditor(
                    attributedText: $viewModel.noteText,
                    selectedTextColor: $viewModel.selectedTextColor,
                    selectedRange: $viewModel.noteTextSelectedRange,
                    textSize: Binding<CGFloat>(
                        get: { viewModel.selectedFontSize.fontValue },
                        set: { newSize in
                            // Update the view model when the editor changes the size
                            if let newFontSize = FontSize.allCases.first(where: { $0.fontValue == newSize }) {
                                viewModel.selectedFontSize = newFontSize
                            }
                        }
                    ),selectedFontName: Binding<FontName?>(
                        get: { viewModel.selectedFontName },
                        set: { newSize in
                            // Update the view model when the editor changes the size
                            if let newFontSize = FontName.allCases.first(where: { $0 == newSize }) {
                                viewModel.selectedFontName = newFontSize
                            }
                        }
                    ), selectedListStyle:  $isNumberedList, 
                    isEditable: true
                )
                    .frame(height: 200)  // Set a height for the editor to be visible
//                    .border(Color.gray)
            }
            .textFieldStyle(.roundedBorder)
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

        .sheet(item: $viewModel.actionSheetPresentation){ item in
            
            switch item {
            case .feeling:
                EditEnergyView(actionSheetPresentation: $viewModel.actionSheetPresentation)
                    .environmentObject(viewModel)
//                    .presentationDetents([.medium])
            case .smile:
                EditEmojiView(actionSheetPresentation: $viewModel.actionSheetPresentation)
                    .environmentObject(viewModel)
                    .presentationDetents([.medium]) 
            case .showAlert:
                Text("showAlert")
            case .showTags:
                AddTagsView(selectedTags: $viewModel.selectedTags)

                    .presentationDetents([.fraction(0.5), .medium, .large])
                    .environmentObject(viewModel)            case .showTextEditor:
                FontView()
                    .environmentObject(viewModel)
                    .presentationDetents([.fraction(0.5), .medium, .large])
                
            case .showKindOfList:
                Text("")
            }
        }

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
    private func handleDeleteAction(for data: Data) {
        if let index = viewModel.selectedCoverDataList.firstIndex(of: data) {
            viewModel.selectedCoverDataList.remove(at: index) // Update viewModel

        }
    }
}

