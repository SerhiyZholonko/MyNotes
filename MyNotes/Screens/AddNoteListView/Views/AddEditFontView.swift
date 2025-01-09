//
//  DetailEditFontView.swift
//  MyNotes
//
//  Created by apple on 04.01.2025.
//


#Preview {
    DetailEditFontView()
}
import SwiftUI

struct DetailEditFontView: View {
    @EnvironmentObject var viewModel: NoteDetailViewModel
    @Environment (\.dismiss) private var dismiss
    let columns = Array(repeating: GridItem(.adaptive(minimum: 100), spacing: 16), count: 3) // Four columns with flexible width


    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading) {
                    //                Text("Select a font size")
                    //                    .padding(.vertical)
                   
                HStack {
                    ForEach(FontColor.allCases) { color in
                        Color(viewModel.selectedFontColor == color ? color.color : color.color.opacity(0.5))
                            .frame(width: 30, height: 30)
                            .cornerRadius(15)
                            .overlay(
                                Circle()
                                    .stroke(viewModel.selectedFontColor == color ? Color.gray : Color.clear, lineWidth: 2)
                            )
                            .onTapGesture {
                                viewModel.selectedFontColor = color
                                viewModel.selectedTextColor = UIColor(color.color)
                            }
                    }
                }
                .padding(.vertical)
                    Divider()
                        .frame( height: 2)
                        .background(.gray)
                        .padding(.vertical, 3)
                    HStack {
                        ForEach(FontSize.allCases) { size in
                            Text(size.name) // Assuming you have a way to convert each case to a string, like `.name`
                                .font(.system(size: size.fontValue)) // Use custom font size based on the case
                                .padding()
                                .background( viewModel.selectedFontSize == size ? Color.gray : Color.gray.opacity(0.5))
                                .cornerRadius(10)
                                .onTapGesture {
                                    // Handle the tap gesture
                                    print(size.fontValue)
                                    viewModel.selectedFontSize = size
                                }
                            
                        }
                        Spacer()
                    }
                    //                Text("Select a font style")
                    //                    .padding(.vertical)
                    Divider()
                        .frame( height: 2)
                        .background(.gray)
                        .padding(.vertical, 3)
                    VStack(alignment: .leading) {

                        ScrollView {
                            LazyVGrid(columns: columns, spacing: 16) {
                                ForEach(FontName.allCases, id: \.self) { fontName in
                                    Text(fontName.rawValue)
                                        .font(.custom(fontName.fontName, size: 16))
                                        .padding()
                                        .frame(maxWidth: .infinity, alignment: .leading) // Aligns the text to the leading edge
                                        .background(viewModel.selectedFontName == fontName ? Color.gray : Color.gray.opacity(0.5))
                                        .cornerRadius(10)
                                        .onTapGesture {
                                            viewModel.selectedFontName = fontName
                                        }
                                }
                            }
                        }
                        
                        Spacer()
                    }

                
                
                Spacer()
            }
        }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .padding()
            
//                .background(Color.gray)
                .toolbar {
                    Button {
                        dismiss()
                    } label: {
                        Image(systemName: "checkmark")
                            .font(.system(size: 20, weight: .bold))
                            .tint(Color.gray)
                        
                    }

                }
                .navigationTitle("Font")
                .navigationBarTitleDisplayMode(.inline)
        }
        
        
    }
}
