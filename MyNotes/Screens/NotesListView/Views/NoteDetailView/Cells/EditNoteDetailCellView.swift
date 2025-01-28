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
    @State private var isNumberedList: SelectedList = .none

    @State private var selectedFontName: FontName? = .bold
    @State private var editorHeight: CGFloat = 40 // Default height
    @State private var calculatedHeight: CGFloat = 200 // Default height

    var body: some View {
        ScrollView {
        VStack(alignment: .leading) {
            VStack {
                HStack {
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
                        ), selectedListStyle: .constant(.none), height: .constant(40),
                        isEditable: true, isScrollEnabled: true
                    )
                    .frame( height: 40)
                    .frame(maxWidth: .infinity)
                    
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
                    ), selectedListStyle:  $isNumberedList, height: $editorHeight,
                    isEditable: true, isScrollEnabled: true
                )
                
                //                .frame(width: UIScreen.main.bounds.width)
                .frame(height: calculatedHeight) // Bind dynamic height
                .onChange(of: viewModel.noteText) { _, _ in
                    updateHeight()
                }
                .onAppear {
                    updateHeight()
                }
                
                //                    .border(Color.gray)
                .onChange(of: isNumberedList) { oldValue, newValue in
                    // Create a mutable copy of the existing note text
                    let mutableText = NSMutableAttributedString(attributedString: viewModel.noteText)
                    
                    // Define the text to append based on the selected list style
                    let newText: String
                    switch newValue {
                    case .numbered:
                        newText = "\n1. "
                    case .simpleNumbered:
                        newText = "\n1) "
                    case .star:
                        newText = "\n★ "
                    case .point:
                        newText = "\n● "
                    case .heart:
                        newText = "\n❤️ "
                        
                        //                        case .greenPoint:
                        //                            newText = "\n🟢 "
                    case .none:
                        newText = "\n"
                    }
                    let attributes: [NSAttributedString.Key: Any] = [
                        .font: UIFont(name: viewModel.selectedFontName?.fontName ?? "System", size: viewModel.selectedFontSize.fontValue) ?? UIFont.systemFont(ofSize: viewModel.selectedFontSize.fontValue),
                        .foregroundColor: UIColor(viewModel.selectedFontColor?.color ?? .black) ?? UIColor.black // Use a default color if nil
                    ]
                    let attributedStringToAppend = NSAttributedString(string: newText, attributes: attributes)
                    mutableText.append(attributedStringToAppend)
                    
                    // Update the view model's note text
                    viewModel.noteText = mutableText
                }
            }
            //            .textFieldStyle(.roundedBorder)
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
            
                .padding()
        }
    }
        .scrollIndicators(.never) // Turns off the scroll indicators

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
                KindOfListView(selectedList: $isNumberedList)
                    .environmentObject(viewModel)
                    .presentationDetents([.fraction(0.5), .medium, .large])            }
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
    private func updateHeight() {
         let maxWidth: CGFloat = UIScreen.main.bounds.width - 40 // Adjust as needed
         let text = viewModel.noteText.string // Convert NSAttributedString to plain string
         let font = UIFont.systemFont(ofSize: 16) // Adjust font as used in RichTextEditor

         let size = CGSize(width: maxWidth, height: .greatestFiniteMagnitude)
         let boundingBox = text.boundingRect(with: size,
                                             options: [.usesLineFragmentOrigin, .usesFontLeading],
                                             attributes: [.font: font],
                                             context: nil)
         calculatedHeight = boundingBox.height + 20 // Add padding or set a minimum height
     }
}

