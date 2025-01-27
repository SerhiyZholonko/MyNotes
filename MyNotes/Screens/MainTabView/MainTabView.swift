//
//  MainTabView.swift
//  MyNotes
//
//  Created by apple on 01.12.2024.
//

import SwiftUI


struct MainTabView: View { // Renamed to CustomTabView
    @State private var isAddViewPresented = true // State for presenting AddView
    @StateObject var viewModel = MainTabViewModel()
    @StateObject var noteViewModel = NoteViewModel()
    @StateObject var notesListViewModel = NotesListViewModel()

    var body: some View {
        ZStack(alignment: .bottom) {
            
            TabView(selection: $viewModel.selectedTab) {
                //CalendarView
                CalendarScreen(isAddViewPresented: $isAddViewPresented).tag("1")
                    .environmentObject(noteViewModel)
                    .environmentObject(notesListViewModel)
                //NotesListView
                NotesListView(isAddViewPresented: $isAddViewPresented).tag("2")
                    .environmentObject(noteViewModel)
                    .environmentObject(notesListViewModel)
                //SetingView
                SettingsView().tag("3")
            }
            if  isAddViewPresented {
            HStack {
                // First Button
                Button {
                    viewModel.selectedTab = "1"
                } label: {
                    //Image("time")
                    Image(systemName: "calendar.circle.fill")
                        .renderingMode(.template)
                        .resizable()
                        .frame(width: 40, height: 40)
                }
                .buttonStyle(PlainButtonStyle())
                .simultaneousGesture(
                    DragGesture(minimumDistance: 0)
                        .onChanged { _ in viewModel.isPressed1 = true }
                        .onEnded { _ in viewModel.isPressed1 = false }
                )
                .scaleEffect(viewModel.isPressed1 ? 1.2 : 1.0)
                .animation(.easeInOut(duration: 0.2), value: viewModel.isPressed1)
                
                Spacer()
                
                // Second Button
                Button {
                    viewModel.selectedTab = "2"
                } label: {
//                    Image("note")
                    Image(systemName: "list.dash.header.rectangle")
                        .renderingMode(.template)
                        .resizable()
                        .frame(width: 50, height: 50)
                }
                .buttonStyle(PlainButtonStyle())
                .simultaneousGesture(
                    DragGesture(minimumDistance: 0)
                        .onChanged { _ in viewModel.isPressed2 = true }
                        .onEnded { _ in viewModel.isPressed2 = false }
                )
                .scaleEffect(viewModel.isPressed2 ? 1.2 : 1.0)
                .animation(.easeInOut(duration: 0.2), value: viewModel.isPressed2)
                
                Spacer()
                
                // Third Button
                Button {
                    viewModel.selectedTab = "3"
                } label: {
                    //Image("user")
                    Image(systemName: "gearshape.circle.fill")
                        .renderingMode(.template)
                        .resizable()
                        .frame(width: 40, height: 40)
                }
                .buttonStyle(PlainButtonStyle())
                .simultaneousGesture(
                    DragGesture(minimumDistance: 0)
                        .onChanged { _ in viewModel.isPressed3 = true }
                        .onEnded { _ in viewModel.isPressed3 = false }
                )
                .scaleEffect(viewModel.isPressed3 ? 1.2 : 1.0)
                .animation(.easeInOut(duration: 0.2), value: viewModel.isPressed3)
            }
            .padding()
            .frame(maxWidth: .infinity)
        }

        }
    }
}
