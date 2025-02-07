//
//  NoteDetailViewModel.swift
//  MyNotes
//
//  Created by apple on 30.11.2024.
//

import SwiftData
import SwiftUI
import PhotosUI

//class NoteDetailViewModel: ObservableObject {
//    @Published var actionSheetPresentation: ActionSheetPresentation? = nil // Optional enum
//    @Published var title: String = ""
////    @Published var note: String = ""
//    @Published var noteText = NSAttributedString(string: "Write and change text color.")
//    @Published var selectedTextColor: UIColor = .black
//    @Published var selectedRange: NSRange = NSRange(location: 0, length: 0)
//    @Published var selectedFontName: FontName? = .default
//    @Published var selectedFontSize: FontSize? = .h3
//    @Published var selectedFontColor: FontColor? = .primary
//    @Published var newTag: String = ""
//    
//    @Published var selectedFeeling: FeelingItem = FeelingItem(emoji: "😊", name: "Happy")
//    @Published var selectedEnergy: EnergyItem = EnergyItem(color: "#00FF00", name: "Growth", sfSymbol: "leaf.fill")
//    @Published var emoji: String = ""
//    
//    @Published var tags: [TagModel] = []  // All available tags
//    @Published var selectedTags = Set<TagModel>()  // Tags selected for the note
//    @Published var imagesData: [Data] = []
//
//    @Published var selectedImage: UIImage?
//    @Published private var selectedImageIndex: Int? = nil // Track the selected image index
//
//    private var originalNote: NoteModel  // Keep a reference to the original book
//    let feelings: [FeelingItem] = [
//        FeelingItem(emoji: "😊", name: "Happy"),
//        FeelingItem(emoji: "😔", name: "Sad"),
//        FeelingItem(emoji: "😡", name: "Angry"),
//        FeelingItem(emoji: "😴", name: "Tired"),
//        FeelingItem(emoji: "😎", name: "Confident"),
//        FeelingItem(emoji: "🤔", name: "Thoughtful"),
//        FeelingItem(emoji: "😇", name: "Grateful"),
//        FeelingItem(emoji: "😬", name: "Nervous"),
//        FeelingItem(emoji: "🥳", name: "Excited"),
//        FeelingItem(emoji: "😌", name: "Relaxed"),
//        FeelingItem(emoji: "😱", name: "Surprised"),
//        FeelingItem(emoji: "😕", name: "Confused"),
//        FeelingItem(emoji: "🤯", name: "Overwhelmed"),
//        FeelingItem(emoji: "🤗", name: "Loved"),
//        FeelingItem(emoji: "😤", name: "Frustrated"),
//        FeelingItem(emoji: "😭", name: "Heartbroken"),
//        FeelingItem(emoji: "😅", name: "Embarrassed"),
//        FeelingItem(emoji: "🤩", name: "Amazed"),
//        FeelingItem(emoji: "🥶", name: "Cold"),
//        FeelingItem(emoji: "🤒", name: "Sick"),
//        FeelingItem(emoji: "😇", name: "Blessed"),
//        FeelingItem(emoji: "😜", name: "Playful"),
//        FeelingItem(emoji: "🤤", name: "Hungry"),
//        FeelingItem(emoji: "😷", name: "Unwell")
//    ]
//    let energyColors: [EnergyItem] = [
//        EnergyItem(color: Color.blue.toHex(), name: "Calm", sfSymbol: "tortoise"),
//        EnergyItem(color: Color.red.toHex(), name: "Passion", sfSymbol: "flame.fill"),
//        EnergyItem(color: Color.green.toHex(), name: "Growth", sfSymbol: "leaf.fill"),
//        EnergyItem(color: Color.orange.toHex(), name: "Enthusiasm", sfSymbol: "sun.max.fill"),
//        EnergyItem(color: Color.purple.toHex(), name: "Creativity", sfSymbol: "paintbrush.fill"),
//        EnergyItem(color: Color.yellow.toHex(), name: "Happiness", sfSymbol: "star.fill"),
//        EnergyItem(color: Color.pink.toHex(), name: "Love", sfSymbol: "heart.fill"),
//        EnergyItem(color: Color.gray.toHex(), name: "Neutral", sfSymbol: "cloud.fill"),
//        EnergyItem(color: Color.brown.toHex(), name: "Stability", sfSymbol: "house.fill"),
//        EnergyItem(color: Color.cyan.toHex(), name: "Freshness", sfSymbol: "drop.fill")
//    ]
//    init(note: NoteModel, allTags: [TagModel]) {
//        if let attributedText = note.noteText.toAttributedString() {
//               self.noteText = attributedText // Update view model with converted NSAttributedString
//           } else {
//               print("Failed to decode attributed text.")
//               self.noteText = NSAttributedString(string: "Error loading note text.")
//           }
//        self.originalNote = note
//        self.title = note.title
////        self.noteText = note.noteText
//        self.selectedFeeling = note.emoji
//        self.selectedEnergy = note.energy
//        self.imagesData = note.coverImages
//        self.tags = allTags  // Load all available tags
//        self.selectedTags = Set(note.tags)  // Pre-select existing tags
//            }
//    
//    func updateNote(in context: ModelContext) {
//        // Convert noteText to RichTextEntity
//        guard let noteTextData = noteText.toData() else {
//            print("Failed to serialize attributed text.")
//            return
//        }
//        let richTextEntity = RichTextEntity(attributedTextData: noteTextData)
//        context.insert(richTextEntity) // Save RichTextEntity to context
//            originalNote.coverImages = imagesData
//        originalNote.title = title
//        originalNote.noteText = richTextEntity
//        // Clear existing tags and add updated ones
//        originalNote.emoji = selectedFeeling
//        originalNote.energy = selectedEnergy
//        originalNote.tags = Array(selectedTags)
//        tags = Array(selectedTags)
//
//        // Ensure the tags are correctly linked back to the note
//        for tag in selectedTags {
//            if !tag.notes.contains(originalNote) {
//                tag.notes.append(originalNote)
//            }
//        }
//
//        do {
//            try context.save()
//        } catch {
//            print("Failed to save updated book: \(error)")
//        }
//    }
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
//    func deleteNote(in context: ModelContext) {
//        // Remove the note from all tags
//        for tag in selectedTags {
//            if let index = tag.notes.firstIndex(where: { $0.id == originalNote.id }) {
//                tag.notes.remove(at: index)
//            }
//        }
//
//        // Delete the note from the context
//        context.delete(originalNote)
//
//        // Save the changes
//        do {
//            try context.save()
//        } catch {
//            print("Failed to delete note: \(error)")
//        }
//    }
//}
import SwiftData
import SwiftUI
import PhotosUI

