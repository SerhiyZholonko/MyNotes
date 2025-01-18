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
    var title: RichTextEntity
    var noteText: RichTextEntity
    var energy: EnergyItem
    var emoji: FeelingItem
    @Relationship(deleteRule: .nullify, inverse: \TagModel.notes)
    var tags: [TagModel] = [] // Many-to-many relationship inferred automatically
    var coverImages: [Data] = [] // Store multiple images
    init(
        date: Date = Date(), // Default to current date
        title: RichTextEntity,
        noteText: RichTextEntity,
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


@Model
class RichTextEntity {
    var id: UUID
    var attributedTextData: Data // To store serialized NSAttributedString

    init(attributedTextData: Data) {
        self.id = UUID()
        self.attributedTextData = attributedTextData
    }
}
extension RichTextEntity {
    func toAttributedString() -> NSAttributedString? {
        return NSAttributedString.fromData(attributedTextData)
    }
}
extension RichTextEntity {
    var plainText: String {
        if let attributedString = NSAttributedString.fromData(attributedTextData) {
            return attributedString.string // Extract plain text
        }
        return ""
    }
}
