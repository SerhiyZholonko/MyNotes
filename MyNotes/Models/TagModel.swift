//
//  TagModel.swift
//  MyNotes
//
//  Created by apple on 30.11.2024.
//

import Foundation
import SwiftData



@Model
class TagModel: Hashable {
    var name: String
    var notes: [NoteModel] = []  // Many-to-many relationship inferred automatically
    
    init(name: String) {
        self.name = name
    }

    // Conformance to Hashable
    static func == (lhs: TagModel, rhs: TagModel) -> Bool {
        lhs.name == rhs.name
    }

    func hash(into hasher: inout Hasher) {
        hasher.combine(name)
    }
}
