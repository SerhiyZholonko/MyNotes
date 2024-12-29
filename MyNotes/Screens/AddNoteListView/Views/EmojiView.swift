//
//  EmojiView.swift
//  MyNotes
//
//  Created by apple on 21.12.2024.
//

import SwiftUI


struct EmojiView: View {
    @EnvironmentObject var viewModel: AddNoteListViewModel

    @Binding var actionSheetPresentation: ActionSheetPresentation?
    let columns = [
        GridItem(.fixed(110)),
        GridItem(.fixed(110)),
        GridItem(.fixed(110))
    ]
    var body: some View {

        NavigationStack {

            ScrollView {
                LazyVGrid(columns: columns, spacing: 10) {
                    ForEach(viewModel.feelings) { item in
                        VStack {
                            Text(item.emoji)
                                .font(.system(size: 70))
                                .cornerRadius(8) // Optional: for rounded corners
                                .onTapGesture {
                                    viewModel.selectedFeeling = item
                                }
                            Text(item.name)
                                .font(.system(size: 16))
                        }
                       
                    }
                }
                .padding()
            }
            .toolbar(content: {
                Button {
                actionSheetPresentation = nil
                } label: {
                    Image(systemName: "checkmark")
                        .font(.system(size: 20, weight: .bold))

                }

            })
            .navigationTitle("How do you feeling this day?")
            .navigationBarTitleDisplayMode(.inline)
        }
//            Text("You tapped on the smile 🙂")
//                .font(.title)
//                .padding()
//            Spacer()
//        }
    }
}


