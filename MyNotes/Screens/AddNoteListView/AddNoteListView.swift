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
    @EnvironmentObject private var viewModel: NoteViewModel
    @State private var selectedCoverData: [Data] = []
    @State private var isEditingImages: Bool = false  // Track if edit mode is active for images
    @Binding var isAddViewPresented: Bool
    @FocusState private var focusedField: FocusableField?

    @State private var textSize: CGFloat = 40

    @Environment(\.modelContext) private var context
    @Environment(\.dismiss) private var dismiss
    var fetchNote: (() -> Void)
    @State private var isNumberedList: SelectedList = .none
    @State var showPhotoPicker: Bool = false
    @Binding var tags: [TagModel]  // Use a Binding
    @State private var selectedFontName: FontName? = .bold
    enum FocusableField {
            case firstEditor, secondEditor
        }
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
                            .focused($focusedField, equals: .firstEditor)  // Focus state for the first editor
                                           .onSubmit {  // When the return key is pressed
                                               focusedField = .secondEditor
                                           }
                                           .frame(height: viewModel.selectedFontSize.fontValue + 5)
                            
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
                        Divider()
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
                            ), selectedFontName: Binding<FontName?>(
                                get: { viewModel.selectedFontName },
                                set: { newSize in
                                    // Update the view model when the editor changes the size
                                    if let newFontSize = FontName.allCases.first(where: { $0 == newSize }) {
                                        viewModel.selectedFontName = newFontSize
                                    }
                                }
                            ), selectedListStyle: $isNumberedList,
                            isEditable: true
                        ) 
                        .focused($focusedField, equals: .secondEditor)  // Focus state for the second editor
                            .frame(height: 200)  // Set a height for the editor to be visible
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
                                case .greenPoint:
                                    newText = "\n🟢 "
                                case .none:
                                    newText = "\n"
                                }

                                // Append the new text as an NSAttributedString
                                let attributedStringToAppend = NSAttributedString(string: newText)
                                mutableText.append(attributedStringToAppend)

                                // Update the view model's note text
                                viewModel.noteText = mutableText
                            }
                        
                       
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

                        viewModel.saveOrUpdateNote(in: context) {
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

                case .showKindOfList:
                    KindOfListView(selectedList: $isNumberedList)
                        .environmentObject(viewModel)
                        .presentationDetents([.fraction(0.5), .medium, .large])
                }
            }
            .onAppear {
                isAddViewPresented = false// show tapbar
                focusedField = .firstEditor  // Focus the first editor when the view appears
            }
        }
        .toolbar(.hidden, for: .tabBar) // Hides TabBar
    }
    private func handleDeleteAction(for data: Data) {
        if let index = viewModel.selectedCoverDataList.firstIndex(of: data) {
            viewModel.selectedCoverDataList.remove(at: index) // Update viewModel

        }
    }
    private func applyListStyle(_ style: SelectedList, to textView: UITextView) {
        guard style != .none else { return } // Exit if no style is selected

        // Ensure the text ends with a newline before appending the new list style
        if !textView.text.hasSuffix("\n") {
            textView.text.append("\n")
        }

        // Get the list marker from the selected style
        let listMarker = style.markForList

        // Create a mutable attributed string to append the list marker
        let mutableAttributedString = NSMutableAttributedString(attributedString: textView.attributedText)
        
        // Append the list marker
        mutableAttributedString.append(listMarker)
        mutableAttributedString.append(NSAttributedString(string: " ")) // Add a space after the marker
        
        // Update the text view with the new attributed string
        textView.attributedText = mutableAttributedString

        // Move the cursor to the end of the text
        let endPosition = textView.endOfDocument
        textView.selectedTextRange = textView.textRange(from: endPosition, to: endPosition)
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
    case showTextEditor
    case showKindOfList
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
        case .showTextEditor:
            return "showTextEditor"
        case .showKindOfList:
            return "showKindOfList"
        }
    }
}


