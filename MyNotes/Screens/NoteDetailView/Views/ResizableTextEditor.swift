//
//  ResizableTextEditor.swift
//  MyNotes
//
//  Created by apple on 06.12.2024.
//


import SwiftUI

//struct ResizableTextEditor: View {
//    @Binding var text: String
//    @State private var textHeight: CGFloat = 200 // Initial height
//    var placeholder: String
//
//    var body: some View {
//        VStack(alignment: .leading) {
//            ZStack(alignment: .topLeading) {
//               
//                TextEditor(text: $text)
//                    .frame(height: textHeight) // Dynamic height
//                    .background(GeometryReader { geo -> Color in
//                        DispatchQueue.main.async {
//                            let size = geo.size.height
//                            if size != textHeight {
//                                textHeight = size
//                            }
//                        }
//                        return Color.clear
//                    })
//                
//                    .onChange(of: text) { _, _ in
//                        calculateTextHeight()
//                    }
//                if text.isEmpty {
//                    Text(placeholder)
//                        .foregroundColor(Color(uiColor: .systemGray3))
//                        .bold()
//                        .padding(.vertical, 8)
//                }
//            }
//        }
//        .onAppear {
//            calculateTextHeight()
//        }
//    }
//
//    private func calculateTextHeight() {
//        let width = UIScreen.main.bounds.width - 32 // Adjust as per padding
//        let font = UIFont.systemFont(ofSize: 17) // Font size
//        let size = CGSize(width: width, height: .infinity)
//        let attributes: [NSAttributedString.Key: Any] = [.font: font]
//        let estimatedHeight = text.boundingRect(with: size, options: .usesLineFragmentOrigin, attributes: attributes, context: nil).height
//        textHeight = max(40, estimatedHeight + 40) // Minimum height of 40
//    }
//}

struct RichTextEditor: UIViewRepresentable {
    @Binding var attributedText: NSAttributedString
    @Binding var selectedTextColor: UIColor
    @Binding var selectedRange: NSRange
    @Binding var textSize: CGFloat // Add a binding for text size
    var isEditable: Bool = false

    func makeUIView(context: Context) -> UITextView {
        let textView = UITextView()
        textView.isEditable = isEditable
        textView.isSelectable = true
        textView.delegate = context.coordinator
        textView.backgroundColor = .clear
        textView.typingAttributes = [.foregroundColor: selectedTextColor, .font: UIFont.systemFont(ofSize: textSize)]

        // Disable autocapitalization
        textView.autocapitalizationType = .none
        textView.autocorrectionType = .no
        textView.smartQuotesType = .no
        textView.smartDashesType = .no
        textView.smartInsertDeleteType = .no

        return textView
    }

    func updateUIView(_ uiView: UITextView, context: Context) {
        if uiView.attributedText != attributedText {
            uiView.attributedText = attributedText
        }

        uiView.isEditable = isEditable
        uiView.typingAttributes = [.foregroundColor: selectedTextColor, .font: UIFont.systemFont(ofSize: textSize)]

        // Ensure the selected range is valid before applying it
        let validRange = NSRange(
            location: min(selectedRange.location, uiView.attributedText.length),
            length: min(selectedRange.length, uiView.attributedText.length - selectedRange.location)
        )
        uiView.selectedRange = validRange

        // Optionally update the text color for the selected range
        if validRange.length > 0 {
            let mutableText = NSMutableAttributedString(attributedString: uiView.attributedText)
            mutableText.addAttributes([.foregroundColor: selectedTextColor, .font: UIFont.systemFont(ofSize: textSize)], range: validRange)
            uiView.attributedText = mutableText
            DispatchQueue.main.async {
                self.attributedText = mutableText
            }
        }
    }

    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }

    class Coordinator: NSObject, UITextViewDelegate {
        var parent: RichTextEditor

        init(_ parent: RichTextEditor) {
            self.parent = parent
        }

        func textViewDidChangeSelection(_ textView: UITextView) {
            // Update the @Binding value asynchronously
            DispatchQueue.main.async {
                self.parent.selectedRange = textView.selectedRange
            }
        }

        func textViewDidChange(_ textView: UITextView) {
            parent.attributedText = textView.attributedText
        }

        func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
            guard parent.isEditable else { return false }

            if !text.isEmpty {
                let mutableText = NSMutableAttributedString(attributedString: textView.attributedText)

                // Ensure range is valid
                let validRange = NSRange(location: range.location, length: min(range.length, mutableText.length - range.location))

                // Create attributed text for the new text
                let coloredText = NSAttributedString(
                    string: text,
                    attributes: [
                        .foregroundColor: parent.selectedTextColor,
                        .font: UIFont.systemFont(ofSize: parent.textSize)
                    ]
                )

                // Safely replace characters in the valid range
                mutableText.replaceCharacters(in: validRange, with: coloredText)

                // Update the text view
                textView.attributedText = mutableText

                // Update the cursor position
                let newCursorPosition = NSRange(location: validRange.location + text.count, length: 0)
                textView.selectedRange = newCursorPosition

                // Asynchronously update the binding
                DispatchQueue.main.async {
                    self.parent.attributedText = mutableText
                }

                return false // Prevent UITextView from applying the default change
            }

            return true
        }
    }
}
