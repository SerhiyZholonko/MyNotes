//
//  EditEnergyView.swift
//  MyNotes
//
//  Created by apple on 02.01.2025.
//

import SwiftUI

struct EditEnergyView: View {
    @EnvironmentObject var viewModel: NoteDetailViewModel
    @Binding var actionSheetPresentation: ActionSheetPresentation?
    let columns = [
        GridItem(.flexible()),
        GridItem(.flexible())
    ]
    var body: some View {

        NavigationStack {
            ScrollView {
                LazyVGrid(columns: columns, spacing: 20) {
                    ForEach(viewModel.energyColors, id: \.self) { item in
//                        let item = viewModel.energyColors
//                        Text(item.name)
                        VStack{
                            ZStack {
                                Rectangle()
                                    .fill(Color.fromHex(item.color ?? ""))
                                    .frame(height: 100)
                                    .cornerRadius(10)
                                    .onTapGesture {
                                        viewModel.selectedEnergy = item
                                    }
                                Image(systemName: item.sfSymbol)
                                    .resizable()
                                    .frame(width: 32, height: 32)
                                    .foregroundColor(.white)
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
            .navigationTitle("How energetic was your day?")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}

