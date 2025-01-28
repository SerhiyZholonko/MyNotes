//
//  FontView.swift
//  MyNotes
//
//  Created by apple on 02.01.2025.
//

import SwiftUI




 enum FontSize: CaseIterable, Identifiable {
    case h1
    case h2
    case h3
    
    var id: Self { self }
    
    var name: String {
        switch self {
        case .h1: return "H1"
        case .h2: return "H2"
        case .h3: return "H3"
        }
    }
    
    var fontValue: CGFloat {
        switch self {
        case .h1: return 24
        case .h2: return 18
        case .h3: return 14
        }
    }
}
enum FontName: String, CaseIterable, Identifiable {
    case `default` = "Default"
    case bold = "Bold"
    case italic = "Italic"
    case light = "Light"
    case avenir = "Avenir"
    case bradleyHand = "Bradley Hand"
    
    var id: Self { self }
    
    var fontName: String {
        switch self {
        case .default:
            return ".SFUIText" // Default system font
        case .bold:
            return "Helvetica-Bold"
        case .italic:
            return "Helvetica-Oblique"
        case .light:
            return "Helvetica-Light"
        case .avenir:
            return "Avenir"
        case .bradleyHand:
            return "BradleyHandITCTT-Bold"
        }
    }
}

enum FontColor: CaseIterable, Identifiable {
    case primary
    case secondary
    case accent
    case warning
    case success
    
    var id: Self { self }
    
    var color: Color {
        switch self {
        case .primary: return Color(UIColor.white)
        case .secondary: return .gray
        case .accent: return .blue
        case .warning: return .red
        case .success: return .green
        }
    }
}
extension FontColor {
    var name: String {
        switch self {
        case .primary: return "Primary"
        case .secondary: return "Secondary"
        case .accent: return "Accent"
        case .warning: return "Warning"
        case .success: return "Success"
        }
    }
}
struct FontView: View {
    @EnvironmentObject var viewModel: NoteViewModel
    @Environment (\.dismiss) private var dismiss
    let columns = Array(repeating: GridItem(.adaptive(minimum: 100), spacing: 16), count: 3) // Four columns with flexible width

    var updateColor: ((Color) -> Void)?

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
                                updateColor?(color.color)
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
