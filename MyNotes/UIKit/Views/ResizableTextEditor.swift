//
//  ResizableTextEditor.swift
//  MyNotes
//
//  Created by apple on 06.12.2024.
//


import SwiftUI
//
struct RichTextEditor: UIViewRepresentable {
    @State private var itemCount: Int = 1
    @Binding var attributedText: NSAttributedString
    @Binding var selectedTextColor: UIColor
    @Binding var selectedRange: NSRange
    @Binding var textSize: CGFloat
    @Binding var selectedFontName: FontName?
    @Binding var selectedListStyle: SelectedList
    var isEditable: Bool = false

    func makeUIView(context: Context) -> UITextView {
        let textView = UITextView()
        textView.isEditable = isEditable
        textView.isSelectable = true
        textView.delegate = context.coordinator
        textView.backgroundColor = .clear
        textView.typingAttributes = createTypingAttributes()
        textView.attributedText = formattedString()

        textView.autocapitalizationType = .none
        textView.autocorrectionType = .no
        textView.smartQuotesType = .no
        textView.smartDashesType = .no
        textView.smartInsertDeleteType = .no
        return textView
    }
    func formattedString() -> NSAttributedString {
        let listMarker = selectedListStyle.markForList // Get the attributed mark for the current case

        // Create another string and set attributes to it
        let text = NSAttributedString(string: " This is a sample text", attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 16)])

        // Combine the marker and the regular text
        let combinedString = NSMutableAttributedString()
        combinedString.append(listMarker)
        combinedString.append(text)

        return combinedString
    }

    func updateUIView(_ uiView: UITextView, context: Context) {
        // Avoid resetting attributedText unless necessary
        if uiView.attributedText != attributedText {
            uiView.attributedText = attributedText
        }

        // Update typing attributes for new text
        let currentAttributes = uiView.typingAttributes
        let newAttributes = createTypingAttributes()
        if !attributesEqual(currentAttributes, newAttributes) {
            uiView.typingAttributes = newAttributes
        }

        // Keep the editor editable state in sync
        uiView.isEditable = isEditable
    }

    // Helper function to compare attributes
    func attributesEqual(
        _ lhs: [NSAttributedString.Key: Any],
        _ rhs: [NSAttributedString.Key: Any]
    ) -> Bool {
        guard lhs.count == rhs.count else { return false }
        for (key, value) in lhs {
            if let rhsValue = rhs[key] {
                if !("\(value)" == "\(rhsValue)") { // Use string comparison for equality
                    return false
                }
            } else {
                return false
            }
        }
        return true
    }

    func createTypingAttributes() -> [NSAttributedString.Key: Any] {
        let font = UIFont(name: selectedFontName?.fontName ?? FontName.default.fontName, size: textSize)
            ?? UIFont.systemFont(ofSize: textSize)
        return [
            .foregroundColor: selectedTextColor,
            .font: font
        ]
    }
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    class Coordinator: NSObject, UITextViewDelegate {
        var parent: RichTextEditor
          private var lastAppliedStyle: SelectedList = .none
          private var attributedTextCache: NSAttributedString?

          init(_ parent: RichTextEditor) {
              self.parent = parent
              self.attributedTextCache = parent.attributedText
          }
        func textViewDidChange(_ textView: UITextView) {
                   parent.attributedText = textView.attributedText
               }

        func textViewDidChangeSelection(_ textView: UITextView) {
            if let range = textView.selectedTextRange {
                let location = textView.offset(from: textView.beginningOfDocument, to: range.start)
                let length = textView.offset(from: range.start, to: range.end)
                
                // Defer the state change to the next run loop cycle
                DispatchQueue.main.async {
                    self.parent.selectedRange = NSRange(location: location, length: length)
                }
            }
        }
//        func updateListStyleIfNeeded(uiView: UITextView) {
//               if parent.selectedListStyle != lastAppliedStyle || uiView.text.isEmpty {
//                   if !uiView.text.hasSuffix("\n") {
//                       uiView.text.append("\n")
//                   }
//
//                   let newListPrefix = handleListStyle(textView: uiView, for: "")
//                   uiView.text.append(newListPrefix)
//
//                   // Cache the updated text and update the binding later
//                   attributedTextCache = uiView.attributedText
//                   DispatchQueue.main.async {
//                       self.parent.attributedText = self.attributedTextCache ?? NSAttributedString()
//                   }
//
//                   lastAppliedStyle = parent.selectedListStyle
//
//                   // Move cursor to the end
//                   let endPosition = uiView.endOfDocument
//                   uiView.selectedTextRange = uiView.textRange(from: endPosition, to: endPosition)
//               }
//           }

        func updateListStyleIfNeeded(uiView: UITextView) {
            guard parent.selectedListStyle != .none else { return }

            // Check if we need to append a new list prefix
            if parent.selectedListStyle != lastAppliedStyle || uiView.text.isEmpty {
                if !uiView.text.hasSuffix("\n") {
                    uiView.text.append("\n")
                }

                // Create a list prefix based on the current style
                let newListPrefix = handleListStyle(textView: uiView, for: "")
                let newText = NSAttributedString(string: newListPrefix, attributes: parent.createTypingAttributes())

                // Append the new list prefix to the text view
                let mutableAttributedText = NSMutableAttributedString(attributedString: uiView.attributedText)
                mutableAttributedText.append(newText)

                // Update the text view content
                uiView.attributedText = mutableAttributedText
                parent.attributedText = mutableAttributedText // Sync with the binding

                // Update the cursor position
                let endPosition = uiView.endOfDocument
                uiView.selectedTextRange = uiView.textRange(from: endPosition, to: endPosition)

                lastAppliedStyle = parent.selectedListStyle
            }
        }
        private var consecutiveReturns: Int = 0 // Track consecutive "Return" presses

//        func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
//            guard parent.isEditable else { return false }
//
//            if text == "\n" { // Handle "Return" key
//                let nsText = textView.text as NSString
//                let textBeforeCursor = nsText.substring(to: range.location)
//                let lines = textBeforeCursor.components(separatedBy: "\n")
//                let currentLine = lines.last ?? ""
//
//                if parent.selectedListStyle != .none {
//                    // Reset numbering if "Return" is pressed twice
//                    consecutiveReturns += 1
//                    if consecutiveReturns == 2 {
//                        resetNumbering()
//                        consecutiveReturns = 0
//                        return false
//                    }
//
//                    let newText = handleListStyle(textView: textView, for: currentLine)
//                    textView.text = nsText.replacingCharacters(in: range, with: "\n\(newText)")
//                    parent.attributedText = textView.attributedText
//                    return false
//                }
//            } else {
//                consecutiveReturns = 0 // Reset if another key is pressed
//            }
//            return true
//        }
        func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
            guard parent.isEditable else { return false }

            if text == "\n" { // Handle "Return" key
                let nsText = textView.text as NSString
                let textBeforeCursor = nsText.substring(to: range.location)
                let lines = textBeforeCursor.components(separatedBy: "\n")
                let currentLine = lines.last ?? ""

                if parent.selectedListStyle != .none {
                    // Reset numbering if "Return" is pressed twice
                    consecutiveReturns += 1
                    if consecutiveReturns == 2 {
                        resetNumbering()
                        consecutiveReturns = 0
                        return false
                    }

                    // Create the new list prefix
                    let newListPrefix = handleListStyle(textView: textView, for: currentLine)
                    let newText = "\n\(newListPrefix)"
                    let attributes = parent.createTypingAttributes()

                    // Modify the attributed text
                    let mutableAttributedText = NSMutableAttributedString(attributedString: textView.attributedText)
                    let attributedNewText = NSAttributedString(string: newText, attributes: attributes)
                    mutableAttributedText.replaceCharacters(in: range, with: attributedNewText)

                    // Update the text view and bindings
                    textView.attributedText = mutableAttributedText
                    parent.attributedText = mutableAttributedText
                    return false
                }
            } else {
                consecutiveReturns = 0 // Reset if another key is pressed
            }
            return true
        }
        private func handleListStyle(textView: UITextView, for currentLine: String) -> String {
            switch parent.selectedListStyle {
            case .numbered:
                parent.itemCount += 1
                return "\(parent.itemCount). "

            case .simpleNumbered:
                parent.itemCount += 1
                return "\(parent.itemCount)) "

            case .star:
                return "★ "

            case .point:
                return "● "

            case .heart:
                return "❤️ "

            case .greenPoint:
                return "🟢 "

            case .none:
                return ""
            }
        }


        private func resetNumbering() {
            parent.selectedListStyle = .none
            parent.itemCount = 1

            // Update the attributed text to remove the last line
            let nsText = parent.attributedText.string as NSString
            let lines = nsText.components(separatedBy: "\n")
            
            guard !lines.isEmpty else { return }

            // Remove the last line
            let newText = lines.dropLast().joined(separator: "\n")
//            parent.attributedText = NSAttributedString(string: newText, attributes: [
//                .font: UIFont.systemFont(ofSize: 16)
//            ])
        }
    }
}

