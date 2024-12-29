//
//  NoteDetailViewModel.swift
//  MyNotes
//
//  Created by apple on 30.11.2024.
//

import Foundation
import SwiftData
import SwiftUI

class NoteDetailViewModel: ObservableObject {
    @Published var title: String = ""
    @Published var note: String = ""
    @Published var newTag: String = ""

    @Published var tags: [TagModel] = []  // All available tags
    @Published var selectedTags = Set<TagModel>()  // Tags selected for the note
    @Published var imagesData: [Data] = []

    @Published var selectedImage: UIImage?
    @Published private var selectedImageIndex: Int? = nil // Track the selected image index

    private var originalNote: NoteModel  // Keep a reference to the original book

    init(note: NoteModel, allTags: [TagModel]) {
        self.originalNote = note
        self.title = note.title
        self.note = note.noteText
        self.imagesData = note.coverImages
        self.tags = allTags  // Load all available tags
        self.selectedTags = Set(note.tags)  // Pre-select existing tags
            }
    
    func updateNote(in context: ModelContext) {
            originalNote.coverImages = imagesData
        originalNote.title = title
        originalNote.noteText = note
        // Clear existing tags and add updated ones
        originalNote.tags = Array(selectedTags)
        tags = Array(selectedTags)

        // Ensure the tags are correctly linked back to the note
        for tag in selectedTags {
            if !tag.notes.contains(originalNote) {
                tag.notes.append(originalNote)
            }
        }

        do {
            try context.save()
        } catch {
            print("Failed to save updated book: \(error)")
        }
    }
    func saveNewTag(in context: ModelContext) {
            // Ensure the tag name is not empty
            guard !newTag.trimmingCharacters(in: .whitespaces).isEmpty else { return }

            // Create a new tag
            let tag = TagModel(name: newTag)

            // Add the new tag to the context
            context.insert(tag)

            // Save the context to persist changes
            do {
                try context.save()
                // Clear the input field
                newTag = ""
                // Optionally update the `tags` array to reflect changes in UI
                tags.append(tag)
            } catch {
                print("Failed to save the new tag: \(error.localizedDescription)")
            }
        }
    func deleteNote(in context: ModelContext) {
        // Remove the note from all tags
        for tag in selectedTags {
            if let index = tag.notes.firstIndex(where: { $0.id == originalNote.id }) {
                tag.notes.remove(at: index)
            }
        }

        // Delete the note from the context
        context.delete(originalNote)

        // Save the changes
        do {
            try context.save()
        } catch {
            print("Failed to delete note: \(error)")
        }
    }
}
