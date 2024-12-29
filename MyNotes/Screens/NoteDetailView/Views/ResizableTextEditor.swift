//
//  ResizableTextEditor.swift
//  MyNotes
//
//  Created by apple on 06.12.2024.
//


import SwiftUI

struct ResizableTextEditor: View {
    @Binding var text: String
    @State private var textHeight: CGFloat = 200 // Initial height
    var placeholder: String

    var body: some View {
        VStack(alignment: .leading) {
            ZStack(alignment: .topLeading) {
               
                TextEditor(text: $text)
                    .frame(height: textHeight) // Dynamic height
                    .background(GeometryReader { geo -> Color in
                        DispatchQueue.main.async {
                            let size = geo.size.height
                            if size != textHeight {
                                textHeight = size
                            }
                        }
                        return Color.clear
                    })
                
                    .onChange(of: text) { _, _ in
                        calculateTextHeight()
                    }
                if text.isEmpty {
                    Text(placeholder)
                        .foregroundColor(Color(uiColor: .systemGray3))
                        .bold()
                        .padding(.vertical, 8)
                }
            }
        }
        .onAppear {
            calculateTextHeight()
        }
    }

    private func calculateTextHeight() {
        let width = UIScreen.main.bounds.width - 32 // Adjust as per padding
        let font = UIFont.systemFont(ofSize: 17) // Font size
        let size = CGSize(width: width, height: .infinity)
        let attributes: [NSAttributedString.Key: Any] = [.font: font]
        let estimatedHeight = text.boundingRect(with: size, options: .usesLineFragmentOrigin, attributes: attributes, context: nil).height
        textHeight = max(40, estimatedHeight + 40) // Minimum height of 40
    }
}
