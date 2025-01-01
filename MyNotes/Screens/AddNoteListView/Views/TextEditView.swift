//
//  File.swift
//  MyNotes
//
//  Created by apple on 31.12.2024.
//


//TODO: - here
import SwiftUI

struct TextEditView: View {
    @EnvironmentObject var viewModel: AddNoteListViewModel
//    var dismissKeybourd: () -> Void
//    @EnvironmentObject var viewModel: MainTabViewViewModel

    @Binding var showPhotoPicker: Bool
    var body: some View {
        VStack {
            HStack {
                Button  {
//                    dismissKeybourd()
//                    currentView = .listBullet

                    print("list.bullet")
                } label: {
                    Image(systemName: "list.bullet")
                        .resizable()
                        .frame(width: 24, height: 24)
                        .padding(.horizontal, 6)
                }
                Button  {
//                    dismissKeybourd()
//                    currentView = .textFormatSize
                    viewModel.actionSheetPresentation = .showTextEditor
                    print("textformat.size")
                } label: {
                    Image(systemName: "textformat.size")
                        .resizable()
                        .frame(width: 24, height: 24)
                        .padding(.horizontal, 6)
                }
                Button  {
//                    dismissKeybourd()
//                    currentView = .tag
                    viewModel.actionSheetPresentation = .showTags
                } label: {
                    Image(systemName: "tag")
                        .resizable()
                        .frame(width: 24, height: 24)
                        .padding(.horizontal, 6)
                }
                Button  {
//                    viewModel.actionSheetPresentation = .showPhotoLibrary
                    showPhotoPicker = true
                    viewModel.selectedCover = []
                } label: {
                    Image(systemName: "photo.on.rectangle.angled")
                        .resizable()
                        .frame(width: 24, height: 24)
                        .padding(.horizontal, 6)
                }
            }
            .padding()
            .tint(.black)
        }
//        .background(viewModel.getSelectedColor())
        .cornerRadius(10)
    }
}




enum NoteViewCase {
    case rectanglePortrait
    case photo
    case listBullet
    case smile
    case textFormatSize
    case tag
    case none
}
