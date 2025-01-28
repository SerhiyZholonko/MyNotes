//
//  EnergyAndFeelingView.swift
//  MyNotes
//
//  Created by apple on 02.01.2025.
//

import SwiftUI

struct EnergyAndFeelingView: View {
    @EnvironmentObject var viewModel: NoteViewModel
    @Binding var isEditMode: Bool
    var body: some View {
        HStack {
            Text(viewModel.selectedFeeling.emoji)
                .font(.system(size: 40))
                .onTapGesture {

                    if isEditMode{
                        viewModel.actionSheetPresentation = .smile
                    }
                    
                }
            ZStack {
                
                Color.fromHex(viewModel.selectedEnergy.color ?? "#FFFFFFFF").fontWeight(.bold)
                    .frame(width: 40, height: 40)
                    .cornerRadius(20)
                    .onTapGesture {
   
                        if isEditMode{
                            viewModel.actionSheetPresentation = .feeling
                        }
                        
                    }
                Image(systemName: viewModel.selectedEnergy.sfSymbol)
                    .resizable()
                    .frame(width: 30, height: 30)
                
            }
        }
     
    }
}


#Preview {
    EnergyAndFeelingView( isEditMode: .constant(true))
}
