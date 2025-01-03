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
    @Published var actionSheetPresentation: ActionSheetPresentation? = nil // Optional enum
    @Published var title: String = ""
    @Published var note: String = ""
    @Published var newTag: String = ""
    
    @Published var selectedFeeling: FeelingItem = FeelingItem(emoji: "😊", name: "Happy")
    @Published var selectedEnergy: EnergyItem = EnergyItem(color: "#00FF00", name: "Growth", sfSymbol: "leaf.fill")
    @Published var emoji: String = ""
    
    @Published var tags: [TagModel] = []  // All available tags
    @Published var selectedTags = Set<TagModel>()  // Tags selected for the note
    @Published var imagesData: [Data] = []

    @Published var selectedImage: UIImage?
    @Published private var selectedImageIndex: Int? = nil // Track the selected image index

    private var originalNote: NoteModel  // Keep a reference to the original book
    let feelings: [FeelingItem] = [
        FeelingItem(emoji: "😊", name: "Happy"),
        FeelingItem(emoji: "😔", name: "Sad"),
        FeelingItem(emoji: "😡", name: "Angry"),
        FeelingItem(emoji: "😴", name: "Tired"),
        FeelingItem(emoji: "😎", name: "Confident"),
        FeelingItem(emoji: "🤔", name: "Thoughtful"),
        FeelingItem(emoji: "😇", name: "Grateful"),
        FeelingItem(emoji: "😬", name: "Nervous"),
        FeelingItem(emoji: "🥳", name: "Excited"),
        FeelingItem(emoji: "😌", name: "Relaxed"),
        FeelingItem(emoji: "😱", name: "Surprised"),
        FeelingItem(emoji: "😕", name: "Confused"),
        FeelingItem(emoji: "🤯", name: "Overwhelmed"),
        FeelingItem(emoji: "🤗", name: "Loved"),
        FeelingItem(emoji: "😤", name: "Frustrated"),
        FeelingItem(emoji: "😭", name: "Heartbroken"),
        FeelingItem(emoji: "😅", name: "Embarrassed"),
        FeelingItem(emoji: "🤩", name: "Amazed"),
        FeelingItem(emoji: "🥶", name: "Cold"),
        FeelingItem(emoji: "🤒", name: "Sick"),
        FeelingItem(emoji: "😇", name: "Blessed"),
        FeelingItem(emoji: "😜", name: "Playful"),
        FeelingItem(emoji: "🤤", name: "Hungry"),
        FeelingItem(emoji: "😷", name: "Unwell")
    ]
    let energyColors: [EnergyItem] = [
        EnergyItem(color: Color.blue.toHex(), name: "Calm", sfSymbol: "tortoise"),
        EnergyItem(color: Color.red.toHex(), name: "Passion", sfSymbol: "flame.fill"),
        EnergyItem(color: Color.green.toHex(), name: "Growth", sfSymbol: "leaf.fill"),
        EnergyItem(color: Color.orange.toHex(), name: "Enthusiasm", sfSymbol: "sun.max.fill"),
        EnergyItem(color: Color.purple.toHex(), name: "Creativity", sfSymbol: "paintbrush.fill"),
        EnergyItem(color: Color.yellow.toHex(), name: "Happiness", sfSymbol: "star.fill"),
        EnergyItem(color: Color.pink.toHex(), name: "Love", sfSymbol: "heart.fill"),
        EnergyItem(color: Color.gray.toHex(), name: "Neutral", sfSymbol: "cloud.fill"),
        EnergyItem(color: Color.brown.toHex(), name: "Stability", sfSymbol: "house.fill"),
        EnergyItem(color: Color.cyan.toHex(), name: "Freshness", sfSymbol: "drop.fill")
    ]
    init(note: NoteModel, allTags: [TagModel]) {
        self.originalNote = note
        self.title = note.title
        self.note = note.noteText
        self.selectedFeeling = note.emoji
        self.selectedEnergy = note.energy
        self.imagesData = note.coverImages
        self.tags = allTags  // Load all available tags
        self.selectedTags = Set(note.tags)  // Pre-select existing tags
            }
    
    func updateNote(in context: ModelContext) {
            originalNote.coverImages = imagesData
        originalNote.title = title
        originalNote.noteText = note
        // Clear existing tags and add updated ones
        originalNote.emoji = selectedFeeling
        originalNote.energy = selectedEnergy
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