class NoteViewModel: ObservableObject {
    // Shared properties
    @Published var note: NoteModel? {
        didSet { loadNoteDetails(note) }
    }
    @Published var title = NSAttributedString(string: "")
    @Published var noteText = NSAttributedString(string: "")
    @Published var selectedTextColor: UIColor = .label
    @Published var noteTextSelectedRange: NSRange = NSRange(location: 0, length: 0)
    @Published var titleSelectedRange: NSRange = NSRange(location: 0, length: 0)
    @Published var selectedFontName: FontName? = .default
    @Published var selectedFontSize: FontSize = .h3{
        didSet{
            print(selectedFontSize.fontValue)
        }
    }
    @Published var selectedFontColor: FontColor? = .primary
    @Published var newTag: String = ""
    @Published var tags: [TagModel] = []  // All available tags
    @Published var selectedTags = Set<TagModel>()  // Tags selected for the note
    @Published var imagesData: [Data] = []
    @Published var selectedFeeling: FeelingItem = FeelingItem(emoji: "😊", name: "Happy")
    @Published var selectedEnergy: EnergyItem = EnergyItem(color: "#00FF00", name: "Growth", sfSymbol: "leaf.fill")
    @Published var emoji: String = ""
    @Published var dateNow: Date = Date()

    @Published var selectedImage: UIImage?

    // Add-only properties
    @Published var selectedCover: [PhotosPickerItem] = []
    @Published var actionSheetPresentation: ActionSheetPresentation? = nil
    @Published var selectedCoverDataList: [Data] = [] // For adding multiple images

    // Shared reference for "Edit" mode
     var originalNote: NoteModel?

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

