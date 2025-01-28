//
//  TagsView.swift
//  MyNotes
//
//  Created by apple on 30.11.2024.
//



//struct TagsView: View {
//    var tags: [TagModel]
//    @Binding var selectedTag: TagModel?
//    
//    var body: some View {
//        ScrollView(.horizontal) {
//            HStack(spacing: 8) {
//                AllTagView(selectedTag: $selectedTag)
//                
//                ForEach(tags, id: \.id) { tag in
//                    SingleTagView(tag: tag, selectedTag: $selectedTag)
//                }
//            }
//            .padding(.horizontal)
//        }
//    }
//}
//
//struct AllTagView: View {
//    @Binding var selectedTag: TagModel?
//    
//    var body: some View {
//        Text("# All")
//            .font(.headline)
//            .padding(.vertical, 8)
//            .padding(.horizontal, 16)
//            .onTapGesture {
//                selectedTag = nil  // Clear selection
//            }
//            .background(
//                selectedTag == nil ? Color.blue.opacity(0.2) : Color.clear,
//                in: Capsule()
//            )
//    }
//}
//
//struct SingleTagView: View {
//    var tag: TagModel
//    @Binding var selectedTag: TagModel?
//    
//    var body: some View {
//        Text("# \(tag.name)")
//            .padding(.vertical, 8)
//            .padding(.horizontal, 16)
//            .background(
//                selectedTag == tag ? Color.blue.opacity(0.2) : Color.clear,
//                in: Capsule()
//            )
//            .onTapGesture {
//                selectedTag = selectedTag == tag ? nil : tag
//            }
//    }
//}
import SwiftUI

struct TagsView: View {
    var tags: [TagModel]
    @Binding var selectedTag: TagModel?
    @Binding var isShowingAddTagSheet: Bool
    var onDelete: (TagModel) -> Void // Required delete action
    @State private var showDeleteConfirmation = false
    var body: some View {
        VStack {
            HStack {
                Text("Tags:")
                    .padding(.horizontal)
                Spacer()
                Button {
                    showDeleteConfirmation.toggle()
                } label: {
                    Image(systemName: showDeleteConfirmation ? "trash.slash" : "trash")
                }
                Button {
                    isShowingAddTagSheet.toggle()
                } label: {
                    Image(systemName: "plus")
                }
                .padding(8)
            }
           

            ScrollView(.horizontal) {
                HStack(spacing: 8) {
                    AllTagView(selectedTag: $selectedTag)
                    
                    ForEach(tags, id: \.id) { tag in
                        SingleTagView(tag: tag, selectedTag: $selectedTag, onDelete: onDelete, isDeleteVisible: $showDeleteConfirmation)
                    }
                }
                .padding(.horizontal)
            }
        }
       
    }
}

struct AllTagView: View {
    @Binding var selectedTag: TagModel?

    var body: some View {
        Text("# All")
            .font(.headline)
            .padding(.vertical, 8)
            .padding(.horizontal, 16)
            .onTapGesture {
                selectedTag = nil // Clear selection
            }
            .background(
                selectedTag == nil ? Color.blue.opacity(0.2) : Color.clear,
                in: Capsule()
            )
    }
}

struct SingleTagView: View {
    var tag: TagModel
    @Binding var selectedTag: TagModel?
    var onDelete: ((TagModel) -> Void)? // Optional delete action
    @Binding var isDeleteVisible: Bool
    var body: some View {
        HStack {
            Text("# \(tag.name)")
                .padding(.vertical, 8)
//                .padding(.horizontal, 16)
                
                .onTapGesture {
                    selectedTag = selectedTag == tag ? nil : tag
                }
            if isDeleteVisible {
                if let onDelete = onDelete {
                    Button(action: {
                        onDelete(tag)
                    }) {
                        Image(systemName: "xmark.circle.fill")
                            .foregroundColor(.red)
                    }
                    .buttonStyle(PlainButtonStyle()) // Prevents default button style
                }
            }
         
        }
        .padding(.horizontal)
        .background(
            selectedTag == tag ? Color.blue.opacity(0.2) : Color.clear,
            in: Capsule()
        )
        .background(Color.black.opacity(0.1))
        .cornerRadius(20)
       
        
    }
}
