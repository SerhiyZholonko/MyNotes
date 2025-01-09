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
    @Binding var isEditMode: Bool

    var body: some View {
        Group {
            VStack(alignment: .leading) {
                HStack {
                    Text(viewModel.title)
                    
                    Spacer()
                    EnergyAndFeelingView( isEditMode: $isEditMode)
                        .environmentObject(viewModel)
                }
//                Text(viewModel.noteText.string)
                RichTextEditor(attributedText: $viewModel.noteText, selectedTextColor: $viewModel.selectedTextColor, selectedRange: $viewModel.selectedRange, textSize: $textSize)
                    .frame(height: 200)  // Set a height for the editor to be visible
                            .border(Color.gray)
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
        .fullScreenCover(isPresented: $isFullScreenPresented) {
            // Force unwrap the optional selectedImage
            if let selectedImage = viewModel.selectedImage {
                FullScreenImageView(image: selectedImage, isPresented: $isFullScreenPresented)
            }
        }
        .formStyle(.grouped)
        .toolbar(.hidden, for: .tabBar) // Hides TabBar

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
