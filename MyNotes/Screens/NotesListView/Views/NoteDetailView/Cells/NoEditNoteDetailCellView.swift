//
//  NoEditNoteDetailCellView.swift
//  MyNotes
//
//  Created by apple on 30.11.2024.
//

import SwiftUI


struct NoEditNoteDetailCellView: View {
    @EnvironmentObject var viewModel: NoteViewModel
    @State private var selectedImage: UIImage? = nil  // Store the selected image
    @State private var isFullScreenPresented = false // Track full-screen presentation
    @State private var textEditerHeight: CGFloat = 200
    @State private var textSize: CGFloat = 16
    @State private var selectedFontName: FontName? = .bold
    @State private var calculatedHeight: CGFloat = 200 // Default height

    @Binding var isEditMode: Bool

    var body: some View {
        Group {
            ScrollView {
            VStack(alignment: .leading) {
                HStack {
                    RichTextEditor(attributedText: $viewModel.title, selectedTextColor: $viewModel.selectedTextColor, selectedRange: $viewModel.titleSelectedRange, textSize: $textSize, selectedFontName: $selectedFontName, selectedListStyle: .constant(.none), height: .constant(40), isScrollEnabled: true)
                        .frame(height: 40)  // Set a height for the editor to be visible
                    Spacer()
                    EnergyAndFeelingView( isEditMode: $isEditMode)
                        .environmentObject(viewModel)
                }
                
                RichTextEditor(attributedText: $viewModel.noteText, selectedTextColor: $viewModel.selectedTextColor, selectedRange: $viewModel.noteTextSelectedRange, textSize: $textSize, selectedFontName: $selectedFontName, selectedListStyle: .constant(.none), height: .constant(40), isScrollEnabled: true)
                    .frame(height: calculatedHeight)
                    .onChange(of: viewModel.noteText) { _, _ in
                        updateHeight()
                    }
                    .onAppear {
                        updateHeight()
                    }
                HStack {
                    if !viewModel.tags.isEmpty {
                        Text("# ")
                            .font(.system(size: 20, weight: .bold))
                        
                        HStack {
                            ForEach(viewModel.tags, id: \.self) { tag in
                                Text(tag.name)
                                    .font(.caption)
                                    .padding(.horizontal, 8)
                                    .padding(.vertical, 8)
                                    .background(.green.opacity(0.2), in: .capsule)
                            }
                        }
                    }
                }
                .padding(.vertical)
                
                ScrollView(.horizontal) {
                    HStack {
                        ForEach(viewModel.imagesData, id: \.self) { imageData in
                            if let uiImage = UIImage(data: imageData) {
                                Image(uiImage: uiImage)
                                    .resizable()
                                    .frame(width: 100, height: 100)
                                    .scaledToFill()
                                    .cornerRadius(20)
                                    .onTapGesture {
                                        viewModel.selectedImage = uiImage  // Set the tapped image
                                        isFullScreenPresented = true // Show the full screen
                                    }
                            }
                        }
                    }
                }
            }
            .frame(maxWidth: .infinity, alignment: .leading)
        }
            .scrollIndicators(.never) // Turns off the scroll indicators

        }
        .fullScreenCover(isPresented: $isFullScreenPresented) {
            // Force unwrap the optional selectedImage
            if let selectedImage = viewModel.selectedImage {
                FullScreenImageView(image: selectedImage, isPresented: $isFullScreenPresented)
            }
        }
        .formStyle(.grouped)
        .toolbar(.hidden, for: .tabBar) // Hides TabBar

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

struct FullScreenImageView: View {
    var image: UIImage  // The image should be non-optional
    @Binding var isPresented: Bool

    var body: some View {
        ZStack {
            Color.black.ignoresSafeArea()

            Image(uiImage: image)
                .resizable()
                .scaledToFit()
                .onTapGesture {
                    isPresented = false
                }
        }
    }
}
