//
//  File.swift
//  MyNotes
//
//  Created by apple on 21.12.2024.
//

import Foundation
import SwiftData

@Model
class FeelingItem: Identifiable {
    var id = UUID()
    var emoji: String
    var name: String
    init(emoji: String, name: String) {
        self.emoji = emoji
        self.name = name
    }
}
