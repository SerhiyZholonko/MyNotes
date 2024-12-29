//
//  AddNoteListViewModel.swift
//  MyNotes
//
//  Created by apple on 30.11.2024.
//

import SwiftUI
import SwiftData
import PhotosUI


class AddNoteListViewModel: ObservableObject {
    @Published var selectedCover: [PhotosPickerItem] = []
    @Published var actionSheetPresentation: ActionSheetPresentation? = nil // Optional enum
    @Published var dateNow: Date = Date()
    //Calendar.current.date(byAdding: .day, value: 7, to: Date()) ?? Date()
    @Published var title: String = ""
    @Published var noteText: String = ""
    @Published var energyColor: String = ""
    @Published var energyImageName: String = ""
    @Published var emoji: String = ""
    @Published var selectedCoverDataList: [Data] = [] // Store multiple images
    @Published var newTag: String = ""
     var tags: [TagModel] = []
    
    @Published var selectedTags = Set<TagModel>()
    
    @Published var selectedFeeling: FeelingItem = FeelingItem(emoji: "😊", name: "Happy")
    @Published var selectedEnergy: EnergyItem = EnergyItem(color: "#00FF00", name: "Growth", sfSymbol: "leaf.fill")
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
    func saveNote(in context: ModelContext, dismiss: @escaping () -> Void) {
        let note = NoteModel(
            date: dateNow,
            title: title,
            noteText: noteText,
            energy: selectedEnergy,
            emoji: selectedFeeling,
            tags: Array(selectedTags),
            coverImages: selectedCoverDataList // Save multiple images
        )
        
        selectedTags.forEach { tag in
            tag.notes.append(note)
            context.insert(tag)
        }
        context.insert(note)
        
        do {
            try context.save()
            dismiss()
        } catch {
            print("Failed to save note: \(error.localizedDescription)")
        }
    }

    func deleteImage(at index: Int) {
           selectedCoverDataList.remove(at: index)
       }
//    func saveNewTag(in context: ModelContext) {
//            // Ensure the tag name is not empty
//            guard !newTag.trimmingCharacters(in: .whitespaces).isEmpty else { return }
//
//            // Create a new tag
//            let tag = TagModel(name: newTag)
//
//            // Add the new tag to the context
//            context.insert(tag)
//
//            // Save the context to persist changes
//            do {
//                try context.save()
//                // Clear the input field
//                newTag = ""
//                // Optionally update the `tags` array to reflect changes in UI
//                tags.append(tag)
//            } catch {
//                print("Failed to save the new tag: \(error.localizedDescription)")
//            }
//        }
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
}
