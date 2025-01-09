//
//  NotesListViewModel.swift
//  MyNotes
//
//  Created by apple on 30.11.2024.
//

import Foundation
import SwiftData

class NotesListViewModel: ObservableObject {
    @Published var notes: [NoteModel] = [] // Notes array
    @Published var tags: [TagModel] = []   // Tags array
    @Published var selectedNote: NoteModel?
    @Published var searchText: String = "" // Search text
    @Published var newTag: String = ""
    @Published var selectedTag: TagModel? = nil // Selected tag{
    @Published var currentOffset: Int = 0 // Offset for pagination
    @Published var isLoading: Bool = false // Prevent duplicate fetches
    @Published var isAdd: Bool = false
    @Published var isEdit: Bool = false
    private let itemsPerPage = 10 // Number of items per fetch
    // Filtered notes based on searchText
    var filteredNotes: [NoteModel] {
        let filteredByTag: [NoteModel]
        
        if let selectedTag = selectedTag {
            // Filter notes that contain the selected tag
            filteredByTag = notes.filter { $0.tags.contains(where: { $0 == selectedTag }) }
        } else {
            filteredByTag = notes // No tag selected, return all notes
        }
        
        if searchText.isEmpty {
            return filteredByTag
        } else {
            return filteredByTag.filter { note in
                note.title.localizedCaseInsensitiveContains(searchText) ||
                note.noteText.plainText.localizedCaseInsensitiveContains(searchText)
            }
        }
    }
    func processedNotes(from notes: [NoteModel]) -> [NoteModel] {
        // Add any processing logic if needed
        return notes
    }
    
    func deleteNotes(at indexSet: IndexSet, from notes: [NoteModel], context: ModelContext) {
        for index in indexSet {
            let noteToDelete = notes[index]
            context.delete(noteToDelete)  // Use the provided ModelContext to delete
        }
        do {
            try context.save()  // Save the context after deletion
        } catch {
            print("Error saving context after deletion: \(error)")
        }
    }
    
    func deleteNote(_ note: NoteModel, modelContext: ModelContext) {
        guard let index = notes.firstIndex(where: { $0.id == note.id }) else { return }
        // Remove from the array
        notes.remove(at: index)
        // Remove from the database
        modelContext.delete(note)
        // Save changes
        do {
            try modelContext.save()
        } catch {
            print("Failed to delete note: \(error)")
        }
    }

    func fetchNotes(offset: Int, reset: Bool = false, modelContext: ModelContext) {
            guard !isLoading else { return } // Prevent duplicate fetches
            isLoading = true

            if reset {
                currentOffset = 0
                notes = []
            }

            var fetchDescriptor = FetchDescriptor<NoteModel>(
                sortBy: [SortDescriptor(\NoteModel.date, order: .reverse)]
            )
            fetchDescriptor.fetchOffset = offset
            fetchDescriptor.fetchLimit = itemsPerPage

            do {
                let fetchedNotes = try modelContext.fetch(fetchDescriptor)

                DispatchQueue.main.async {
                    // Replace or append notes based on the reset state
                    if reset {
                        self.notes = fetchedNotes
                    } else {
                        let uniqueNotes = fetchedNotes.filter { fetchedNote in
                            !self.notes.contains(where: { $0.id == fetchedNote.id })
                        }
                        self.notes.append(contentsOf: uniqueNotes)
                    }

                    // Update offset if new notes were fetched
                    if !fetchedNotes.isEmpty {
                        self.currentOffset += fetchedNotes.count
                    }

                    self.isLoading = false
                }
            } catch {
                DispatchQueue.main.async {
                    print("Failed to fetch notes: \(error)")
                    self.isLoading = false
                }
            }
        }

        func fetchTags(modelContext: ModelContext) {
            let fetchDescriptor = FetchDescriptor<TagModel>(
                sortBy: [SortDescriptor(\TagModel.name)] // Replace with your TagModel property
            )
            do {
                tags = try modelContext.fetch(fetchDescriptor)
            } catch {
                print("Failed to fetch tags: \(error)")
            }
        }
    func saveNewTag(in context: ModelContext) {
        guard !newTag.trimmingCharacters(in: .whitespaces).isEmpty else { return }
        let tag = TagModel(name: newTag)
        context.insert(tag)

        do {
            try context.save()
            newTag = ""
            tags.append(tag)  // Update the shared tags array
        } catch {
            print("Failed to save the new tag: \(error.localizedDescription)")
        }
    }
    func deleteTag(_ tag: TagModel, modelContext: ModelContext) {
        if let index = tags.firstIndex(where: { $0.id == tag.id }) {
            tags.remove(at: index) // Remove from tags list
        }

        modelContext.delete(tag) // Delete from database

        do {
            try modelContext.save()
        } catch {
            print("Error deleting tag: \(error.localizedDescription)")
        }
    }
}
