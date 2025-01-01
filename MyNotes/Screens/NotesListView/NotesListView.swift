//
//  NotesListView.swift
//  MyNotes
//
//  Created by apple on 30.11.2024.
//

import SwiftUI
import SwiftData




struct NotesListView: View {
    @Environment(\.modelContext) private var modelContext
    @Binding var isAddViewPresented: Bool
    @StateObject var viewModel = NotesListViewModel()
    @State private var isShowingAddTagSheet = false
    @State private var isSearching = false
    @State private var isFiltering = false
    var body: some View {
        NavigationStack {
            VStack {
                if isFiltering {
                TagsView(tags: viewModel.tags, selectedTag: $viewModel.selectedTag, isShowingAddTagSheet: $isShowingAddTagSheet, onDelete: { tag in
                    viewModel.deleteTag(tag, modelContext: modelContext)
                })
                .padding(.vertical, 8)
                .overlay(
                    RoundedRectangle(cornerRadius: 10)
                        .stroke(Color.gray.opacity(0.3), lineWidth: 1) // Border color and width
                )
                .padding()
            }
                // Search bar
                if viewModel.filteredNotes.count > 10 {
                    VStack {
                        TextField("Search Notes", text: $viewModel.searchText)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                            .padding(.horizontal)
                        
                    }
                }
                
                ZStack {
                    // List of notes
                    List {
                        ForEach(viewModel.filteredNotes) { note in
                            HStack {
                                NoteRow(note: note)
                            }
                            .contentShape(Rectangle())
                            .onTapGesture {
                                viewModel.selectedNote = note
                            }
                            .swipeActions {
                                Button(role: .destructive) {
                                    viewModel.deleteNote(note, modelContext: modelContext)
                                } label: {
                                    Label("Delete", systemImage: "trash")
                                }
                            }
                        }

                        if viewModel.isLoading {
                            ProgressView()
                                .frame(maxWidth: .infinity, alignment: .center)
                        } else {
                            if viewModel.filteredNotes.count > 10 {
                                Button(action: {
                                    viewModel.fetchNotes(offset: viewModel.currentOffset, modelContext: modelContext)
                                }) {
                                    Text("Load More")
                                        .frame(maxWidth: .infinity, alignment: .center)
                                }
                            }
                        }
                    }
                    
                    // Placeholder view shown when no notes are available
                    if viewModel.filteredNotes.isEmpty && !viewModel.isLoading {
                        VStack {
                            Image(systemName: "note.text")
                                .font(.largeTitle)
                                .foregroundColor(.gray)
                            Text("No notes found")
                                .foregroundColor(.gray)
                                .font(.headline)
                        }
                        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center) // Centers the placeholder
                        .background(Color.white.opacity(0.7)) // Optional: background to make the placeholder stand out
                    }
                }
                .navigationTitle("Notes List")
                .navigationDestination(item: $viewModel.selectedNote) { note in
                    NoteDetailView(isAddViewPresented: $isAddViewPresented, note: note) {
                        // Refresh tags and notes after returning from detail view
                               viewModel.fetchTags(modelContext: modelContext)
                               viewModel.fetchNotes(offset: 0, reset: true, modelContext: modelContext)

                    }
                }
                .listStyle(PlainListStyle())
                .onAppear {
                    if viewModel.notes.isEmpty {
                        viewModel.fetchNotes(offset: 0, modelContext: modelContext)
                    }
                }
            }
            .onAppear {
                withAnimation {
                    isAddViewPresented = true
                }
            }
//            .fullScreenCover(isPresented: $viewModel.isAdd, onDismiss: {
//                viewModel.fetchNotes(offset: 0, modelContext: modelContext)
//            }) {
//
//                AddNoteListView(tags: $viewModel.tags) {
//                    viewModel.fetchNotes(offset: 0, reset: true, modelContext: modelContext)
//                }
//                .presentationDetents([.large])
//                .presentationDragIndicator(.visible)
//            }
            .sheet(isPresented: $isShowingAddTagSheet, content: {
                VStack(spacing: 20) {
                    Text("Enter new tag")
                        .font(.headline)
                    TextField("Tag name", text: $viewModel.newTag)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .padding()
                    HStack {
                        Button("Cancel") {
                            isShowingAddTagSheet.toggle()
                        }
                        .foregroundColor(.red)
                        Spacer()
                        Button("Add Tag") {
                            viewModel.saveNewTag(in: modelContext)
                            isShowingAddTagSheet.toggle()
                        }
                    }
                    .padding()
                }
                .presentationDetents([.fraction(0.3), .medium, .large])
            })
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button(action: { isFiltering.toggle() }) {
                        Image(systemName: "arrow.up.arrow.down")
                            .resizable()
                            .frame(width: 40, height: 40)
                            .tint(.black)
                    }
                }
            }
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    NavigationLink {
                        AddNoteListView(tags: $viewModel.tags, isAddViewPresented: $isAddViewPresented) {
                            viewModel.fetchNotes(offset: 0, reset: true, modelContext: modelContext)
                        }
                    } label: {
                        Image("notes")
                            .resizable()
                            .frame(width: 40, height: 40)
                    }

//                    Button(action: {
//                       
//
//                       /* viewModel.isAdd.toggle()*/ }) {
//                        Image("notes")
//                            .resizable()
//                            .frame(width: 40, height: 40)
//                    }
                }
            }
            .toolbar(.visible, for: .tabBar)

        }
        .onAppear {
            viewModel.fetchTags(modelContext: modelContext)
            viewModel.fetchNotes(offset: 0, modelContext: modelContext)
        }
    }
}