// List Styles
enum SelectedList: CaseIterable, Identifiable{
    case numbered
    case simpleNumbered
    case star
    case point
    case heart
    case greenPoint
    case none
    var id: Self { self }
    var imageName: String {
        switch self {
        case .numbered:
            return "numberedList"
        case .simpleNumbered:
            return "simpleNumberedList"
        case .star:
            return "starList"
        case .point:
            return "BlackPointList"
        case .heart:
            return "heartRedList"
        case .greenPoint:
            return "greenCircleList"
        case .none:
            return "none"
        }
    }
    var markForList: NSAttributedString {
        switch self {
        case .numbered:
            return NSAttributedString(string: "1", attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 16)])
        case .simpleNumbered:
            return NSAttributedString(string: "1)", attributes: [NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 16)])
        case .star:
            return NSAttributedString(string: "★", attributes: [NSAttributedString.Key.font: UIFont(name: "HelveticaNeue-Bold", size: 20)!])
        case .point:
            return NSAttributedString(string: "●", attributes: [NSAttributedString.Key.font: UIFont(name: "Courier", size: 18)!])
        case .heart:
            return NSAttributedString(string: "❤️", attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 18)])
        case .greenPoint:
            return NSAttributedString(string: "🟢", attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 14)])
        case .none:
            return NSAttributedString(string: "none", attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 16)])
        }
    }
}


extension NSRange {
    func intersects(_ other: NSRange) -> Bool {
        return NSLocationInRange(other.location, self) || NSLocationInRange(self.location, other)
    }
}
