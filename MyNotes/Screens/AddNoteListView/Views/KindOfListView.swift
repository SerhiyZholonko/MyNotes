//
//  KindOfListView.swift
//  MyNotes
//
//  Created by apple on 15.01.2025.
//

import SwiftUI

struct KindOfListView: View {
    @Environment(\.dismiss) private var dismiss
    
   @Binding var selectedList: SelectedList // Track the selected image
    var isSelectedList: Bool {
        return !(selectedList == .none)
    }
    let columns = Array(repeating: GridItem(.adaptive(minimum: 100), spacing: 16), count: 3) // Grid layout
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack {
                    LazyVGrid(columns: columns, spacing: 16) {
                        ForEach(SelectedList.allCases, id: \.self) { imageName in
                            Image(imageName.imageName)
                                .resizable()
                                .frame(width: 100, height: 100)
                                .cornerRadius(10)
                                .border(isSelectedList && selectedList == imageName && selectedList != .none ? Color.green : Color.clear, width: 4) // Apply border
                                .onTapGesture {
                                    selectedList = imageName // Set selected image in viewModel
//                                    dismiss()
                                }
                        }
                    }


                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .padding()
            .toolbar {
                Button {
                    dismiss()
                } label: {
                    Image(systemName: "checkmark")
                        .font(.system(size: 20, weight: .bold))
                }
            }
            .navigationTitle("List")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}