    func setup(note: NoteModel?, allTags: [TagModel]) {
        self.note = note
        self.tags = allTags
        loadNoteDetails(note)
    }
    func reset() {
        note = nil
        title = NSAttributedString(string: "")
        noteText = NSAttributedString(string: "")
        selectedTextColor = .label
        noteTextSelectedRange = NSRange(location: 0, length: 0)
        titleSelectedRange = NSRange(location: 0, length: 0)
        selectedFontName = .default
        selectedFontSize = .h3
        selectedFontColor = .primary
        newTag = ""
        tags = []
        selectedTags = []
        imagesData = []
        selectedFeeling = FeelingItem(emoji: "😊", name: "Happy")
        selectedEnergy = EnergyItem(color: "#00FF00", name: "Growth", sfSymbol: "leaf.fill")
        emoji = ""
        dateNow = Date()
        selectedImage = nil
        selectedCover = []
        actionSheetPresentation = nil
        selectedCoverDataList = []
        originalNote = nil
    }
    func updateNote(in context: ModelContext) {
        // Your logic for updating the note
        do {
            try context.save()
        } catch {
            print("Failed to save the updated note: \(error.localizedDescription)")
        }
    }
    private func loadNoteDetails(_ note: NoteModel?) {
        guard let note = note else { return }
        if let attributedText = note.title.toAttributedString() {
            title = attributedText
        } else {
            noteText = NSAttributedString(string: "Error loading note text.")
        }
        if let attributedText = note.noteText.toAttributedString() {
            noteText = attributedText
        } else {
            noteText = NSAttributedString(string: "Error loading note text.")
        }
        selectedFeeling = note.emoji
        selectedEnergy = note.energy
        imagesData = note.coverImages
        selectedTags = Set(note.tags)
    }

    // Save or update the note
    func saveOrUpdateNote(in context: ModelContext, complition: @escaping (Result<Void, Error>) -> Void) {
        guard
              let titleData = title.toData(),
              let noteTextData = noteText.toData(),
              title.string != "" || noteText.string != ""
          else {
              // Optionally show user feedback about empty note
            print("Title or body text is empty.")
            complition(.failure(NSError(domain: "NoteError", code: 1, userInfo: [NSLocalizedDescriptionKey: "Title or note text is empty."])))
              return
          }
//        guard let titleData = title.toData() else {
//            print("Failed to serialize attributed text.")
//            return
//        }
//        guard let noteTextData = noteText.toData() else {
//            print("Failed to serialize attributed text.")
//            return
//        }
        let richTitleEntity = RichTextEntity(attributedTextData: titleData)
        context.insert(richTitleEntity)

        let richTextEntity = RichTextEntity(attributedTextData: noteTextData)
        context.insert(richTextEntity)

        
        if let note = originalNote {
            // Update existing note
            note.title = richTitleEntity
            note.noteText = richTextEntity
            note.emoji = selectedFeeling
            note.energy = selectedEnergy
            note.tags = Array(selectedTags)
            note.coverImages = selectedCoverDataList
        } else {
            // Create a new note
            let newNote = NoteModel(
                date: dateNow,
                title: richTitleEntity,
                noteText: richTextEntity,
                energy: selectedEnergy,
                emoji: selectedFeeling,
                tags: Array(selectedTags),
                coverImages: selectedCoverDataList
            )
            context.insert(newNote)
        }
        // Save context
        do {
            try context.save()
            selectedCover = []
            complition(.success(()))
        } catch {
            print("Failed to save note: \(error.localizedDescription)")
        }
    }

    func deleteImage(at index: Int) {
        imagesData.remove(at: index)
    }

    func saveNewTag(in context: ModelContext) {
        guard !newTag.trimmingCharacters(in: .whitespaces).isEmpty else { return }
        let tag = TagModel(name: newTag)
        context.insert(tag)
        do {
            try context.save()
            newTag = ""
            tags.append(tag)
        } catch {
            print("Failed to save the new tag: \(error.localizedDescription)")
        }
    }

    func deleteNote(in context: ModelContext) {
        guard let note = originalNote else { return }

        // Remove the note from all tags
        for tag in selectedTags {
            if let index = tag.notes.firstIndex(where: { $0.id == note.id }) {
                tag.notes.remove(at: index)
            }
        }

        // Delete the note from the context
        context.delete(note)

        // Save the changes
        do {
            try context.save()
        } catch {
            print("Failed to delete note: \(error.localizedDescription)")
        }
    }
}
