//
//  NoteModel.swift
//  MyNotes
//
//  Created by apple on 30.11.2024.
//

import SwiftUI
import SwiftData


@Model
class NoteModel: Identifiable {
    @Attribute(.unique) var id: UUID = UUID()
    var date: Date
    var title: String
    var noteText: String
    var energy: EnergyItem
    var emoji: FeelingItem
    @Relationship(deleteRule: .nullify, inverse: \TagModel.notes)
    var tags: [TagModel] = [] // Many-to-many relationship inferred automatically
    var coverImages: [Data] = [] // Store multiple images
    init(
        date: Date = Date(), // Default to current date
        title: String,
        noteText: String,
        energy: EnergyItem,
        emoji: FeelingItem,
        tags: [TagModel] = [], // Default empty tags
        coverImages: [Data] = []
    ) {
        self.date = date
        self.title = title
        self.noteText = noteText
        self.energy = energy
        self.emoji = emoji
        self.tags = tags
        self.coverImages = coverImages
    }
}
